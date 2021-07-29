import React from "react";

import Header from "./Header";
import DataTable from "./DataTable";

export default function TransactionTable() {
  // const [search, setSearch] = useState(false);
  // const [keywords, setKeywords] = useState([]);

  return (
    <div
      className="content content-height d-flex flex-column flex-column-fluid pb-0 pt-0"
      id="kt_content"
      style={{ height: "100%" }}
    >
      <div className="container" style={{ margin: "auto" }}>
        <div className="card card-custom">
          <Header
          // setSearch={setSearch}
          // keywords={keywords}
          // setKeywords={setKeywords}
          />
          <DataTable
          // search={search}
          // setSearch={setSearch}
          // keywords={keywords}
          />
        </div>
      </div>
    </div>
  );
}
