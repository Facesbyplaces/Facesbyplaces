import thunk from "redux-thunk";
import { createStore, applyMiddleware, compose } from "redux";

// Import the reducers.
import rootReducer from "./reducers";
// import { fetch_admin } from "./actions/admin_fetch_action";

// If other middleware are needed simply add it in the array
const middleware = [thunk];

// App initial State
const initialState = {};

const composeEnhancer = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose;

const store = createStore(
  rootReducer,
  initialState,
  composeEnhancer(
    applyMiddleware(...middleware)
    // window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__()
  )
);

store.subscribe(() => {
  console.log(store.getState());
});

store.dispatch(fetch_admin);

console.log(store.getState());

export default store;
