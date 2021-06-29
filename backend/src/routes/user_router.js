const express = require("express");
const router = express.Router();

const { getUser, getUsers, feed } = require("./../controller/user_controller");
const { protect } = require("./../middleware/auth");

router.get("/", protect, getUsers);
router.get("/feed", protect, feed);
router.get("/:username", protect, getUser);

module.exports = router;
