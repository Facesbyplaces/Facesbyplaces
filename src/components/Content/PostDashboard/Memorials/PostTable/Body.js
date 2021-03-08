import React, { useState } from "react";
import PostDataTable from "./PostDataTable";
import { AddMemorialAction } from "../../../../../redux/actions";

export default function Body({ pageType, setPageType }) {
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
          <div className="col-sm-3 mt-5 mt-lg-0">
            <div className="dropdown pl-22">
              <div
                className="btn-group btn-group-toggle"
                style={{
                  display: "inline-block",
                  textAlign: "center",
                }}
                data-toggle="buttons"
              >
                <label
                  className={`btn btn-outline-warning ${
                    pageType === 2 ? "active" : ""
                  }`}
                  style={{ width: "84px" }}
                  onClick={() => setPageType(2)}
                >
                  <input type="radio" name="options" />
                  ALM
                </label>
                <label
                  className={`btn btn-outline-warning ${
                    pageType === 1 ? "active" : ""
                  }`}
                  style={{ width: "84px" }}
                >
                  <input
                    type="radio"
                    name="options"
                    onClick={() => setPageType(1)}
                  />
                  BLM
                </label>
              </div>
            </div>
          </div>
        </div>
      </div>
      {/*end::Search Form*/}

      {/*begin: Datatable*/}
      <div className="">
        <PostDataTable
          search={search}
          setSearch={setSearch}
          keywords={keywords}
          pageType={pageType}
        />
      </div>
      {/*end: Datatable*/}
    </div>
  );
}
