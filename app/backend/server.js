const express = require("express");
const cors = require("cors");

const app = express();

app.use(cors());
app.use(express.json());

const appointments = [
  {
    id: 1,
    patient: "John Doe",
    doctor: "Dr. Smith",
    date: "2026-05-12",
    time: "10:00 AM"
  },
  {
    id: 2,
    patient: "Jane Wilson",
    doctor: "Dr. Adams",
    date: "2026-05-13",
    time: "02:30 PM"
  },
  {
    id: 3,
    patient: "Van Dame",
    doctor: "Dr. Kay",
    date: "2026-05-14",
    time: "02:30 PM"
  },
  {
    id: 4,
    patient: "Jet Li",
    doctor: "Dr. Kay",
    date: "2026-05-15",
    time: "02:30 PM"
  }
];

app.get("/api/health", (req, res) => {
  res.status(200).json({
    status: "healthy",
    service: "healthpulse-backend"
  });
});

app.get("/api/appointments", (req, res) => {
  res.json(appointments);
});

const PORT = process.env.PORT || 3000;

if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`HealthPulse backend running on port ${PORT}`);
  });
}

module.exports = app;
