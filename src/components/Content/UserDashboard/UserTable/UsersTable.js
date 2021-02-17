import React from "react";
import { useSelector, useDispatch } from "react-redux";
import { TableUserAction } from "../../../../redux/actions";

import Header from "./Header";
import Body from "./Body";
import User from "../UserProfile/User";
import AddUser from "../UserProfile/AddUser";

export default function UsersTable() {
  const dispatch = useDispatch();
  const { tab } = useSelector(({ tab }) => ({
    tab: tab,
  }));

  const handleTableClick = () => {
    dispatch(TableUserAction());
  };

  return (
    <div
      className="content content-height d-flex flex-column flex-column-fluid"
      id="kt_content"
    >
      {(() => {
        switch (tab.option) {
          case "v":
            return <User />;
          case "e":
            return <User />;
          case "a":
            return <AddUser />;
          default:
            return (
              <div className="container">
                <div className="card card-custom">
                  <Header />
                  <Body />
                </div>
              </div>
            );
        }
      })()}
    </div>
  );
}
