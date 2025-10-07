# Quick Start Guide - AI Chat Bot

## 🚀 Get Started in 5 Minutes

### 1. Firebase Setup (2 minutes)

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Click "Add project" → Enter project name → Continue
   - Disable Google Analytics (optional) → Create project

2. **Add Web App**
   - Click "Web" icon (</>) → Register app
   - Copy the config object
   - Open `web/index.html` and replace lines 23-29

3. **Add Android App**
   - Click "Android" icon → Package: `com.aichatbot.ai_chat_bot`
   - Run `cd android && ./gradlew signingReport` → copy SHA-1 (and SHA-256) from `Variant: debug`
   - Paste fingerprints in Firebase Console → Android app settings → “Add fingerprint”
   - Download fresh `google-services.json` → Replace `android/app/google-services.json`
   - Copy the “Web client ID” from Firebase Console → `.env` → `GOOGLE_WEB_CLIENT_ID`
   - Back in project root:
     ```bash
     flutter clean
     flutter pub get
     ```

4. **Enable Firestore**
   - Left menu → Firestore Database → Create database
   - Start in **test mode** → Choose location → Enable

### 2. Gemini API Setup (1 minute)

1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Click "Create API Key" → Copy the key

### 3. Configure App (1 minute)

1. **Update `lib/config/app_config.dart`:**
   ```dart
   static const String firebaseProjectId = 'your-project-id';
   static const String geminiApiKey = 'your-api-key-here';
   ```

2. **Update `lib/main.dart` (lines 15-21):**
   ```dart
   await Firebase.initializeApp(
     options: const FirebaseOptions(
       apiKey: 'your-api-key',
       appId: 'your-app-id',
       messagingSenderId: 'your-sender-id',
       projectId: 'your-project-id',
       storageBucket: 'your-project-id.appspot.com',
     ),
   );
   ```

### 4. Run the App (1 minute)

```bash
# Install dependencies
flutter pub get

# Run on Web
flutter run -d chrome

# OR Run on Android
flutter run
```

## 📱 Usage

- **New Chat**: Tap "+" button
- **Send Message**: Type and tap send
- **View Chats**: Open drawer (menu icon)
- **Delete Chat**: Swipe left on chat item

## 🎨 UI Features

- **Dark Theme**: Easy on the eyes
- **Clean Design**: Minimal distractions
- **Easy Reach**: Buttons optimized for thumb access
- **Smooth Animations**: Polished user experience

## 🔧 Troubleshooting

**Firebase Error?**
- Check `google-services.json` is in `android/app/`
- Verify config in `web/index.html`

**Gemini Error?**
- Verify API key in `lib/config/app_config.dart`
- Check internet connection

**Build Error?**
```bash
flutter clean
flutter pub get
flutter run
```

## 🎯 What's Next?

- Customize theme colors in `lib/theme/app_theme.dart`
- Add user authentication
- Implement message search
- Export chat history

---

**Need help?** Check the main [README.md](README.md) for detailed instructions.
