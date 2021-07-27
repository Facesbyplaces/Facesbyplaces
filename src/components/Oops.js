import React from "react";
import { Login } from "./auth/Login";
import Assets from "./Assets";

export default function Oops() {
  return (
    <div style={{ height: "100%" }}>
      <Assets />
      <div
        className="d-flex flex-column flex-root"
        style={{
          backgroundColor: "#009ee5",
          height: "100%",
        }}
      >
        <div
          className="error error-6 d-flex flex-row-fluid bgi-size-cover bgi-position-center"
          style={{
            backgroundImage: "url(assets/media/error/bg6.jpg)",
            backgroundColor: "#009ee5",
            height: "100%",
          }}
          id="kt_login"
        >
          <div className="d-flex flex-center bgi-size-cover bgi-no-repeat flex-row-fluid">
            <div className="login-form text-center text-white p-7 position-relative overflow-hidden">
              <div className="">
                <div className="d-flex flex-column flex-row-fluid text-center">
                  <h1
                    className="error-title font-weight-boldest text-white mb-5"
                    style={{ marginTop: "10rem", fontSize: "100px" }}
                  >
                    Oops...
                  </h1>
                  <p className="display-4 font-weight-bold text-white">
                    Looks like something went wrong. We're working on it.
                  </p>
                </div>
              </div>
              <div className="">
                <div className="d-flex flex-column flex-row-fluid text-center">
                  <h1
                    className="error-title font-weight-boldest text-white mb-12"
                    style={{ fontSize: "100px" }}
                  ></h1>
                  <p className="display-4 font-weight-bold text-white"></p>
                </div>
              </div>
              <div className="">
                <div className="d-flex flex-column flex-row-fluid text-center">
                  <h1
                    className="error-title font-weight-boldest text-white"
                    style={{ marginTop: "20rem", fontSize: "100px" }}
                  ></h1>
                  <p className="display-4 font-weight-bold text-white"></p>
                </div>
              </div>
            </div>
          </div>
        </div>
        )}
      </div>
    </div>
  );
}
