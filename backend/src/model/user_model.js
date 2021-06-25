class UserModel {
  constructor({ user_id, email, username, password, avatar_path, avatar_url }) {
    this.userId = user_id;
    this.email = email;
    this.username = username;
    this.password = password;
    this.avatarPath = avatar_path;
    this.avatarUrl = avatar_url;
  }
}

module.exports = UserModel;
