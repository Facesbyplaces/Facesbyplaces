import { persistReducer } from "redux-persist";
import storage from "redux-persist/lib/storage";

const initialAuthState = {
  id: undefined,
  page: "",
  tab: "",
  pageType: undefined,
};

export const MemorialTabReducer = persistReducer(
  { storage, key: "fbp-admin-portal-memorial-tab" },
  (state = initialAuthState, action) => {
    switch (action.type) {
      case "VIEW_MEMORIAL":
        localStorage.setItem("id", action.data.id);
        localStorage.setItem("page", action.data.page);
        localStorage.setItem("tab", action.data.option);
        localStorage.setItem("pageType", action.data.type);

        return action.data;

      case "EDIT_MEMORIAL":
        localStorage.setItem("id", action.data.id);
        localStorage.setItem("page", action.data.page);
        localStorage.setItem("tab", action.data.option);
        localStorage.setItem("pageType", action.data.type);

        return action.data;

      case "ADD_MEMORIAL":
        localStorage.setItem("tab", action.data.option);
        localStorage.setItem("pageType", action.data.type);
        console.log(action.data);
        return action.data;

      case "DELETE_MEMORIAL":
        localStorage.setItem("id", action.data.id);
        localStorage.setItem("page", action.data.page);
        localStorage.setItem("tab", action.data.option);

        return action.data;

      case "TABLE_MEMORIAL":
        localStorage.removeItem("tab");
        localStorage.removeItem("id");

        return initialAuthState;

      default:
        return state;
    }
  }
);