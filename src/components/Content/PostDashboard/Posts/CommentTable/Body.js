import React, { useState } from "react";
import CommentDataTable from "./CommentDataTable";
import { AddMemorialAction } from "../../../../../redux/actions";

export default function Body({ pageType, setPageType, comments }) {
  const [search, setSearch] = useState(false);
  const [keywords, setKeywords] = useState([]);

  const handleClick = () => {
    setSearch(true);
  };

  const handleChange = (e) => {
    setKeywords(e.target.value);
    // setSearch(true);
  };

  return (
    <div className="card-body">
      {/*begin: Search Form*/}
      {/*begin::Search Form*/}
      <div className="mb-7">
        <div className="row align-items-center">
          <div className="col-lg-9 col-xl-8">
            <div className="row align-items-center">
              <div className="col-md-12 my-2 my-md-0">
                <div className="input-icon">
                  <input
                    type="text"
                    className="form-control"
                    placeholder="Search..."
                    onChange={handleChange}
                    value={keywords}
                  />
                  <span>
                    <i className="flaticon2-search-1 text-muted" />
                  </span>
                </div>
              </div>
            </div>
          </div>
          <div className="col-sm-1 mt-5 mt-lg-0">
            <a
              className="btn btn-light-primary px-6 font-weight-bold"
              onClick={() => handleClick()}
            >
              Search
            </a>
          </div>
        </div>
      </div>
      {/*end::Search Form*/}

      {/*begin: Datatable*/}
      <div className="">
        <CommentDataTable
          search={search}
          setSearch={setSearch}
          keywords={keywords}
          pageType={pageType}
          comments={comments}
        />
      </div>
      {/*end: Datatable*/}
    </div>
  );
}
