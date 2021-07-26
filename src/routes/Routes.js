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
import Dashboard from "../components/Content/Dashboard/Dashboard";
import Oops from "../components/Oops";

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

  // console.log("isAuthorized: ", isAuthorized);
  // console.log("isTokenValid: ", isTokenValid);

  if (isAuthorized && isTokenValid) {
    return (
      <Switch>
        <Redirect from="/admin" to="/users" />
        <Route path="/users" component={Dashboard} />
        <Route path="/memorials" component={Dashboard} />
        <Route path="/posts" component={Dashboard} />
        <Route path="/reports" component={Dashboard} />
        <Route path="/transactions" component={Dashboard} />

        {/* Invalid Urls */}
        <Route path="/404" component={Oops} />
        <Redirect to={{ pathname: "/404" }} />
      </Switch>
    );
  } else {
    return (
      <Switch>
        <Route exact path="/admin" component={Home} />
        <Redirect to="/admin" />
      </Switch>
    );
  }
});
