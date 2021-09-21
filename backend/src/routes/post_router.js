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
  deleteComment,
} = require("./../controller/post_controller");

router.get("/", getPosts);
router.put("/", protect, addPost);
router.get("/:id", protect, getPost);
router.delete("/:id", protect, deletePost);
router.get("/:id/togglelike", protect, toggleLike);
router.post("/:id/comments", protect, addComment);
router.delete("/:id/comments/:commentId", protect, deleteComment);

module.exports = router;
