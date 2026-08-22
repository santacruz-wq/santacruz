import multer from "multer";
import path from "path";
import fs from "fs";

//CREAMOS LA CARPETA UPLOADS SI NO EXISTE
const carpetaUploads = "uploads";
if (!fs.existsSync(carpetaUploads)) {
    fs.mkdirSync(carpetaUploads);
}

//CONFIGURAMOS DONDE Y CON QUE NOMBRE SE GUARDA CADA ARCHIVO
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, carpetaUploads);
    },
    filename: (req, file, cb) => {
        const nombreUnico = `${Date.now()}${path.extname(file.originalname)}`;
        cb(null, nombreUnico);
    }
});

//FILTRAMOS SOLO IMAGENES PERMITIDAS
const filtroArchivo = (req, file, cb) => {
    const tiposPermitidos = /jpeg|jpg|png|webp/;
    const extensionValida = tiposPermitidos.test(path.extname(file.originalname).toLowerCase());
    const mimeValido = tiposPermitidos.test(file.mimetype);

    if (extensionValida && mimeValido) {
        cb(null, true);
    } else {
        cb(new Error("Formato de imagen no soportado. Usa JPG, PNG o WEBP."));
    }
};

const upload = multer({
    storage,
    fileFilter: filtroArchivo,
    limits: { fileSize: 5 * 1024 * 1024 } // 5MB máximo
});

export default upload;