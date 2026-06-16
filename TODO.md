# LingoBreeze – My Vocabulary Feature

## Goal

Build a single, polished "My Vocabulary" feature for a language-learning app called LingoBreeze.
Users can save vocabulary words (word + meaning + translation) and view them in a clean list.

Scope is intentionally narrow — evaluators want a **complete, polished Create + Read flow**, not a half-built larger feature set.

---

## Repo Structure

```
lingobreeeze/          ← root
├── flutter-app/       ← Flutter app
├── backend/           ← Node.js API
└── README.md
```

---

## Backend — Node.js

### Stack
- Node.js + Express
- Firebase Admin SDK (Firestore)

### Endpoint

```
GET /words
```

- Queries Firestore `words` collection
- Returns JSON array of all saved words
- Example response:
```json
[
  {
    "id": "abc123",
    "word": "Apple",
    "meaning": "A fruit",
    "translation": "Manzana"
  }
]
```

### Tasks
- [ ] Init Node project (`npm init`, install `express`, `firebase-admin`)
- [ ] Connect Firebase Admin SDK with service account
- [ ] Implement `GET /words` route
- [ ] Add basic error handling (try/catch, proper status codes)
- [ ] Test locally before wiring Flutter to it

---

## Firebase

- Use **Firestore** as the database
- Collection name: `words`
- Document fields: `word` (string), `meaning` (string), `translation` (string)
- Flutter writes **directly to Firestore** (no write endpoint needed on Node)
- Node API reads from Firestore for `GET /words`

### Tasks
- [ ] Create Firebase project
- [ ] Enable Firestore
- [ ] Add Android app to Firebase, download `google-services.json`
- [ ] Generate service account key for Node backend
- [ ] Set Firestore rules (allow read/write for now, lock down later)

---

## Flutter App

### Architecture — Clean, Feature-First

```
flutter-app/
└── lib/
    ├── main.dart
    └── features/
        └── vocabulary/
            ├── data/
            │   ├── datasources/
            │   │   ├── firestore_datasource.dart    ← writes to Firestore
            │   │   └── api_datasource.dart          ← GET /words from Node API
            │   └── repositories/
            │       └── vocab_repository_impl.dart
            ├── domain/
            │   ├── models/
            │   │   └── vocab_word.dart
            │   └── repositories/
            │       └── vocab_repository.dart        ← abstract
            └── presentation/
                ├── cubit/
                │   ├── vocab_cubit.dart
                │   └── vocab_state.dart
                ├── screens/
                │   └── vocabulary_screen.dart
                └── widgets/
                    ├── word_card.dart
                    ├── empty_state.dart
                    ├── error_state.dart
                    └── add_word_sheet.dart          ← modal bottom sheet
```

### State Management
- **Cubit** (`flutter_bloc`)
- States: `VocabInitial`, `VocabLoading`, `VocabLoaded`, `VocabError`

### Dependencies
```yaml
flutter_bloc: ...
firebase_core: ...
cloud_firestore: ...
http: ...              # or dio, for Node API calls
equatable: ...
```

---

## Feature Spec

### Screen: My Vocabulary

**Empty State**
```
You haven't saved any words yet.
[ Add Your First Word ]
```

**Loaded State**
```
My Vocabulary                    [+ icon]

Apple
Meaning: A fruit
Translation: Manzana

Beautiful
Meaning: Pleasing to look at
Translation: Hermosa
```

### Add Word — Modal Bottom Sheet
Fields:
- Word (required)
- Meaning (required)
- Translation (required)

On submit:
1. Validate all fields non-empty
2. Write to Firestore directly
3. Close sheet
4. Refresh word list (re-fetch from Node API)

### Read Words — from Node API
- On screen load → `GET /words` → display list
- Loading spinner while fetching
- Error state with retry button if request fails
- Pull-to-refresh (optional but nice)

---

## UI/UX Notes

UI/UX is weighted **40%** — highest weight. Make it count.

- Use `Material 3` or a clean custom theme
- Word cards should feel distinct, not just `ListTile` defaults
- Empty state should look intentional, not like a missing widget
- Bottom sheet should have smooth open/close, keyboard-aware layout
- Loading state: use `CircularProgressIndicator` or shimmer if time allows
- Error state: show message + retry button, not a crash screen

---

## Evaluation Criteria

| Area                 | Weight |
|----------------------|--------|
| UI/UX Quality        | 40%    |
| Flutter Code Quality | 25%    |
| Firebase Integration | 15%    |
| Node.js API Quality  | 10%    |

---

## AI Contribution Estimate (fill before submitting)

```
UI: ~%
Backend: ~%
Architecture: Manual
```

---

## Build Order

1. Firebase project setup (Firestore + credentials)
2. Node API (`GET /words` working and tested)
3. Flutter scaffold (clean arch folders, deps, Firebase init)
4. `VocabWord` model + repository layer
5. `VocabCubit` with all states
6. `VocabularyScreen` — loading / error / empty / loaded
7. `AddWordSheet` — form + Firestore write
8. Polish UI (cards, spacing, colors, empty state illustration)
9. README
10. Push to GitHub

---

## Submission

GitHub repo with:
- `flutter-app/` — complete Flutter project
- `backend/` — Node.js API
- `README.md` — setup instructions, how to run both, Firebase config note, AI contribution breakdown
