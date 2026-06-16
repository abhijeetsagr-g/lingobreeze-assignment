import { Router, Request, Response } from 'express';
import { db } from '../config/firebase';
import type { QueryDocumentSnapshot } from 'firebase-admin/firestore';

const router = Router();

interface VocabWord {
  id: string;
  word: string;
  meaning: string;
  translation: string;
}

interface FirestoreWordData {
  word?: string;
  meaning?: string;
  translation?: string;
}

router.get('/', async (_req: Request, res: Response) => {
  try {
    const snapshot = await db.collection('words').get();

    if (snapshot.empty) {
      res.json([]);
      return;
    }

    const words: VocabWord[] = snapshot.docs.map(
      (doc: QueryDocumentSnapshot<FirestoreWordData>) => {
        const data = doc.data();
        return {
          id: doc.id,
          word: data.word ?? '',
          meaning: data.meaning ?? '',
          translation: data.translation ?? '',
        };
      }
    );

    res.json(words);
  } catch (error) {
    console.error('Error fetching words:', error);
    res.status(500).json({
      error: 'Failed to fetch vocabulary words',
      message: error instanceof Error ? error.message : 'Unknown error',
    });
  }
});

export default router;
