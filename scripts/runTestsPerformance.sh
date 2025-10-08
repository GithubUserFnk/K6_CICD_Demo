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
if [[ -n "$K6_CLOUD_TOKEN" && -n "$K6_CLOUD_PROJECT_ID" ]]; then
  echo "☁️ Running in K6 Cloud mode"
  RUN_CMD="k6 cloud"
  CLOUD_ARGS="--token $K6_CLOUD_TOKEN --project-id $K6_CLOUD_PROJECT_ID"
else
  echo "💻 Running locally"
  RUN_CMD="k6 run"
  CLOUD_ARGS=""
fi

# 🧪 Jalankan test
echo "▶️  Running: $TEST_FILE ..."
$RUN_CMD "$TEST_FILE" $CLOUD_ARGS --no-usage-report

# 📊 Cek hasil exit code
if [[ $? -eq 0 ]]; then
  echo "✅ K6 performance test finished successfully"
else
  echo "❌ K6 performance test failed (thresholds not met)"
fi

echo "======================================="
echo "🎯 Performance Test Completed"
echo "======================================="
