import mysql from "mysql2/promise";

export const pool = mysql.createPool({
  host: process.env.DB_HOST || "localhost",
  port: Number(process.env.DB_PORT || 3306),
  database: process.env.DB_NAME || "college_app",
  user: process.env.DB_USER || "college_user",
  password: process.env.DB_PASSWORD || "college_password",
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

