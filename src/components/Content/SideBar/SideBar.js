import React from "react";

export default function SideBar() {
  return (
    <div>
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
              src="assets/media/logos/fbp-logo.png"
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
                      <a href="javascript:;" className="menu-link menu-toggle">
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
                      <a href="javascript:;" className="menu-link menu-toggle">
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
                      <a href="javascript:;" className="menu-link menu-toggle">
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
                      <a href="javascript:;" className="menu-link menu-toggle">
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
                      <a href="javascript:;" className="menu-link menu-toggle">
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
                      <a href="javascript:;" className="menu-link menu-toggle">
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
                      <a href="javascript:;" className="menu-link menu-toggle">
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
                      <a href="javascript:;" className="menu-link menu-toggle">
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
    </div>
  );
}
