# Firebase 설정 가이드 (초보자용)

Firebase 설정을 **자동으로** 해주는 FlutterFire CLI를 사용합니다. 매우 쉽습니다!

## 방법 1: FlutterFire CLI 사용 (추천 ⭐️)

### 1단계: Firebase CLI 설치

터미널에서 다음 명령어를 실행하세요:

```bash
# npm이 설치되어 있다면
npm install -g firebase-tools

# npm이 없다면 Homebrew 사용 (macOS)
brew install firebase-cli
```

### 2단계: Firebase 로그인

```bash
firebase login
```

브라우저가 열리면 Google 계정으로 로그인하세요.

### 3단계: FlutterFire CLI 설치

```bash
dart pub global activate flutterfire_cli
```

### 4단계: Firebase 프로젝트 자동 생성 및 설정 (이게 전부입니다!)

프로젝트 폴더에서 다음 명령어 실행:

```bash
cd /Users/rsc/StudioProjects/medigation
flutterfire configure
```

그러면 자동으로:
1. Firebase 프로젝트 생성 (또는 기존 프로젝트 선택)
2. Android/iOS 앱 등록
3. `google-services.json` 자동 생성 및 배치
4. `GoogleService-Info.plist` 자동 생성 및 배치
5. `lib/firebase_options.dart` 자동 생성

### 5단계: main.dart 수정

`flutterfire configure` 실행 후, `lib/main.dart`를 다음과 같이 수정:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart'; // 자동 생성된 파일

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화 (이제 주석 해제!)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```

**끝!** 이제 Firebase가 완전히 설정되었습니다.

---

## 방법 2: 수동 설정 (복잡함, 비추천)

### 1단계: Firebase Console에서 프로젝트 생성

1. https://console.firebase.google.com 접속
2. "프로젝트 추가" 클릭
3. 프로젝트 이름 입력: `medigation`
4. Google Analytics 사용 여부 선택 (선택사항)
5. "프로젝트 만들기" 클릭

### 2단계: Android 앱 추가

1. Firebase Console에서 프로젝트 선택
2. "앱 추가" → Android 아이콘 클릭
3. Android 패키지 이름 입력: `com.example.medigation`
   - 이것은 `android/app/build.gradle.kts` 파일의 `applicationId`와 동일해야 함
4. 앱 닉네임 입력 (선택사항): `Medigation Android`
5. "앱 등록" 클릭
6. **`google-services.json` 파일 다운로드**
7. 다운로드한 파일을 `android/app/` 폴더에 복사
8. 계속 버튼 클릭 (나머지 단계는 이미 설정되어 있음)

### 3단계: iOS 앱 추가

1. Firebase Console에서 "앱 추가" → iOS 아이콘 클릭
2. iOS 번들 ID 입력: `com.example.medigation`
   - Xcode에서 확인 가능: `ios/Runner.xcodeproj` 열기 → Runner → General → Bundle Identifier
3. 앱 닉네임 입력 (선택사항): `Medigation iOS`
4. "앱 등록" 클릭
5. **`GoogleService-Info.plist` 파일 다운로드**
6. 다운로드한 파일을 `ios/Runner/` 폴더에 복사
7. Xcode에서 프로젝트를 열고, `GoogleService-Info.plist`를 Runner 폴더로 드래그 앤 드롭
   - "Copy items if needed" 체크
8. 계속 버튼 클릭

### 4단계: firebase_options.dart 생성

`lib/firebase_options.dart` 파일을 수동으로 생성하거나, 방법 1의 `flutterfire configure`를 실행하세요.

---

## 🚨 문제 해결

### "firebase: command not found" 오류

```bash
# Homebrew로 설치
brew install firebase-cli

# 또는 npm으로 설치
npm install -g firebase-tools
```

### "flutterfire: command not found" 오류

```bash
# FlutterFire CLI 설치
dart pub global activate flutterfire_cli

# PATH 추가 (필요한 경우)
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

### Android 빌드 오류

`android/build.gradle.kts`에 다음이 있는지 확인:

```kotlin
dependencies {
    classpath("com.google.gms:google-services:4.4.0")
}
```

`android/app/build.gradle.kts` 맨 아래에 다음 추가:

```kotlin
apply(plugin = "com.google.gms.google-services")
```

---

## ✅ 설정 확인

Firebase가 제대로 설정되었는지 확인하려면:

```bash
flutter run
```

앱이 오류 없이 실행되면 성공!

---

## 다음 단계

Firebase 설정이 완료되면:

1. Firestore 데이터베이스 생성
   - Firebase Console → Firestore Database → 데이터베이스 만들기
   - "테스트 모드로 시작" 선택 (개발 중)

2. Firebase Storage 설정 (이미지 저장용, 선택사항)
   - Firebase Console → Storage → 시작하기

3. Firebase Authentication 설정 (사용자 인증, 선택사항)
   - Firebase Console → Authentication → 시작하기

---

## 📞 도움이 필요하면

- Firebase 공식 문서: https://firebase.google.com/docs/flutter/setup
- FlutterFire 문서: https://firebase.flutter.dev/docs/overview
