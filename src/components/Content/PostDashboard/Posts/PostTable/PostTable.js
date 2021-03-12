import React, { useState } from "react";
import { useSelector } from "react-redux";

import Header from "./Header";
import Body from "./Body";

// Post
import EditPost from "../PostCRUD/EditPost";
import ViewPost from "../PostCRUD/ViewPost";
import AddPost from "../PostCRUD/AddPost";

import { SuccessModal } from "../PostCRUD/SuccessModal";

export default function PostTable() {
  const [showModal, setShowModal] = useState(true);
  const [pageType, setPageType] = useState(0);
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
            return <AddPost />;
          case "d":
            return (
              <div className="container">
                <SuccessModal
                  showModal={showModal}
                  setShowModal={setShowModal}
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
