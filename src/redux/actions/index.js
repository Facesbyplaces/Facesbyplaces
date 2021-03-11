export const LoginAction = (user_data) => {
  console.log(user_data);
  return {
    type: "SIGN_IN",
    data: user_data,
  };
};

export const LogoutAction = () => {
  return {
    type: "SIGN_OUT",
  };
};

export const TokenValidation = (token_valid) => {
  return {
    type: "TOKEN_VALIDATION",
    data: token_valid,
  };
};
// USER
export const AddUserAction = (option) => {
  return {
    type: "VIEW_USER",
    data: option,
  };
};

export const DeleteUserAction = (user) => {
  return {
    type: "VIEW_USER",
    data: user,
  };
};

export const ViewUserAction = (user) => {
  return {
    type: "VIEW_USER",
    data: user,
  };
};

export const EditUserAction = (user) => {
  return {
    type: "EDIT_USER",
    data: user,
  };
};

export const TableUserAction = () => {
  return {
    type: "TABLE_USER",
  };
};

// MEMORIAL
export const DeleteMemorialAction = (memorial) => {
  return {
    type: "DELETE_MEMORIAL",
    data: memorial,
  };
};

export const ViewMemorialAction = (memorial) => {
  return {
    type: "VIEW_MEMORIAL",
    data: memorial,
  };
};

export const EditMemorialAction = (memorial) => {
  return {
    type: "EDIT_MEMORIAL",
    data: memorial,
  };
};

export const AddMemorialAction = (option) => {
  return {
    type: "ADD_MEMORIAL",
    data: option,
  };
};

export const TableMemorialAction = () => {
  return {
    type: "TABLE_MEMORIAL",
  };
};

// POST
export const DeletePostAction = (post) => {
  return {
    type: "DELETE_POST",
    data: post,
  };
};

export const ViewPostAction = (post) => {
  return {
    type: "VIEW_POST",
    data: post,
  };
};

export const EditPostAction = (post) => {
  return {
    type: "EDIT_POST",
    data: post,
  };
};

export const AddPostAction = (option) => {
  return {
    type: "ADD_POST",
    data: option,
  };
};

export const TablePostAction = () => {
  return {
    type: "TABLE_POST",
  };
};
