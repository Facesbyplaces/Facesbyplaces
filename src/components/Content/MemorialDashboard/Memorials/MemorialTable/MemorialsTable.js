import React, { useEffect, useState } from "react";
import { useSelector, useDispatch } from "react-redux";
import { TableUserAction } from "../../../../../redux/actions";

import Header from "./Header";
import Body from "./Body";
import ViewMemorial from "../MemorialCRUD/ViewMemorial";
import EditMemorial from "../MemorialCRUD/EditMemorial";
import AddMemorial from "../MemorialCRUD/AddMemorial";
import { SuccessModal } from "../../../../Modals/SuccessModal";

export default function MemorialsTable() {
  const dispatch = useDispatch();
  const [showModal, setShowModal] = useState(true);
  const { memorialTab } = useSelector(({ memorialTab }) => ({
    memorialTab: memorialTab,
  }));

  return (
    <div
      className="content-height d-flex flex-column flex-column-fluid"
      id="kt_content"
    >
      {(() => {
        switch (memorialTab.option) {
          case "v":
            return <ViewMemorial />;
          case "e":
            return <EditMemorial />;
          case "a":
            return <AddMemorial />;
          case "d":
            return (
              <div className="container">
                <SuccessModal
                  showModal={showModal}
                  setShowModal={setShowModal}
                  action={memorialTab.option}
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
