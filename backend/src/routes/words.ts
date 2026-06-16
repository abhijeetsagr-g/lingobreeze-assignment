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

// Return Words available; GET
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

// Add A word
router.post('/', async (_req : Request, res : Response) => {
  const {word, meaning, translation} = _req.body;

  if (!word || !meaning || !translation) {
    res.status(201).json({error : "All fields are required"});
  }

  const docRef = await db.collection('words').add(
    {
      word,
      meaning,
      translation
    }
  );

  const newDoc = await docRef.get();

  res.status(201).json({
    id: docRef.id,
    word: newDoc.data()?.word ?? '',
    meaning: newDoc.data()?.meaning ?? '',
    translation: newDoc.data()?.translation ?? '',
  });
})

// Update a word
router.put('/:id', async (req: Request, res: Response) => {
  const id = String(req.params.id);
  const { word, meaning, translation } = req.body;

  if (!word || !meaning || !translation) {
    res.status(400).json({ error: 'All fields are required' });
    return;
  }

  const docRef = db.collection('words').doc(id);
  const doc = await docRef.get();

  if (!doc.exists) {
    res.status(404).json({ error: 'Word not found' });
    return;
  }

  await docRef.update({ word, meaning, translation });

  const updatedDoc = await docRef.get();

  res.json({
    id: updatedDoc.id,
    word: updatedDoc.data()?.word ?? '',
    meaning: updatedDoc.data()?.meaning ?? '',
    translation: updatedDoc.data()?.translation ?? '',
  });
});

// Delete a word
router.delete('/:id', async (req: Request, res: Response) => {
  const id = String(req.params.id);

  const docRef = db.collection('words').doc(id);
  const doc = await docRef.get();

  if (!doc.exists) {
    res.status(404).json({ error: 'Word not found' });
    return;
  }

  await docRef.delete();

  res.status(204).send();
});

export default router;
