import { htmlReport } from "https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js";
import http from 'k6/http'
import { sleep } from 'k6'
import {options} from '../utils/options.js'
import {url, formDataTesting, paramsPostDevice} from '../utils/settings.js'
export {options}

let res;
const urlTesting = url.testing.BASE_URL

export const GetListDevicesLoad = () =>{
    res = http.get(`${urlTesting}/posts`, { redirects: 0 });
    sleep(1);
}

export const PostDevicesStress = () =>{
    res = http.post(`${urlTesting}/posts`, formDataTesting, {paramsPostDevice, redirects: 0} )
    sleep(1)
}



// ==============================
// 🧾 HTML Report Generator
// ==============================
export function handleSummary(data) {
  const now = new Date();
  const timestamp = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(
    now.getDate()
  ).padStart(2, '0')}_${String(now.getHours()).padStart(2, '0')}-${String(
    now.getMinutes()
  ).padStart(2, '0')}-${String(now.getSeconds()).padStart(2, '0')}`;

  const filename = `reports/performances-${timestamp}.html`;

  return {
    [filename]: htmlReport(data),
  };
}
