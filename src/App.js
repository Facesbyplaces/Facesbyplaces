import React, { Component } from "react";
import { BrowserRouter, Switch, Route } from "react-router-dom";
import Home from "./components/Home";
import Dashboard from "./components/Dashboard";

export default class App extends Component {
  constructor() {
    super();

    this.state = {
      loggedInStatus: "NOT_LOGGED_IN",
      admin: {},
      access_token: {},
      client: {},
    };

    this.handleLogin = this.handleLogin.bind(this);
  }

  handleLogin(data, access_token, client) {
    this.setState({
      loggedInStatus: "LOGGED_IN",
      admin: data.admin,
      access_token: access_token,
      client: client,
    });
  }

  render() {
    return (
      <div className="App">
        <BrowserRouter>
          <Switch>
            <Route
              exact
              path={"/home"}
              render={(props) => (
                <Home
                  {...props}
                  loggedInStatus={this.state.loggedInStatus}
                  handleLogin={this.handleLogin}
                />
              )}
            />
          </Switch>
          <Switch>
            <Route
              exact
              path={"/dashboard"}
              render={(props) => (
                <Dashboard
                  {...props}
                  loggedInStatus={this.state.loggedInStatus}
                  handleLogin={this.handleLogin}
                />
              )}
            />
          </Switch>
        </BrowserRouter>
      </div>
    );
  }
}
