import React, { useState, useEffect } from "react";
import axios from "../../../auxiliary/axios";

import DataTableRowUserData from "./DataTableRowData/DataTableRowUserData";

export default function DataTable() {
  const [page, setPage] = useState(1);
  const [users, setUsers] = useState([]);

  useEffect(() => {
    axios
      .get(`/api/v1/admin/users`, { params: { page: page } })
      .then((response) => {
        setUsers(response.data.users);
        console.log("Response: ", response.data.users);
      })
      .catch((error) => {
        console.log(error.response);
      });
  }, [users.id]);

  const handleClick = (page) => {
    setPage(page);

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
        <div className="d-flex align-items-center">
          <a href="#" className="btn btn-icon btn-sm btn-light mr-2 my-1">
            <i className="ki ki-bold-double-arrow-back icon-xs" />
          </a>
          <a href="#" className="btn btn-icon btn-sm btn-light mr-2 my-1">
            <i className="ki ki-bold-arrow-back icon-xs" />
          </a>
          <a
            className="btn btn-icon btn-sm border-0 btn-light mr-2 my-1 btn-hover-primary active"
            onClick={() => handleClick(1)}
          >
            1
          </a>
          <a
            href="#"
            className="btn btn-icon btn-sm border-0 btn-light mr-2 my-1"
            onClick={() => handleClick(2)}
          >
            2
          </a>
          <a
            href="#"
            className="btn btn-icon btn-sm border-0 btn-light mr-2 my-1"
            onClick={() => handleClick(3)}
          >
            3
          </a>
          <a
            href="#"
            className="btn btn-icon btn-sm border-0 btn-light mr-2 my-1"
            onClick={() => handleClick(4)}
          >
            4
          </a>
          <a
            href="#"
            className="btn btn-icon btn-sm border-0 btn-light mr-2 my-1"
            onClick={() => handleClick(5)}
          >
            5
          </a>
          <a
            href="#"
            className="btn btn-icon btn-sm border-0 btn-light mr-2 my-1"
            onClick={() => handleClick(6)}
          >
            6
          </a>
          <a
            href="#"
            className="btn btn-icon btn-sm border-0 btn-light mr-2 my-1"
            onClick={() => handleClick(7)}
          >
            7
          </a>
          <a
            href="#"
            className="btn btn-icon btn-sm border-0 btn-light mr-2 my-1"
            onClick={() => handleClick(8)}
          >
            8
          </a>
          <a
            href="#"
            className="btn btn-icon btn-sm border-0 btn-light mr-2 my-1"
            onClick={() => handleClick(9)}
          >
            9
          </a>
          <a
            href="#"
            className="btn btn-icon btn-sm border-0 btn-light mr-2 my-1"
            onClick={() => handleClick(10)}
          >
            10
          </a>
          <a href="#" className="btn btn-icon btn-sm btn-light mr-2 my-1">
            <i className="ki ki-bold-arrow-next icon-xs" />
          </a>
          <a href="#" className="btn btn-icon btn-sm btn-light mr-2 my-1">
            <i className="ki ki-bold-double-arrow-next icon-xs" />
          </a>
        </div>
      </div>
    </div>
  );
}
