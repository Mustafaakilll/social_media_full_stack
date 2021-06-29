require("dotenv").config();
const express = require("express");
const logger = require("morgan");
const cors = require("cors");

const postsRouter = require("./src/routes/post_router");
const usersRouter = require("./src/routes/user_router");
const authRouter = require("./src/routes/auth_router");

const errorHandler = require("./src/middleware/error_handler");
const connectToDb = require("./src/utils/db");

const app = express();

connectToDb();

app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cors());

app.use("/auth", authRouter);
app.use("/posts", postsRouter);
app.use("/users", usersRouter);

app.use(errorHandler);

app.listen(process.env.PORT, () => {
  console.log(`App is running on port: ${process.env.PORT}`);
});
