#!/bin/bash

cd "$(dirname "$0")"

echo "🚀 Запуск приложения..."
echo ""

# Открываем симулятор
echo "📱 Открываем iOS Simulator..."
open -a Simulator

echo ""
echo "⏳ Ждем запуска симулятора (5 секунд)..."
sleep 5

echo ""
echo "🔨 Запускаем приложение..."
flutter run


