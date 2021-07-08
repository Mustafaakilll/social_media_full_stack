const mongoose = require("mongoose");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");

const UserSchema = new mongoose.Schema({
  username: {
    type: String,
    required: [true, "Please enter your username"],
    trim: true,
    unique: true,
  },
  email: {
    type: String,
    required: [true, "Please enter your email"],
    trim: true,
    lowercase: true,
    unique: true,
  },
  password: {
    type: String,
    required: [true, "Please enter your password"],
    minlength: [6, "Password should be atleast minimum of 6 characters"],
  },
  avatar: {
    type: String,
    default:
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
  },
  bio: String,
  followers: [{ type: mongoose.Schema.ObjectId, ref: "User" }],
  followersCount: {
    type: Number,
    default: 0,
  },
  following: [{ type: mongoose.Schema.ObjectId, ref: "User" }],
  followingCount: {
    type: Number,
    default: 0,
  },
  posts: [{ type: mongoose.Schema.ObjectId, ref: "Post" }],
  postCount: {
    type: Number,
    default: 0,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

UserSchema.pre("save", async function (next) {
  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);
  next();
});

UserSchema.methods.getJwtToken = function () {
  return jwt.sign({ id: this._id }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRE,
  });
};

UserSchema.methods.checkPassword = async function (password) {
  return await bcrypt.compare(password, this.password);
};

module.exports = mongoose.model("User", UserSchema);
