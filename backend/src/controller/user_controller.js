const userModel = require("./../model/user_model");
// TODO: CREATE MODEL FOR RESPONSE AND ERROR
const knex = require("knex")({
  client: "mysql2",
  connection: {
    host: process.env.DB_URL,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_DATABASE,
  },
  migrations: {
    tableName: process.env.DB_USER_TABLE,
  },
});

module.exports = {
  getAllUser: async (res) => {
    try {
      const users = [];
      const _user = await knex("user").select();
      _user.map((user) => {
        users.push(new userModel(user));
      });
      res.json(users);
    } catch (e) {
      console.log(e);
      res.status(400).json(e);
    }
  },
  getUserById: async (req, res) => {
    try {
      let user;
      const userId = req.params.userId;
      const _user = await knex("user").select().where("user_id", userId);
      _user.map((u) => {
        user = new userModel(u);
      });
      res.json(user);
    } catch (e) {
      res.status(400).json(e);
    }
  },
  createUser: async (req, res) => {
    //TODO: ADD USER TO AWS COGNITO SAME TIME
    try {
      const _user = await knex("user").insert(req.body);
      res.json(_user);
    } catch (e) {
      res.status(400).json(e);
    }
  },
  updateUser: async (req, res) => {
    try {
      const userId = req.params.userId;
      const _user = await knex("user")
        .where("user_id", userId)
        .update(req.body);
      res.json(_user + " Satir guncellendi.");
    } catch (e) {
      res.status(400).json(e);
    }
  },
  deleteUser: async (req, res) => {
    try {
      const userId = req.params.userId;
      const _user = await knex("user").where("user_id", userId).delete();
      res.json(_user + " Satir silindi.");
    } catch (e) {
      res.status(400).json(e);
    }
  },
};
