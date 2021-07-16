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
    console.log("Reportable Type: ", report.reportable_type);
    console.log("Reportable Id: ", report.reportable_id);
    console.log("Subject: ", reportSubject);
    console.log("Description: ", reportDescription);
    const reportSubjectWhenEmpty = reportSubject
      ? reportSubject
      : report.subject;
    const reportDescriptionWhenEmpty = reportDescription
      ? reportDescription
      : report.description;

    setLoading(true);
    axios
      .put(`/api/v1/admin/reports/edit/${reportTab.id}`, {
        report: {
          id: report.id,
          reportable_type: report.reportable_type,
          reportable_id: report.reportable_id,
          subject: reportSubjectWhenEmpty,
          description: reportDescriptionWhenEmpty,
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

  const handleTableClick = () => {
    dispatch(TableReportAction());
  };

  const handleViewClick = (id, option, type) => {
    console.log(id, option, type);
    dispatch(ViewReportAction({ id, option, type }));
  };

  useEffect(() => {
    axios
      .get(`/api/v1/admin/reports/${reportTab.id}`)
      .then((response) => {
        setReport(response.data.report);
        console.log("Response: ", response.data.report);
      })
      .catch((error) => {
        console.log(error.errors);
      });
  }, report.id);

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
                              Edit {report.reportable_type} Report Information
                            </h3>

                            <span className="text-muted font-weight-bold font-size-sm mt-1">
                              Edit Users, Memorials, and Posts' Report
                              Information
                            </span>
                          </div>
                        </div>
                      </div>
                      <div className="pt-5 pl-15">
                        <a
                          className="btn btn-sm btn-light-primary font-weight-bolder text-uppercase mr-3"
                          onClick={() => handleTableClick()}
                        >
                          back
                        </a>
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
                                        onClick={() =>
                                          handleViewClick(report.id, "v", 2)
                                        }
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
