import React, { useState, useEffect } from "react";
import DataTableRowUserData from "./DataTableRowData/DataTableRowUserData";

export default function DataTable() {
  const [page, setPage] = useState(1);
  console.log("Page: ", page);

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
        <DataTableRowUserData page={page} />
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
            onClick={() => setPage(1)}
          >
            1
          </a>
          <a
            href="#"
            className="btn btn-icon btn-sm border-0 btn-light mr-2 my-1"
            onClick={() => setPage(2)}
          >
            2
          </a>
          <a
            href="#"
            className="btn btn-icon btn-sm border-0 btn-light mr-2 my-1"
            onClick={() => setPage(3)}
          >
            3
          </a>
          <a
            href="#"
            className="btn btn-icon btn-sm border-0 btn-light mr-2 my-1"
            onClick={() => setPage(4)}
          >
            4
          </a>
          <a
            href="#"
            className="btn btn-icon btn-sm border-0 btn-light mr-2 my-1"
            onClick={() => setPage(5)}
          >
            5
          </a>
          <a
            href="#"
            className="btn btn-icon btn-sm border-0 btn-light mr-2 my-1"
            onClick={() => setPage(6)}
          >
            6
          </a>
          <a
            href="#"
            className="btn btn-icon btn-sm border-0 btn-light mr-2 my-1"
            onClick={() => setPage(7)}
          >
            7
          </a>
          <a
            href="#"
            className="btn btn-icon btn-sm border-0 btn-light mr-2 my-1"
            onClick={() => setPage(8)}
          >
            8
          </a>
          <a
            href="#"
            className="btn btn-icon btn-sm border-0 btn-light mr-2 my-1"
            onClick={() => setPage(9)}
          >
            9
          </a>
          <a
            href="#"
            className="btn btn-icon btn-sm border-0 btn-light mr-2 my-1"
            onClick={() => setPage(10)}
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
