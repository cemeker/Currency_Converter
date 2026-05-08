const express = require("express");
const cors = require("cors");

const app = express();
const PORT = 3000;

app.use(cors());

const API_URL =
  "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/eur.json";

app.get("/convert", async (req, res) => {
  try {
    const amount = Number(req.query.amount);
    const to = req.query.to?.toLowerCase();

    const response = await fetch(API_URL);
    const data = await response.json();

    const rate = data.eur[to];
    const result = amount * rate;

    res.json({
      amount,
      from: "eur",
      to,
      rate,
      result,
    });

  } catch (error) {
    res.status(500).json({ error: "Fehler beim Abrufen der API" });
  }
});

app.get("/rates", async (req, res) => {
  try {
    const response = await fetch(API_URL);
    const data = await response.json();

    res.json(data.eur);
  } catch (error) {
    res.status(500).json({ error: "Fehler beim Abrufen der Kurse" });
  }
});

app.listen(PORT, () => {
  console.log(`Server läuft auf http://localhost:${PORT}`);
});