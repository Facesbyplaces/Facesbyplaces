export const LoginAction = (user_data) => {
  console.log(user_data)
  return {
    type: 'SIGN_IN', 
    data: user_data
  }
}

export const LogoutAction = () => {
  return {
    type: 'SIGN_OUT'
  }
}


export const TokenValidation = (token_valid) => {
  return {
    type: 'TOKEN_VALIDATION',
    data: token_valid
  }
}
