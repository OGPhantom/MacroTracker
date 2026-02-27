# 🍎 MacroTracker 
An **AI-powered macronutrient tracker for iOS and watchOS** built with **SwiftUI**, **SwiftData**, **Firebase**, **WatchConnectivity** and **OpenAI API**. 
Track your **daily macros** by simply entering a food name, let **AI** calculate the rest, and sync seamlessly with **Apple Watch**. 

--- 

### 📌 Short Description 

MacroTracker is a SwiftUI iOS/watchOS app that tracks macronutrients. 
Users can authenticate via Firebase, add food items, automatically estimate protein/fats/carbs by OpenAI API, store data locally with SwiftData and sync entries from Apple Watch. 

--- 

## 📹 Demo 

  [Watch iOS Demo](https://github.com/user-attachments/assets/42863138-c895-4478-bd08-eb9c3d8705e9)

  [Watch watchOS Demo](https://github.com/user-attachments/assets/4ea65083-fc76-4a57-90b4-1949d8d5a898)

--- 

## 📸 Screenshots 

### 🔐 Authentication
<p align="center"> 
  <img width="484" height="937" alt="Screenshot 2026-02-27 at 20 43 26" src="https://github.com/user-attachments/assets/3ba03d44-ebe1-4788-90d2-8a2832b97f1b" />
  <img width="484" height="937" alt="Screenshot 2026-02-27 at 20 43 52" src="https://github.com/user-attachments/assets/d65123d6-6f67-41a0-ab69-48361d249412" />
</p> 

### 🥗 Track & Log Your Meals
<p align="center"> 
  <img width="484" height="937" alt="Screenshot 2026-02-27 at 20 47 47" src="https://github.com/user-attachments/assets/e67f998c-3881-41ce-8762-f656acf72282" />
  <img width="484" height="937" alt="Screenshot 2026-02-27 at 20 54 44" src="https://github.com/user-attachments/assets/e0c09fd2-9150-4275-8f2a-82ce02471eba" />
</p>


### ⌚ Apple Watch Companion
<p align="center"> 
  <img width="420" height="511" alt="Screenshot 2026-02-27 at 20 57 05" src="https://github.com/user-attachments/assets/9f33df5f-6d77-49b8-95e9-beee469252e7" />
  <img width="420" height="511" alt="Screenshot 2026-02-27 at 20 59 00" src="https://github.com/user-attachments/assets/3f96ac8a-12e8-4bd4-a3fa-dfce54f7330f" />
</p> 

--- 

## ✨ Features 

- 🔐 Authentication with Firebase
- 🍽 Add food by name — AI calculates macros automatically
- 📊 Track proteins, fats, and carbs
- 📅 Historical logs aggregated by date
- 🤖 OpenAI function calling for structured macro estimation
- 💾 Local persistence powered by SwiftData
- ⌚ Apple Watch companion app
- 🔄 Real-time sync between Watch and iPhone

--- 

## 🛠️ Tech Stack 

iOS & watchOS 
- **SwiftUI**
- **SwiftData**
- **WatchConnectivity**
- **URLSession**
  
Services
- **Firebase**
- **OpenAI API**

--- 

## 📄 Requirements

- Xcode 15+
- iOS 17+
- watchOS 10+
- Firebase project with Email/Password enabled
- OpenAI API key 

--- 

## 🚀 Installation 

1. Clone the repository.
2. Open MacroTracker.xcodeproj in Xcode.
3. Configure Firebase:
– Add GoogleService-Info.plist to the iOS target.
– Enable Email/Password authentication.
4. Configure OpenAI API key (see Security section).
5. Run on iPhone simulator or device.
6. For Watch testing, launch paired iPhone + Watch simulator.
