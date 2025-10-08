#!/bin/bash
set -m
set +e

echo "======================================="
echo "🚀 Starting K6 Performance Test"
echo "======================================="

TEST_FILE="performance/main.js"

# 🔍 Cek apakah file test ada
if [[ ! -f "$TEST_FILE" ]]; then
  echo "❌ File not found: $TEST_FILE"
  exit 1
fi

# 🔐 Cek ketersediaan environment variables
if [[ -n "$K6_CLOUD_TOKEN" ]]; then
  echo "🔑 K6_CLOUD_TOKEN available: true"
else
  echo "🔑 K6_CLOUD_TOKEN available: false"
fi

if [[ -n "$K6_CLOUD_PROJECT_ID" ]]; then
  echo "🆔 K6_CLOUD_PROJECT_ID available: true"
else
  echo "🆔 K6_CLOUD_PROJECT_ID available: false"
fi

# 🌩️ Tentukan mode eksekusi
if [[ -n "$K6_CLOUD_TOKEN" && -n "$K6_CLOUD_PROJECT_ID" ]]; then
  echo "☁️ Running in K6 Cloud mode"
  echo "   → Project ID: $K6_CLOUD_PROJECT_ID"
  RUN_CMD="k6 cloud"
else
  echo "💻 Running locally (missing Cloud credentials)"
  RUN_CMD="k6 run"
fi

# 🧪 Jalankan test
echo "▶️  Running: $TEST_FILE ..."
$RUN_CMD "$TEST_FILE"
TEST_EXIT_CODE=$?

# 📊 Cek hasil exit code
if [[ $TEST_EXIT_CODE -eq 0 ]]; then
  echo "✅ K6 performance test finished successfully"
else
  echo "❌ K6 performance test failed (thresholds not met)"
fi

echo "======================================="
echo "🎯 Performance Test Completed"
echo "📁 Report Folder: reports/performance/"
echo "======================================="

# Exit dengan kode sesuai hasil
exit $TEST_EXIT_CODE
