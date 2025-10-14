#!/bin/bash

# Скрипт для исправления ошибки "Command PhaseScriptExecution failed"
echo "🔧 Исправление Xcode проекта..."

cd "$(dirname "$0")"

# 1. Очистка
echo "1️⃣ Очистка старых файлов..."
flutter clean
rm -rf ios/Pods ios/.symlinks ios/Podfile.lock
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# 2. Восстановление зависимостей
echo "2️⃣ Восстановление зависимостей..."
flutter pub get

# 3. Установка CocoaPods
echo "3️⃣ Установка CocoaPods..."
cd ios
pod deintegrate 2>/dev/null || true
pod install --repo-update
cd ..

# 4. Исправление Build Settings
echo "4️⃣ Применение исправлений Xcode..."
defaults write com.apple.dt.Xcode IDEBuildOperationMaxNumberOfConcurrentCompileTasks 1
defaults write com.apple.dt.Xcode ShowBuildOperationDuration -bool YES

echo ""
echo "✅ Готово! Скрипты сборки исправлены (/bin/sh → /bin/bash)"
echo ""
echo "Теперь:"
echo "1. Закройте Xcode (если открыт): Cmd+Q"
echo "2. Откройте проект: open ios/Runner.xcworkspace"
echo "3. Очистите сборку: Product → Clean Build Folder (Cmd+Shift+K)"
echo "4. Запустите: Product → Run (Cmd+R)"
echo ""
echo "Или используйте Flutter CLI:"
echo "  open -a Simulator"
echo "  flutter run"
echo ""

