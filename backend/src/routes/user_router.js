const express = require("express");
const router = express.Router();

const { getUser, getUsers, feed, getUserById } = require("./../controller/user_controller");
const { protect } = require("./../middleware/auth");

router.get("/", protect, getUsers);
router.get("/feed", protect, feed);
// router.get("/:username", protect, getUser);
router.get("/:id", protect, getUserById);

module.exports = router;
