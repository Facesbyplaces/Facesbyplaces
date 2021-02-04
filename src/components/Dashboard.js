import React from "react";
import { LogoutAction } from "../redux/actions";
import { useDispatch } from "react-redux";

const Dashboard = (props) => {
  const dispatch = useDispatch();

  const onLogOutClicked = () => {
    dispatch(LogoutAction({}));
  };

  return (
    <div>
      {/*begin::Head*/}
      <base href />
      <meta charSet="utf-8" />
      <title>Metronic Live preview | Keenthemes</title>
      <meta name="description" content="Updates and statistics" />
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
      {/*begin::Page Vendors Styles(used by this page)*/}
      <link
        href="assets/plugins/custom/fullcalendar/fullcalendar.bundle.css"
        rel="stylesheet"
        type="text/css"
      />
      {/*end::Page Vendors Styles*/}
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

      <div className="content-height d-flex flex-column flex-root">
        {/*begin::Page*/}
        <div className="d-flex flex-row flex-column-fluid page">
          {/*begin::Aside*/}
          <div
            className="aside aside-left aside-fixed d-flex flex-column flex-row-auto"
            id="kt_aside"
          >
            {/*begin::Brand*/}
            <div className="brand flex-column-auto" id="kt_brand">
              {/*begin::Logo*/}
              <a href="index.html" className="brand-logo">
                <img
                  alt="Logo"
                  className="w-65px"
                  src="assets/media/logos/logo-letter-13.png"
                />
              </a>
              {/*end::Logo*/}
            </div>
            {/*end::Brand*/}
            {/*begin::Aside Menu*/}
            <div
              className="aside-menu-wrapper flex-column-fluid"
              id="kt_aside_menu_wrapper"
            >
              {/*begin::Menu Container*/}
              <div
                id="kt_aside_menu"
                className="aside-menu my-4"
                data-menu-vertical={1}
                data-menu-scroll={1}
                data-menu-dropdown-timeout={500}
              >
                {/*begin::Menu Nav*/}
                <ul className="menu-nav">
                  <li
                    className="menu-item menu-item-submenu"
                    aria-haspopup="true"
                    data-menu-toggle="hover"
                  >
                    <a href="javascript:;" className="menu-link menu-toggle">
                      <i className="menu-icon flaticon2-telegram-logo" />
                      <span className="menu-text">Actions</span>
                      <i className="menu-arrow" />
                    </a>
                    <div className="menu-submenu">
                      <i className="menu-arrow" />
                      <ul className="menu-subnav">
                        <li
                          className="menu-item menu-item-parent"
                          aria-haspopup="true"
                        >
                          <span className="menu-link">
                            <span className="menu-text">Actions</span>
                          </span>
                        </li>
                        <li
                          className="menu-item menu-item-submenu"
                          aria-haspopup="true"
                          data-menu-toggle="hover"
                        >
                          <a
                            href="javascript:;"
                            className="menu-link menu-toggle"
                          >
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Reports</span>
                            <i className="menu-arrow" />
                          </a>
                          <div className="menu-submenu">
                            <i className="menu-arrow" />
                            <ul className="menu-subnav">
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">Finance</span>
                                </a>
                              </li>
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">HR</span>
                                </a>
                              </li>
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">Projects</span>
                                </a>
                              </li>
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">Events</span>
                                </a>
                              </li>
                            </ul>
                          </div>
                        </li>
                        <li className="menu-item" aria-haspopup="true">
                          <a href="#" className="menu-link">
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Messages</span>
                          </a>
                        </li>
                        <li className="menu-item" aria-haspopup="true">
                          <a href="#" className="menu-link">
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Notes</span>
                          </a>
                        </li>
                        <li className="menu-item" aria-haspopup="true">
                          <a href="#" className="menu-link">
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Remarks</span>
                          </a>
                        </li>
                      </ul>
                    </div>
                  </li>
                  <li
                    className="menu-item menu-item-submenu"
                    aria-haspopup="true"
                    data-menu-toggle="hover"
                  >
                    <a href="javascript:;" className="menu-link menu-toggle">
                      <i className="menu-icon flaticon2-telegram-logo" />

                      <i className="menu-arrow" />
                    </a>
                    <div className="menu-submenu">
                      <i className="menu-arrow" />
                      <ul className="menu-subnav">
                        <li
                          className="menu-item menu-item-parent"
                          aria-haspopup="true"
                        >
                          <span className="menu-link"></span>
                        </li>
                        <li
                          className="menu-item menu-item-submenu"
                          aria-haspopup="true"
                          data-menu-toggle="hover"
                        >
                          <a
                            href="javascript:;"
                            className="menu-link menu-toggle"
                          >
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Reports</span>
                            <i className="menu-arrow" />
                          </a>
                          <div className="menu-submenu">
                            <i className="menu-arrow" />
                            <ul className="menu-subnav">
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">Finance</span>
                                </a>
                              </li>
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">HR</span>
                                </a>
                              </li>
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">Projects</span>
                                </a>
                              </li>
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">Events</span>
                                </a>
                              </li>
                            </ul>
                          </div>
                        </li>
                        <li className="menu-item" aria-haspopup="true">
                          <a href="#" className="menu-link">
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Messages</span>
                          </a>
                        </li>
                        <li className="menu-item" aria-haspopup="true">
                          <a href="#" className="menu-link">
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Notes</span>
                          </a>
                        </li>
                        <li className="menu-item" aria-haspopup="true">
                          <a href="#" className="menu-link">
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Remarks</span>
                          </a>
                        </li>
                      </ul>
                    </div>
                  </li>
                  <li
                    className="menu-item menu-item-submenu"
                    aria-haspopup="true"
                    data-menu-toggle="hover"
                  >
                    <a href="javascript:;" className="menu-link menu-toggle">
                      <i className="menu-icon flaticon2-telegram-logo" />

                      <i className="menu-arrow" />
                    </a>
                    <div className="menu-submenu">
                      <i className="menu-arrow" />
                      <ul className="menu-subnav">
                        <li
                          className="menu-item menu-item-parent"
                          aria-haspopup="true"
                        >
                          <span className="menu-link"></span>
                        </li>
                        <li
                          className="menu-item menu-item-submenu"
                          aria-haspopup="true"
                          data-menu-toggle="hover"
                        >
                          <a
                            href="javascript:;"
                            className="menu-link menu-toggle"
                          >
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Reports</span>
                            <i className="menu-arrow" />
                          </a>
                          <div className="menu-submenu">
                            <i className="menu-arrow" />
                            <ul className="menu-subnav">
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">Finance</span>
                                </a>
                              </li>
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">HR</span>
                                </a>
                              </li>
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">Projects</span>
                                </a>
                              </li>
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">Events</span>
                                </a>
                              </li>
                            </ul>
                          </div>
                        </li>
                        <li className="menu-item" aria-haspopup="true">
                          <a href="#" className="menu-link">
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Messages</span>
                          </a>
                        </li>
                        <li className="menu-item" aria-haspopup="true">
                          <a href="#" className="menu-link">
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Notes</span>
                          </a>
                        </li>
                        <li className="menu-item" aria-haspopup="true">
                          <a href="#" className="menu-link">
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Remarks</span>
                          </a>
                        </li>
                      </ul>
                    </div>
                  </li>
                  <li
                    className="menu-item menu-item-submenu"
                    aria-haspopup="true"
                    data-menu-toggle="hover"
                  >
                    <a href="javascript:;" className="menu-link menu-toggle">
                      <i className="menu-icon flaticon2-telegram-logo" />

                      <i className="menu-arrow" />
                    </a>
                    <div className="menu-submenu">
                      <i className="menu-arrow" />
                      <ul className="menu-subnav">
                        <li
                          className="menu-item menu-item-parent"
                          aria-haspopup="true"
                        >
                          <span className="menu-link"></span>
                        </li>
                        <li
                          className="menu-item menu-item-submenu"
                          aria-haspopup="true"
                          data-menu-toggle="hover"
                        >
                          <a
                            href="javascript:;"
                            className="menu-link menu-toggle"
                          >
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Reports</span>
                            <i className="menu-arrow" />
                          </a>
                          <div className="menu-submenu">
                            <i className="menu-arrow" />
                            <ul className="menu-subnav">
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">Finance</span>
                                </a>
                              </li>
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">HR</span>
                                </a>
                              </li>
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">Projects</span>
                                </a>
                              </li>
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">Events</span>
                                </a>
                              </li>
                            </ul>
                          </div>
                        </li>
                        <li className="menu-item" aria-haspopup="true">
                          <a href="#" className="menu-link">
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Messages</span>
                          </a>
                        </li>
                        <li className="menu-item" aria-haspopup="true">
                          <a href="#" className="menu-link">
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Notes</span>
                          </a>
                        </li>
                        <li className="menu-item" aria-haspopup="true">
                          <a href="#" className="menu-link">
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Remarks</span>
                          </a>
                        </li>
                      </ul>
                    </div>
                  </li>
                  <li
                    className="menu-item menu-item-submenu"
                    aria-haspopup="true"
                    data-menu-toggle="hover"
                  >
                    <a href="javascript:;" className="menu-link menu-toggle">
                      <i className="menu-icon flaticon2-telegram-logo" />

                      <i className="menu-arrow" />
                    </a>
                    <div className="menu-submenu">
                      <i className="menu-arrow" />
                      <ul className="menu-subnav">
                        <li
                          className="menu-item menu-item-parent"
                          aria-haspopup="true"
                        >
                          <span className="menu-link"></span>
                        </li>
                        <li
                          className="menu-item menu-item-submenu"
                          aria-haspopup="true"
                          data-menu-toggle="hover"
                        >
                          <a
                            href="javascript:;"
                            className="menu-link menu-toggle"
                          >
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Reports</span>
                            <i className="menu-arrow" />
                          </a>
                          <div className="menu-submenu">
                            <i className="menu-arrow" />
                            <ul className="menu-subnav">
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">Finance</span>
                                </a>
                              </li>
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">HR</span>
                                </a>
                              </li>
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">Projects</span>
                                </a>
                              </li>
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">Events</span>
                                </a>
                              </li>
                            </ul>
                          </div>
                        </li>
                        <li className="menu-item" aria-haspopup="true">
                          <a href="#" className="menu-link">
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Messages</span>
                          </a>
                        </li>
                        <li className="menu-item" aria-haspopup="true">
                          <a href="#" className="menu-link">
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Notes</span>
                          </a>
                        </li>
                        <li className="menu-item" aria-haspopup="true">
                          <a href="#" className="menu-link">
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Remarks</span>
                          </a>
                        </li>
                      </ul>
                    </div>
                  </li>
                  <li
                    className="menu-item menu-item-submenu"
                    aria-haspopup="true"
                    data-menu-toggle="hover"
                  >
                    <a href="javascript:;" className="menu-link menu-toggle">
                      <i className="menu-icon flaticon2-telegram-logo" />

                      <i className="menu-arrow" />
                    </a>
                    <div className="menu-submenu">
                      <i className="menu-arrow" />
                      <ul className="menu-subnav">
                        <li
                          className="menu-item menu-item-parent"
                          aria-haspopup="true"
                        >
                          <span className="menu-link"></span>
                        </li>
                        <li
                          className="menu-item menu-item-submenu"
                          aria-haspopup="true"
                          data-menu-toggle="hover"
                        >
                          <a
                            href="javascript:;"
                            className="menu-link menu-toggle"
                          >
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Reports</span>
                            <i className="menu-arrow" />
                          </a>
                          <div className="menu-submenu">
                            <i className="menu-arrow" />
                            <ul className="menu-subnav">
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">Finance</span>
                                </a>
                              </li>
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">HR</span>
                                </a>
                              </li>
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">Projects</span>
                                </a>
                              </li>
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">Events</span>
                                </a>
                              </li>
                            </ul>
                          </div>
                        </li>
                        <li className="menu-item" aria-haspopup="true">
                          <a href="#" className="menu-link">
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Messages</span>
                          </a>
                        </li>
                        <li className="menu-item" aria-haspopup="true">
                          <a href="#" className="menu-link">
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Notes</span>
                          </a>
                        </li>
                        <li className="menu-item" aria-haspopup="true">
                          <a href="#" className="menu-link">
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Remarks</span>
                          </a>
                        </li>
                      </ul>
                    </div>
                  </li>
                  <li
                    className="menu-item menu-item-submenu"
                    aria-haspopup="true"
                    data-menu-toggle="hover"
                  >
                    <a href="javascript:;" className="menu-link menu-toggle">
                      <i className="menu-icon flaticon2-telegram-logo" />

                      <i className="menu-arrow" />
                    </a>
                    <div className="menu-submenu">
                      <i className="menu-arrow" />
                      <ul className="menu-subnav">
                        <li
                          className="menu-item menu-item-parent"
                          aria-haspopup="true"
                        >
                          <span className="menu-link"></span>
                        </li>
                        <li
                          className="menu-item menu-item-submenu"
                          aria-haspopup="true"
                          data-menu-toggle="hover"
                        >
                          <a
                            href="javascript:;"
                            className="menu-link menu-toggle"
                          >
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Reports</span>
                            <i className="menu-arrow" />
                          </a>
                          <div className="menu-submenu">
                            <i className="menu-arrow" />
                            <ul className="menu-subnav">
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">Finance</span>
                                </a>
                              </li>
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">HR</span>
                                </a>
                              </li>
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">Projects</span>
                                </a>
                              </li>
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">Events</span>
                                </a>
                              </li>
                            </ul>
                          </div>
                        </li>
                        <li className="menu-item" aria-haspopup="true">
                          <a href="#" className="menu-link">
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Messages</span>
                          </a>
                        </li>
                        <li className="menu-item" aria-haspopup="true">
                          <a href="#" className="menu-link">
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Notes</span>
                          </a>
                        </li>
                        <li className="menu-item" aria-haspopup="true">
                          <a href="#" className="menu-link">
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Remarks</span>
                          </a>
                        </li>
                      </ul>
                    </div>
                  </li>
                  <li
                    className="menu-item menu-item-submenu"
                    aria-haspopup="true"
                    data-menu-toggle="hover"
                  >
                    <a href="javascript:;" className="menu-link menu-toggle">
                      <i className="menu-icon flaticon2-telegram-logo" />

                      <i className="menu-arrow" />
                    </a>
                    <div className="menu-submenu">
                      <i className="menu-arrow" />
                      <ul className="menu-subnav">
                        <li
                          className="menu-item menu-item-parent"
                          aria-haspopup="true"
                        >
                          <span className="menu-link"></span>
                        </li>
                        <li
                          className="menu-item menu-item-submenu"
                          aria-haspopup="true"
                          data-menu-toggle="hover"
                        >
                          <a
                            href="javascript:;"
                            className="menu-link menu-toggle"
                          >
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Reports</span>
                            <i className="menu-arrow" />
                          </a>
                          <div className="menu-submenu">
                            <i className="menu-arrow" />
                            <ul className="menu-subnav">
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">Finance</span>
                                </a>
                              </li>
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">HR</span>
                                </a>
                              </li>
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">Projects</span>
                                </a>
                              </li>
                              <li className="menu-item" aria-haspopup="true">
                                <a href="#" className="menu-link">
                                  <i className="menu-bullet menu-bullet-dot">
                                    <span />
                                  </i>
                                  <span className="menu-text">Events</span>
                                </a>
                              </li>
                            </ul>
                          </div>
                        </li>
                        <li className="menu-item" aria-haspopup="true">
                          <a href="#" className="menu-link">
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Messages</span>
                          </a>
                        </li>
                        <li className="menu-item" aria-haspopup="true">
                          <a href="#" className="menu-link">
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Notes</span>
                          </a>
                        </li>
                        <li className="menu-item" aria-haspopup="true">
                          <a href="#" className="menu-link">
                            <i className="menu-bullet menu-bullet-line">
                              <span />
                            </i>
                            <span className="menu-text">Remarks</span>
                          </a>
                        </li>
                      </ul>
                    </div>
                  </li>
                </ul>
                {/*end::Menu Nav*/}
              </div>
              {/*end::Menu Container*/}
            </div>
            {/*end::Aside Menu*/}
          </div>
          {/*end::Aside*/}
          {/*begin::Wrapper*/}
          <div
            className="d-flex flex-column flex-row-fluid wrapper"
            id="kt_wrapper"
          >
            {/*begin::Header*/}
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
                      <li
                        className="menu-item menu-item-active"
                        aria-haspopup="true"
                      >
                        <a href="index.html" className="menu-link">
                          <span className="menu-text">Dashboard</span>
                        </a>
                      </li>
                      <li
                        className="menu-item menu-item-submenu menu-item-rel"
                        data-menu-toggle="click"
                        aria-haspopup="true"
                      >
                        <a
                          href="javascript:;"
                          className="menu-link menu-toggle"
                        >
                          <span className="menu-text">Features</span>
                          <span className="menu-desc" />
                          <i className="menu-arrow" />
                        </a>
                      </li>
                      <li
                        className="menu-item menu-item-submenu menu-item-rel"
                        data-menu-toggle="click"
                        aria-haspopup="true"
                      >
                        <a
                          href="javascript:;"
                          className="menu-link menu-toggle"
                        >
                          <span className="menu-text">Crud</span>
                          <span className="menu-desc" />
                          <i className="menu-arrow" />
                        </a>
                      </li>
                      <li
                        className="menu-item menu-item-submenu menu-item-rel"
                        data-menu-toggle="click"
                        aria-haspopup="true"
                      >
                        <a
                          href="javascript:;"
                          className="menu-link menu-toggle"
                        >
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
                        <a
                          href="javascript:;"
                          className="menu-link menu-toggle"
                        >
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
                {/*begin::Topbar*/}
                <div className="topbar">
                  {/*begin::User*/}
                  <div className="topbar-item">
                    <div
                      className="btn btn-icon w-auto btn-clean d-flex align-items-center btn-lg px-2"
                      id="kt_quick_user_toggle"
                    >
                      <span className="text-muted font-weight-bold font-size-base d-none d-md-inline mr-1">
                        Hi,
                      </span>
                      <span className="text-dark-50 font-weight-bolder font-size-base d-none d-md-inline mr-3">
                        Sean
                      </span>
                      <span className="symbol symbol-35 symbol-light-success">
                        <span className="symbol-label font-size-h5 font-weight-bold">
                          S
                        </span>
                      </span>
                    </div>
                  </div>
                  <div className="topbar-item">
                    <div
                      className="btn btn-icon w-auto btn-clean d-flex align-items-center btn-lg px-2"
                      id="kt_quick_user_toggle"
                    >
                      <span
                        className="text-dark-50 font-weight-bolder font-size-base d-none d-md-inline mr-3"
                        onClick={onLogOutClicked}
                      >
                        Sign Out
                      </span>
                    </div>
                  </div>
                  {/*end::User*/}
                </div>
                {/*end::Topbar*/}
              </div>
              {/*end::Container*/}
            </div>
            {/*end::Header*/}

            {/*begin::Content*/}
            <div
              className="content content-height d-flex flex-column flex-column-fluid"
              id="kt_content"
            ></div>
            {/*end::Content*/}

            {/*begin::Footer*/}
            <div
              className="footer bg-white py-4 d-flex flex-lg-column"
              id="kt_footer"
            >
              {/*begin::Container*/}
              <div className="container-fluid d-flex flex-column flex-md-row align-items-center justify-content-between">
                {/*begin::Copyright*/}
                <div className="text-dark order-2 order-md-1">
                  <span className="text-muted font-weight-bold mr-2">
                    2020©
                  </span>
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
          {/*end::Wrapper*/}
        </div>
        {/*end::Page*/}
      </div>
      {/*end::Main*/}

      {/*begin::Global Config(global config for global JS scripts)*/}
      {/*end::Global Config*/}
      {/*begin::Global Theme Bundle(used by all pages)*/}
      {/*end::Global Theme Bundle*/}
      {/*begin::Page Vendors(used by this page)*/}
      {/*end::Page Vendors*/}
      {/*begin::Page Scripts(used by this page)*/}
      {/*end::Page Scripts*/}
      {/*end::Body*/}
    </div>
  );
};

export default Dashboard;
