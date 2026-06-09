import cors from "cors";
import express from "express";
import { pool } from "./db.js";

const app = express();
const port = Number(process.env.PORT || 5000);

app.use(cors());
app.use(express.json());

app.get("/api/health", async (_req, res, next) => {
  try {
    const [rows] = await pool.query("SELECT 1 AS db");

    res.json({
      status: "ok",
      service: "backend",
      database: rows[0].db === 1 ? "connected" : "unknown"
    });
  } catch (error) {
    next(error);
  }
});

app.get("/api/messages", async (_req, res, next) => {
  try {
    const [rows] = await pool.query(
      "SELECT id, text, created_at FROM messages ORDER BY id DESC"
    );

    res.json(rows);
  } catch (error) {
    next(error);
  }
});

app.post("/api/messages", async (req, res, next) => {
  try {
    const text = String(req.body.text || "").trim();

    if (!text) {
      return res.status(400).json({ error: "Message text is required." });
    }

    const [result] = await pool.query("INSERT INTO messages (text) VALUES (?)", [
      text
    ]);
    const [rows] = await pool.query(
      "SELECT id, text, created_at FROM messages WHERE id = ?",
      [result.insertId]
    );

    return res.status(201).json(rows[0]);
  } catch (error) {
    return next(error);
  }
});

app.delete("/api/messages/:id", async (req, res, next) => {
  try {
    const id = Number(req.params.id);

    if (!Number.isInteger(id) || id <= 0) {
      return res.status(400).json({ error: "Valid message id is required." });
    }

    const [result] = await pool.query("DELETE FROM messages WHERE id = ?", [id]);

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: "Message not found." });
    }

    return res.status(204).send();
  } catch (error) {
    return next(error);
  }
});

app.use((err, _req, res, _next) => {
  console.error(err);
  res.status(500).json({ error: "Internal server error" });
});

app.listen(port, () => {
  console.log(`Backend listening on port ${port}`);
});
