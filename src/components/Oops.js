import React from "react";

export default function Oops() {
  return (
    <div>
      {/*begin::Head*/}
      <base href="../../../" />
      <meta charSet="utf-8" />
      <title>Error Page - 6 | Keenthemes</title>
      <meta name="description" content />
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
        href="assets/css/pages/error/error-6.css"
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
        {/*begin::Error*/}
        <div
          className="error error-6 d-flex flex-row-fluid bgi-size-cover bgi-no-repeat bgi-position-center"
          style={{ backgroundImage: "url(assets/media/error/bg6.jpg)" }}
        >
          {/*begin::Content*/}
          <div className="d-flex flex-column flex-row-fluid text-center">
            <h1
              className="error-title font-weight-boldest text-white mb-12"
              style={{ marginTop: "12rem" }}
            >
              Oops...
            </h1>
            <p className="display-4 font-weight-bold text-white">
              Looks like something went wrong.We're working on it
            </p>
          </div>
          {/*end::Content*/}
        </div>
        {/*end::Error*/}
      </div>
      {/*end::Main*/}
      {/*begin::Global Config(global config for global JS scripts)*/}
      {/*end::Global Config*/}
      {/*begin::Global Theme Bundle(used by all pages)*/}
      {/*end::Global Theme Bundle*/}
      {/*end::Body*/}
    </div>
  );
}
