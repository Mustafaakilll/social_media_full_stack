const postModel = require("./../model/post_model");
const userModel = require("./../model/user_model");
const asyncHandler = require("./../middleware/async_handler");

exports.getPosts = asyncHandler(async (req, res, _) => {
  const posts = await postModel.find();

  res.status(200).json({ isSuccess: true, data: posts });
});

exports.getPost = asyncHandler(async (req, res, next) => {
  const post = postModel
    .findById(req.params.id)
    .populate({
      path: "comments",
      select: "text",
      populate: {
        path: "user",
        select: "avatar username",
      },
    })
    .populate({
      path: "user",
      select: "avatar username",
    })
    .lean()
    .exec();

  if (!post) {
    return next({
      message: `There is no post for this id: ${req.params.id}`,
      statusCode: 400,
    });
  }

  post.isMine = req.user.id === post.user._id.toString();

  const likes = post.likes.map((like) => like.toString());
  post.isLiked = likes.includes(req.user.id);

  post.comments.forEach((comment) => {
    comment.isMine = false;

    if (comment.user._id.toString() === req.user.id) {
      comment.isMine = true;
    }
  });

  res.status(200).json({
    isSuccess: true,
    data: post,
  });
});

exports.addPost = asyncHandler(async (req, res, _) => {
  const { caption, files, tags } = req.body;
  const user = req.user.id;

  let post = await postModel.create({ user, caption, files, tags });

  await userModel.findByIdAndUpdate(user, {
    $push: { posts: post._id },
    $inc: { postCount: 1 },
  });

  post = await post
    .populate({ path: "user", select: "username avatar" })
    .execPopulate();

  res.status(200).json({ isSuccess: true, data: post });
});

exports.deletePost = asyncHandler(async (req, res, next) => {
  const post = postModel.findById(req.params.id);

  if (!post) {
    return next({
      message: `There is no post for this id: ${req.params.id}`,
      statusCode: 404,
    });
  }

  if (post.user.toString() !== req.user.id) {
    return next({
      message: "You are not authorized for this post",
      statusCode: 401,
    });
  }

  await userModel.findByIdAndUpdate(req.user.id, {
    $pull: { posts: req.params.id },
    $inc: { postCount: -1 },
  });

  await post.remove();

  res.status(200).json({ isSuccess: true, data: post });
});
