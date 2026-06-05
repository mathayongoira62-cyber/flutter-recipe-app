# TODO - Add Firebase Authentication backend

## Plan approved: use Firebase Authentication and make favorites user-specific (keep Firestore)

- [x] Update `pubspec.yaml` to include `firebase_auth`.

- [x] Update `FavoriteProvider` to store favorites under `users/{uid}/userFavorites/{productId}` and require a signed-in user.

- [ ] Update `FavoriteScreen` (and any favorite toggling usage) to only show favorites for the current user.

- [ ] Add an authentication gate (sign-in anonymously by default) in `app_main.dart`/`main.dart`.

- [ ] Run `flutter pub get` and ensure build passes.

- [ ] Sanity-test flows: sign-in -> toggle favorite -> favorites screen shows correct items.

