#!/bin/bash
set -m
set +e

echo "======================================="
echo "🚀 Starting Sequential K6 Regression Test Execution"
echo "======================================="

# 🔐 Cek environment variables
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

# 🔍 Cari semua file test JS di folder regression
TEST_FILES=$(find regression -type f -name "*.js" | sort)
if [[ -z "$TEST_FILES" ]]; then
  echo "❌ No test files found in ./regression"
  exit 1
fi

PASS_COUNT=0
FAIL_COUNT=0

# 🧪 Jalankan semua file secara berurutan
for TEST_FILE in $TEST_FILES; do
  TEST_NAME=$(basename "$TEST_FILE" .js)
  echo "---------------------------------------"
  echo "▶️  Running regression test: $TEST_NAME"
  echo "---------------------------------------"

  # Jalankan test dengan threshold dinonaktifkan
  $RUN_CMD "$TEST_FILE" --no-thresholds
  TEST_EXIT_CODE=$?

  if [[ $TEST_EXIT_CODE -eq 0 ]]; then
    echo "✅ $TEST_NAME finished successfully!"
    ((PASS_COUNT++))
  else
    echo "❌ $TEST_NAME failed!"
    ((FAIL_COUNT++))
  fi
done

# 📊 Summary hasil
echo "======================================="
echo "🎯 All regression tests finished!"
echo "✅ Passed: $PASS_COUNT"
echo "❌ Failed: $FAIL_COUNT"
echo "📁 Report Folder: reports/regression/"
echo "======================================="

# 🚪 Exit dengan kode sesuai hasil
if [[ $FAIL_COUNT -gt 0 ]]; then
  exit 1
else
  exit 0
fi
