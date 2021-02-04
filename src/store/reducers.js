import { combineReducers } from "redux";

// import adminReducer from "store/reducers/admins";
import loggedReducer from "store/reducers/isLogged";

const rootReducer = combineReducers({
  // adminList: adminReducer,
  isLogged: loggedReducer,
});

export default rootReducer;
