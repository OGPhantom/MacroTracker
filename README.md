# 🍎 MacroTracker 
An **AI-powered macronutrient tracker for iOS and watchOS** built with **SwiftUI**, **SwiftData**, **Firebase**, **WatchConnectivity** and **OpenAI API**. 
Track your **daily macros** by simply entering a food name, let **AI** calculate the rest, and sync seamlessly with **Apple Watch**. 

--- 

### 📌 Short Description 

MacroTracker is a SwiftUI iOS/watchOS app that tracks macronutrients. 
Users can authenticate via Firebase, add food items, automatically estimate protein/fats/carbs by OpenAI API, store data locally with SwiftData and sync entries from Apple Watch. 

--- 

## 📹 Demo 

video here 

--- 

## 📸 Screenshots 

<p align="center"> 
  <img width="292" height="566" alt="image" src="https://github.com/user-attachments/assets/997be132-fd31-41d9-af3a-0140ec561123" /> 
  <img width="322" height="569" alt="image" src="https://github.com/user-attachments/assets/281baedc-a77a-46b6-bf28-2314b237ed88" /> 
</p> 

<p align="center"> 
  <img width="291" height="193" alt="image" src="https://github.com/user-attachments/assets/ab0b73b0-289d-4dce-961d-470aba83a718" /> 
  <img width="274" height="299" alt="image" src="https://github.com/user-attachments/assets/a67a9b38-c57f-481c-af31-2b5626b81957" /> 
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
