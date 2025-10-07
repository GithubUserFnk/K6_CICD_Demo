import { htmlReport } from "https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js";
import { expect } from 'https://jslib.k6.io/k6-testing/0.5.0/index.js';
import http from 'k6/http'
import { sleep } from 'k6'
import { optionsGetListDevices} from '../utils/options.js'
import {url} from '../utils/settings.js'

export const options = optionsGetListDevices 

let res;
const urlTesting = url.testing.BASE_URL


export default () => {
    res = http.get(`${urlTesting}/posts`, { redirects: 0 });
    sleep(1);
    // const checkBody = JSON.parse(res.body)
    // Assertions
    expect(res.status).toEqual(200)
}

// 🧾 Generate report dengan format timestamp: YYYY-MM-DD-HH-MM-SS
export function handleSummary(data) {
  const now = new Date();
  const timestamp = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(
    now.getDate()
  ).padStart(2, '0')}-${String(now.getHours()).padStart(2, '0')}-${String(
    now.getMinutes()
  ).padStart(2, '0')}-${String(now.getSeconds()).padStart(2, '0')}`;

  const filename = `reports/getDeviceList-${timestamp}.html`;
  return {
    [filename]: htmlReport(data),
  };
}
