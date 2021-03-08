import React from "react";

export default function Navbar() {
  return (
    <div id="kt_header" className="header">
      {/*begin::Container*/}
      <div className="container-fluid d-flex align-items-stretch justify-content-between">
        {/*begin::Header Menu Wrapper*/}
        <div
          className="header-menu-wrapper header-menu-wrapper-left"
          id="kt_header_menu_wrapper"
        >
          {/*begin::Header Menu*/}
          <div
            id="kt_header_menu"
            className="header-menu header-menu-mobile header-menu-layout-default"
          >
            {/*begin::Header Nav*/}
            <ul className="menu-nav">
              <li className="menu-item menu-item-submenu" aria-haspopup="true">
                <a href="/users" className="menu-link">
                  <span className="menu-text">Users</span>
                </a>
              </li>
              <li
                className="menu-item menu-item-active menu-item-rel"
                data-menu-toggle="click"
                aria-haspopup="true"
              >
                <a href="/memorials" className="menu-link menu-toggle">
                  <span className="menu-text">Memorials</span>
                  <span className="menu-desc" />
                  <i className="menu-arrow" />
                </a>
              </li>
              <li
                className="menu-item menu-item-submenu menu-item-rel"
                data-menu-toggle="click"
                aria-haspopup="true"
              >
                <a href="/posts" className="menu-link menu-toggle">
                  <span className="menu-text">Posts</span>
                  <span className="menu-desc" />
                  <i className="menu-arrow" />
                </a>
              </li>
              <li
                className="menu-item menu-item-submenu menu-item-rel"
                data-menu-toggle="click"
                aria-haspopup="true"
              >
                <a href="javascript:;" className="menu-link menu-toggle">
                  <span className="menu-text">Apps</span>
                  <span className="menu-desc" />
                  <i className="menu-arrow" />
                </a>
              </li>
              <li
                className="menu-item menu-item-submenu"
                data-menu-toggle="click"
                aria-haspopup="true"
              >
                <a href="javascript:;" className="menu-link menu-toggle">
                  <span className="menu-text">Pages</span>
                  <span className="menu-desc" />
                  <i className="menu-arrow" />
                </a>
              </li>
            </ul>
            {/*end::Header Nav*/}
          </div>
          {/*end::Header Menu*/}
        </div>
        {/*end::Header Menu Wrapper*/}
      </div>
      {/*end::Container*/}
    </div>
  );
}
