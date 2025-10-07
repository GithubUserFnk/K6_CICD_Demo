#!/bin/bash
mkdir -p reports

# # 🧹 Clean old reports
# if [ "$(ls -A reports)" ]; then
#   echo "🧹 Cleaning old reports..."
#   rm -rf reports/*
# fi

# 🧪 Run getDeviceList test
echo "🚀 Running getDeviceList.js..."
k6 run src/getDeviceList.js

# 🧪 Run postDevice test
echo "🚀 Running postDevice.js..."
k6 run src/postDevice.js

echo "✅ Reports generated in /reports"
