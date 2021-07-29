import React, { useEffect, useState } from "react";
import axios from "../../../../auxiliary/axios";

import { useDispatch, useSelector } from "react-redux";
import { TableReportAction, EditReportAction } from "../../../../redux/actions";

export default function ViewReport() {
  var dateFormat = require("dateformat");
  const dispatch = useDispatch();
  const { reportTab } = useSelector(({ reportTab }) => ({
    reportTab: reportTab,
  }));
  const [report, setReport] = useState([]);
  const [reported, setReported] = useState("");

  const handleEditClick = (id, option, type) => {
    console.log(id, option, type);
    dispatch(EditReportAction({ id, option, type }));
  };
  const handleTableClick = () => {
    dispatch(TableReportAction());
  };

  useEffect(() => {
    axios
      .get(`/api/v1/admin/reports/${reportTab.id}`)
      .then((response) => {
        setReport(response.data.report);
        setReported(response.data.reported);
        console.log("Response: ", response.data);
      })
      .catch((error) => {
        console.log(error.errors);
      });
  }, report.id);

  return (
    <div className="container" style={{ margin: "auto" }}>
      <div className="card card-custom">
        <div className="card-body">
          <form className="form">
            <div className="tab-content">
              {/*begin::Tab*/}
              <div className="tab-pane show active px-7 mt-5">
                <div className="card-header py-3 pl-5">
                  <div className="card-title align-items-start flex-column mb-2">
                    <h3 className="card-label font-weight-bolder text-dark">
                      {report.reportable_type} Report Information
                    </h3>

                    <span className="text-muted font-weight-bold font-size-sm mt-1">
                      Users, Memorials, and Posts' Report Information
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
              <div className="tab-pane show active px-7" role="tabpanel">
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
                    <div className="form-group row">
                      <label className="col-form-label col-3 text-lg-right text-left">
                        Reported
                      </label>
                      <div className="col-9">
                        <input
                          className="form-control form-control-lg border-0 placeholder-dark-75"
                          type="username"
                          name="username"
                          defaultValue={reported}
                          disabled
                        />
                      </div>
                    </div>
                    {/*end::Group*/}
                    {/*begin::Group*/}
                    <div className="form-group row">
                      <label className="col-form-label col-3 text-lg-right text-left">
                        Subject
                      </label>
                      <div className="col-9">
                        <input
                          className="form-control form-control-lg border-0 placeholder-dark-75"
                          type="username"
                          name="username"
                          defaultValue={report.subject}
                          disabled
                        />
                      </div>
                    </div>
                    {/*end::Group*/}
                    {/*begin::Group*/}
                    <div className="form-group row">
                      <label className="col-form-label col-3 text-lg-right text-left">
                        Report Type
                      </label>
                      <div className="col-9">
                        <input
                          className="form-control form-control-lg form-control-solid placeholder-dark-75"
                          type="relationship"
                          name="relationship"
                          defaultValue={report.reportable_type}
                          disabled
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
                          disabled
                        />
                      </div>
                    </div>
                    {/*end::Group*/}
                    <div className="separator separator-solid my-10" />

                    {/*begin::Row*/}
                    <div className="row">
                      <div className="col-9">
                        <h6 className="text-dark font-weight-bold mb-10">
                          Other {report.reportable_type} Report Infos:
                        </h6>
                      </div>
                    </div>
                    {/*end::Row*/}
                    {/*begin::Group*/}
                    <div className="form-group row">
                      <label className="col-form-label col-3 text-lg-right text-left">
                        Created At
                      </label>
                      <div className="col-9">
                        <input
                          className="form-control form-control-lg border-0 placeholder-dark-75"
                          type="text"
                          name="latitude"
                          defaultValue={dateFormat(
                            report.created_at,
                            "mmmm d, yyyy"
                          )}
                          disabled
                        />
                      </div>
                    </div>
                    {/*end::Group*/}
                    {/*begin::Group*/}
                    <div className="form-group row">
                      <label className="col-form-label col-3 text-lg-right text-left">
                        Updated At
                      </label>
                      <div className="col-9">
                        <input
                          className="form-control form-control-lg border-0 placeholder-dark-75"
                          type="text"
                          name="longitude"
                          defaultValue={dateFormat(
                            report.updated_at,
                            "mmmm d, yyyy"
                          )}
                          disabled
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
                              <a
                                className="btn btn-success btn-md btn-block font-weight-bold mr-2"
                                onClick={() =>
                                  handleEditClick(report.id, "e", 2)
                                }
                              >
                                Edit
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
  );
}
