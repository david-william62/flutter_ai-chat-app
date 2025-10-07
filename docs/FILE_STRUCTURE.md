# 📁 Project File Structure

## Complete File Tree

```
ai_chat_bot/
│
├── 📱 lib/                              # Flutter application code
│   ├── 🔧 config/
│   │   └── app_config.dart              # Firebase & Gemini API configuration
│   │
│   ├── 📊 models/
│   │   ├── chat.dart                    # Chat data model
│   │   └── message.dart                 # Message data model
│   │
│   ├── 🔄 providers/
│   │   └── chat_provider.dart           # State management (Provider)
│   │
│   ├── 🖼️ screens/
│   │   └── chat_screen.dart             # Main chat UI screen
│   │
│   ├── 🌐 services/
│   │   ├── firebase_service.dart        # Firestore database operations
│   │   └── gemini_service.dart          # Gemini AI integration
│   │
│   ├── 🎨 theme/
│   │   └── app_theme.dart               # Dark theme configuration
│   │
│   ├── 🧩 widgets/
│   │   ├── chat_list_item.dart          # Individual chat item widget
│   │   ├── message_bubble.dart          # Message display widget
│   │   └── message_input.dart           # Message input field widget
│   │
│   └── main.dart                        # App entry point
│
├── 🌐 web/
│   ├── index.html                       # Web entry point (Firebase config here)
│   ├── manifest.json                    # PWA manifest
│   └── favicon.png                      # App icon
│
├── 🤖 android/
│   ├── app/
│   │   ├── build.gradle                 # Android build config
│   │   ├── src/main/AndroidManifest.xml # Android manifest
│   │   └── google-services.json         # ⚠️ ADD THIS FILE (Firebase config)
│   └── build.gradle                     # Project-level build config
│
├── 📝 Documentation Files
│   ├── README.md                        # Main documentation
│   ├── QUICKSTART.md                    # Quick start guide
│   ├── CHECKLIST.md                     # Setup checklist
│   ├── CONFIGURATION.md                 # Config templates
│   ├── PROJECT_SUMMARY.md               # Project overview
│   ├── UI_GUIDE.md                      # UI design guide
│   └── FILE_STRUCTURE.md                # This file
│
├── ⚙️ Configuration Files
│   ├── pubspec.yaml                     # Flutter dependencies
│   ├── analysis_options.yaml            # Dart analyzer config
│   ├── .gitignore                       # Git ignore rules
│   ├── .env.example                     # Environment template
│   └── setup.sh                         # Setup script (executable)
│
└── 🔒 Security (Create These)
    ├── .env                             # Your API keys (DO NOT COMMIT)
    └── android/app/google-services.json # Firebase config (DO NOT COMMIT)
```

## 📝 Key Files to Configure

### 1️⃣ Must Edit Before Running

| File | Lines | What to Change |
|------|-------|----------------|
| `lib/config/app_config.dart` | 10-11 | Firebase Project ID & Gemini API Key |
| `lib/main.dart` | 15-21 | Firebase initialization options |
| `web/index.html` | 23-30 | Firebase web configuration |

### 2️⃣ Must Add Before Running

| File | Location | Source |
|------|----------|--------|
| `google-services.json` | `android/app/` | Firebase Console → Android App |

## 📦 Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # UI
  cupertino_icons: ^1.0.8
  
  # Firebase
  firebase_core: ^3.6.0
  cloud_firestore: ^5.4.4
  
  # AI
  google_generative_ai: ^0.4.6
  
  # State & Utils
  provider: ^6.1.2
  intl: ^0.19.0
  uuid: ^4.5.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

## 🎯 File Purposes

### Core Application Files

**`lib/main.dart`**
- App entry point
- Firebase initialization
- Provider setup
- Theme configuration

**`lib/config/app_config.dart`**
- Centralized configuration
- API keys storage
- Project settings

### Data Layer

**`lib/models/chat.dart`**
```dart
Chat {
  - id: String
  - title: String
  - createdAt: DateTime
  - lastMessageAt: DateTime
}
```

**`lib/models/message.dart`**
```dart
Message {
  - id: String
  - text: String
  - isUser: bool
  - timestamp: DateTime
  - chatId: String
}
```

### Service Layer

**`lib/services/firebase_service.dart`**
- Create/read/delete chats
- Store/retrieve messages
- Firestore operations

**`lib/services/gemini_service.dart`**
- Send messages to AI
- Receive AI responses
- Manage chat sessions

### State Management

**`lib/providers/chat_provider.dart`**
- Manage app state
- Handle user actions
- Coordinate services
- UI updates

### UI Layer

**`lib/screens/chat_screen.dart`**
- Main chat interface
- Navigation drawer
- Message list
- Input field integration

**`lib/widgets/`**
- `message_bubble.dart` - Individual message display
- `message_input.dart` - Text input with send button
- `chat_list_item.dart` - Sidebar chat item

**`lib/theme/app_theme.dart`**
- Dark theme colors
- Typography styles
- Component themes

## 📊 Data Flow

```
User Input
    ↓
MessageInput Widget
    ↓
ChatProvider (State)
    ↓
├─→ FirebaseService → Firestore (Save)
└─→ GeminiService → Gemini API (Get Response)
    ↓
ChatProvider (Update State)
    ↓
ChatScreen (Re-render)
    ↓
MessageBubble Widget (Display)
```

## 🔄 File Relationships

```
main.dart
  └─→ ChatProvider
       ├─→ FirebaseService
       │    └─→ Chat Model
       │    └─→ Message Model
       │
       └─→ GeminiService
            └─→ Message Model

ChatScreen
  ├─→ ChatProvider (state)
  ├─→ MessageBubble (widget)
  ├─→ MessageInput (widget)
  └─→ ChatListItem (widget)
```

## 🎨 UI Component Tree

```
MaterialApp
  └─→ ChatScreen (Scaffold)
       ├─→ AppBar
       │    ├─→ Menu Icon
       │    ├─→ Title Text
       │    └─→ New Chat Button
       │
       ├─→ Drawer
       │    ├─→ DrawerHeader
       │    └─→ ListView
       │         └─→ ChatListItem (repeated)
       │
       ├─→ Body (Column)
       │    ├─→ ListView (Messages)
       │    │    └─→ MessageBubble (repeated)
       │    │
       │    ├─→ Error Banner (conditional)
       │    │
       │    └─→ MessageInput
       │         ├─→ TextField
       │         └─→ Send Button
```

## 📱 Platform-Specific Files

### Web Only
- `web/index.html` - HTML entry point
- `web/manifest.json` - PWA configuration
- `web/favicon.png` - Browser icon

### Android Only
- `android/app/build.gradle` - Android build settings
- `android/app/src/main/AndroidManifest.xml` - App permissions
- `android/app/google-services.json` - Firebase config

### iOS (Not included, but ready to add)
- `ios/Runner/Info.plist` - iOS configuration
- `ios/Runner/GoogleService-Info.plist` - Firebase config

## 🔍 Where to Find Things

### Need to change colors?
→ `lib/theme/app_theme.dart`

### Need to modify AI behavior?
→ `lib/services/gemini_service.dart`

### Need to change database structure?
→ `lib/services/firebase_service.dart`
→ `lib/models/`

### Need to update UI layout?
→ `lib/screens/chat_screen.dart`
→ `lib/widgets/`

### Need to add new features?
→ `lib/providers/chat_provider.dart` (state logic)
→ `lib/screens/chat_screen.dart` (UI)

### Firebase configuration?
→ `web/index.html` (web)
→ `android/app/google-services.json` (android)
→ `lib/main.dart` (app initialization)

### API keys?
→ `lib/config/app_config.dart`

## 📏 File Size Reference

```
Typical sizes:
- Models:       ~50-100 lines each
- Services:     ~100-150 lines each
- Providers:    ~150-200 lines
- Screens:      ~200-300 lines
- Widgets:      ~50-150 lines each
- Theme:        ~80-100 lines
- Config:       ~20-30 lines
```

## 🚀 Build Outputs (Auto-generated)

```
build/
├── web/                    # Web build output
├── app/                    # Android build output
└── ...                     # Other platforms

.dart_tool/                 # Dart analysis cache
.flutter-plugins            # Plugin registry
.flutter-plugins-dependencies
.packages                   # Package resolution
```

**Note:** These are auto-generated and should NOT be edited manually.

## ✅ Files You Need to Create

1. **`.env`** (Optional, for production)
   ```
   FIREBASE_PROJECT_ID=your-id
   GEMINI_API_KEY=your-key
   ```

2. **`android/app/google-services.json`** (Required for Android)
   - Download from Firebase Console

## 🔒 Files to Never Commit

Add to `.gitignore`:
```
.env
google-services.json
*.log
.DS_Store
```

## 📚 Documentation Files Explained

| File | Purpose | When to Use |
|------|---------|-------------|
| `README.md` | Full documentation | Detailed setup & info |
| `QUICKSTART.md` | 5-minute setup | Quick start guide |
| `CHECKLIST.md` | Step-by-step tasks | Ensure nothing missed |
| `CONFIGURATION.md` | Config templates | Copy-paste configs |
| `PROJECT_SUMMARY.md` | Overview | Understand project |
| `UI_GUIDE.md` | Design specs | Customize UI |
| `FILE_STRUCTURE.md` | This file | Find your way |

---

## 🎯 Quick Navigation

**To start:** Read `QUICKSTART.md`  
**To configure:** Check `CONFIGURATION.md`  
**To verify:** Use `CHECKLIST.md`  
**To understand:** See `PROJECT_SUMMARY.md`  
**To customize:** Read `UI_GUIDE.md`  
**To navigate:** You're here! 📍

---

**Last Updated:** October 6, 2024  
**Version:** 1.0.0  
**Total Files:** ~25 (excluding auto-generated)
