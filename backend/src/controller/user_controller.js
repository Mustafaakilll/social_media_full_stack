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
    user.isFollowing = false;
    if (req.user.followers.includes(user._id.toString())) {
      user.isFollowing = true;
    }
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

exports.getUserById = asyncHandler(async (req, res, next) => {
  const user = await userModel
    .findOne({ _id: req.params.id })
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
    user.isFollowing = false;
    if (req.user.followers.includes(user._id.toString())) {
      user.isFollowing = true;
    }
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

  const users = await userModel.find()
    .where("_id")
    .in(following.concat([req.user.id]))
    .exec();

  const postIds = users.map((user) => user.posts).flat();

  const posts = await postModel.find()
    .populate({
      path: "Comment",
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

    post.isMine = false;
    if (post.user._id.toString() === req.user.id) {
      post.isMine = true;
    }

    post.comments.map((comment) => {
      comment.isCommentMine = false;
      if (comment.user._id.toString() === req.user.id) {
        comment.isCommentMine = true;
      }
    });
  });

  res.status(200).json({ isSuccess: true, data: posts });
});
