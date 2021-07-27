import React, { useState } from "react";
import { useSelector } from "react-redux";

import Header from "./Header";
import Body from "./Body";

// Post
import EditPost from "../PostCRUD/EditPost";
import ViewPost from "../PostCRUD/ViewPost";
import AddPost from "../PostCRUD/AddPost";

import { SuccessModal } from "../Modals/SuccessModal";
import DataTable from "./CommentDataTable";

export default function CommentTable() {
  const [search, setSearch] = useState(false);
  const [keywords, setKeywords] = useState([]);
  const [showModal, setShowModal] = useState(true);
  const [pageType, setPageType] = useState(0);

  return (
    <div
      className="content content-height d-flex flex-column flex-column-fluid"
      id="kt_content"
    >
      <div className="container">
        <div className="card card-custom">
          <Header pageType={pageType} setPageType={setPageType} />
          <DataTable
            search={search}
            setSearch={setSearch}
            keywords={keywords}
          />
        </div>
      </div>
    </div>
  );
}
