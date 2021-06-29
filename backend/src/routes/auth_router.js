const express = require("express");
const router = express.Router();
const { protect } = require("./../middleware/auth");
const { signup, me, login } = require("./../controller/auth_controller");

router.post("/signup", signup);
router.post("/login", login);
router.route("/me").get(protect, me);

module.exports = router;
