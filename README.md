##  🎭  Face Emotion Detection 
This is a flutter application which detects a person's face and analyzes its condition in real-time, even in different lighting environments.
You can take a selfie or back photo or upload a photo and give u the results 

## Core features

1. You can take a photo selfie or back or upload photo 

2. I used local storage for the app using `Shared_preferences`

3. I used `GETX` in state management

4. the app architecture is very organised

5. You can use it OFFLINE

6. It has easy , simple beatuful ui

7. Work on both `Android` and `IOS`

### These are the plugins i used

## 🛠 Tech Stack

- **Flutter (SDK >= 3.0.0 < 4.0.0)**
- **GetX** – State Management & Routing
- **Google ML Kit (Face Detection)**
- **Camera**
- **Image Picker**
- **Permission Handler**
- **Shared Preferences**
- **Image Processing (image + flutter_image_compress)**

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  get: ^4.6.5
  camera: ^0.10.6
  google_mlkit_face_detection: ^0.11.1
  image_picker: ^1.0.0
  permission_handler: ^11.4.0
  image: ^4.0.17
  shared_preferences: ^2.2.0
  flutter_image_compress: ^2.4.0
```



### This is The App Architecture 

The project follows a **feature-based modular architecture**:

```
lib
├── app
│   ├── routes.dart
│   ├── themes.dart
├── main.dart
├── modules
│   ├── camera
│   │   ├── common_widgets.dart
│   │   ├── gallery_upload_screen.dart
│   │   ├── take_photo.dart
│   ├── home
│   │   ├── home_controllor.dart
│   │   ├── home_page.dart
│   ├── onboarding
│   │   ├── features.dart
│   │   ├── onboarding.dart
│   │   ├── onboarding_controllor.dart
│   │   ├── permissions.dart
│   │   ├── welcome_page.dart
│   ├── results
│   │   ├── result.dart
│   │   ├── result_controllor.dart
├── services
│   ├── face_analyzer.dart
├── widgets
│   ├── custom_buttom.dart
```
---


### App Icon

<div align="center">
  <img src="https://github.com/user-attachments/assets/9bc31212-37c8-46d9-b711-f9ec16506f3c" width="250" height="auto"/>
</div>

## 📱 Screens From The Application

### OnBoarding Screens
<p align="center">
  <img src="https://github.com/user-attachments/assets/67e8056a-d7e6-47c4-9239-05ea597c9620" width="250"/>
  &nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/c65140e6-2e2e-4c83-955b-106b55e43f78" width="250"/>
  &nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/99d08cc9-9516-4a78-a21c-5204179bd020" width="250"/>
</p>

---


### Home Page Screes 
<p align="center">
  <img src="https://github.com/user-attachments/assets/1346cb3c-149b-4956-8f0e-847fac1a5046" width="250"/>
  &nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/353b8617-b685-4a77-92d3-2db8098116d2" width="250"/>
</p>

---
### Results after take Photos 

<p align="center">
  <img width="230" height="1300" alt="image" src="https://github.com/user-attachments/assets/2568c08e-0af7-4547-99ef-d49832269da6" />
  &nbsp;&nbsp;&nbsp;
  <img width="230" height="1300" alt="image" src="https://github.com/user-attachments/assets/df4e33ee-c814-4792-9b12-c0aefd267237" />
  &nbsp;&nbsp;&nbsp;
  </p>

  <p align="center">

  <img width="230" height="1300" alt="image" src="https://github.com/user-attachments/assets/506d5a3d-60aa-4793-b742-3619ec852321" />
  &nbsp;&nbsp;&nbsp;
  <img width="230" height="1300" alt="image" src="https://github.com/user-attachments/assets/cd3053bd-440b-4340-846a-af51dbb4f668" />
</p>

---
### Results after upload Photos

<p align="center">
  <img width="230" height="800" alt="image" src="https://github.com/user-attachments/assets/405f0a4a-f292-43fa-8f8c-301eb8559d4e" />
  &nbsp;&nbsp;&nbsp;
  <img width="230" height="1280" alt="image" src="https://github.com/user-attachments/assets/87364ab7-9aba-4bfe-9afc-87c8e042a5ff" />
  &nbsp;&nbsp;&nbsp;
  </p>

  <p align="center">
  <img width="230" height="800" alt="image" src="https://github.com/user-attachments/assets/6a985de7-2308-40c2-a860-24547e01a12c" />
  &nbsp;&nbsp;&nbsp;
  <img width="230" height="800" alt="image" src="https://github.com/user-attachments/assets/40cc574c-9716-4df5-9c02-68b00e759bc1" />
</p>

---

### If You use Random photo not a human 
<p align="center">
  <img width="250" " alt="image" src="https://github.com/user-attachments/assets/825c1033-f195-4e41-972b-7a0d26bdf841" />
     &nbsp;&nbsp;&nbsp;
  <img width="250"  alt="image" src="https://github.com/user-attachments/assets/992a887f-c1e5-4f8b-91ac-8aedd40a61f0" />
 

</p>

---


# 🚀 Getting Started

Follow these steps to run the project locally:

## 1️⃣ Clone the repository

```bash
git clone https://github.com/Manar-Elhabbal7/Face-Emotion-Detector.git
cd Face-Emotion-Detector
```

## 2️⃣ Install dependencies

```bash
flutter pub get
```

## 3️⃣ Check connected devices

```bash
flutter devices
```

## 4️⃣ Run the application

```bash
flutter run
```

---


# 🤝 Contribution Guide

Contributions are welcome and appreciated!

## 🛠 How to Contribute

1. Fork the repository
2. Create a new branch:

```bash
git checkout -b feature/your-feature-name
```

3. Make your changes
4. Commit your changes:

```bash
git commit -m "Add: short description of your feature"
```

5. Push your branch:

```bash
git push origin feature/your-feature-name
```

6. Open a Pull Request

---

## 📌 Contribution Rules

- Follow the existing project structure
- Use meaningful commit messages
- Keep the UI clean and consistent
- Make sure the app runs without errors before submitting PR
- Write clean and readable code

---

##  Testing Before PR

Before submitting a pull request, make sure:

```bash
flutter analyze
flutter test
```

---

## Please Star the repo if you find it helpful `Maintainer: Manar Elhabbal`
