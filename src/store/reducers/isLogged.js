import { ADMIN_ISLOGGED_REQUEST } from "store/action_types";

// const initialState = {
//   isLogged: false,
// };

const loggedReducer = (state = false, action) => {
  switch (action.type) {
    case ADMIN_ISLOGGED_REQUEST.ISLOGGED_ADMIN:
      return !state;

    default:
      return state;
  }
};

export default loggedReducer;
