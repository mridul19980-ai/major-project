CREATE TABLE IF NOT EXISTS messages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  text VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO messages (text)
SELECT 'Frontend, backend, and MySQL are connected successfully.'
WHERE NOT EXISTS (SELECT 1 FROM messages LIMIT 1);

