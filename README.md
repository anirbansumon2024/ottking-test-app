# Flutter App

> **Platform files (android/, ios/, web/) রিপোতে নেই।**
> GitHub Actions নিজেই `flutter create` দিয়ে তৈরি করে বিল্ড করে।

## 📁 রিপোতে শুধু এটুকুই আছে

```
flutter_app/
├── .github/
│   └── workflows/
│       └── flutter_ci.yml   ← CI/CD pipeline
├── lib/
│   └── main.dart            ← App কোড
├── test/
│   └── widget_test.dart     ← Tests
├── pubspec.yaml             ← Dependencies
├── analysis_options.yaml    ← Lint rules
└── .gitignore
```

## 🚀 GitHub-এ Push করার নিয়ম

```bash
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git push -u origin main
```

Push করার সাথে সাথে **Actions** ট্যাবে বিল্ড শুরু হবে।

## ✅ CI/CD — কী হয় প্রতিটি push-এ

| Job | Runner | কাজ | Output |
|-----|--------|-----|--------|
| 🤖 Android | ubuntu | flutter create → analyze → test → build apk | `app-release.apk` |
| 🌐 Web | ubuntu | flutter create → build web | `build/web/` |
| 🍎 iOS | macos | flutter create → build ios | iOS build |

## 📥 APK ডাউনলোড

**GitHub → Actions → সর্বশেষ run → Artifacts → `android-release-apk`**

## 💻 Local-এ রান করতে হলে

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
cd YOUR_REPO
flutter create --org com.example --project-name flutter_app .
flutter pub get
flutter run
```
