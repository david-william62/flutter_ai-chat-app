#!/bin/bash

echo "🚀 AI Chat Bot Setup Script"
echo "============================"
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null
then
    echo "❌ Flutter is not installed. Please install Flutter first."
    echo "   Visit: https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo "✅ Flutter is installed"
echo ""

# Get Flutter dependencies
echo "📦 Installing Flutter dependencies..."
flutter pub get

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo "✅ Dependencies installed successfully"
echo ""

# Check for .env file
if [ ! -f .env ]; then
    echo "⚠️  .env file not found"
    echo "   Creating .env from .env.example..."
    cp .env.example .env
    echo "   Please edit .env and add your API keys"
    echo ""
fi

# Check for google-services.json
if [ ! -f android/app/google-services.json ]; then
    echo "⚠️  google-services.json not found in android/app/"
    echo "   Please download it from Firebase Console and place it there"
    echo ""
fi

echo "📋 Next Steps:"
echo "=============="
echo ""
echo "1. Configure Firebase:"
echo "   - Create project at: https://console.firebase.google.com/"
echo "   - Download google-services.json to android/app/"
echo "   - Update web/index.html with Firebase config"
echo ""
echo "2. Get Gemini API Key:"
echo "   - Visit: https://makersuite.google.com/app/apikey"
echo "   - Create API key"
echo ""
echo "3. Update Configuration:"
echo "   - Edit lib/config/app_config.dart"
echo "   - Edit lib/main.dart with Firebase options"
echo ""
echo "4. Run the app:"
echo "   - For Web: flutter run -d chrome"
echo "   - For Android: flutter run"
echo ""
echo "✅ Setup complete! Read README.md for detailed instructions."
