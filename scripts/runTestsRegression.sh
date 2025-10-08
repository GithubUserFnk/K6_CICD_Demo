#!/bin/bash
set -m
set +e

echo "======================================="
echo "🚀 Starting Sequential K6 Regression Test Execution"
echo "======================================="

# Cek mode eksekusi: Cloud vs Local
if [[ -n "$K6_CLOUD_TOKEN" ]]; then
  echo "☁️ Running in K6 Cloud mode"
  RUN_CMD="k6 cloud"
else
  echo "💻 Running locally"
  RUN_CMD="k6 run"
fi

# Cari semua file test JS di folder regression
TEST_FILES=$(find regression -type f -name "*.js")
if [[ -z "$TEST_FILES" ]]; then
  echo "❌ No test files found in ./regression"
  exit 1
fi

PASS_COUNT=0
FAIL_COUNT=0

# Jalankan semua file secara berurutan
for TEST_FILE in $TEST_FILES; do
  TEST_NAME=$(basename "$TEST_FILE" .js)
  echo "---------------------------------------"
  echo "▶️  Running regression test: $TEST_NAME"
  echo "---------------------------------------"

  # Jalankan test tanpa --token/--project-id (karena sudah dari env)
  $RUN_CMD "$TEST_FILE" --no-thresholds --no-usage-report
  TEST_EXIT_CODE=$?

  if [[ $TEST_EXIT_CODE -eq 0 ]]; then
    echo "✅ $TEST_NAME finished successfully!"
    ((PASS_COUNT++))
  else
    echo "❌ $TEST_NAME failed!"
    ((FAIL_COUNT++))
  fi
done

# Summary hasil
echo "======================================="
echo "🎯 All regression tests finished!"
echo "✅ Passed: $PASS_COUNT"
echo "❌ Failed: $FAIL_COUNT"
echo "📁 Report Folder: reports/regression/"
echo "======================================="

# Exit dengan kode error kalau ada yang gagal
if [[ $FAIL_COUNT -gt 0 ]]; then
  exit 1
else
  exit 0
fi
