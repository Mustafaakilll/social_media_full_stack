const express = require("express");
const path = require("path");
const cookieParser = require("cookie-parser");
const logger = require("morgan");
require("dotenv").config();

const postRouter = require("./src/routes/post");
const usersRouter = require("./src/routes/user_router");

const app = express();

app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());

app.use("/post", postRouter);
app.use("/users", usersRouter);

app.listen(process.env.PORT, () => {
  console.log(`App is running on port: ${process.env.PORT}`);
});
