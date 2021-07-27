import React, { useState } from "react";
import { useSelector } from "react-redux";

import Header from "./Header";
import DataTable from "./DataTable";

// Post
import EditPost from "../PostCRUD/EditPost";
import ViewPost from "../PostCRUD/ViewPost";
import AddPost from "../PostCRUD/AddPost";

import { SuccessModal } from "../Modals/SuccessModal";

export default function PostTable() {
  const [search, setSearch] = useState(false);
  const [keywords, setKeywords] = useState([]);
  const [showModal, setShowModal] = useState(true);
  const [pageType, setPageType] = useState(2);
  const { postTab } = useSelector(({ postTab }) => ({
    postTab: postTab,
  }));

  return (
    <div
      className="content content-height d-flex flex-column flex-column-fluid"
      id="kt_content"
    >
      {(() => {
        switch (postTab.option) {
          case "v":
            return <ViewPost />;
          case "e":
            return <EditPost />;
          case "a":
            return <AddPost pageType={pageType} setPageType={setPageType} />;
          case "d":
            return (
              <div className="container">
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
              <div className="container">
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
