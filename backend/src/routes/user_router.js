const express = require("express");
const router = express.Router();
const mysql = require("mysql2");
const knex = require("knex")({
  client: "mysql2",
  connection: {
    host: process.env.DB_URL,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_DATABASE,
  },
  migrations: {
    database: process.env.DB_DATABASE,
    tableName: process.env.DB_TABLE,
  },
});

const userController = require("./../controller/user_controller");

router.get("/", (req, res) => userController.getAllUser(knex, res));
router.get("/:userId", (req, res) =>
  userController.getUserById(knex, req, res)
);
router.post("/", (req, res) => userController.createUser(knex, req, res));
router.put("/:userId", (req, res) => userController.updateUser(knex, req, res));
router.delete("/:userId", (req, res) =>
  userController.deleteUser(knex, req, res)
);

module.exports = router;
