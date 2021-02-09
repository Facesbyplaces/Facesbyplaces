import React, { useState, useEffect } from "react";
import axios from "../../../auxiliary/axios";

import DataTableRowUserData from "./DataTableRowData/DataTableRowUserData";
import ReactPaginate from "react-paginate";

export default function DataTable() {
  const [page, setPage] = useState(1);
  const [users, setUsers] = useState([]);
  console.log("User count: ", users.length);

  useEffect(() => {
    fetchUsers(page);
  }, [users.id]);

  // const handleClick = (page) => {
  //   setPage(page);
  //   setClicked(true);
  //   fetchUsers(page);
  // };

  const fetchUsers = (page) => {
    axios
      .get(`/api/v1/admin/users`, { params: { page: page } })
      .then((response) => {
        setUsers(response.data.users);
        console.log("Response: ", response.data.users);
      })
      .catch((error) => {
        console.log(error.response);
      });
  };
  const pageCount = Math.ceil(users.length / 20);
  const changePage = ({ selected }) => {
    setPage(selected);
  };

  return (
    <div className="table-responsive">
      <table
        className="table table-head-custom table-vertical-center"
        id="kt_advance_table_widget_2"
      >
        <thead>
          <tr className="text-uppercase">
            <th className="pl-0" style={{ width: "40px" }}>
              <label className="checkbox checkbox-lg checkbox-inline mr-2">
                <input type="checkbox" defaultValue={1} />
                <span />
              </label>
            </th>
            <th className="pl-0" style={{ minWidth: "100px" }}>
              user id
            </th>
            <th style={{ minWidth: "120px" }}>email</th>
            <th style={{ minWidth: "150px" }}>name</th>
            <th style={{ minWidth: "150px" }}>phone number</th>
            <th style={{ minWidth: "130px" }}>type</th>
            <th className="pr-0 text-right" style={{ minWidth: "160px" }}>
              action
            </th>
          </tr>
        </thead>
        <DataTableRowUserData users={users} />
      </table>
      <div className="d-flex justify-content-between align-items-center flex-wrap">
        <ReactPaginate
          previousLabel={"<<"}
          nextLabel={">>"}
          pageCount={pageCount}
          onPageChange={changePage}
          containerClassName={"d-flex mt-0"}
          previousLinkClassName={"btn btn-icon btn-sm btn-light mr-2 my-1"}
          nextLinkClassName={"btn btn-icon btn-sm btn-light mr-2 my-1"}
          activeClassName={
            "btn btn-icon btn-sm border-0 btn-light mr-2 my-1 btn-hover-primary active"
          }
        />
      </div>
    </div>
  );
}
