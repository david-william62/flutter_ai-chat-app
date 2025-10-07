# AI Chat Bot - Flutter & Gemini AI

A clean, minimal dark-themed AI chatbot built with Flutter and Google's Gemini AI, featuring Firebase Firestore for cross-platform chat storage.

## Features

✨ **Clean Dark Theme UI** - Minimal, easy-to-use interface  
🤖 **Gemini AI Integration** - Powered by Google's latest AI model  
☁️ **Firebase Firestore** - Cross-platform chat storage  
📱 **Multi-Platform** - Works on Android and Web  
💬 **Chat History** - Save and manage multiple conversations  
🔄 **Real-time Sync** - Access chats across devices

## Setup Instructions

### Prerequisites

1. Flutter SDK (3.9.2 or higher)
2. Firebase account
3. Google AI Studio account (for Gemini API key)

### Step 1: Firebase Setup

#### 1.1 Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" or select an existing project
3. Follow the setup wizard

#### 1.2 Add Web App

1. In Firebase Console, select your project
2. Click "Add app" and select "Web"
3. Register your app with a nickname (e.g., "AI Chat Bot Web")
4. Copy the Firebase configuration
5. Open `web/index.html` and replace the Firebase config:

#### 1.3 Add Android App

1. In Firebase Console, click "Add app" and select "Android"
2. Enter package name: `com.aichatbot.ai_chat_bot`
3. Download `google-services.json`
4. Place it in `android/app/` directory
5. Add your SHA-1 (and SHA-256 if available):  
   - Run `./gradlew signingReport` inside `android/` or use Android Studio (Gradle panel → Tasks → android → signingReport).  
   - Copy the `SHA1` (and `SHA-256`) values into the Firebase Console → Android app settings → “Add fingerprint”.
6. Download the updated `google-services.json` (now containing OAuth clients) and replace `android/app/google-services.json`.
7. Open Firebase Console → Project settings → “Your apps” → Web App. Copy the “Web client ID” into `.env` → `GOOGLE_WEB_CLIENT_ID`.
8. From the project root run:
   ```bash
   flutter clean
   flutter pub get
   ```

#### 1.4 Enable Firestore

1. In Firebase Console, go to "Firestore Database"
2. Click "Create database"
3. Choose "Start in test mode" (for development)
4. Select a location and click "Enable"

### Step 2: Gemini API Setup

1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with your Google account
3. Click "Create API Key"
4. Copy your API key

### Step 3: Configure the App

1. Rename .env.example to .env and fill the values
2. Rename google-servieses.example.json to google-services.json in android/app/src and fill the needed details

### Step 4: Install Dependencies

```bash
flutter pub get
```

### Step 5: Run the App

#### For Web:
```bash
flutter run -d chrome
```

#### For Android:
```bash
flutter run -d android
```

## Project Structure

```
lib/
├── config/
│   └── app_config.dart          # App configuration
├── models/
│   ├── chat.dart                # Chat model
│   └── message.dart             # Message model
├── providers/
│   └── chat_provider.dart       # State management
├── screens/
│   └── chat_screen.dart         # Main chat screen
├── services/
│   ├── firebase_service.dart    # Firebase operations
│   └── gemini_service.dart      # Gemini AI integration
├── theme/
│   └── app_theme.dart           # Dark theme configuration
├── widgets/
│   ├── chat_list_item.dart      # Chat list item widget
│   ├── message_bubble.dart      # Message bubble widget
│   └── message_input.dart       # Message input widget
└── main.dart                    # App entry point
```

## Usage

1. **Start New Chat**: Tap the "+" button in the app bar
2. **Send Message**: Type your message and tap the send button
3. **View Chat History**: Open the drawer (menu icon) to see all chats
4. **Delete Chat**: Swipe left on any chat in the drawer
5. **Switch Chat**: Tap on any chat in the drawer

## Customization

### Change Theme Colors

Edit `lib/theme/app_theme.dart`:

```dart
static const Color primaryColor = Color(0xFF6C63FF); // Your color
static const Color backgroundColor = Color(0xFF0F0F0F);
```

## Troubleshooting

### Firebase Errors
- Make sure `google-services.json` is in `android/app/`
- Verify Firebase configuration in `web/index.html` and `lib/main.dart`

### Gemini API Errors
- Verify your API key is correct in `lib/config/app_config.dart`
- Check API quota limits in Google AI Studio

## Security Notes

⚠️ **Important**: 
- Never commit API keys to public repositories
- Use environment variables for production
- Implement proper Firebase security rules

## License

This project is open source and available under the MIT License.

---

Built with ❤️ using Flutter
