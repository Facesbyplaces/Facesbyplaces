import React, { useState, useEffect } from "react";

//Loader
import HashLoader from "react-spinners/HashLoader";

//Components
import Navbar from "../../Navbar/Navbar";
import Topbar from "../../Navbar/Topbar/Topbar";
import SideBar from "../../SideBar/SideBar";
import Footer from "../../Footer";
import Assets from "../../Assets";
import TransactionTable from "./Transactions/TransactionTable/TransactionTable";

const Dashboard = () => {
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    setLoading(true);
    setTimeout(() => {
      setLoading(false);
    }, 2000);
  }, []);

  return (
    <div>
      <Assets />
      <div className="content-height d-flex flex-column flex-root">
        {loading ? (
          <div className="loader-container">
            <HashLoader color={"#04ECFF"} loading={loading} size={90} />
          </div>
        ) : (
          <div className="d-flex flex-row flex-column-fluid page">
            <SideBar />
            {/*begin::Wrapper*/}
            <div
              className="d-flex flex-column flex-row-fluid wrapper"
              id="kt_wrapper"
            >
              {/*begin::Header*/}
              <div id="kt_header" className="header">
                {/*begin::Container*/}
                <div className="container-fluid d-flex align-items-stretch justify-content-between">
                  <Navbar />
                  <Topbar />
                </div>
                {/*end::Container*/}
              </div>
              {/*end::Header*/}

              {/*begin::Content*/}
              <TransactionTable />
              {/*end::Content*/}
              <Footer />
            </div>
            {/*end::Wrapper*/}
          </div>
        )}
      </div>
      {/*end::Main*/}

      {/*begin::Global Config(global config for global JS scripts)*/}
      {/*end::Global Config*/}
      {/*begin::Global Theme Bundle(used by all pages)*/}
      {/*end::Global Theme Bundle*/}
      {/*begin::Page Vendors(used by this page)*/}
      {/*end::Page Vendors*/}
      {/*begin::Page Scripts(used by this page)*/}
      {/*end::Page Scripts*/}
      {/*end::Body*/}
    </div>
  );
};

export default Dashboard;
