import React, { useState } from "react";
import { useSelector } from "react-redux";

import Header from "./Header";
import Body from "./Body";

// Post
import EditReport from "../ReportCRUD/EditReport";
import ViewReport from "../ReportCRUD/ViewReport";
import AddReport from "../ReportCRUD/AddReport";

import { SuccessModal } from "../ReportCRUD/SuccessModal";

export default function ReportTable() {
  const [showModal, setShowModal] = useState(true);
  const [pageType, setPageType] = useState(0);
  const { reportTab } = useSelector(({ reportTab }) => ({
    reportTab: reportTab,
  }));

  return (
    <div
      className="content content-height d-flex flex-column flex-column-fluid"
      id="kt_content"
    >
      {(() => {
        switch (reportTab.option) {
          case "v":
            return <ViewReport />;
          case "e":
            return <EditReport />;
          case "a":
            return <AddReport />;
          case "d":
            return (
              <div className="container">
                <SuccessModal
                  showModal={showModal}
                  setShowModal={setShowModal}
                />
                <div className="card card-custom">
                  <Header pageType={pageType} setPageType={setPageType} />
                  <Body pageType={pageType} setPageType={setPageType} />
                </div>
              </div>
            );
          default:
            return (
              <div className="container">
                <div className="card card-custom">
                  <Header pageType={pageType} setPageType={setPageType} />
                  <Body pageType={pageType} setPageType={setPageType} />
                </div>
              </div>
            );
        }
      })()}
    </div>
  );
}
