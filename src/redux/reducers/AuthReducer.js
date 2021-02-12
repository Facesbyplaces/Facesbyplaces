import { persistReducer } from "redux-persist";
import storage from "redux-persist/lib/storage";

const initialTokenState = {
  accessToken: undefined,
  clientID: undefined,
  uid: undefined,
};

const initialAuthState = {
  user: undefined,
  auth_token: initialTokenState,
  token_valid: false,
};

export const AuthReducer = persistReducer(
  { storage, key: "fbp-admin-portal" },
  (state = initialAuthState, action) => {
    switch (action.type) {
      case "SIGN_IN":
        localStorage.setItem("accessToken", action.data.auth_token.accessToken);
        localStorage.setItem("clientID", action.data.auth_token.clientID);
        localStorage.setItem("uid", action.data.auth_token.uid);

        return action.data;

      case "SIGN_OUT":
        localStorage.removeItem("accessToken");
        localStorage.removeItem("clientID");
        localStorage.removeItem("uid");

        return initialAuthState;

      case "TOKEN_VALIDATION":
        return { ...state, token_valid: action.data };

      default:
        return state;
    }
  }
);
