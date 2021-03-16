import { persistReducer } from "redux-persist";
import storage from "redux-persist/lib/storage";

const initialAuthState = {
  id: undefined,
  tab: "",
  reportableType: undefined,
};

export const ReportTabReducer = persistReducer(
  { storage, key: "fbp-admin-portal-post-tab" },
  (state = initialAuthState, action) => {
    switch (action.type) {
      case "VIEW_REPORT":
        localStorage.setItem("id", action.data.id);
        localStorage.setItem("tab", action.data.option);
        localStorage.setItem("reportableType", action.data.type);

        return action.data;

      case "EDIT_REPORT":
        localStorage.setItem("id", action.data.id);
        localStorage.setItem("tab", action.data.option);
        localStorage.setItem("reportableType", action.data.type);

        return action.data;

      case "ADD_REPORT":
        localStorage.setItem("tab", action.data.option);
        localStorage.setItem("reportableType", action.data.type);
        console.log(action.data);
        return action.data;

      case "DELETE_REPORT":
        localStorage.setItem("id", action.data.id);
        localStorage.setItem("tab", action.data.option);

        return action.data;

      case "TABLE_REPORT":
        localStorage.removeItem("tab");
        localStorage.removeItem("id");

        return initialAuthState;

      default:
        return state;
    }
  }
);
