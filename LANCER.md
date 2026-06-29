# Comment lancer l'app EP DOUSSAY

## 1. Installer Flutter
https://docs.flutter.dev/get-started/install/windows

## 2. Installer les dépendances
```
cd ep_app
flutter pub get
```

## 3. Lancer sur Android (téléphone branché en USB)
```
flutter run
```

## 4. Lancer sur iOS (Mac requis)
```
flutter run
```

## 5. Générer l'APK Android (pour distribuer)
```
flutter build apk --release
```
→ Le fichier APK sera dans : `build/app/outputs/flutter-apk/app-release.apk`

## 6. Générer pour iOS
```
flutter build ios --release
```
→ Ouvrir `ios/Runner.xcworkspace` dans Xcode pour signer et distribuer.

## Personnaliser les paroles
Ouvre `lib/data/tracks_data.dart` et remplace les textes dans chaque champ `lyrics:`.

## Changer le nom de l'EP
Dans `lib/data/tracks_data.dart`, modifie `kEpTitle` et `kArtistBio`.
