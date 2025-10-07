export const optionsGetListDevices = {
  scenarios: {
    getDeviceList: {
      executor: 'ramping-vus',
      gracefulStop: '30s',
      stages: [
        { target: 10, duration: '10s' },
        { target: 20, duration: '20s' },
        { target: 0, duration: '30s' },
      ],
      gracefulRampDown: '30s',
    }
  },
    thresholds: {
    http_req_failed: ['rate<0.01'], // http errors should be less than 1%
    http_req_duration: ['p(95)<500'], // 95% of requests should be below 200ms
  },
}

export const optionsPostDevices = {
  scenarios:{
    postDevice: {
      executor: 'constant-vus',
      vus: 3,
      duration: '10s',
    }
  },
    thresholds: {
    http_req_failed: ['rate<0.01'], // http errors should be less than 1%
    http_req_duration: ['p(95)<500'], // 95% of requests should be below 200ms
  },
}


