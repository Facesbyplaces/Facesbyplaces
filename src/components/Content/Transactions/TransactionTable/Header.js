import React from "react";

export default function Header({ setSearch, keywords, setKeywords }) {
  const handleClick = () => {
    setSearch(true);
  };

  const handleChange = (e) => {
    setKeywords(e.target.value);
    // setSearch(true);
  };

  return (
    <>
      <div className="card-header flex-wrap border-0 pt-6 pb-0">
        <div className="card-title">
          <h3 className="card-label">
            Transactions Datatable
            <span className="d-block text-muted pt-2 font-size-sm">
              List of memorial's gift transactions.
            </span>
          </h3>
        </div>
      </div>
      {/* <div className="card-body ">
        
        <div>
          <div className="row align-items-center">
            <div className="col-lg-5 col-xl-8">
              <div className="row align-items-center">
                <div className="col-md-12 my-2 my-md-0">
                  <div className="input-icon">
                    <input
                      type="text"
                      className="form-control"
                      placeholder="Search..."
                      onChange={handleChange}
                      value={keywords}
                    />
                    <span>
                      <i className="flaticon2-search-1 text-muted" />
                    </span>
                  </div>
                </div>
              </div>
            </div>
            <div className="col-sm-1 mt-5 mt-lg-0">
              <a
                className="btn btn-light-primary px-6 font-weight-bold"
                onClick={() => handleClick()}
              >
                Search
              </a>
            </div>
          </div>
        </div>
        
      </div> */}
    </>
  );
}
