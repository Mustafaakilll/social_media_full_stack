const userModel = require("./../model/user_model");
const postModel = require("./../model/post_model");
const asyncHandler = require("./../middleware/async_handler");

exports.getUsers = asyncHandler(async (req, res, _) => {
  let users = await userModel.find().select("-password").lean().exec();

  users.forEach((user) => {
    user.isFollowing = false;
    const followers = user.followers.map((follower) => follower._id.toString());
    if (followers.includes(req.user.id)) {
      user.isFollowing = true;
    }
  });

  users = users.filter((user) => user._id.toString() !== req.user.id);

  res.status(200).json({ isSuccess: true, data: users });
});

exports.getUser = asyncHandler(async (req, res, next) => {
  const user = await userModel
    .findOne({ username: req.params.username })
    .select("-password")
    .populate({ path: "posts", select: "files commentsCount likesCount" })
    .populate({ path: "followers", select: "avatar username" })
    .populate({ path: "following", select: "avatar username" })
    .lean()
    .exec();

  if (!user) {
    return next({
      message: `There is no account for this username: ${req.params.username}`,
      statusCode: 404,
    });
  }

  user.isFollowing = false;
  const followers = user.followers.map((follower) => follower._id.toString());

  user.followers.forEach((follower) => {
    follower.isFollowing = false;
    if (req.user.following.includes(follower._id.toString())) {
      user.isFollowing = true;
    }
  });

  user.followers.forEach((user) => {
    user.isFollowing = req.user.followers.includes(user._id.toString());
  });

  if (followers.includes(req.user.id)) {
    user.isFollowing = true;
  }

  user.isMe = req.user.id === user._id.toString();

  res.status(200).json({
    isSuccess: true,
    data: user,
  });
});

exports.feed = asyncHandler(async (req, res, _) => {
  const following = req.user.following;

  const users = await userModel
    .find()
    .where("_id")
    .in(following.concat([req.user.id]))
    .exec();

  const postIds = users.map((user) => user.posts).flat();

  const posts = await postModel
    .find()
    .populate({
      path: "comments",
      select: "text",
      populate: { path: "user", select: "avatar username" },
    })
    .populate({ path: "user", select: "avatar username" })
    .sort("-createdAt")
    .where("_id")
    .in(postIds)
    .lean()
    .exec();

  posts.forEach((post) => {
    post.isLiked = false;
    const likes = post.likes.map((like) => like.toString());
    if (likes.includes(req.user.id)) {
      post.isLiked = true;
    }

    post.isMine = post.user._id.toString() === req.user.id;

    post.comments.map((comment) => {
      comment.isCommentMine = comment.user._id.toString() === req.user.id;
    });
  });

  res.status(200).json({ isSuccess: true, data: posts });
});

exports.follow = asyncHandler(async (req, res, next) => {
  const user = await userModel.findById(req.params.id);

  if (!user) {
    return next({
      message: `There is no account for this id: ${req.params.id}`,
      statusCode: 404,
    });
  }

  if (req.params.id === req.user.id) {
    return next({ message: "You can't follow yourself", statusCode: 400 });
  }

  if (user.followers.includes(req.user.id)) {
    return next({
      message: "You are already follow this account",
      statusCode: 400,
    });
  }

  await userModel.findByIdAndUpdate(req.params.id, {
    $push: { followers: req.user.id },
    $inc: { followersCount: 1 },
  });
  await userModel.findByIdAndUpdate(req.user.id, {
    $push: { following: req.params.id },
    $inc: { followingCount: 1 },
  });

  res.status(200).json({ isSuccess: true, data: {} });
});

exports.unfollow = asyncHandler(async (req, res, next) => {
  const user = await userModel.findById(req.params.id);

  if (!user) {
    return next({
      message: `There is no account for this id: ${req.params.id}`,
      statusCode: 404,
    });
  }

  if (req.params.id === req.user.id) {
    return next({
      message: "You can't follow/unfollow yourself",
      statusCode: 400,
    });
  }

  await userModel.findByIdAndUpdate(req.params.id, {
    $pull: { followers: req.user.id },
    $inc: { followersCount: -1 },
  });

  await userModel.findByIdAndUpdate(req.user.id, {
    $pull: { following: req.params.id },
    $inc: { followingCount: -1 },
  });

  res.status(200).json({ isSuccess: true, data: {} });
});

exports.searchUser = asyncHandler(async (req, res, next) => {
  if (!req.query.username) {
    return next({ message: "Username can't be null", statusCode: 400 });
  }

  const regex = new RegExp(req.query.username, "i");
  const user = await userModel.find({ username: regex });

  const index = user.findIndex((u) => u.id === req.user.id);
  user.splice(index, 1);

  res.status(200).json({ isSuccess: true, data: user });
});

exports.editUser = asyncHandler(async (req, res) => {
  const { avatar, username, bio, email } = req.body;

  const fieldsToUpdate = {};
  if (avatar) fieldsToUpdate.avatar = avatar;
  if (username) fieldsToUpdate.username = username;
  if (email) fieldsToUpdate.email = email;

  const user = await userModel
    .findByIdAndUpdate(
      req.user.id,
      {
        $set: { ...fieldsToUpdate, bio },
      },
      {
        new: true,
        runValidators: true,
      }
    )
    .select("username avatar email bio");

  res.status(200).json({ isSuccess: true, data: user });
});
