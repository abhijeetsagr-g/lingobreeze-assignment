import { initializeApp, cert, getApps } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';
import path from 'path';

const serviceAccountPath = process.env.GOOGLE_APPLICATION_CREDENTIALS;

if (!serviceAccountPath) {
  console.warn(
    'WARNING: GOOGLE_APPLICATION_CREDENTIALS env var not set. ' +
    'Firebase Admin will not be initialized.'
  );
} else if (getApps().length === 0) {
  const absolutePath = path.resolve(serviceAccountPath);

  initializeApp({
    credential: cert(absolutePath),
  });

  console.log('Firebase Admin initialized successfully');
}

const db = getFirestore();

export { db };
