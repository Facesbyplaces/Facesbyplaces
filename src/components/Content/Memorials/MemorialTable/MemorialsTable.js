import React, { useState } from "react";
import { useSelector } from "react-redux";

import Header from "./Header";
import DataTable from "./DataTable";
// Memorial CRUD
import ViewMemorial from "../MemorialCRUD/ALM/ViewMemorial";
import EditMemorial from "../MemorialCRUD/ALM/EditMemorial";
import AddMemorial from "../MemorialCRUD/ALM/AddMemorial";
// BLM CRUD
import ViewBlm from "../MemorialCRUD/BLM/ViewBlm";
import EditBlm from "../MemorialCRUD/BLM/EditBlm";
import AddBlm from "../MemorialCRUD/BLM/AddBlm";
import { SuccessModal } from "../Modals/SuccessModal";

export default function MemorialsTable() {
  const [search, setSearch] = useState(false);
  const [keywords, setKeywords] = useState([]);
  const [showModal, setShowModal] = useState(true);
  const [pageType, setPageType] = useState(2);
  const { memorialTab } = useSelector(({ memorialTab }) => ({
    memorialTab: memorialTab,
  }));

  return (
    <div
      className="content content-height d-flex flex-column flex-column-fluid pb-0 pt-0"
      id="kt_content"
      style={{ height: "100%" }}
    >
      {(() => {
        if (memorialTab.type === 2) {
          switch (memorialTab.option) {
            case "v":
              return <ViewMemorial />;
            case "e":
              return <EditMemorial />;
            case "a":
              return <AddMemorial />;
            case "d":
              return (
                <div className="container" style={{ margin: "auto" }}>
                  <SuccessModal
                    showModal={showModal}
                    setShowModal={setShowModal}
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
        } else {
          switch (memorialTab.option) {
            case "v":
              return <ViewBlm />;
            case "e":
              return <EditBlm />;
            case "a":
              return <AddBlm />;
            case "d":
              return (
                <div className="container" style={{ margin: "auto" }}>
                  <SuccessModal
                    showModal={showModal}
                    setShowModal={setShowModal}
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
        }
      })()}
    </div>
  );
}
