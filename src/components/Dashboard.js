import React from "react";
import { LogoutAction } from "../redux/actions";
import { useDispatch } from "react-redux";

//Components
import Navbar from "./Content/Navbar/Navbar";
import SideBar from "./Content/SideBar/SideBar";
import Topbar from "./Content/Navbar/Topbar/Topbar";
import Users from "./Content/UserTable/Header";
import Footer from "./Footer";
import UsersTable from "./Content/UserTable/UsersTable";

const Dashboard = (props) => {
  const dispatch = useDispatch();

  const onLogOutClicked = () => {
    dispatch(LogoutAction({}));
  };

  return (
    <div>
      {/*begin::Head*/}
      <base href />
      <meta charSet="utf-8" />
      <title>Metronic Live preview | Keenthemes</title>
      <meta name="description" content="Updates and statistics" />
      <meta
        name="viewport"
        content="width=device-width, initial-scale=1, shrink-to-fit=no"
      />
      <link rel="canonical" href="https://keenthemes.com/metronic" />
      {/*begin::Fonts*/}
      <link
        rel="stylesheet"
        href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700"
      />
      {/*end::Fonts*/}
      {/*begin::Page Vendors Styles(used by this page)*/}
      <link
        href="assets/plugins/custom/fullcalendar/fullcalendar.bundle.css"
        rel="stylesheet"
        type="text/css"
      />
      {/*end::Page Vendors Styles*/}
      {/*begin::Global Theme Styles(used by all pages)*/}
      <link
        href="assets/plugins/global/plugins.bundle.css"
        rel="stylesheet"
        type="text/css"
      />
      <link
        href="assets/plugins/custom/prismjs/prismjs.bundle.css"
        rel="stylesheet"
        type="text/css"
      />
      <link
        href="assets/css/style.bundle.css"
        rel="stylesheet"
        type="text/css"
      />
      {/*end::Global Theme Styles*/}
      {/*begin::Layout Themes(used by all pages)*/}
      {/*end::Layout Themes*/}
      <link rel="shortcut icon" href="assets/media/logos/favicon.ico" />
      {/*end::Head*/}
      {/*begin::Body*/}
      {/*begin::Main*/}

      <div className="content-height d-flex flex-column flex-root">
        {/*begin::Page*/}
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
            <div
              className="content content-height d-flex flex-column flex-column-fluid"
              id="kt_content"
            >
              <UsersTable />
            </div>
            {/*end::Content*/}
            <Footer />
          </div>
          {/*end::Wrapper*/}
        </div>
        {/*end::Page*/}
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
