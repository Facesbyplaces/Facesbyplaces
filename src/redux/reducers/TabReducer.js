import { persistReducer } from "redux-persist";
import storage from "redux-persist/lib/storage";

const initialAuthState = {
  id: undefined,
  account_type: undefined,
  tab: "",
};

export const TabReducer = persistReducer(
  { storage, key: "fbp-admin-portal-tab" },
  (state = initialAuthState, action) => {
    switch (action.type) {
      case "VIEW_USER":
        localStorage.setItem("id", action.data.id);
        localStorage.setItem("id", action.data.account_type);
        localStorage.setItem("tab", action.data.option);
        console.log(action.data);

        return action.data;

      case "EDIT_USER":
        localStorage.setItem("id", action.data.id);
        localStorage.setItem("id", action.data.account_type);
        localStorage.setItem("tab", action.data.option);

        return action.data;

      case "ADD_USER":
        localStorage.setItem("tab", action.data.option);

        return action.data;

      case "TABLE_USER":
        localStorage.removeItem("tab");
        localStorage.removeItem("id");

        return initialAuthState;

      default:
        return state;
    }
  }
);
