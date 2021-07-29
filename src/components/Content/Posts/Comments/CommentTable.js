import React, { useState } from "react";
import Header from "./Header";
import DataTable from "./DataTable";

export default function CommentTable() {
  const [search, setSearch] = useState(false);
  const [keywords, setKeywords] = useState([]);

  return (
    <div className="container" style={{ margin: "auto" }}>
      <div className="card card-custom">
        <Header
          search={search}
          setSearch={setSearch}
          keywords={keywords}
          setKeywords={setKeywords}
        />
        <DataTable search={search} setSearch={setSearch} keywords={keywords} />
      </div>
    </div>
  );
}
