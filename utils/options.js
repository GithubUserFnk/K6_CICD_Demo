export const options = {
  scenarios: {
    // 🚀 Stress Test
    stress_test: {
      executor: 'ramping-vus',
      startVUs: 0,
      stages: [
        { duration: '10s', target: 5 },
        { duration: '20s', target: 10 },
        { duration: '30s', target: 0 },
      ],
      exec: 'PostDevicesStress',
      gracefulRampDown: '30s'
    },

    // 🧱 Load Test
    load_test: {
      executor: 'constant-vus',
      vus: 15,
      duration: '1m',
      gracefulStop: '30s',
      exec: 'GetListDevicesLoad'
    },
  },

  // =============================
  // 📊 Thresholds (Global + Per Scenario)
  // =============================
  thresholds: {
    // 🌐 Global (gabungan semua)
    http_req_failed: ['rate<0.03'],
    vus_max: ['value>0'],

    // 🎯 Load Test khusus
    'http_req_duration{scenario:load_test}': [
      'p(95)<1000', // 95% < 1 detik
      'p(99)<1500', // 99% < 1.5 detik
    ],
    'http_req_failed{scenario:load_test}': ['rate<0.01'],

    // 🔥 Stress Test khusus
    'http_req_duration{scenario:stress_test}': [
      'p(95)<2000', // 95% < 2 detik
      'p(99)<3000', // 99% < 3 detik
    ],
    'http_req_failed{scenario:stress_test}': ['rate<0.02'],
  },
}

export const optionsGetListDevicesRegression = {
  scenarios: {
    regression_suite: {
      executor: 'per-vu-iterations',
      vus: 1,
      iterations: 5,
    },
  },
}

export const optionsPostDevicesRegression = {
  scenarios: {
    PostDevicesRegression: {
      executor: 'per-vu-iterations',
      vus: 1,
      iterations: 5,
    },
  },
}


