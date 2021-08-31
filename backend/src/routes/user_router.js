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
router.get("/feed", protect, feed);
router.get("/:username", protect, getUser);
router.put("/", protect, editUser);
router.get("/:id/follow", protect, follow);
router.get("/:id/unfollow", protect, unfollow);
router.get("/search", searchUser);

module.exports = router;
