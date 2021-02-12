import React, { useEffect } from "react";
import {
  Redirect,
  Route,
  Switch,
  withRouter,
  useLocation,
} from "react-router-dom";
import { shallowEqual, useSelector, useDispatch } from "react-redux";
import { LogoutAction, TokenValidation } from "../redux/actions";
import axios from "../auxiliary/axios";

//COMPONENTS
import { Home } from "../components/Home";
import Dashboard from "../components/Dashboard";
import User from "../components/Content/UserProfile/User";

export const Routes = withRouter(({ history }) => {
  const dispatch = useDispatch();
  const location = useLocation();

  const { isTokenValid, isAuthorized } = useSelector(
    ({ auth_data }) => ({
      isTokenValid: auth_data.token_valid,
      isAuthorized: auth_data.user != null,
    }),
    shallowEqual
  );

  useEffect(() => {
    const validateToken = async () => {
      axios
        .get("/auth/validate_token")
        .then(function () {
          dispatch(TokenValidation(true));
        })
        .catch(() => {
          dispatch(LogoutAction({}));
          dispatch(TokenValidation(false));
        });
    };
    if (isAuthorized) {
      validateToken();
    }
  }, [location]); // eslint-disable-line react-hooks/exhaustive-deps

  console.log("isAuthorized: ", isAuthorized);
  console.log("isTokenValid: ", isTokenValid);

  return (
    <>
      <Switch>
        {isAuthorized && isTokenValid ? (
          <Redirect from="/admin" to="/dashboard" />
        ) : (
          <>
            <Redirect to="/admin" />
            <Route exact path="/admin" component={Home} />
          </>
        )}
        {/* <Route path="/logout" component={LogOut} /> */}
        {isAuthorized && isTokenValid ? (
          <>
            <Route exact path="/dashboard" component={Dashboard} />
            <Route exact path="/user" component={User} />
          </>
        ) : (
          <Redirect to="/admin" />
        )}
      </Switch>
    </>
  );
});
