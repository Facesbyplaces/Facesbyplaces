import React, { useState } from "react";
import { useSelector, useDispatch } from "react-redux";
import { TableUserAction } from "../../../../../redux/actions";

import Header from "./Header";
import Body from "./Body";
import User from "../UserProfile/User";
import AddUser from "../UserProfile/AddUser";
import { SuccessModal } from "../UserProfile/SuccessModal";

export default function UsersTable() {
  const [showModal, setShowModal] = useState(true);
  const { tab } = useSelector(({ tab }) => ({
    tab: tab,
  }));

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
          case "d":
            return (
              <div className="container">
                <SuccessModal
                  showModal={showModal}
                  setShowModal={setShowModal}
                  action={tab.option}
                />
                <div className="card card-custom">
                  <Header />
                  <Body />
                </div>
              </div>
            );
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
