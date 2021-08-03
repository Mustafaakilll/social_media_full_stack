const express = require("express");
const { protect } = require("../middleware/auth");
const router = express.Router();

const {
  addPost,
  deletePost,
  getPost,
  getPosts,
  toggleLike,
  addComment,
} = require("./../controller/post_controller");

router.get("/", getPosts);
router.put("/", protect, addPost);
router.delete("/:id", protect, deletePost);
router.get("/:id", protect, getPost);
router.get("/:id/togglelike", protect, toggleLike);
router.post("/:id/comments", protect, addComment);

module.exports = router;
