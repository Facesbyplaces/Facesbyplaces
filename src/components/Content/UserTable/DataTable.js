import React from "react";
import DataTableRowUserData from "./DataTableRowData/DataTableRowUserData";

export default function DataTable() {
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
        <DataTableRowUserData />
      </table>
    </div>
  );
}
