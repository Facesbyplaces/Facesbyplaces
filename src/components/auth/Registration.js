import React, { Component } from "react";
import qs from "qs";
import axios from "axios";

export default class Registration extends Component {
  constructor(props) {
    super(props);

    this.state = {
      email: "",
      full_name: "",
      password: "",
      password_confirmation: "",
      registrationErrors: "",
    };

    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleChange = this.handleChange.bind(this);
    this.handleRegistrationError = this.handleRegistrationError.bind(this);
  }

  handleChange(event) {
    this.setState({
      [event.target.name]: event.target.value,
    });
  }

  handleSubmit(event) {
    axios({
      method: "post",
      url: "http://localhost:3001/admin_auth",
      data: qs.stringify({
        email: this.state.email,
        full_name: this.state.full_name,
        password: this.state.password,
        password_confirmation: this.password_confirmation,
      }),
      headers: {
        "content-type": "application/x-www-form-urlencoded;charset=utf-8",
      },
    })
      .then((response) => {
        if (response.data.status === "created")
          this.props.handleSuccessfulAuth(response.data);
        console.log("Registration Response", response);
      })
      .catch((error) => {
        this.handleRegistrationError(error);
        console.log("Registration Error", error);
      });

    event.preventDefault();
  }

  handleRegistrationError(error) {
    this.setState({
      registrationErrors: this.state.registrationErrors.concat(
        error.response.data.errors.full_messages
      ),
    });
    console.log(this.state.registrationErrors.split(","));
  }

  render() {
    return (
      <div className="">
        <div className="mb-20">
          <h3>Sign Up</h3>
          <p className="opacity-60">
            Enter your details to create your account
          </p>
        </div>
        <form onSubmit={this.handleSubmit}>
          <div className="form-group">
            <input
              className="form-control h-auto text-white placeholder-white opacity-70 bg-dark-o-70 rounded-pill border-0 py-4 px-8"
              type="email"
              name="email"
              placeholder="Email"
              value={this.state.email}
              onChange={this.handleChange}
              required
            />
          </div>
          <div className="form-group">
            <input
              className="form-control h-auto text-white placeholder-white opacity-70 bg-dark-o-70 rounded-pill border-0 py-4 px-8"
              type="full_name"
              name="full_name"
              placeholder="Fullname"
              value={this.state.full_name}
              onChange={this.handleChange}
              required
            />
          </div>
          <div className="form-group">
            <input
              className="form-control h-auto text-white placeholder-white opacity-70 bg-dark-o-70 rounded-pill border-0 py-4 px-8"
              type="password"
              name="password"
              placeholder="Password"
              value={this.state.password}
              onChange={this.handleChange}
              required
            />
          </div>
          <div className="form-group">
            <input
              className="form-control h-auto text-white placeholder-white opacity-70 bg-dark-o-70 rounded-pill border-0 py-4 px-8"
              type="password"
              name="password_confirmation"
              placeholder="Password Confirmation"
              value={this.state.password_confirmation}
              onChange={this.handleChange}
              required
            />
          </div>
          {/* <div className="form-group text-left px-8">
                <div className="checkbox-inline">
                  <label className="checkbox checkbox-outline checkbox-white text-white m-0">
                    <input type="checkbox" name="agree" />
                    <span />I Agree the
                    <a href="#" className="text-white font-weight-bold ml-1">
                      terms and conditions
                    </a>
                    .
                  </label>
                </div>
                <div className="form-text text-muted text-center" />
              </div> */}
          <div className="form-group">
            <button
              id="kt_login_signup_submit"
              className="btn btn-pill btn-outline-white font-weight-bold opacity-90 px-15 py-3 m-2"
              type="submit"
            >
              Sign Up
            </button>
            <button
              id="kt_login_signup_cancel"
              className="btn btn-pill btn-outline-white font-weight-bold opacity-70 px-15 py-3 m-2"
              onClick={this.props.handleClick}
            >
              Cancel
            </button>
          </div>
        </form>
      </div>
    );
  }
}
