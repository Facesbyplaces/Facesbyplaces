import { createStore, combineReducers } from "redux";
import { persistStore } from "redux-persist";

//REDUCERS
import { AuthReducer } from "../redux/reducers/AuthReducer";
import { TabReducer } from "./reducers/TabReducer";
import { MemorialTabReducer } from "./reducers/MemorialTabReducer";
import { PostTabReducer } from "./reducers/PostTabReducer";

const rootReducer = combineReducers({
  auth_data: AuthReducer,
  tab: TabReducer,
  memorialTab: MemorialTabReducer,
  postTab: PostTabReducer,
});

const store = createStore(
  rootReducer,
  window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__()
);

export const persistor = persistStore(store);

export default store;
