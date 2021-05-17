import { persistReducer } from "redux-persist";
import storage from "redux-persist/lib/storage";

const initialAuthState = {
  tab: "",
};

export const NavbarTabReducer = persistReducer(
  { storage, key: "fbp-admin-portal-memorial-tab" },
  (state = initialAuthState, action) => {
    switch (action.type) {
      case "USER_TAB":
        localStorage.setItem("tab", action.data.tab);
        console.log("Tab: ", action.data.tab);

        return action.data;

      case "MEMORIAL_TAB":
        localStorage.setItem("tab", action.data.tab);

        return action.data;

      case "POST_TAB":
        localStorage.setItem("tab", action.data.tab);

        return action.data;

      case "REPORT_TAB":
        localStorage.setItem("tab", action.data.tab);

        return initialAuthState;

      default:
        return state;
    }
  }
);
