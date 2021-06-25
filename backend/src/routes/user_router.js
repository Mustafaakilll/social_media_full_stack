const express = require("express");
const router = express.Router();

const userController = require("./../controller/user_controller");

router.get("/", (req, res) => userController.getAllUser(res));
router.get("/:userId", (req, res) =>
  userController.getUserById(knex, req, res)
);
router.post("/", (req, res) => userController.createUser(knex, req, res));
router.put("/:userId", (req, res) => userController.updateUser(knex, req, res));
router.delete("/:userId", (req, res) =>
  userController.deleteUser(knex, req, res)
);

module.exports = router;
