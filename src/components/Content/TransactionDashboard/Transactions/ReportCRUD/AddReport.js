import React, { useEffect, useState } from "react";
import axios from "../../../../../auxiliary/axios";
import HashLoader from "react-spinners/HashLoader";
import { SuccessModal } from "./SuccessModal";

import { useDispatch, useSelector } from "react-redux";
import {
  TableReportAction,
  ViewReportAction,
} from "../../../../../redux/actions";

export default function EditReport() {
  var dateFormat = require("dateformat");
  const dispatch = useDispatch();
  const [report, setReport] = useState([]);
  const [showModal, setShowModal] = useState(false);
  const [loading, setLoading] = useState(false);
  const { reportTab } = useSelector(({ reportTab }) => ({
    reportTab: reportTab,
  }));
  // Form data
  const [reportSubject, setReportSubject] = useState("");
  const [reportDescription, setReportDescription] = useState("");
  const [reportType, setReportType] = useState("");
  const [reportId, setReportId] = useState("");
  // Fetch data
  const [alms, setAlms] = useState([]);
  const [almUsers, setAlmUsers] = useState([]);
  const [blms, setBlms] = useState([]);
  const [blmUsers, setBlmUsers] = useState([]);
  const [posts, setPosts] = useState([]);

  // Change Table View
  const handleTableClick = () => {
    dispatch(TableReportAction());
  };

  const handleViewClick = (id, option, type) => {
    console.log(id, option, type);
    dispatch(ViewReportAction({ id, option, type }));
  };

  const fetchData = (reportable_type) => {
    axios
      .get(`/api/v1/admin/reports/fetchData/${reportable_type}`)
      .then((response) => {
        console.log("Response: ", response.data);
        response.data.memorials != null
          ? setAlms(response.data.memorials)
          : response.data.alm_users != null
          ? setAlmUsers(response.data.alm_users)
          : response.data.blms != null
          ? setBlms(response.data.blms)
          : response.data.blm_users != null
          ? setBlmUsers(response.data.blm_users)
          : response.data.posts != null
          ? setPosts(response.data.posts)
          : console.log("Wow, such empty!");
      })
      .catch((error) => {
        console.log(error.errors);
      });
  };

  const handleReportTypeChange = (e) => {
    setReportType(e.target.value);
    fetchData(e.target.value);
  };

  const handleReportableIdChange = (e) => {
    setReportId(e.target.value);
  };

  const handleSubjectChange = (e) => {
    setReportSubject(e.target.value);
  };
  const handleDescriptionChange = (e) => {
    setReportDescription(e.target.value);
  };

  // Modal
  const openModal = () => {
    setShowModal((prev) => !prev);
  };

  const handleSubmit = (e) => {
    console.log("Reportable Type: ", reportType);
    console.log("Reportable Id: ", reportId);
    console.log("Subject: ", reportSubject);
    console.log("Description: ", reportDescription);

    setLoading(true);
    axios
      .post(`/api/v1/admin/reports/create`, {
        report: {
          reportable_type: reportType,
          reportable_id: reportId,
          subject: reportSubject,
          description: reportDescription,
        },
      })
      .then((response) => {
        console.log("Response: ", response.data);
        setTimeout(() => {
          setLoading(false);
        }, 1000);
        openModal();
      })
      .catch((error) => {
        console.log(error.errors);
      });

    e.preventDefault();
  };

  // Render fetched alm memorials
  const renderFetchedMemorial = alms.map((alm) => (
    <option value={alm.id}>{alm.name}</option>
  ));
  // Render fetched alm users
  const renderFetchedMemorialUsers = almUsers.map((user) => (
    <option value={user.id}>
      {user.first_name} {user.last_name}
    </option>
  ));
  // Render fetched blm memorials
  const renderFetchedBlmMemorials = blms.map((blm) => (
    <option value={blm.id}>{blm.name}</option>
  ));
  // Render fetched blm users
  const renderFetchedBlmMemorialUsers = blmUsers.map((user) => (
    <option value={user.id}>
      {user.first_name} {user.last_name}
    </option>
  ));
  // Render fetched posts
  const renderFetchedPosts = posts.map((post) => (
    <option value={post.id}>{post.body}</option>
  ));

  const renderFetchedDatas = () => {
    switch (reportType) {
      case "Memorial":
        return renderFetchedMemorial;
      case "AlmUser":
        return renderFetchedMemorialUsers;
      case "Blm":
        return renderFetchedBlmMemorials;
      case "User":
        return renderFetchedBlmMemorialUsers;
      case "Post":
        return renderFetchedPosts;
    }
  };

  return (
    <div className="d-flex flex-column flex-column-fluid mt-25">
      <SuccessModal showModal={showModal} setShowModal={setShowModal} />
      <>
        {loading ? (
          <div className="loader-container">
            <HashLoader color={"#04ECFF"} loading={loading} size={90} />
          </div>
        ) : (
          <>
            {/*begin::Section*/}
            <div className="container mt-n15 gutter-b">
              <div className="card card-custom">
                <div className="card-body">
                  <form className="form" onSubmit={handleSubmit}>
                    <div className="tab-content">
                      {/*begin::Tab*/}
                      <div className="tab-pane show active px-7 mt-5">
                        <div className="card-header py-3 pl-5">
                          <div className="card-title align-items-start flex-column mb-2">
                            <h3 className="card-label font-weight-bolder text-dark">
                              Add Report Information
                            </h3>

                            <span className="text-muted font-weight-bold font-size-sm mt-1">
                              Add Users, Memorials, and Posts' Report
                              Information
                            </span>
                          </div>
                        </div>
                      </div>
                      <div
                        className="tab-pane show active px-7"
                        role="tabpanel"
                      >
                        {/*begin::Row*/}
                        <div className="row mb-10">
                          <div className="col-xl-2" />
                          <div className="col-xl-7 my-2">
                            {/*begin::Row*/}
                            <div className="row">
                              <div className="col-9">
                                <h6 className="text-dark font-weight-bold mb-10">
                                  Report Info:
                                </h6>
                              </div>
                            </div>
                            {/*end::Row*/}
                            {/*begin::Group*/}
                            {/* Show Errors if existing */}
                            {/* <div className="form-group row">
                                  <label className="col-form-label col-3 text-lg-right text-left"></label>
                                  <div className="col-9">
                                    {errors ? (
                                      <p
                                        className="opacity-80 font-weight-bold"
                                        style={{ color: "red" }}
                                      >
                                        {errors}
                                      </p>
                                    ) : (
                                      ""
                                    )}
                                  </div>
                                </div> */}
                            {/*begin::Group*/}
                            <div className="form-group row">
                              <label className="col-form-label col-3 text-lg-right text-left">
                                Report Type
                              </label>
                              <div className="col-9">
                                <div className="input-group input-group-lg input-group-solid">
                                  <select
                                    id="users"
                                    className="form-control form-control-lg form-control-solid"
                                    name="users"
                                    onChange={handleReportTypeChange}
                                  >
                                    <option selected>Select Report Type</option>
                                    <option value="Memorial">ALM</option>
                                    <option value="AlmUser">ALM USER</option>
                                    <option value="Blm">BLM</option>
                                    <option value="User">BLM User</option>
                                    <option value="Post">POST</option>
                                  </select>
                                </div>
                              </div>
                            </div>
                            {/*end::Group*/}
                            {/*begin::Group*/}
                            <div className="form-group row">
                              <label className="col-form-label col-3 text-lg-right text-left">
                                Report A Content
                              </label>
                              <div className="col-9">
                                <div className="input-group input-group-lg input-group-solid">
                                  <select
                                    id="users"
                                    className="form-control form-control-lg form-control-solid"
                                    name="users"
                                    onChange={handleReportableIdChange}
                                  >
                                    <option selected>
                                      Select a content to report
                                    </option>
                                    {renderFetchedDatas()}
                                  </select>
                                </div>
                              </div>
                            </div>
                            {/*end::Group*/}
                            <div className="form-group row">
                              <label className="col-form-label col-3 text-lg-right text-left">
                                Subject
                              </label>
                              <div className="col-9">
                                <input
                                  className="form-control form-control-lg form-control-solid placeholder-dark-75"
                                  type="username"
                                  name="username"
                                  defaultValue={report.subject}
                                  onChange={handleSubjectChange}
                                />
                              </div>
                            </div>
                            {/*end::Group*/}

                            {/*begin::Group*/}
                            <div className="form-group row">
                              <label className="col-form-label col-3 text-lg-right text-left">
                                Body
                              </label>
                              <div className="col-9">
                                <textarea
                                  className="form-control form-control-solid form-control-lg"
                                  id="exampleTextarea"
                                  rows={6}
                                  defaultValue={report.description}
                                  onChange={handleDescriptionChange}
                                />
                              </div>
                            </div>
                            {/*end::Group*/}

                            {/*begin::Footer*/}
                            <div className="card-footer pb-0">
                              <div className="row">
                                <div className="col-xl-2 pt-5" />
                                <div className="col-xl-7">
                                  <div className="row">
                                    <div className="col-3" />
                                    <div className="col-9">
                                      <button
                                        type="submit"
                                        className="btn btn-success font-weight-bold mr-2"
                                      >
                                        Save changes
                                      </button>
                                      <a
                                        className="btn btn-secondary font-weight-bold"
                                        onClick={() => handleTableClick()}
                                      >
                                        Cancel
                                      </a>
                                    </div>
                                  </div>
                                </div>
                              </div>
                            </div>
                            {/*end::Footer*/}
                          </div>
                        </div>
                        {/*end::Row*/}
                      </div>
                      {/*end::Tab*/}
                    </div>
                  </form>
                </div>
              </div>
            </div>
            {/*end::Section*/}
          </>
        )}
        {/*end::Entry*/}
      </>
    </div>
  );
}
