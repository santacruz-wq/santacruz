import express from "express";
import { chatearConBarista } from "../controllers/chatcontroller.js";

const router = express.Router();

// Ruta: POST /api/chat
router.post("/", chatearConBarista);

export default router;