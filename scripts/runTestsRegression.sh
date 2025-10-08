#!/bin/bash
set -m
set +e

echo "======================================="
echo "🚀 Starting Sequential K6 Regression Test Execution"
echo "======================================="

# Cek mode eksekusi: Cloud vs Local
if [[ -n "$K6_CLOUD_TOKEN" && -n "$K6_CLOUD_PROJECT_ID" ]]; then
  echo "☁️ Running in K6 Cloud mode"
  RUN_CMD="k6 cloud"
  CLOUD_ARGS="--token $K6_CLOUD_TOKEN --project-id $K6_CLOUD_PROJECT_ID"
else
  echo "💻 Running locally"
  RUN_CMD="k6 run"
  CLOUD_ARGS=""
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

  $RUN_CMD "$TEST_FILE" $CLOUD_ARGS \
    --no-thresholds --no-usage-report

  if [[ $? -eq 0 ]]; then
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
echo "======================================="
