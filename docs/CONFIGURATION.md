# Configuration Templates

## 🔥 Firebase Configuration

### For `web/index.html` (lines 23-29)

```javascript
const firebaseConfig = {
  apiKey: "AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  authDomain: "your-project-id.firebaseapp.com",
  projectId: "your-project-id",
  storageBucket: "your-project-id.appspot.com",
  messagingSenderId: "123456789012",
  appId: "1:123456789012:web:abcdef1234567890"
};
```

### For `lib/main.dart` (lines 15-21)

```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: 'AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
    appId: '1:123456789012:web:abcdef1234567890',
    messagingSenderId: '123456789012',
    projectId: 'your-project-id',
    storageBucket: 'your-project-id.appspot.com',
  ),
);
```

### For `lib/config/app_config.dart`

```dart
class AppConfig {
  static const String firebaseProjectId = 'your-project-id';
  static const String geminiApiKey = 'AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
}
```

---

## 🎨 Theme Customization

### Primary Color Schemes

**Purple (Default)**
```dart
static const Color primaryColor = Color(0xFF6C63FF);
```

**Blue**
```dart
static const Color primaryColor = Color(0xFF2196F3);
```

**Green**
```dart
static const Color primaryColor = Color(0xFF4CAF50);
```

**Orange**
```dart
static const Color primaryColor = Color(0xFFFF9800);
```

**Pink**
```dart
static const Color primaryColor = Color(0xFFE91E63);
```

### Background Variations

**Darker (Default)**
```dart
static const Color backgroundColor = Color(0xFF0F0F0F);
static const Color surfaceColor = Color(0xFF1A1A1A);
```

**Lighter Dark**
```dart
static const Color backgroundColor = Color(0xFF1A1A1A);
static const Color surfaceColor = Color(0xFF252525);
```

**True Black (OLED)**
```dart
static const Color backgroundColor = Color(0xFF000000);
static const Color surfaceColor = Color(0xFF0F0F0F);
```

---

## 📱 Platform-Specific Setup

### Android Setup Checklist

1. ✅ Add `google-services.json` to `android/app/`
2. ✅ Package name: `com.aichatbot.ai_chat_bot`
3. ✅ Update `android/app/build.gradle` if needed:
   ```gradle
   android {
       compileSdkVersion 34
       defaultConfig {
           minSdkVersion 21
           targetSdkVersion 34
       }
   }
   ```

### Web Setup Checklist

1. ✅ Update Firebase config in `web/index.html`
2. ✅ CORS is handled by Firebase
3. ✅ No additional setup needed

---

## 🔒 Security Best Practices

### Firebase Security Rules (Production)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Only authenticated users can read/write their own chats
    match /chats/{chatId} {
      allow read, write: if request.auth != null && 
                         request.auth.uid == resource.data.userId;
    }
    
    match /messages/{messageId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### API Key Management

**Development:**
- Store keys in `lib/config/app_config.dart`
- Add to `.gitignore`

**Production:**
- Use environment variables
- Use Firebase Remote Config
- Implement backend proxy for Gemini API

---

## 🚀 Deployment

### Web Deployment (Firebase Hosting)

```bash
# Build for web
flutter build web

# Install Firebase CLI
npm install -g firebase-tools

# Initialize Firebase
firebase init hosting

# Deploy
firebase deploy --only hosting
```

### Android Release Build

```bash
# Generate keystore
keytool -genkey -v -keystore release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release

# Build APK
flutter build apk --release

# Build App Bundle (Google Play)
flutter build appbundle --release
```

---

## 📊 Firebase Collections Structure

```
firestore/
├── chats/
│   └── {chatId}
│       ├── id: string
│       ├── title: string
│       ├── createdAt: timestamp
│       └── lastMessageAt: timestamp
│
└── messages/
    └── {messageId}
        ├── id: string
        ├── text: string
        ├── isUser: boolean
        ├── timestamp: timestamp
        └── chatId: string
```

---

## 🔧 Common Issues & Solutions

### Issue: Firebase not initializing
**Solution:** Check if all Firebase config values are correct in both `web/index.html` and `lib/main.dart`

### Issue: Gemini API quota exceeded
**Solution:** Check your API quota at [Google AI Studio](https://makersuite.google.com/app/apikey)

### Issue: Build fails on Android
**Solution:** 
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Issue: CORS error on Web
**Solution:** Firebase handles CORS automatically. Ensure you're using the correct Firebase config.
