# ♻️ ECO NOVA — Smart Waste Management & IoT Monitoring App

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%5E3.38.4-02569B.svg?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2.svg?logo=dart)](https://dart.dev)
[![Hardware](https://img.shields.io/badge/Edge%20Hardware-Raspberry%20Pi%205-C51A4A.svg?logo=raspberry-pi)](https://www.raspberrypi.com/)

**ECO NOVA** is an AI-powered automated waste-sorting and IoT monitoring system designed for hospitals, private clinics, and high-traffic facilities. This repository houses the **cross-platform mobile monitoring application** built with Flutter, enabling facility staff and administrators to track bin fill-levels in real time, monitor sorting analytics, and receive instant overflow alerts from ECO NOVA smart sorting units.

---

## 🌟 System & App Features

- **Real-Time IoT Bin Telemetry:** Connects with ultrasonic fill-level sensors mounted inside ECO NOVA sorting compartments to display live capacity percentages.
- **Automated Sorting Analytics:** Tracks categorized waste metrics (plastics, metals, paper, and medical/general waste) processed by the Raspberry Pi 5 computer vision pipeline.
- **Instant Overflow & Maintenance Alerts:** Notifies facility staff before bins reach critical capacity to reduce biohazard exposure and optimize collection schedules.
- **Responsive Cross-Platform UI:** Built with Flutter (`Sizer` & Material Design) supporting both Light and Dark themes for seamless operation across mobile and tablet devices.

---

## 📋 Prerequisites

- **Flutter SDK** (`^3.38.4`)
- **Dart SDK**
- **Android Studio / VS Code** with Flutter & Dart extensions
- **Android SDK / Xcode** (for Android & iOS builds)

---

## 🛠️ Installation & Setup

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/zozmohamed19/econova.git](https://github.com/zozmohamed19/econova.git)
   cd econova
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   flutter run
   ```

---

## 📁 Project Structure

```text
flutter_app/
├── android/               # Android-specific configuration
├── ios/                   # iOS-specific configuration
├── lib/
│   ├── core/              # Core utilities, API services, and IoT data handlers
│   │   └── utils/         # Helper & formatting classes
│   ├── presentation/      # UI screens (Dashboards, Bin Status, Analytics)
│   │   └── splash_screen/ # Splash screen implementation
│   ├── routes/            # Application routing configuration
│   ├── theme/             # Light & Dark Material theme configuration
│   ├── widgets/           # Reusable UI components & telemetry cards
│   └── main.dart          # Application entry point
├── assets/                # Static assets (icons, images, custom fonts)
├── pubspec.yaml           # Project dependencies and configuration
└── README.md              # Project documentation
```

---

## 🎨 Theming & Responsive Architecture

The application implements a unified theme system supporting automatic Light and Dark mode switching alongside responsive screen scaling:

- **Theming (`lib/theme/`):** Custom `ColorScheme`, typography, button, card, and dialog themes tailored for high-contrast monitoring dashboards.
- **Responsive Layout (`Sizer`):** Adaptive sizing (`50.w`, `20.h`) ensuring consistent rendering across handheld phones and facility control tablets.

---

## 📦 Production Build

To build the release APK for Android deployment:

```bash
flutter build apk --release
```

---

## 🏆 Recognition & Milestones

- **Finalist** — *Youth Leaders Foundation Competition* (Environment & Green Technology Track, 2026)
- **Official Submission** — *3rd Edition Presidential African Youth in AI and Robotics Competition (2026)*

---

## 👥 Core Team (NOVA SONIC)

Developed by **Team NOVA SONIC** — Faculty of Computers and Artificial Intelligence, Assiut National University:
- **Ziad Mohamed** — Co-Founder & Software/AI Developer
- **Joudy Ahmed Mahmoud** — Co-Founder
- **Mohamed Bahaa El-Din Mohamed** — Co-Founder
- **Rival Ashraf Abdel-Sattar** — Co-Founder

---

## 🙏 Acknowledgments & License

- Built with [Flutter](https://flutter.dev) & [Dart](https://dart.dev) (bootstrapped via [Rocket.new](https://rocket.new))
- Released as open-source under the **MIT License**.
