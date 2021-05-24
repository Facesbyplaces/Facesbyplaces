import React, { useState } from "react";
import { useSelector } from "react-redux";

import Header from "./Header";
import Body from "./Body";

// Post
import EditPost from "../PostCRUD/EditPost";
import ViewPost from "../PostCRUD/ViewPost";
import AddPost from "../PostCRUD/AddPost";

import { SuccessModal } from "../PostCRUD/SuccessModal";

export default function CommentTable({ comments }) {
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
      <div className="container">
        <div className="card card-custom">
          <Header pageType={pageType} setPageType={setPageType} />
          <Body
            comments={comments}
            pageType={pageType}
            setPageType={setPageType}
          />
        </div>
      </div>
    </div>
  );
}
