const userModel = require("./../model/user_model");
// TODO: CREATE MODEL FOR RESPONSE AND ERROR

module.exports = {
  getAllUser: async (con, res) => {
    try {
      const users = [];
      const _user = await con("user").select();
      _user.map((user) => {
        users.push(new userModel(user));
      });
      res.json(users);
    } catch (e) {
      res.json(e);
    }
  },
  getUserById: async (con, req, res) => {
    try {
      let user;
      const userId = req.params.userId;
      const _user = await con("user").select().where("user_id", userId);
      _user.map((u) => {
        user = new userModel(u);
      });
      res.json(user);
    } catch (e) {
      res.json(e);
    }
  },
  createUser: async (con, req, res) => {
    //TODO: ADD USER TO AWS COGNITO SAME TIME
    try {
      const _user = await con("user").insert(req.body);
      res.json(_user);
    } catch (e) {
      res.json(e);
    }
  },
  updateUser: async (con, req, res) => {
    try {
      const userId = req.params.userId;
      const _user = await con("user").where("user_id", userId).update(req.body);
      res.json(_user + " Satir guncellendi.");
    } catch (e) {
      res.json(e);
    }
  },
  deleteUser: async (con, req, res) => {
    try {
      const userId = req.params.userId;
      const _user = await con("user").where("user_id", userId).delete();
      res.json(_user + " Satir silindi.");
    } catch (e) {
      res.json(e);
    }
  },
};
