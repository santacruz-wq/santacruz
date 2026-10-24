
import multer from 'multer';
import { CloudinaryStorage } from 'multer-storage-cloudinary';
import cloudinary from '../config/cloudinary.js';

const formatosPermitidos = ['jpg', 'jpeg', 'png', 'webp'];

const storage = new CloudinaryStorage({
  cloudinary,
  params: {
    folder: 'santacruz-plazuela/productos',
    allowed_formats: formatosPermitidos,
    transformation: [
      { width: 800, height: 800, crop: 'limit' },
    ],
  },
});

const filtroImagenes = (req, file, cb) => {
  const extension = file.originalname
    ?.split('.')
    .pop()
    ?.toLowerCase();

  const tiposPermitidos = [
    'image/jpeg',
    'image/jpg',
    'image/png',
    'image/webp',
  ];

  const tipoValido = tiposPermitidos.includes(file.mimetype);
  const extensionValida = formatosPermitidos.includes(extension);

  if (tipoValido && extensionValida) {
    return cb(null, true);
  }

  return cb(
    new Error('Solo se permiten imágenes JPG, JPEG, PNG o WEBP válidas.'),
    false
  );
};

export const upload = multer({
  storage,
  fileFilter: filtroImagenes,
  limits: {
    fileSize: 5 * 1024 * 1024,
  },
});
