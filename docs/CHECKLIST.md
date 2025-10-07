# ✅ Setup Checklist

Use this checklist to ensure your AI Chat Bot is properly configured and ready to use.

## 📋 Pre-Setup

- [ ] Flutter SDK installed (3.9.2+)
- [ ] Android Studio / VS Code installed
- [ ] Chrome browser for web testing
- [ ] Google account for Firebase
- [ ] Google account for Gemini API

## 🔥 Firebase Setup

### Create Project
- [ ] Go to [Firebase Console](https://console.firebase.google.com/)
- [ ] Create new project or select existing
- [ ] Note your project ID: `________________`

### Web App Configuration
- [ ] Add Web app in Firebase Console
- [ ] Copy Firebase config object
- [ ] Update `web/index.html` (lines 23-29)
- [ ] Verify all 6 config values are set

### Android App Configuration
- [ ] Add Android app in Firebase Console
- [ ] Use package name: `com.aichatbot.ai_chat_bot`
- [ ] Download `google-services.json`
- [ ] Place file in `android/app/` directory
- [ ] Verify file is in correct location

### Firestore Database
- [ ] Open Firestore Database in Firebase Console
- [ ] Click "Create database"
- [ ] Select "Start in test mode"
- [ ] Choose closest region
- [ ] Wait for database to be created
- [ ] Verify database is active

## 🤖 Gemini AI Setup

- [ ] Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
- [ ] Sign in with Google account
- [ ] Click "Create API Key"
- [ ] Copy API key: `AIzaSy...`
- [ ] Store key securely

## ⚙️ App Configuration

### File: `lib/config/app_config.dart`
- [ ] Open file in editor
- [ ] Replace `YOUR_FIREBASE_PROJECT_ID` with actual project ID
- [ ] Replace `YOUR_GEMINI_API_KEY` with actual API key
- [ ] Save file

### File: `lib/main.dart`
- [ ] Open file in editor
- [ ] Update `apiKey` (line 17)
- [ ] Update `appId` (line 18)
- [ ] Update `messagingSenderId` (line 19)
- [ ] Update `projectId` (line 20)
- [ ] Update `storageBucket` (line 21)
- [ ] Save file

### File: `web/index.html`
- [ ] Open file in editor
- [ ] Update `apiKey` (line 25)
- [ ] Update `authDomain` (line 26)
- [ ] Update `projectId` (line 27)
- [ ] Update `storageBucket` (line 28)
- [ ] Update `messagingSenderId` (line 29)
- [ ] Update `appId` (line 30)
- [ ] Save file

## 🔧 Dependencies

- [ ] Open terminal in project directory
- [ ] Run: `flutter pub get`
- [ ] Wait for completion (no errors)
- [ ] Verify all packages downloaded

## 🧪 Testing

### Code Analysis
- [ ] Run: `flutter analyze`
- [ ] Verify: "No issues found!"

### Build Test (Web)
- [ ] Run: `flutter run -d chrome`
- [ ] Wait for app to open in Chrome
- [ ] Verify app loads without errors

### Build Test (Android)
- [ ] Connect Android device or start emulator
- [ ] Run: `flutter run`
- [ ] Wait for app to install
- [ ] Verify app launches

## 🎯 Functionality Tests

### Test New Chat
- [ ] App opens successfully
- [ ] See "Start a conversation" message
- [ ] Type a test message: "Hello"
- [ ] Press send button
- [ ] See your message appear
- [ ] See AI response appear
- [ ] Verify chat title updates

### Test Chat List
- [ ] Open drawer (menu icon)
- [ ] See your chat in the list
- [ ] Create new chat (+ button)
- [ ] See new chat appears
- [ ] Switch between chats
- [ ] Verify messages persist

### Test Delete Chat
- [ ] Open drawer
- [ ] Swipe left on a chat
- [ ] See red delete background
- [ ] Tap to delete
- [ ] Confirm deletion
- [ ] Verify chat is removed

### Test Error Handling
- [ ] Turn off internet
- [ ] Try to send message
- [ ] See error notification
- [ ] Tap X to dismiss
- [ ] Turn on internet
- [ ] Try again successfully

## 🔒 Security Checks

- [ ] `.env` file in `.gitignore`
- [ ] `google-services.json` in `.gitignore`
- [ ] API keys not in git history
- [ ] Firestore rules reviewed

## 📱 Platform-Specific

### Web
- [ ] Test in Chrome
- [ ] Test in Firefox (optional)
- [ ] Test in Safari (optional)
- [ ] Check responsive design
- [ ] Test keyboard shortcuts

### Android
- [ ] Test on physical device
- [ ] Test on emulator
- [ ] Check different screen sizes
- [ ] Test orientation changes
- [ ] Verify back button behavior

## 🎨 UI/UX Verification

- [ ] Dark theme loads correctly
- [ ] Purple accent color visible
- [ ] Text is readable
- [ ] Buttons are easy to tap
- [ ] Animations are smooth
- [ ] Empty states show correctly
- [ ] Loading indicators work

## 📊 Firebase Console Checks

### Firestore Database
- [ ] Open Firestore in console
- [ ] See `chats` collection created
- [ ] See `messages` collection created
- [ ] Verify data is being stored
- [ ] Check timestamps are correct

### Usage Monitoring
- [ ] Check Firestore usage stats
- [ ] Verify reads/writes are counting
- [ ] Monitor for errors

## 🚀 Production Readiness (Optional)

### Security
- [ ] Update Firestore rules for production
- [ ] Add user authentication
- [ ] Move API keys to environment variables
- [ ] Enable app check

### Performance
- [ ] Test with 100+ messages
- [ ] Test with 50+ chats
- [ ] Check load times
- [ ] Optimize images (if added)

### Deployment
- [ ] Build release version
- [ ] Test release build
- [ ] Prepare app store assets
- [ ] Set up Firebase Hosting (web)

## ✅ Final Verification

- [ ] All checklists above completed
- [ ] No console errors
- [ ] App works offline (gracefully)
- [ ] All features functional
- [ ] Documentation reviewed
- [ ] README.md read thoroughly

## 📝 Notes

**Issues encountered:**
```
Write any problems you faced here:



```

**Solutions found:**
```
Write how you solved them:



```

**Configuration used:**
```
Firebase Project ID: ________________
Gemini API Key: AIzaSy______________ (first 10 chars)
Platforms tested: [ ] Web  [ ] Android
```

---

## 🎉 Completion

When all items are checked:

**Congratulations! 🎊**

Your AI Chat Bot is fully configured and ready to use!

**Next Steps:**
1. Customize the theme colors
2. Add more features
3. Share with friends
4. Deploy to production

**Support:**
- 📖 Read [README.md](README.md) for detailed docs
- ⚡ Check [QUICKSTART.md](QUICKSTART.md) for quick reference
- 🎨 See [UI_GUIDE.md](UI_GUIDE.md) for design specs
- ⚙️ View [CONFIGURATION.md](CONFIGURATION.md) for templates

---

**Date Completed:** _______________

**Version:** 1.0.0

**Built by:** _______________
