import React, { useState, useEffect } from "react";
import axios from "../../../../../auxiliary/axios";
//Loader
import HashLoader from "react-spinners/HashLoader";
import DataTableRowReportsData from "./DataTableRowData/DataTableRowReportsData";

export default function PostDataTable({
  search,
  setSearch,
  keywords,
  pageType,
}) {
  const [page, setPage] = useState(1);
  const [clicked, setClicked] = useState(false);
  const [loader, setLoader] = useState(false);
  // Reports
  const [posts, setPosts] = useState([]);
  const [memorialReports, setMemorialReports] = useState([]);
  const [memorialReportUsers, setMemorialReportUsers] = useState([]);
  const [blmReports, setBlmReports] = useState([]);
  const [blmReportUsers, setBlmReportUsers] = useState([]);
  const [reports, setReports] = useState([]);

  const handleSearch = () => {
    axios
      .get(`/api/v1/admin/search/report`, {
        params: { keywords: keywords, page: page },
      })
      .then((response) => {
        console.log(response.data);
        setReports(response.data.reports);
      })
      .catch((error) => {
        console.log(error.response);
      });
    setSearch(false);
  };

  {
    search ? handleSearch() : console.log("Search", search);
  }

  useEffect(() => {
    fetchPosts(page);
  }, [posts.id]);

  const handleClick = (page) => {
    console.log(search);
    setPage(page);
    setClicked(true);
    fetchPosts(page);
  };

  const fetchPosts = (page) => {
    // setLoader(true);
    axios
      .get(`/api/v1/admin/reports`, { params: { page: page } })
      .then((response) => {
        // setLoader(false);
        const memorials = [];
        const memorialUsers = [];
        const blms = [];
        const blmUsers = [];
        const posts = [];

        response.data.reports.map((report) => {
          switch (report.reportable_type) {
            case "Memorial":
              return memorials.push(report);
            case "AlmUser":
              return memorialUsers.push(report);
            case "Blm":
              return blms.push(report);
            case "User":
              return blmUsers.push(report);
            case "Post":
              return posts.push(report);
          }
        });
        setBlmReports(blms);
        setBlmReportUsers(blmUsers);
        setMemorialReports(memorials);
        setMemorialReportUsers(memorialUsers);
        setPosts(posts);
        setReports(response.data.reports);

        console.log("Response: ", response.data.reports);
      })
      .catch((error) => {
        console.log(error.response);
      });
  };

  return (
    <div className="table-responsive">
      <table
        className="table table-hover table-head-custom table-vertical-center"
        id="kt_advance_table_widget_2"
      >
        <thead>
          <tr className="text-uppercase">
            <th className="pl-2" style={{ width: "40px" }}>
              <label className="checkbox checkbox-lg checkbox-inline mr-2">
                <input type="checkbox" defaultValue={1} />
                <span />
              </label>
            </th>
            <th className="pl-0" style={{ minWidth: "100px" }}>
              report id
            </th>
            <th style={{ minWidth: "120px" }}>report subject</th>
            <th style={{ minWidth: "130px" }}>reportable type</th>
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
          <DataTableRowReportsData
            reports={
              {
                0: reports,
                1: memorialReports,
                2: memorialReportUsers,
                3: blmReports,
                4: blmReportUsers,
                5: posts,
              }[pageType]
            }
            search={search}
            pageType={pageType}
          />
        )}
      </table>
      <div className="d-flex justify-content-between align-items-center flex-wrap">
        <div className="d-flex align-items-center">
          {/* <a href="#" className="btn btn-icon btn-sm btn-light mr-2 my-1">
            <b>&#60;</b>
          </a> */}
          <a
            className={
              page === 1
                ? "btn btn-icon btn-sm border-0 btn-light mr-2 my-1 btn-hover-primary active"
                : "btn btn-icon btn-sm border-0 btn-light mr-2 my-1"
            }
            onClick={() => handleClick(1)}
          >
            1
          </a>
          <a
            href="#"
            className={
              clicked && page === 2
                ? "btn btn-icon btn-sm border-0 btn-light mr-2 my-1 btn-hover-primary active"
                : "btn btn-icon btn-sm border-0 btn-light mr-2 my-1"
            }
            onClick={() => handleClick(2)}
          >
            2
          </a>
          <a
            href="#"
            className={
              clicked && page === 3
                ? "btn btn-icon btn-sm border-0 btn-light mr-2 my-1 btn-hover-primary active"
                : "btn btn-icon btn-sm border-0 btn-light mr-2 my-1"
            }
            onClick={() => handleClick(3)}
          >
            3
          </a>
          <a
            href="#"
            className={
              clicked && page === 4
                ? "btn btn-icon btn-sm border-0 btn-light mr-2 my-1 btn-hover-primary active"
                : "btn btn-icon btn-sm border-0 btn-light mr-2 my-1"
            }
            onClick={() => handleClick(4)}
          >
            4
          </a>
          <a
            href="#"
            className={
              clicked && page === 5
                ? "btn btn-icon btn-sm border-0 btn-light mr-2 my-1 btn-hover-primary active"
                : "btn btn-icon btn-sm border-0 btn-light mr-2 my-1"
            }
            onClick={() => handleClick(5)}
          >
            5
          </a>
          <a
            href="#"
            className={
              clicked && page === 6
                ? "btn btn-icon btn-sm border-0 btn-light mr-2 my-1 btn-hover-primary active"
                : "btn btn-icon btn-sm border-0 btn-light mr-2 my-1"
            }
            onClick={() => handleClick(6)}
          >
            6
          </a>
          <a
            href="#"
            className={
              clicked && page === 7
                ? "btn btn-icon btn-sm border-0 btn-light mr-2 my-1 btn-hover-primary active"
                : "btn btn-icon btn-sm border-0 btn-light mr-2 my-1"
            }
            onClick={() => handleClick(7)}
          >
            7
          </a>
          <a
            href="#"
            className={
              clicked && page == 8
                ? "btn btn-icon btn-sm border-0 btn-light mr-2 my-1 btn-hover-primary active"
                : "btn btn-icon btn-sm border-0 btn-light mr-2 my-1"
            }
            onClick={() => handleClick(8)}
          >
            8
          </a>
          <a
            href="#"
            className={
              clicked && page == 9
                ? "btn btn-icon btn-sm border-0 btn-light mr-2 my-1 btn-hover-primary active"
                : "btn btn-icon btn-sm border-0 btn-light mr-2 my-1"
            }
            onClick={() => handleClick(9)}
          >
            9
          </a>
          <a
            href="#"
            className={
              clicked && page == 10
                ? "btn btn-icon btn-sm border-0 btn-light mr-2 my-1 btn-hover-primary active"
                : "btn btn-icon btn-sm border-0 btn-light mr-2 my-1"
            }
            onClick={() => handleClick(10)}
          >
            10
          </a>
          {/* <a href="#" className="btn btn-icon btn-sm btn-light mr-2 my-1">
            <b>&#62;</b>
          </a> */}
        </div>
      </div>
    </div>
  );
}
