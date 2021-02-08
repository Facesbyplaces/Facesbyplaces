import React, { useState, useEffect } from "react";
import { Login } from "./auth/Login";

//Loader
import HashLoader from "react-spinners/HashLoader";

export function Home() {
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    setLoading(true);
    setTimeout(() => {
      setLoading(false);
    }, 2000);
  }, []);

  return (
    <div>
      {/*begin::Head*/}
      <meta charSet="utf-8" />
      <title>Admin Login Page | Keenthemes</title>
      <meta name="description" content="Admin Login Page" />
      <meta
        name="viewport"
        content="width=device-width, initial-scale=1, shrink-to-fit=no"
      />
      <link rel="canonical" href="https://keenthemes.com/metronic" />
      {/*begin::Fonts*/}
      <link
        rel="stylesheet"
        href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700"
      />
      {/*end::Fonts*/}
      {/*begin::Page Custom Styles(used by this page)*/}
      <link
        href="assets/css/pages/login/classic/login-3.css"
        rel="stylesheet"
        type="text/css"
      />
      {/*end::Page Custom Styles*/}
      {/*begin::Global Theme Styles(used by all pages)*/}
      <link
        href="assets/plugins/global/plugins.bundle.css"
        rel="stylesheet"
        type="text/css"
      />
      <link
        href="assets/plugins/custom/prismjs/prismjs.bundle.css"
        rel="stylesheet"
        type="text/css"
      />
      <link
        href="assets/css/style.bundle.css"
        rel="stylesheet"
        type="text/css"
      />
      {/*end::Global Theme Styles*/}
      {/*begin::Layout Themes(used by all pages)*/}
      {/*end::Layout Themes*/}
      <link rel="shortcut icon" href="assets/media/logos/favicon.ico" />
      {/*end::Head*/}
      {/*begin::Body*/}
      {/*begin::Main*/}
      <div className="d-flex flex-column flex-root">
        {loading ? (
          <div className="home">
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
                {/*begin::Login Header*/}
                <div className="d-flex flex-center mb-15 mt-5">
                  <a href="#">
                    <img
                      src="assets/media/logos/fbp-logo.png"
                      className="max-h-200px"
                      alt=""
                    />
                  </a>
                </div>
                {/*end::Login Header*/}
                <Login />
                {/* // <Registration
                  //   handleSuccessfulAuth={this.handleSuccessfulAuth}
                  //   handleClick={this.handleClick}
                  // /> */}
              </div>
            </div>
          </div>
        )}
      </div>
      {/*end::Main*/}
      {/*begin::Global Config(global config for global JS scripts)*/}
      {/*end::Global Config*/}
      {/*begin::Global Theme Bundle(used by all pages)*/}
      {/*end::Global Theme Bundle*/}
      {/*begin::Page Scripts(used by this page)*/}
      {/*end::Page Scripts*/}
      {/*end::Body*/}
    </div>
  );
}
