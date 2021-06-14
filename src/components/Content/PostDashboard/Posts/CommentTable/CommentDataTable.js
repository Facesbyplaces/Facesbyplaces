import React, { useState } from "react";
import { useSelector } from "react-redux";
import axios from "../../../../../auxiliary/axios";
//Data Table
import DataTableRowPostCommentsData from "./DataTableRowData/DataTableRowPostCommentsData";
//Loader
import HashLoader from "react-spinners/HashLoader";

export default function PostDataTable({ search, setSearch, keywords }) {
  const { postTab } = useSelector(({ postTab }) => ({
    postTab: postTab,
  }));
  const [fetched, setFetched] = useState(false);
  const [loader, setLoader] = useState(false);
  const [comments, setComments] = useState([]);
  const [page, setPage] = useState(1);

  const fetchComments = (page) => {
    axios
      .get(`/api/v1/admin/comments`, { params: { page: page, id: postTab.id } })
      .then((response) => {
        setComments(response.data.comments);
        setFetched(true);
      })
      .catch((error) => {
        console.log(error.response);
      });
  };

  const handleSearch = () => {
    axios
      .get(`/api/v1/admin/search/comments`, {
        params: { keywords: keywords, page: page },
      })
      .then((response) => {
        setComments(response.data.comments);
      })
      .catch((error) => {
        console.log(error.response);
      });
    setSearch(false);
  };

  {
    search ? handleSearch() : console.log("Search", search);
  }

  {
    fetched ? console.log(" ") : fetchComments(page);
  }

  const handleNextClick = () => {
    const pages = page + 1;
    setPage(pages);
    fetchComments(pages);
  };

  const renderNextButton = () => {
    if (comments.length != 0) {
      return (
        <a
          className={"btn btn-icon btn-sm border-0 btn-light mr-2 my-1"}
          onClick={() => handleNextClick()}
        >
          <span className="svg-icon svg-icon-md svg-icon-primary">
            <svg
              width="24px"
              height="24px"
              viewBox="0 0 24 24"
              version="1.1"
              xmlns="http://www.w3.org/2000/svg"
              xmlnsXlink="http://www.w3.org/1999/xlink"
            >
              {/* Generator: Sketch 50.2 (55047) - http://www.bohemiancoding.com/sketch */}
              <title>Stockholm-icons / Media / Next</title>
              <desc>Created with Sketch.</desc>
              <defs />
              <g
                id="Stockholm-icons-/-Media-/-Next"
                stroke="none"
                strokeWidth={1}
                fill="none"
                fillRule="evenodd"
              >
                <rect id="bound" x={0} y={0} width={24} height={24} />
                <path
                  d="M6.82866499,18.2771971 L13.5693679,12.3976203 C13.7774696,12.2161036 13.7990211,11.9002555 13.6175044,11.6921539 C13.6029128,11.6754252 13.5872233,11.6596867 13.5705402,11.6450431 L6.82983723,5.72838979 C6.62230202,5.54622572 6.30638833,5.56679309 6.12422426,5.7743283 C6.04415337,5.86555116 6,5.98278612 6,6.10416552 L6,17.9003957 C6,18.1765381 6.22385763,18.4003957 6.5,18.4003957 C6.62084305,18.4003957 6.73759731,18.3566309 6.82866499,18.2771971 Z"
                  id="Path-10-Copy"
                  fill="#000000"
                />
                <rect
                  id="Rectangle-Copy"
                  fill="#000000"
                  opacity="0.3"
                  transform="translate(16.500000, 12.000000) scale(-1, 1) translate(-16.500000, -12.000000) "
                  x={15}
                  y={6}
                  width={3}
                  height={12}
                  rx={1}
                />
              </g>
            </svg>
          </span>
        </a>
      );
    } else {
      return "";
    }
  };

  const handleBackClick = () => {
    const pages = page - 1;
    setPage(pages);
    fetchComments(pages);
  };

  const renderBackButton = () => {
    if (page == 1) {
      return "";
    } else {
      return (
        <a
          className={"btn btn-icon btn-sm border-0 btn-light mr-2 my-1"}
          onClick={() => handleBackClick()}
        >
          <span className="svg-icon svg-icon-md svg-icon-primary">
            <svg
              width="24px"
              height="24px"
              viewBox="0 0 24 24"
              version="1.1"
              xmlns="http://www.w3.org/2000/svg"
              xmlnsXlink="http://www.w3.org/1999/xlink"
            >
              {/* Generator: Sketch 50.2 (55047) - http://www.bohemiancoding.com/sketch */}
              <title>Stockholm-icons / Media / Back</title>
              <desc>Created with Sketch.</desc>
              <defs />
              <g
                id="Stockholm-icons-/-Media-/-Back"
                stroke="none"
                strokeWidth={1}
                fill="none"
                fillRule="evenodd"
              >
                <rect id="bound" x={0} y={0} width={24} height={24} />
                <path
                  d="M11.0879549,18.2771971 L17.8286578,12.3976203 C18.0367595,12.2161036 18.0583109,11.9002555 17.8767943,11.6921539 C17.8622027,11.6754252 17.8465132,11.6596867 17.8298301,11.6450431 L11.0891271,5.72838979 C10.8815919,5.54622572 10.5656782,5.56679309 10.3835141,5.7743283 C10.3034433,5.86555116 10.2592899,5.98278612 10.2592899,6.10416552 L10.2592899,17.9003957 C10.2592899,18.1765381 10.4831475,18.4003957 10.7592899,18.4003957 C10.8801329,18.4003957 10.9968872,18.3566309 11.0879549,18.2771971 Z"
                  id="Path-10-Copy"
                  fill="#000000"
                  transform="translate(14.129645, 12.002277) scale(-1, 1) translate(-14.129645, -12.002277) "
                />
                <rect
                  id="Rectangle-Copy"
                  fill="#000000"
                  opacity="0.3"
                  x={6}
                  y={6}
                  width={3}
                  height={12}
                  rx={1}
                />
              </g>
            </svg>
          </span>
        </a>
      );
    }
  };

  return (
    <div className="table-responsive">
      <table
        className="table table-hover table-head-custom table-vertical-center"
        id="kt_advance_table_widget_2"
      >
        <thead>
          <tr className="text-uppercase">
            {/* <th className="pl-2" style={{ width: "40px" }}>
              <label className="checkbox checkbox-lg checkbox-inline mr-2">
                <input type="checkbox" defaultValue={1} />
                <span />
              </label>
            </th> */}
            <th className="pl-0" style={{ minWidth: "100px" }}>
              post id
            </th>
            <th style={{ minWidth: "150px" }}>user</th>
            <th style={{ minWidth: "150px" }}>body</th>
            <th className="pr-0 text-left" style={{ minWidth: "160px" }}>
              action
            </th>
          </tr>
        </thead>
        {loader ? (
          <tbody>
            <tr>
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td>
                <div
                  className="loader-container"
                  style={{ width: "100%", height: "100vh" }}
                >
                  <HashLoader color={"#04ECFF"} loading={loader} size={70} />
                </div>
              </td>
              <td></td>
              <td></td>
              <td></td>
            </tr>
          </tbody>
        ) : (
          <DataTableRowPostCommentsData search={search} comments={comments} />
        )}
      </table>
      <div className="d-flex justify-content-between align-items-center flex-wrap">
        <div className="d-flex align-items-center">
          {renderBackButton()}
          <a
            className={
              "btn btn-icon btn-sm border-0 btn-light mr-2 my-1 btn-hover-primary active"
            }
          >
            {page}
          </a>
          {renderNextButton()}
        </div>
      </div>
    </div>
  );
}