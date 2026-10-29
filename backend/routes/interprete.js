
import express from "express";
import multer from "multer";
import { traducirAudio } from "../controllers/interprete.js";

const router = express.Router();

const upload = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: 15 * 1024 * 1024,
  },
});

router.post("/", upload.single("audio"), traducirAudio);

export default router;
