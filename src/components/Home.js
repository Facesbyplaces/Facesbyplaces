import React, { useState, useEffect } from "react";
import { Login } from "./auth/Login";

//Loader
import HashLoader from "react-spinners/HashLoader";
import Assets from "./Assets";

export function Home() {
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    setLoading(true);
    setTimeout(() => {
      setLoading(false);
    }, 2000);
  }, []);

  return (
    <div style={{ height: "100%" }}>
      <Assets />
      <div className="d-flex flex-column flex-root" style={{ height: "100%" }}>
        {loading ? (
          <div className="loader-container">
            <HashLoader color={"#04ECFF"} loading={loading} size={90} />
          </div>
        ) : (
          <div
            className="login login-3 login-signin-on d-flex flex-row-fluid"
            id="kt_login"
          >
            <div
              className="d-flex flex-center bgi-size-cover bgi-no-repeat flex-row-fluid"
              style={{
                backgroundImage: "url(assets/media/bg/background_candles.png)",
                backgroundColor: "#1b1e22",
              }}
            >
              <div className="login-form text-center text-white p-7 position-relative overflow-hidden">
                <div className="d-flex flex-center mb-15 mt-5">
                  <a href="#">
                    <img
                      src="assets/media/logos/fbp-logo.png"
                      className="max-h-200px"
                      alt=""
                    />
                  </a>
                </div>
                <Login />
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
