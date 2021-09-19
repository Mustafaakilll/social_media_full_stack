const express = require("express");
const router = express.Router();

const {
  getUser,
  getUsers,
  feed,
  editUser,
  follow,
  searchUser,
  unfollow,
} = require("./../controller/user_controller");
const { protect } = require("./../middleware/auth");

router.get("/", protect, getUsers);
router.put("/", protect, editUser);
router.get("/feed", protect, feed);
router.get("/search", protect, searchUser);
router.get("/:username", protect, getUser);
router.get("/:id/follow", protect, follow);
router.get("/:id/unfollow", protect, unfollow);

module.exports = router;
