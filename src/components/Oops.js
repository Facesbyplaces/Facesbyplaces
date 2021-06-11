import React from "react";
import { Login } from "./auth/Login";

export default function Oops() {
  return (
    <div>
      <>
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
      </>
      {/*begin::Body*/}
      {/*begin::Main*/}
      <div
        className="d-flex flex-column flex-root"
        style={{
          backgroundColor: "#009ee5",
        }}
      >
        <div
          className="error error-6 d-flex flex-row-fluid bgi-size-cover bgi-position-center"
          style={{
            backgroundImage: "url(assets/media/error/bg6.jpg)",
            backgroundColor: "#009ee5",
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
