import axios from "axios";
import store from "../redux/store";

console.log("ENTER", store.getState().auth_data.auth_token);
const instance = axios.create({
  baseURL: process.env.REACT_APP_API_BASE_URL,
});

instance.interceptors.request.use(
  function (config) {
    const {
      accessToken,
      clientID,
      uid,
    } = store.getState().auth_data.auth_token;

    config.headers["access-token"] = accessToken;
    config.headers["client"] = clientID;
    config.headers["uid"] = uid;
    config.headers["content-type"] = "application/json";

    return config;
  },
  function (error) {
    console.log(error.response);
    return Promise.reject(error);
  }
);

export default instance;
