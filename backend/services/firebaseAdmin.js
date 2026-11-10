import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { initializeApp, cert, getApps } from 'firebase-admin/app';
import { getMessaging } from 'firebase-admin/messaging';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const rutaCredenciales =
    process.env.FIREBASE_SERVICE_ACCOUNT_PATH ||
    path.join(__dirname, '../config/firebase-service-account.json');

const credenciales = JSON.parse(
    fs.readFileSync(rutaCredenciales, 'utf8')
);

const app = getApps().length
    ? getApps()[0]
    : initializeApp({
        credential: cert(credenciales),
        projectId: credenciales.project_id
    });

export const fcmMessaging = getMessaging(app);

console.log('Firebase Admin inicializado correctamente');