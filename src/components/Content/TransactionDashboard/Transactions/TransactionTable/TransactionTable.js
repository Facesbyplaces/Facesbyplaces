import React, { useState } from "react";

import Header from "./Header";
import Body from "./Body";

export default function TransactionTable() {
  const [pageType, setPageType] = useState(0);

  return (
    <div
      className="content content-height d-flex flex-column flex-column-fluid"
      id="kt_content"
    >
      <div className="container">
        <div className="card card-custom">
          <Header pageType={pageType} setPageType={setPageType} />
          <Body pageType={pageType} setPageType={setPageType} />
        </div>
      </div>
    </div>
  );
}
