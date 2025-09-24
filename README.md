# Booking App (Flutter)

A Booking.com–style Flutter application with modular UI, mock and live data modes, and secure secret handling via environment variables.

## Features

### 🎨 Design System
- **Professional Color Scheme**: Uses the exact Booking.com brand colors
- **Consistent Typography**: Roboto font family with proper text hierarchy
- **Modern UI Components**: Cards, buttons, inputs with consistent styling
- **Responsive Layout**: Optimized for mobile devices

### 📱 Screens
1. **Search Page**: Main booking interface with service selection
   - Stays, Car Rental, Taxi, Attractions
   - Search form with destination, dates, and guests
   - Promotional content and loyalty program info

2. **Saved Page**: User's saved items and wishlist
   - Trip planning section
   - Empty state with call-to-action

3. **Bookings Page**: Trip management and history
   - Active, Past, and Cancelled trip tabs
   - Empty state with globe illustration

4. **Profile Page**: User account and settings
   - Genius loyalty program status
   - Account management sections
   - Help and support options

### 🚀 Technical Features
- **State Management**: Proper state handling for service selection
- **Custom Widgets**: Reusable UI components
- **Theme System**: Centralized design tokens and colors
- **Navigation**: Bottom navigation with custom styling

## Color Palette

- **Primary Blue**: `#003580` (Booking.com brand color)
- **Secondary Blue**: `#0052CC`
- **Accent Yellow**: `#FFB700`
- **Accent Green**: `#00A698`
- **Neutral Colors**: White, light grey, dark grey
- **Status Colors**: Success green, warning orange, error red

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code

### Installation
1. Clone the repository
2. Navigate to the project directory
3. Copy `.env.example` to `.env` and fill your keys
4. Run `flutter pub get`
5. Run `flutter run`

### Environment variables
Create a `.env` in the project root:

```
RAPIDAPI_KEY=your_rapidapi_key
BOOKING_API_BASE_URL=https://booking-com15.p.rapidapi.com/api/v1
BOOKING_API_HOST=booking-com15.p.rapidapi.com
AUTH_API_BASE_URL=https://login-signup.p.rapidapi.com/public/v1
AUTH_API_HOST=login-signup.p.rapidapi.com
RAPIDAPI_AUTH_KEY=
```

The app uses `flutter_dotenv` to load variables at startup (see `lib/main.dart`).

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── theme/
│   └── app_theme.dart       # Design system and theme
├── widgets/
│   └── common_widgets.dart  # Reusable UI components
└── pages/
    ├── onboarding_page.dart # Welcome screen
    ├── login_page.dart      # Authentication
    ├── signup_page.dart     # User registration
    ├── search_page.dart     # Main booking interface
    ├── saved_page.dart      # Saved items
    ├── bookings_page.dart   # Trip management
    └── profile_page.dart    # User profile
```

## Design Principles

- **Consistency**: All UI elements follow the same design language
- **Accessibility**: Proper contrast ratios and touch targets
- **Performance**: Optimized widgets and efficient rendering
- **Maintainability**: Clean, well-structured code with reusable components

## Security Notes

- Secrets must never be committed. `.env` is gitignored; share values out-of-band or via CI secrets.
- The app falls back to mock data when keys are missing, enabling safe development without network access.

## Future Enhancements

- [ ] API integration for real booking data
- [ ] Date picker calendar implementation
- [ ] Guest picker with increment/decrement
- [ ] Search functionality
- [ ] User authentication
- [ ] Push notifications
- [ ] Offline support
- [ ] Multi-language support

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License. See `LICENSE` for details.

---

Built with ❤️ using Flutter
