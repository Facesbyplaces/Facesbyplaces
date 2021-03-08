import React, { useState, useEffect } from "react";
import axios from "../../../../../auxiliary/axios";
//Data Table
import DataTableRowMemorialData from "./DataTableRowData/DataTableRowMemorialData";
import DataTableRowBlmData from "./DataTableRowData/DataTableRowBlmData";
//Loader
import HashLoader from "react-spinners/HashLoader";

export default function PostDataTable({
  search,
  setSearch,
  keywords,
  pageType,
}) {
  const [page, setPage] = useState(1);
  const [clicked, setClicked] = useState(false);
  const [loader, setLoader] = useState(false);
  const [posts, setPosts] = useState([]);
  const [memorialPosts, setMemorialPosts] = useState([]);
  const [blmPosts, setBlmPosts] = useState([]);

  // const handleSearch = () => {
  //   axios
  //     .get(`/api/v1/admin/search/memorial`, {
  //       params: { keywords: keywords, page: page },
  //     })
  //     .then((response) => {
  //       response.data.page_type == 2
  //         ? setMemorials(response.data.memorials)
  //         : setBlms(response.data.memorials);
  //     })
  //     .catch((error) => {
  //       console.log(error.response);
  //     });
  //   setSearch(false);
  // };

  // {
  //   search ? handleSearch() : console.log("Search", search);
  // }

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
    setLoader(true);
    axios
      .get(`/api/v1/admin/posts`, { params: { page: page } })
      .then((response) => {
        setLoader(false);
        const memorials = [];
        const blms = [];
        response.data.posts.map((post) =>
          post.page.page_type == "Memorial"
            ? memorials.push(post)
            : blms.push(post)
        );
        setBlmPosts(blms);
        setMemorialPosts(memorials);
        // setPosts(response.data.posts);

        console.log("Response: ", response.data.posts);
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
              post id
            </th>
            <th style={{ minWidth: "120px" }}>page name</th>
            <th style={{ minWidth: "120px" }}>location</th>
            <th style={{ minWidth: "150px" }}>relationship</th>
            <th style={{ minWidth: "150px" }}>privacy</th>
            <th style={{ minWidth: "130px" }}>page type</th>
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
        ) : pageType == 2 ? (
          <DataTableRowMemorialData
            posts={memorialPosts}
            search={search}
            pageType={pageType}
          />
        ) : (
          <DataTableRowBlmData
            posts={blmPosts}
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