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
