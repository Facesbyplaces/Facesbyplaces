import React, { useState, useEffect } from "react";
//Loader
import HashLoader from "react-spinners/HashLoader";

//Components
import Navbar from "../../Navbar/Navbar";
import Topbar from "../../Navbar/Topbar/Topbar";
import SideBar from "../../SideBar/SideBar";
import Assets from "../../Assets";
import Footer from "../../Footer";
import UsersTable from "../Users/UserTable/UsersTable";
import MemorialsTable from "../Memorials/MemorialTable/MemorialsTable";
import PostTable from "../Posts/PostTable/PostTable";
import ReportTable from "../Reports/ReportTable/ReportTable";
import TransactionTable from "../Transactions/TransactionTable/TransactionTable";

const Dashboard = (props) => {
  const [loading, setLoading] = useState(false);
  const [item, setItem] = useState(props.match.path.substring(1));

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
            <div
              className="d-flex flex-column flex-row-fluid wrapper"
              id="kt_wrapper"
            >
              <div id="kt_header" className="header">
                <div className="container-fluid d-flex align-items-stretch justify-content-between">
                  <Navbar item={item} />
                  <Topbar />
                </div>
              </div>
              {
                {
                  users: <UsersTable />,
                  memorials: <MemorialsTable />,
                  posts: <PostTable />,
                  reports: <ReportTable />,
                  transactions: <TransactionTable />,
                }[item]
              }
              <Footer />
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default Dashboard;
