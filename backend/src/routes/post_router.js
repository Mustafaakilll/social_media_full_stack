const express = require("express");
const { protect } = require("../middleware/auth");
const router = express.Router();

const {
  addPost,
  deletePost,
  getPost,
  getPosts,
} = require("./../controller/post_controller");

router.get("/", getPosts);
router.put("/", protect, addPost);
router.delete("/:id", protect, deletePost);
router.get("/:id", protect, getPost);

module.exports = router;
