import { persistReducer } from "redux-persist";
import storage from "redux-persist/lib/storage";

const initialAuthState = {
  id: undefined,
  tab: "",
  pageType: undefined,
};

export const PostTabReducer = persistReducer(
  { storage, key: "fbp-admin-portal-post-tab" },
  (state = initialAuthState, action) => {
    switch (action.type) {
      case "VIEW_POST":
        localStorage.setItem("id", action.data.id);
        localStorage.setItem("tab", action.data.option);
        localStorage.setItem("pageType", action.data.type);

        return action.data;

      case "EDIT_POST":
        localStorage.setItem("id", action.data.id);
        localStorage.setItem("tab", action.data.option);
        localStorage.setItem("pageType", action.data.type);

        return action.data;

      case "ADD_POST":
        localStorage.setItem("tab", action.data.option);
        localStorage.setItem("pageType", action.data.type);
        console.log(action.data);
        return action.data;

      case "DELETE_POST":
        localStorage.setItem("id", action.data.id);
        localStorage.setItem("tab", action.data.option);

        return action.data;

      case "TABLE_POST":
        localStorage.removeItem("tab");
        localStorage.removeItem("id");

        return initialAuthState;

      default:
        return state;
    }
  }
);
