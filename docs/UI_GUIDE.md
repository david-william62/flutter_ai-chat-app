# 🎨 UI Design Guide

## App Structure Overview

```
┌─────────────────────────────────────┐
│  ☰  AI Chat Bot            [+]      │  ← App Bar (Dark)
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │  Hello! How can I help?     │   │  ← AI Message (Gray)
│  │  14:32                      │   │
│  └─────────────────────────────┘   │
│                                     │
│          ┌─────────────────────┐   │
│          │  What's the weather?│   │  ← User Message (Purple)
│          │                14:33│   │
│          └─────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  I don't have real-time...  │   │  ← AI Message
│  │  14:33                      │   │
│  └─────────────────────────────┘   │
│                                     │
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐   │
│  │  Type a message...      [→] │   │  ← Input Field
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

## Navigation Drawer

```
┌─────────────────────────────────┐
│                                 │
│  ┌─────────────────────────┐   │
│  │                         │   │
│  │    💬                   │   │  ← Header
│  │    AI Chat Bot          │   │    (Purple)
│  │    Powered by Gemini    │   │
│  │                         │   │
│  └─────────────────────────┘   │
│                                 │
│  Your Chats              [+]    │  ← Chats Header
│                                 │
│  ┌─────────────────────────┐   │
│  │ 💬  What's the weather? │   │  ← Chat Item
│  │     Oct 6, 14:33    →   │   │    (Selectable)
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │ 💬  New Chat           │   │
│  │     Oct 6, 12:15    →   │   │
│  └─────────────────────────┘   │
│                                 │
│  ... more chats ...             │
│                                 │
└─────────────────────────────────┘
```

## Color Palette

### Primary Colors
```
┌─────────┐  ┌─────────┐  ┌─────────┐
│ #6C63FF │  │ #0F0F0F │  │ #1A1A1A │
│ Primary │  │  BG     │  │ Surface │
└─────────┘  └─────────┘  └─────────┘

┌─────────┐  ┌─────────┐  ┌─────────┐
│ #252525 │  │ #E8E8E8 │  │ #9E9E9E │
│  Card   │  │  Text   │  │ Subtle  │
└─────────┘  └─────────┘  └─────────┘
```

### Message Colors
```
User Message (Right):     AI Message (Left):
┌─────────────────┐      ┌─────────────────┐
│    #6C63FF      │      │    #2A2A2A      │
│    (Purple)     │      │  (Dark Gray)    │
└─────────────────┘      └─────────────────┘
```

## Component Specs

### Message Bubble
```
Properties:
- Max Width: 75% of screen
- Padding: 16px horizontal, 12px vertical
- Border Radius: 16px (top), 4px (bottom corner)
- Margin: 4px vertical, 8px horizontal
- Timestamp: 11px, subtle color
```

### Input Field
```
Properties:
- Background: Surface color (#1A1A1A)
- Border Radius: 24px
- Padding: 20px horizontal, 16px vertical
- Focus Border: 2px Purple (#6C63FF)
- Send Button: Circle, 48px diameter
```

### Chat List Item
```
Properties:
- Height: ~72px
- Border Radius: 12px
- Icon: Circle, 44px, Purple tint
- Selected: Purple border + light background
- Swipe: Red background with delete icon
```

### App Bar
```
Properties:
- Height: 56px
- Background: Surface color (#1A1A1A)
- Elevation: 0 (flat design)
- Icon Color: Light (#E8E8E8)
```

## Typography

### Text Styles
```
Title (App Bar):
- Size: 20px
- Weight: 600 (Semi-bold)
- Color: #E8E8E8

Message Text:
- Size: 15px
- Weight: 400 (Regular)
- Color: #E8E8E8

Timestamp:
- Size: 11px
- Weight: 400 (Regular)
- Color: #9E9E9E (70% opacity)

Chat Title:
- Size: 15px
- Weight: 500 (Medium)
- Color: #E8E8E8

Subtitle:
- Size: 12px
- Weight: 400 (Regular)
- Color: #9E9E9E
```

## Spacing System

```
Extra Small:  4px   (xs)
Small:        8px   (sm)
Medium:       12px  (md)
Large:        16px  (lg)
Extra Large:  24px  (xl)
```

## Animations

### Message Entry
```
- Fade in: 200ms
- Slide up: 300ms ease-out
```

### Chat Selection
```
- Background change: 150ms
- Border appear: 200ms
```

### Input Focus
```
- Border pulse: 200ms ease-in-out
```

## Responsive Breakpoints

### Mobile (Default)
```
< 600px: Single column, full width
```

### Tablet
```
600px - 1024px: 
- Drawer: 320px
- Content: Remaining space
```

### Desktop
```
> 1024px:
- Drawer: Always visible, 380px
- Content: Centered, max 1200px
```

## Icon Set

```
Chat:           chat_bubble_outline
New Chat:       add_circle_outline
Menu:           menu
Send:           send_rounded
Delete:         delete_outline
Error:          error_outline
AI Response:    auto_awesome
Empty State:    chat_bubble_outline
Loading:        CircularProgressIndicator
```

## Empty States

### No Chat Selected
```
┌─────────────────────────────────┐
│                                 │
│         💬 (Large Icon)         │
│                                 │
│      No chat selected           │
│                                 │
│     [Start New Chat]            │
│                                 │
└─────────────────────────────────┘
```

### Empty Chat
```
┌─────────────────────────────────┐
│                                 │
│         ✨ (Large Icon)         │
│                                 │
│    Start a conversation         │
│                                 │
│  Ask me anything! I'm here to   │
│           help.                 │
│                                 │
└─────────────────────────────────┘
```

### Error State
```
┌─────────────────────────────────┐
│ ⚠ Error message text      [X]   │
└─────────────────────────────────┘
Red background, dismissible
```

## Interaction Patterns

### Send Message
```
1. Type in input field
2. Send button turns purple
3. Tap send button
4. Message appears with animation
5. Input clears
6. Loading indicator shows
7. AI response appears
```

### Switch Chat
```
1. Open drawer (swipe right or tap menu)
2. Tap chat item
3. Item highlights in purple
4. Drawer closes
5. Messages load
6. Scroll to bottom
```

### Delete Chat
```
1. Swipe chat item left
2. Red background reveals
3. Confirm dialog appears
4. Tap Delete
5. Chat removes with animation
```

## Accessibility

### Touch Targets
- Minimum: 48x48px
- Recommended: 56x56px for primary actions

### Contrast Ratios
- Text: 4.5:1 minimum
- Interactive elements: 3:1 minimum
- Purple on dark: 7.2:1 ✓

### Keyboard Navigation
- Tab order: Logical flow
- Enter: Send message
- Escape: Close dialogs

## Platform Differences

### Android
- Material design 3 components
- Ripple effects on touch
- System navigation bar color

### Web
- Hover states for buttons
- Mouse interactions
- Keyboard shortcuts support

## Design Tokens

```dart
// In app_theme.dart
class AppTheme {
  // Colors
  static const primaryColor = Color(0xFF6C63FF);
  static const backgroundColor = Color(0xFF0F0F0F);
  static const surfaceColor = Color(0xFF1A1A1A);
  
  // Spacing
  static const spacingXS = 4.0;
  static const spacingSM = 8.0;
  static const spacingMD = 12.0;
  static const spacingLG = 16.0;
  static const spacingXL = 24.0;
  
  // Border Radius
  static const radiusSM = 8.0;
  static const radiusMD = 12.0;
  static const radiusLG = 16.0;
  static const radiusXL = 24.0;
}
```

---

## Quick Customization Guide

### Change Primary Color
```dart
// lib/theme/app_theme.dart
static const Color primaryColor = Color(0xFF2196F3); // Blue
```

### Adjust Message Bubble Radius
```dart
// lib/widgets/message_bubble.dart
borderRadius: BorderRadius.circular(20), // More rounded
```

### Modify Input Height
```dart
// lib/widgets/message_input.dart
contentPadding: EdgeInsets.symmetric(
  horizontal: 24, // Wider
  vertical: 20,   // Taller
)
```

### Change Font Sizes
```dart
// lib/theme/app_theme.dart
textTheme: TextTheme(
  bodyLarge: TextStyle(fontSize: 16), // Larger
  bodyMedium: TextStyle(fontSize: 14),
)
```

---

**Design Philosophy:** Clean, minimal, dark-themed, and easy to reach on mobile devices.
