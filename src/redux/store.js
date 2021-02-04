import { createStore, combineReducers } from "redux";
import { persistStore } from "redux-persist";

//REDUCERS
import { AuthReducer } from "../redux/reducers/AuthReducer";
console.log(AuthReducer);

const rootReducer = combineReducers({
  auth_data: AuthReducer,
});

const store = createStore(
  rootReducer,
  window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__()
);

export const persistor = persistStore(store);

export default store;
