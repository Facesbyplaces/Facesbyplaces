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
              <div className="col-md-4 my-2 my-md-0">
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
              <div className="col-md-4 my-2 my-md-0">
                <div className="d-flex align-items-center">
                  <label className="mr-3 mb-0 d-none d-md-block">Status:</label>
                  <select
                    className="form-control"
                    id="kt_datatable_search_status"
                  >
                    <option value>All</option>
                    <option value={1}>Pending</option>
                    <option value={2}>Delivered</option>
                    <option value={3}>Canceled</option>
                    <option value={4}>Success</option>
                    <option value={5}>Info</option>
                    <option value={6}>Danger</option>
                  </select>
                </div>
              </div>
              <div className="col-md-4 my-2 my-md-0">
                <div className="d-flex align-items-center">
                  <label className="mr-3 mb-0 d-none d-md-block">Type:</label>
                  <select
                    className="form-control"
                    id="kt_datatable_search_type"
                  >
                    <option value>All</option>
                    <option value={1}>Online</option>
                    <option value={2}>Retail</option>
                    <option value={3}>Direct</option>
                  </select>
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
