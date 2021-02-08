import React from "react";
import DataTable from "./DataTable";

export default function Body() {
  return (
    <div className="card-body">
      {/*begin: Search Form*/}
      {/*begin::Search Form*/}
      <div className="mb-7">
        <div className="row align-items-center">
          <div className="col-lg-9 col-xl-8">
            <div className="row align-items-center">
              <div className="col-md-12 my-2 my-md-0">
                <div className="input-icon">
                  <input
                    type="text"
                    className="form-control"
                    placeholder="Search..."
                    id="kt_datatable_search_query"
                  />
                  <span>
                    <i className="flaticon2-search-1 text-muted" />
                  </span>
                </div>
              </div>
            </div>
          </div>
          <div className="col-lg-3 col-xl-4 mt-5 mt-lg-0">
            <a href="#" className="btn btn-light-primary px-6 font-weight-bold">
              Search
            </a>
          </div>
        </div>
      </div>
      {/*end::Search Form*/}

      {/*begin: Datatable*/}
      <div className="">
        <DataTable />
      </div>
      {/*end: Datatable*/}
    </div>
  );
}
