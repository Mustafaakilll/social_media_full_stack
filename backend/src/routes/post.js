const express = require("express");
const router = express.Router();

router.get("/", (req, res, next) => {
  res.json({
    page: "Index page",
  });
});

module.exports = router;
