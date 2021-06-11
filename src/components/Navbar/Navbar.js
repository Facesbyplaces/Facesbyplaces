import React, { useState, useEffect } from "react";
import { useSelector, useDispatch } from "react-redux";
import {
  TableUserAction,
  TableMemorialAction,
  TablePostAction,
  TableReportAction,
} from "../../redux/actions";

export default function Navbar({ item }) {
  const dispatch = useDispatch();
  const { navbarTab } = useSelector(({ navbarTab }) => ({
    navbarTab: navbarTab,
  }));
  const { auth_data } = useSelector(({ auth_data }) => ({
    auth_data: auth_data,
  }));

  const handleUserTabClicked = () => {
    dispatch(TableMemorialAction());
    dispatch(TablePostAction());
    dispatch(TableReportAction());
  };

  const handleMemorialTabClicked = () => {
    dispatch(TableUserAction());
    dispatch(TablePostAction());
    dispatch(TableReportAction());
  };

  const handlePostTabClicked = () => {
    dispatch(TableMemorialAction());
    dispatch(TableUserAction());
    dispatch(TableReportAction());
  };

  const handleReportTabClicked = () => {
    dispatch(TableMemorialAction());
    dispatch(TablePostAction());
    dispatch(TableUserAction());
  };

  const handleTransactionTabClicked = () => {
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
                  item == "users"
                    ? "menu-item menu-item-active"
                    : "menu-item menu-item-submenu"
                }
                aria-haspopup="true"
              >
                <a
                  href="/users"
                  className="menu-link"
                  onClick={() => handleUserTabClicked()}
                >
                  <span className="menu-text">Users</span>
                </a>
              </li>
              <li
                className={
                  item == "memorials"
                    ? "menu-item menu-item-active"
                    : "menu-item menu-item-submenu"
                }
                data-menu-toggle="click"
                aria-haspopup="true"
              >
                <a
                  href="/memorials"
                  className="menu-link menu-toggle"
                  onClick={() => handleMemorialTabClicked()}
                >
                  <span className="menu-text">Memorials</span>
                </a>
              </li>
              <li
                className={
                  item == "posts"
                    ? "menu-item menu-item-active"
                    : "menu-item menu-item-submenu"
                }
                data-menu-toggle="click"
                aria-haspopup="true"
              >
                <a
                  href="/posts"
                  className="menu-link menu-toggle"
                  onClick={() => handlePostTabClicked()}
                >
                  <span className="menu-text">Posts</span>
                </a>
              </li>
              <li
                className={
                  item == "reports"
                    ? "menu-item menu-item-active"
                    : "menu-item menu-item-submenu"
                }
                aria-haspopup="true"
              >
                <a href="/reports" className="menu-link">
                  <span
                    className="menu-text"
                    onClick={() => handleReportTabClicked()}
                  >
                    Reports
                  </span>
                </a>
              </li>
              <li
                className={
                  item == "transactions"
                    ? "menu-item menu-item-active"
                    : "menu-item menu-item-submenu"
                }
                aria-haspopup="true"
              >
                <a href="/transactions" className="menu-link">
                  <span
                    className="menu-text"
                    onClick={() => handleTransactionTabClicked()}
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
