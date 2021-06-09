import React, { useState, useEffect } from "react";
import { useSelector, useDispatch } from "react-redux";
import {
  NavbarUserTabAction,
  NavbarMemorialTabAction,
  NavbarPostTabAction,
  NavbarReportTabAction,
  NavbarTransactionTabAction,
  TableUserAction,
  TableMemorialAction,
  TablePostAction,
  TableReportAction,
} from "../../redux/actions";

export default function Navbar() {
  const dispatch = useDispatch();
  const { navbarTab } = useSelector(({ navbarTab }) => ({
    navbarTab: navbarTab,
  }));
  const { auth_data } = useSelector(({ auth_data }) => ({
    auth_data: auth_data,
  }));

  const handleUserTabClicked = (tab) => {
    console.log("TAB ", tab);
    dispatch(NavbarUserTabAction({ tab }));
    dispatch(TableMemorialAction());
    dispatch(TablePostAction());
    dispatch(TableReportAction());
  };

  const handleMemorialTabClicked = (tab) => {
    console.log("TAB ", tab);
    dispatch(NavbarMemorialTabAction({ tab }));
    dispatch(TableUserAction());
    dispatch(TablePostAction());
    dispatch(TableReportAction());
  };

  const handlePostTabClicked = (tab) => {
    console.log("TAB ", tab);
    dispatch(NavbarPostTabAction({ tab }));
    dispatch(TableMemorialAction());
    dispatch(TableUserAction());
    dispatch(TableReportAction());
  };

  const handleReportTabClicked = (tab) => {
    console.log("TAB ", tab);
    dispatch(NavbarReportTabAction({ tab }));
    dispatch(TableMemorialAction());
    dispatch(TablePostAction());
    dispatch(TableUserAction());
  };

  const handleTransactionTabClicked = (tab) => {
    console.log("TAB ", tab);
    dispatch(NavbarTransactionTabAction({ tab }));
    dispatch(TableUserAction());
    dispatch(TableMemorialAction());
    dispatch(TablePostAction());
    dispatch(TableReportAction());
  };

  useEffect(() => {
    console.log("auth_data: ", auth_data);
  }, []);

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
              <li
                className={
                  navbarTab.tab == "users"
                    ? "menu-item menu-item-active"
                    : "menu-item menu-item-submenu"
                }
                aria-haspopup="true"
              >
                <a href="/users" className="menu-link">
                  <span
                    className="menu-text"
                    onClick={() => handleUserTabClicked("users")}
                  >
                    Users
                  </span>
                </a>
              </li>
              <li
                className={
                  navbarTab.tab == "memorials"
                    ? "menu-item menu-item-active"
                    : "menu-item menu-item-submenu"
                }
                data-menu-toggle="click"
                aria-haspopup="true"
              >
                <a href="/memorials" className="menu-link menu-toggle">
                  <span
                    className="menu-text"
                    onClick={() => handleMemorialTabClicked("memorials")}
                  >
                    Memorials
                  </span>
                  <span className="menu-desc" />
                  <i className="menu-arrow" />
                </a>
              </li>
              <li
                className={
                  navbarTab.tab == "posts"
                    ? "menu-item menu-item-active"
                    : "menu-item menu-item-submenu"
                }
                data-menu-toggle="click"
                aria-haspopup="true"
              >
                <a href="/posts" className="menu-link menu-toggle">
                  <span
                    className="menu-text"
                    onClick={() => handlePostTabClicked("posts")}
                  >
                    Posts
                  </span>
                  <span className="menu-desc" />
                  <i className="menu-arrow" />
                </a>
              </li>
              <li
                className={
                  navbarTab.tab == "reports"
                    ? "menu-item menu-item-active"
                    : "menu-item menu-item-submenu"
                }
                aria-haspopup="true"
              >
                <a href="/reports" className="menu-link">
                  <span
                    className="menu-text"
                    onClick={() => handleReportTabClicked("reports")}
                  >
                    Reports
                  </span>
                </a>
              </li>
              <li
                className={
                  navbarTab.tab == "transactions"
                    ? "menu-item menu-item-active"
                    : "menu-item menu-item-submenu"
                }
                aria-haspopup="true"
              >
                <a href="/transactions" className="menu-link">
                  <span
                    className="menu-text"
                    onClick={() => handleTransactionTabClicked("transactions")}
                  >
                    Transactions
                  </span>
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
