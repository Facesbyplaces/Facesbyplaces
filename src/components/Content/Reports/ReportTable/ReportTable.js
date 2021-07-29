import React, { useState } from "react";
import { useSelector } from "react-redux";

import Header from "./Header";
import DataTable from "./DataTable";

// Post
import EditReport from "../ReportCRUD/EditReport";
import ViewReport from "../ReportCRUD/ViewReport";
import AddReport from "../ReportCRUD/AddReport";

import { SuccessModal } from "../ReportCRUD/SuccessModal";

export default function ReportTable() {
  const [search, setSearch] = useState(false);
  const [keywords, setKeywords] = useState([]);
  const [showModal, setShowModal] = useState(true);
  const [pageType, setPageType] = useState(0);
  const { reportTab } = useSelector(({ reportTab }) => ({
    reportTab: reportTab,
  }));

  return (
    <div
      className="content content-height d-flex flex-column flex-column-fluid pb-0 pt-0"
      id="kt_content"
      style={{ height: "100%" }}
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
              <div className="container" style={{ margin: "auto" }}>
                <SuccessModal
                  showModal={showModal}
                  setShowModal={setShowModal}
                />
                <div className="card card-custom">
                  <Header pageType={pageType} setPageType={setPageType} />
                  <DataTable pageType={pageType} setPageType={setPageType} />
                </div>
              </div>
            );
          default:
            return (
              <div className="container" style={{ margin: "auto" }}>
                <div className="card card-custom">
                  <Header
                    pageType={pageType}
                    setPageType={setPageType}
                    setSearch={setSearch}
                    keywords={keywords}
                    setKeywords={setKeywords}
                  />
                  <DataTable
                    search={search}
                    setSearch={setSearch}
                    keywords={keywords}
                    pageType={pageType}
                  />
                </div>
              </div>
            );
        }
      })()}
    </div>
  );
}
