import React, { useEffect, useState } from "react";
import { createRoot } from "react-dom/client";
import "./styles.css";

function App() {
  const [health, setHealth] = useState(null);
  const [messages, setMessages] = useState([]);
  const [text, setText] = useState("");
  const [error, setError] = useState("");

  async function loadData() {
    const [healthResponse, messagesResponse] = await Promise.all([
      fetch("/api/health"),
      fetch("/api/messages")
    ]);

    if (!healthResponse.ok || !messagesResponse.ok) {
      throw new Error("API request failed");
    }

    setHealth(await healthResponse.json());
    setMessages(await messagesResponse.json());
  }

  useEffect(() => {
    loadData().catch(() => {
      setError("Backend ya database se connection nahi ho pa raha.");
    });
  }, []);

  async function handleSubmit(event) {
    event.preventDefault();
    setError("");

    const response = await fetch("/api/messages", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ text })
    });

    if (!response.ok) {
      setError("Message save nahi ho paya.");
      return;
    }

    setText("");
    await loadData();
  }

  async function handleDelete(id) {
    setError("");

    const response = await fetch(`/api/messages/${id}`, {
      method: "DELETE"
    });

    if (!response.ok) {
      setError("Message delete nahi ho paya.");
      return;
    }

    setMessages((currentMessages) =>
      currentMessages.filter((message) => message.id !== id)
    );
  }

  return (
    <main className="app-shell">
      <section className="panel">
        <div className="badge-row">
          <span className="badge">React</span>
          <span className="badge">Node.js</span>
          <span className="badge">MySQL</span>
        </div>
        <h1>React, Node.js aur MySQL connected project</h1>
        <p className="intro">
          Data frontend se backend tak jaata hai, MySQL me save hota hai, aur
          yahin se delete bhi hota hai.
        </p>
        <div className="status-grid">
          <div>
            <span>Backend</span>
            <strong>{health?.status || "checking"}</strong>
          </div>
          <div>
            <span>Database</span>
            <strong>{health?.database || "checking"}</strong>
          </div>
        </div>
      </section>

      <section className="workspace">
        <div className="workspace-header">
          <div>
            <p className="eyebrow">Live database</p>
            <h2>Saved messages</h2>
          </div>
          <span className="count">{messages.length}</span>
        </div>

        <form onSubmit={handleSubmit} className="message-form">
          <input
            value={text}
            onChange={(event) => setText(event.target.value)}
            placeholder="Database me message save karo"
          />
          <button type="submit">Save</button>
        </form>

        {error ? <p className="error">{error}</p> : null}

        <div className="messages">
          {messages.map((message) => (
            <article key={message.id}>
              <div>
                <p>{message.text}</p>
                <time>{new Date(message.created_at).toLocaleString()}</time>
              </div>
              <button
                type="button"
                className="delete-button"
                onClick={() => handleDelete(message.id)}
                aria-label="Delete message"
                title="Delete message"
              >
                Delete
              </button>
            </article>
          ))}
        </div>
      </section>
    </main>
  );
}

createRoot(document.getElementById("root")).render(<App />);
