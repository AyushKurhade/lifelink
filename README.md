# LifeLink 🩸
### Emergency Blood Response System

> *Every second counts. LifeLink connects patients to donors in real-time.*

Built by **Team Neural Coders** at NAVONMESH 2026 Hackathon.

---

## 📱 About LifeLink

LifeLink is a real-time emergency blood response mobile application built with Flutter and Firebase. It bridges the critical gap between blood donors and patients in emergency situations — connecting them in seconds, not hours.

Every 2 seconds, someone in India needs blood. Every day, thousands of patients struggle to find compatible donors in time. LifeLink solves this by creating a live network of donors and patients in your city.

---

## 🚀 Features

### 🔴 Emergency Blood Request
- Patient selects blood group and urgency level (Critical / Urgent / Normal)
- Request is submitted with live GPS location
- Nearby donors are instantly alerted
- Real-time status updates — patient sees when donor accepts

### 🔔 Real-time Donor Alert
- Available donors receive an automatic popup alert
- Shows blood group, urgency, and distance
- One-tap Accept or Decline
- Patient is notified immediately when donor accepts

### 🏥 Blood Bank Locator
- Find nearest blood banks using Google Maps
- Step-by-step guide on what to do
- No confidential inventory data stored — privacy first

### 🗺️ Live Map
- OpenStreetMap integration (free, no API key required)
- Real-time blood request markers
- Hospital and ambulance locations
- Amravati region coverage

### 🚑 Ambulance Request
- View available ambulances with ETA
- One-tap request nearest ambulance
- Live countdown timer
- Driver info and safety instructions

### 🏨 Nearby Hospitals
- List of hospitals in Amravati region
- Directions via Google Maps
- Government and private hospital categories

### 👤 User Roles
- Donor — I want to donate blood
- Receiver — I need blood
- Both — I can donate and receive

### 🔐 Secure Authentication
- Firebase Phone OTP authentication
- No passwords stored
- Secure user profiles

---

## 🛠️ Tech Stack

| Technology | Usage |
|---|---|
| Flutter | Cross-platform mobile app (Android + iOS) |
| Firebase Firestore | Real-time NoSQL database |
| Firebase Authentication | Phone OTP login |
| Firebase Cloud Messaging | Push notification ready |
| OpenStreetMap + flutter_map | Free real-time mapping |
| Geolocator | Live GPS location tracking |
| GetX | State management and navigation |
| url_launcher | Call and maps integration |

---

## 📂 Project Structure

```plaintext
lifelink/
├── lib/
│   ├── main.dart
│   ├── firebase_options.dart
│   └── screens/
│       ├── splash_screen.dart
│       ├── login_screen.dart
│       ├── register_screen.dart
│       ├── dashboard_screen.dart
│       ├── request_form_screen.dart
│       ├── request_success_screen.dart
│       ├── feed_screen.dart
│       ├── map_screen.dart
│       ├── hospital_screen.dart
│       ├── ambulance_screen.dart
│       └── blood_bank_screen.dart
├── android/
│   └── app/
│       └── google-services.json
├── pubspec.yaml
└── README.md
```

---

## 🗄️ Firebase Schema

### 👤 Users Collection

```plaintext
users/{uid}
├── uid          → string
├── name         → string
├── phone        → string
├── bloodGroup   → string   (A+ | A- | B+ | B- | O+ | O- | AB+ | AB-)
├── role         → string   (Donor | Receiver | Both)
├── available    → boolean
├── location     → GeoPoint
├── fcmToken     → string
└── lastDonated  → string
```

### 🩸 Requests Collection

```plaintext
requests/{requestId}
├── bloodGroup   → string   (A+ | A- | B+ | B- | O+ | O- | AB+ | AB-)
├── urgency      → string   (Critical | Urgent | Normal)
├── status       → string   (pending | accepted)
├── location     → GeoPoint
├── createdBy    → string   (uid of patient)
├── acceptedBy   → string   (uid of donor | null)
├── createdAt    → timestamp
└── acceptedAt   → timestamp | null
```

## Setup & Installation

### Prerequisites
- Flutter SDK (3.0+)
- Android Studio or VS Code
- Firebase account
- Git

### Steps

1. Clone the repository
git clone https://github.com/AyushKurhade/lifelink.git
cd lifelink

2. Install dependencies
flutter pub get

3. Firebase Setup
- Create a Firebase project at console.firebase.google.com
- Enable Phone Authentication
- Enable Firestore Database
- Download google-services.json and place in android/app/
- Run flutterfire configure

4. Run the app
flutter run

5. Build release APK
flutter build apk --release

---

## 🎯 Problem Statement

Blood shortage kills thousands of Indians every year — not because blood is unavailable, but because patients cannot find compatible donors in time. Existing blood bank directories are static and slow. There is no real-time system connecting donors and patients at the ground level.

## 💡 Solution

LifeLink creates a live donor-patient network. When a patient needs blood:
1. They submit a request in under 30 seconds
2. All nearby compatible donors are instantly alerted
3. A donor accepts and heads to the patient
4. The entire process happens in minutes — not hours

## 💰 Business Model

- Phase 1 — Free app, build user base in Tier 2-3 cities
- Phase 2 — Hospital partnerships (₹5000/month premium routing)
- Phase 3 — Donor health subscription (₹99/month)
- Phase 4 — Ambulance service integration (per-booking model)
- Phase 5 — Government contracts under National Blood Policy

## 📈 Scalability

- Firebase auto-scales to millions of users
- Flutter deploys to Android + iOS from one codebase
- OpenStreetMap — zero cost, works globally
- Modular architecture — new cities require zero backend changes

---

## 🔒 Privacy & Security

- No passwords stored — Phone OTP only
- No confidential blood bank inventory data
- Firestore security rules protect user data
- Firebase AES-256 encryption at rest
- TLS encryption in transit
- Users can delete their account and all data anytime

---

## 👥 Team Neural Coders

Built with ❤️ at NAVONMESH 2026 Hackathon

---

## 📄 License

This project is built for hackathon purposes. All rights reserved by Team Neural Coders.

---

LifeLink — Because every second counts. 🩸
