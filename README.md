# Ryou

App Flutter (iOS + Android) de partage d'humeur en temps réel entre partenaires en couple, avec Ryou, la mascotte panda roux.

- **Stack** : Flutter/Dart, Firebase (Auth, Firestore, Storage, Cloud Functions, FCM), Lottie
- **Backlog** : Jira, projet `RYOU`. Chaque commit référence son ticket (ex. `RYOU-15: ...`).

## Lancer le projet

```bash
flutter pub get
flutter run
```

## Tests

```bash
flutter test
```

## Architecture

Le code est découpé **par fonctionnalité** (feature-first). Chaque fonctionnalité a trois couches :

- `data/` : repositories, accès à Firestore, Storage et Auth
- `domain/` : modèles métier (User, Couple, MoodEntry…)
- `presentation/` : écrans, widgets et état de l'UI

Ce qui sert à plusieurs fonctionnalités va dans `core/` (technique) ou `shared/` (UI et modèles communs).

```
lib/
├── main.dart                  # point d'entrée
├── core/
│   ├── theme/                 # thème Dart généré depuis ryou-tokens.json (RYOU-15)
│   ├── router/                # navigation et redirections selon l'état de connexion
│   ├── firebase/              # instances Firebase, initialisation, émulateur local
│   └── errors/                # erreurs métier communes
├── shared/
│   ├── models/                # modèles communs, dont les 9 humeurs
│   └── widgets/               # composants réutilisables (boutons, mascotte, avatar…)
├── features/
│   ├── auth/                  # création de compte, connexion (RYOU-9, 10)
│   ├── couple/                # liaison par code d'invitation (RYOU-11)
│   ├── profile/               # photo de profil, photos et emojis par humeur (RYOU-12, 13)
│   ├── mood/                  # saisie et humeur du partenaire en temps réel (RYOU-16, 17)
│   ├── history/               # historique des humeurs (RYOU-20)
│   ├── notifications/         # push et rappel quotidien (RYOU-18, 19)
│   └── settings/              # réglages, suppression de compte (RYOU-27)
└── l10n/                      # textes de l'app (fichiers .arb)

test/                          # même arborescence que lib/
functions/                     # Cloud Functions Firebase (push FCM, nettoyage des données)
tool/                          # scripts de développement (génération du thème)
assets/tokens/                 # design tokens (ryou-tokens.json)
```

### Règles

- **Pas d'import entre fonctionnalités.** Ce qui doit être partagé remonte dans `core/` ou `shared/`.
- **Pas d'appel direct à Firebase dans l'UI.** Les écrans passent par les repositories de `data/`. Dans les tests, on remplace ces repositories par des versions factices.
- **Pas de texte en dur dans les widgets.** Tous les textes affichés sont dans `lib/l10n/`.
- **Pas de couleur ni de police en dur.** Elles viennent du thème, lui-même généré depuis `assets/tokens/ryou-tokens.json`.
- **Pas de secret dans le repo.** `lib/firebase_options.dart` reste à la racine de `lib/`, exclu par le `.gitignore`. Chaque machine le régénère avec `flutterfire configure`.

### Structure Firestore

| Chemin | Contenu |
|---|---|
| `users/{uid}` | prénom, email, photo, `coupleId`, humeur actuelle, préférences de notifications, tokens FCM |
| `couples/{coupleId}` | les deux membres, code d'invitation, `isPremium` (réservé, inutilisé : l'app est gratuite) |
| `couples/{coupleId}/moods/{entryId}` | humeur, note (140 caractères max), date, auteur |
| `inviteCodes/{code}` | `coupleId` correspondant, pour retrouver un couple à partir de son code |

### Choix techniques

| Sujet | Choix | Statut |
|---|---|---|
| State management | Riverpod | à confirmer |
| Navigation | go_router | à confirmer |
| Modèles | freezed + json_serializable | à confirmer |
| Cloud Functions | TypeScript | à confirmer |
| Environnements Firebase | un projet + émulateur local, projet de prod ajouté avant la bêta | à confirmer |
