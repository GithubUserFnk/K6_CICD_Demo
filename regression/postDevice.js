import { htmlReport } from "https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js";
import { expect } from 'https://jslib.k6.io/k6-testing/0.5.0/index.js';
import http from 'k6/http'
import { sleep } from 'k6'
import { optionsPostDevicesRegression } from '../utils/options.js'
import {url, formDataTesting, paramsPostDevice} from '../utils/settings.js'

export const options = optionsPostDevicesRegression 

let res;
const urlTesting = url.testing.BASE_URL

export default function() {
    res = http.post(`${urlTesting}/posts`, formDataTesting, {paramsPostDevice, redirects: 0} )
    sleep(1)
    const checkBody = JSON.parse(res.body)
    expect(res.status).toEqual(201)
    expect(checkBody.id).toEqual(101)
    expect(checkBody.id).not.toBeNull()
}

// ==============================
// 🧾 Generate HTML Report
// Format: postDevice-YYYY-MM-DD_HH-MM-SS.html
// ==============================
export function handleSummary(data) {
  const now = new Date();
  const timestamp = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(
    now.getDate()
  ).padStart(2, '0')}_${String(now.getHours()).padStart(2, '0')}-${String(
    now.getMinutes()
  ).padStart(2, '0')}-${String(now.getSeconds()).padStart(2, '0')}`;

  const filename = `reports/postDeviceRegression-${timestamp}.html`;

  return {
    [filename]: htmlReport(data),
  };
}