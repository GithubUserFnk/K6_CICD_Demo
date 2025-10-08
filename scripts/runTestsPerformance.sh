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

# 🌩️ Tentukan mode eksekusi
if [[ -n "$K6_CLOUD_TOKEN" ]]; then
  echo "☁️ Running in K6 Cloud mode"
  RUN_CMD="k6 cloud"
else
  echo "💻 Running locally"
  RUN_CMD="k6 run"
fi

# 🧪 Jalankan test
echo "▶️  Running: $TEST_FILE ..."
$RUN_CMD "$TEST_FILE" --no-usage-report
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
