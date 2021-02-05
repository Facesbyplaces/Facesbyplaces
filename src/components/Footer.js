import React, { Component } from "react";

export default class Footer extends Component {
  render() {
    return (
      <div>
        {/*begin::Footer*/}
        <div
          className="footer bg-white py-4 d-flex flex-lg-column"
          id="kt_footer"
        >
          {/*begin::Container*/}
          <div className="container-fluid d-flex flex-column flex-md-row align-items-center justify-content-between">
            {/*begin::Copyright*/}
            <div className="text-dark order-2 order-md-1">
              <span className="text-muted font-weight-bold mr-2">2020©</span>
              <a
                href="http://keenthemes.com/metronic"
                target="_blank"
                className="text-dark-75 text-hover-primary"
              >
                Keenthemes
              </a>
            </div>
            {/*end::Copyright*/}
            {/*begin::Nav*/}
            <div className="nav nav-dark">
              <a
                href="http://keenthemes.com/metronic"
                target="_blank"
                className="nav-link pl-0 pr-5"
              >
                About
              </a>
              <a
                href="http://keenthemes.com/metronic"
                target="_blank"
                className="nav-link pl-0 pr-5"
              >
                Team
              </a>
              <a
                href="http://keenthemes.com/metronic"
                target="_blank"
                className="nav-link pl-0 pr-0"
              >
                Contact
              </a>
            </div>
            {/*end::Nav*/}
          </div>
          {/*end::Container*/}
        </div>
        {/*end::Footer*/}
      </div>
    );
  }
}
