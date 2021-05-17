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
import UserDashboard from "../components/Content/UserDashboard/UserDashboard";
import MemorialDashboard from "../components/Content/MemorialDashboard/MemorialDashboard";
import PostDashboard from "../components/Content/PostDashboard/PostDashboard";
import ReportDashboard from "../components/Content/ReportDashboard/ReportDashboard";
import TransactionDashboard from "../components/Content/TransactionDashboard/TransactionDashboard";
// import Oops from "../components/Oops";

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
          <Redirect from="/admin" to="/users" />
        ) : (
          <>
            <Redirect to="/admin" />
            <Route exact path="/admin" component={Home} />
          </>
        )}
        {/* <Route path="/logout" component={LogOut} /> */}
        {isAuthorized && isTokenValid ? (
          <>
            <Route path="/users" component={UserDashboard} />
            <Route path="/memorials" component={MemorialDashboard} />
            <Route path="/posts" component={PostDashboard} />
            <Route path="/reports" component={ReportDashboard} />
            <Route path="/transactions" component={TransactionDashboard} />
            {/* <Redirect to="/404" /> */}
            {/* <Route path="/404" component={Oops} /> */}
            {/* <Route render={() => <Redirect to={{ pathname: "/users" }} />} /> */}
          </>
        ) : (
          <Redirect to="/admin" />
        )}
      </Switch>
    </>
  );
});
