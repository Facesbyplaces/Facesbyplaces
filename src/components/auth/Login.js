import React, { Component } from "react";
import { Formik } from "formik";
import { useDispatch } from "react-redux";
import axios from "../../auxiliary/axios";

//REDUCERS
import { LoginAction } from "../../redux/actions";

export function Login() {
  const dispatch = useDispatch();

  return (
    <div className="">
      <div className="mb-16">
        <h3>Sign In</h3>
        <p className="opacity-60 font-weight-bold">
          Enter your details to login to your account:
        </p>
      </div>
      <Formik
        initialValues={{
          account_type: "1",
          email: "",
          password: "",
        }}
        validate={(values) => {
          const errors = {};

          if (!values.email) {
            errors.email = "Required";
          }
          if (!values.password) {
            errors.password = "Required";
          }

          return errors;
        }}
        onSubmit={(values, { setStatus, setSubmitting }) => {
          setTimeout(() => {
            axios
              .post("/auth/sign_in", values)
              .then(function (response) {
                console.log("ENTER", response);
                dispatch(
                  LoginAction({
                    user: response.data.user,
                    auth_token: {
                      accessToken: response.headers["access-token"],
                      clientID: response.headers["client"],
                      uid: response.headers["uid"],
                    },
                    token_valid: true,
                  })
                );
                console.log("SUCCESS", response);
              })
              .catch(() => {
                setSubmitting(false);
                setStatus("Invalid login credentials. Please try again.");
              });
          }, 1000);
        }}
      >
        {({
          values,
          status,
          errors,
          touched,
          handleChange,
          handleBlur,
          handleSubmit,
          isSubmitting,
        }) => (
          <form className="form" onSubmit={handleSubmit}>
            {/* Show Errors if existing */}
            {status ? (
              <p
                className="opacity-80 font-weight-bold"
                style={{ color: "red" }}
              >
                {status}
              </p>
            ) : (
              ""
            )}

            <div className="form-group">
              <input
                className="form-control h-auto text-white placeholder-white opacity-100 bg-dark-o-100 rounded-pill border-0 py-4 px-8 mb-5"
                type="email"
                name="email"
                placeholder="Email"
                onChange={handleChange}
                value={values.email}
                helperText={touched.email && errors.email}
                error={Boolean(touched.email && errors.email)}
                autoComplete="off"
                required
              />
            </div>
            <div className="form-group">
              <input
                className="form-control h-auto text-white placeholder-white opacity-100 bg-dark-o-100 rounded-pill border-0 py-4 px-8 mb-5"
                type="password"
                name="password"
                placeholder="Password"
                onChange={handleChange}
                value={values.password}
                helperText={touched.password && errors.password}
                error={Boolean(touched.password && errors.password)}
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
                disabled={isSubmitting}
                type="submit"
              >
                Sign In
              </button>
            </div>
          </form>
        )}
      </Formik>
      <div className="mt-10">
        <span className="opacity-70 mr-4"></span>
        <a
          href="javascript:;"
          id="kt_login_signup"
          className="text-white font-weight-bold"
        ></a>
      </div>
      <div className="mt-10">
        <span className="opacity-70 mr-4"></span>
        <a
          href="javascript:;"
          id="kt_login_signup"
          className="text-white font-weight-bold"
        ></a>
      </div>
      <div className="mt-10">
        <span className="opacity-70 mr-4"></span>
        <a
          href="javascript:;"
          id="kt_login_signup"
          className="text-white font-weight-bold"
        ></a>
      </div>
    </div>
  );
}
