const User = require("../model/user_model");
const asyncHandler = require("../middleware/async_handler");

exports.login = asyncHandler(async (req, res, next) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return next({
      message: "Please provide email and password",
      statusCode: 400,
    });
  }

  const user = await User.findOne({ email });

  if (!user) {
    return next({
      message: "The email is not yet registered to an accout",
      statusCode: 400,
    });
  }

  const match = await user.checkPassword(password);

  if (!match) {
    return next({ message: "The password does not match", statusCode: 400 });
  }
  const token = user.getJwtToken();

  res.status(200).json({ success: true, token });
});

exports.signup = asyncHandler(async (req, res, _) => {
  const { username, email, password } = req.body;

  const user = await User.create({ username, email, password });

  const token = user.getJwtToken();

  res.status(200).json({ success: true, token });
});

exports.me = asyncHandler(async (req, res, _) => {
  const { avatar, username, email, _id, website, bio } = req.user;

  res.status(200).json({
    success: true,
    data: { avatar, username, email, _id, website, bio },
  });
});
