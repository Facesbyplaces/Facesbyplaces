import React, { useState } from "react";
import { useSelector } from "react-redux";

import Header from "./Header";
import DataTable from "./DataTable";
import ViewUser from "../UserProfile/ViewUser";
import AddUser from "../UserProfile/AddUser";
import { SuccessModal } from "../Modals/SuccessModal";

export default function UsersTable() {
  const [search, setSearch] = useState(false);
  const [keywords, setKeywords] = useState([]);
  const [showModal, setShowModal] = useState(true);
  const [pageType, setPageType] = useState(2);
  const { tab } = useSelector(({ tab }) => ({
    tab: tab,
  }));

  return (
    <div
      className="content content-height d-flex flex-column flex-column-fluid pb-0 pt-0"
      id="kt_content"
      style={{ height: "100%" }}
    >
      {(() => {
        switch (tab.option) {
          case "v":
            return <ViewUser />;
          case "e":
            return <ViewUser />;
          case "a":
            return <AddUser />;
          case "d":
            return (
              <div className="container" style={{ margin: "auto" }}>
                <SuccessModal
                  showModal={showModal}
                  setShowModal={setShowModal}
                  action={tab.option}
                />
                <div className="card card-custom">
                  <Header />
                  <DataTable />
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
                    search={search}
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
