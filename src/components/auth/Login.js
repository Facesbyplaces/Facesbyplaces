import React, { Component } from "react";
import qs from "qs";
import axios from "axios";

export default class Login extends Component {
  constructor(props) {
    super(props);

    this.state = {
      email: "",
      password: "",
      loginErrors: "",
    };

    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleChange = this.handleChange.bind(this);
    this.handleLoginError = this.handleLoginError.bind(this);
  }

  handleChange(event) {
    this.setState({
      [event.target.name]: event.target.value,
    });
  }

  handleSubmit(event) {
    axios({
      method: "post",
      url: "http://fbp-admin-portal.dev1.koda.ws/admin_auth/sign_in",
      data: qs.stringify({
        email: this.state.email,
        password: this.state.password,
      }),
      //   headers: {
      //     "content-type": "application/x-www-form-urlencoded;charset=utf-8",
      //   },
    })
      .then((response) => {
        console.log(response);
        console.log(response.headers["client"]);
        if (response.data.loggedIn)
          this.props.handleSuccessfulAuth(
            response.data,
            response.headers["access-token"],
            response.headers["client"]
          );
      })
      .catch((error) => {
        this.handleLoginError(error.response.data.errors);
        console.log(error.response.data.errors);
      });

    event.preventDefault();
  }

  handleLoginError(error) {
    this.setState({
      loginErrors: this.state.loginErrors.concat(error),
    });
  }

  render() {
    return (
      <div className="">
        <div className="mb-16">
          <h3>Sign In</h3>
          <p className="opacity-60 font-weight-bold">
            Enter your details to login to your account:
          </p>
        </div>
        {/* {this.state.loginErrors == 0 ? (
          ""
        ) : (
          <div className="mb-20">
            <p className="opacity-60 font-weight-bold">
              {this.state.LoginErrors}
            </p>
          </div>
        )} */}
        <form className="form" onSubmit={this.handleSubmit}>
          <div className="form-group">
            <input
              className="form-control h-auto text-white placeholder-white opacity-70 bg-dark-o-70 rounded-pill border-0 py-4 px-8 mb-5"
              type="email"
              name="email"
              placeholder="Email"
              value={this.state.email}
              onChange={this.handleChange}
              autoComplete="off"
              required
            />
          </div>
          <div className="form-group">
            <input
              className="form-control h-auto text-white placeholder-white opacity-70 bg-dark-o-70 rounded-pill border-0 py-4 px-8 mb-5"
              type="password"
              name="password"
              placeholder="Password"
              value={this.state.password}
              onChange={this.handleChange}
              required
            />
          </div>
          {/* <div className="form-group d-flex flex-wrap justify-content-between align-items-center px-8">
                      <div className="checkbox-inline">
                        <label className="checkbox checkbox-outline checkbox-white text-white m-0">
                          <input type="checkbox" name="remember" />
                          <span />
                          Remember me
                        </label>
                      </div>
                      <a
                        href="javascript:;"
                        id="kt_login_forgot"
                        className="text-white font-weight-bold"
                      >
                        Forget Password ?
                      </a>
                    </div> */}
          <div className="form-group text-center mt-10">
            <button
              id="kt_login_signin_submit"
              className="btn btn-pill btn-outline-white font-weight-bold opacity-90 px-15 py-3"
              type="submit"
            >
              Sign In
            </button>
          </div>
        </form>
        <div className="mt-10">
          <span className="opacity-70 mr-4"></span>
          <a
            href="javascript:;"
            id="kt_login_signup"
            className="text-white font-weight-bold"
            onClick={this.props.handleClick}
          ></a>
        </div>
        <div className="mt-10">
          <span className="opacity-70 mr-4"></span>
          <a
            href="javascript:;"
            id="kt_login_signup"
            className="text-white font-weight-bold"
            onClick={this.props.handleClick}
          ></a>
        </div>
        <div className="mt-10">
          <span className="opacity-70 mr-4"></span>
          <a
            href="javascript:;"
            id="kt_login_signup"
            className="text-white font-weight-bold"
            onClick={this.props.handleClick}
          ></a>
        </div>
      </div>
    );
  }
}
