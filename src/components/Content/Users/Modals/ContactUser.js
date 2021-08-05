import React, { useState } from "react";
import { useSelector, useDispatch } from "react-redux";
import { TableUserAction, ViewUserAction } from "../../../../redux/actions";
import HashLoader from "react-spinners/HashLoader";
import axios from "../../../../auxiliary/axios";

export const ContactUser = ({ user, showModal, setShowModal }) => {
  const dispatch = useDispatch();
  const { tab } = useSelector(({ tab }) => ({
    tab: tab,
  }));

  const [subject, setSubject] = useState("");
  const [message, setMessage] = useState("");
  const [loading, setLoading] = useState(false);
  const [successMessage, setSuccessMessage] = useState(false);

  //   const handleActionClick = (id, account_type, option) => {
  //     switch (tab.option) {
  //       case "a":
  //         setShowModal((prev) => !prev);
  //         dispatch(TableUserAction());
  //       case "d":
  //         setShowModal((prev) => !prev);
  //         dispatch(TableUserAction());
  //       case "e":
  //         setShowModal((prev) => !prev);
  //         dispatch(ViewUserAction({ id, account_type, option }));
  //         window.location.reload(false);
  //       default:
  //         return "foo";
  //     }
  //   };

  const handleSubjectChange = (e) => {
    setSubject(e.target.value);
    console.log("Subject: ", e.target.value);
  };

  const handleMessageChange = (e) => {
    setMessage(e.target.value);
    console.log("Message: ", e.target.value);
  };

  const handleOkayButton = () => {
    setSuccessMessage(false);
    setShowModal((prev) => !prev);
  };

  const handleSubmit = (e) => {
    setLoading(true);
    console.log("User ID: ", user.id);
    console.log("User Account Type: ", user.account_type);
    console.log("Subject: ", subject);
    console.log("Message: ", message);

    axios
      .post("/api/v1/admin/users/contact", {
        message: message,
        user_id: user.id,
        subject: subject,
        account_type: user.account_type,
      })
      .then((response) => {
        setLoading(false);
        setSuccessMessage(true);
        console.log(response.data);
      })
      .catch((error) => {
        console.log(error.response.data.errors);
      });

    e.preventDefault();
  };

  return (
    <>
      {showModal ? (
        <div className="modal" showModal={showModal}>
          <div className="modal-dialog modal-dialog-centered" role="document">
            {loading ? (
              <div className="modal-content">
                <div
                  className="loader-container"
                  style={{ height: "500px", width: "500px" }}
                >
                  <HashLoader color={"#04ECFF"} loading={loading} size={90} />
                </div>
              </div>
            ) : (
              <>
                {successMessage ? (
                  <div className="modal-content">
                    <div className="pt-10">
                      <span className="svg-icon svg-icon-10x svg-icon-success">
                        <svg
                          width="24px"
                          height="24px"
                          viewBox="0 0 24 24"
                          version="1.1"
                          xmlns="http://www.w3.org/2000/svg"
                          xmlnsXlink="http://www.w3.org/1999/xlink"
                        >
                          {/* Generator: Sketch 50.2 (55047) - http://www.bohemiancoding.com/sketch */}
                          <title>Stockholm-icons / Code / Done-circle</title>
                          <desc>Created with Sketch.</desc>
                          <defs />
                          <g
                            id="Stockholm-icons-/-Code-/-Done-circle"
                            stroke="none"
                            strokeWidth={1}
                            fill="none"
                            fillRule="evenodd"
                          >
                            <rect
                              id="bound"
                              x={0}
                              y={0}
                              width={24}
                              height={24}
                            />
                            <circle
                              id="Oval-5"
                              fill="#000000"
                              opacity="0.3"
                              cx={12}
                              cy={12}
                              r={10}
                            />
                            <path
                              d="M16.7689447,7.81768175 C17.1457787,7.41393107 17.7785676,7.39211077 18.1823183,7.76894473 C18.5860689,8.1457787 18.6078892,8.77856757 18.2310553,9.18231825 L11.2310553,16.6823183 C10.8654446,17.0740439 10.2560456,17.107974 9.84920863,16.7592566 L6.34920863,13.7592566 C5.92988278,13.3998345 5.88132125,12.7685345 6.2407434,12.3492086 C6.60016555,11.9298828 7.23146553,11.8813212 7.65079137,12.2407434 L10.4229928,14.616916 L16.7689447,7.81768175 Z"
                              id="Path-92"
                              fill="#000000"
                              fillRule="nonzero"
                            />
                          </g>
                        </svg>
                      </span>
                    </div>
                    <div className="modal-body">
                      <h2 className="modal-dialog">
                        <b>Success!</b>
                      </h2>
                      <h5 className="modal-dialog">
                        Email successfully sent to the user.
                      </h5>
                    </div>
                    <div className="modal-footer">
                      <button
                        type="button"
                        className="btn btn-md btn-primary font-weight-bold"
                        style={{ width: "200px" }}
                        data-dismiss="modal"
                        onClick={handleOkayButton}
                      >
                        Okay
                      </button>
                    </div>
                  </div>
                ) : (
                  <div className="modal-content">
                    <form className="form" onSubmit={handleSubmit}>
                      <div className="pt-5 pr-5">
                        <a
                          className="btn btn-icon btn-danger btn-circle btn-xs"
                          style={{ float: "right" }}
                          onClick={() => setShowModal((prev) => !prev)}
                        >
                          <span className="svg-icon svg-icon-md svg-icon-light-secondary ml-3 mr-3">
                            <svg
                              width="24px"
                              height="24px"
                              viewBox="0 0 24 24"
                              version="1.1"
                              xmlns="http://www.w3.org/2000/svg"
                              xmlnsXlink="http://www.w3.org/1999/xlink"
                            >
                              {/* Generator: Sketch 50.2 (55047) - http://www.bohemiancoding.com/sketch */}
                              <title>
                                Stockholm-icons / Navigation / Close
                              </title>
                              <desc>Created with Sketch.</desc>
                              <defs />
                              <g
                                id="Stockholm-icons-/-Navigation-/-Close"
                                stroke="none"
                                strokeWidth={1}
                                fill="none"
                                fillRule="evenodd"
                              >
                                <g
                                  id="Group"
                                  transform="translate(12.000000, 12.000000) rotate(-45.000000) translate(-12.000000, -12.000000) translate(4.000000, 4.000000)"
                                  fill="#000000"
                                >
                                  <rect
                                    id="Rectangle-185"
                                    x={0}
                                    y={7}
                                    width={16}
                                    height={2}
                                    rx={1}
                                  />
                                  <rect
                                    id="Rectangle-185-Copy"
                                    opacity="0.3"
                                    transform="translate(8.000000, 8.000000) rotate(-270.000000) translate(-8.000000, -8.000000) "
                                    x={0}
                                    y={7}
                                    width={16}
                                    height={2}
                                    rx={1}
                                  />
                                </g>
                              </g>
                            </svg>
                          </span>
                        </a>
                      </div>
                      <div className="modal-body">
                        <div className="tab-content">
                          {/*begin::Tab*/}
                          <div
                            className="tab-pane show active px-7"
                            role="tabpanel"
                          >
                            {/*begin::Row*/}
                            <div className="row mt-10">
                              <div className="col-xxl my-2">
                                {/*begin::Row*/}
                                <div className="row">
                                  <div className="col-12">
                                    <h6
                                      className="text-dark font-weight-bold mb-10"
                                      style={{ textAlign: "left" }}
                                    >
                                      Contact User
                                    </h6>
                                  </div>
                                </div>
                                {/*end::Row*/}
                                {/*begin::Group*/}
                                <div className="form-group row">
                                  <div className="col-xxl">
                                    <div className="input-group input-group-lg input-group-solid">
                                      <div className="input-group-prepend">
                                        <span className="svg-icon svg-icon-md svg-icon-light-secondary ml-3 mr-3">
                                          <svg
                                            width="24px"
                                            height="24px"
                                            viewBox="0 0 24 24"
                                            version="1.1"
                                            xmlns="http://www.w3.org/2000/svg"
                                            xmlnsXlink="http://www.w3.org/1999/xlink"
                                          >
                                            {/* Generator: Sketch 50.2 (55047) - http://www.bohemiancoding.com/sketch */}
                                            <title>
                                              Stockholm-icons / Communication /
                                              Sending mail
                                            </title>
                                            <desc>Created with Sketch.</desc>
                                            <defs />
                                            <g
                                              id="Stockholm-icons-/-Communication-/-Sending-mail"
                                              stroke="none"
                                              strokeWidth={1}
                                              fill="none"
                                              fillRule="evenodd"
                                            >
                                              <rect
                                                id="bound"
                                                x={0}
                                                y={0}
                                                width={24}
                                                height={24}
                                              />
                                              <path
                                                d="M4,16 L5,16 C5.55228475,16 6,16.4477153 6,17 C6,17.5522847 5.55228475,18 5,18 L4,18 C3.44771525,18 3,17.5522847 3,17 C3,16.4477153 3.44771525,16 4,16 Z M1,11 L5,11 C5.55228475,11 6,11.4477153 6,12 C6,12.5522847 5.55228475,13 5,13 L1,13 C0.44771525,13 6.76353751e-17,12.5522847 0,12 C-6.76353751e-17,11.4477153 0.44771525,11 1,11 Z M3,6 L5,6 C5.55228475,6 6,6.44771525 6,7 C6,7.55228475 5.55228475,8 5,8 L3,8 C2.44771525,8 2,7.55228475 2,7 C2,6.44771525 2.44771525,6 3,6 Z"
                                                id="Combined-Shape"
                                                fill="#000000"
                                                opacity="0.3"
                                              />
                                              <path
                                                d="M10,6 L22,6 C23.1045695,6 24,6.8954305 24,8 L24,16 C24,17.1045695 23.1045695,18 22,18 L10,18 C8.8954305,18 8,17.1045695 8,16 L8,8 C8,6.8954305 8.8954305,6 10,6 Z M21.0849395,8.0718316 L16,10.7185839 L10.9150605,8.0718316 C10.6132433,7.91473331 10.2368262,8.02389331 10.0743092,8.31564728 C9.91179228,8.60740125 10.0247174,8.9712679 10.3265346,9.12836619 L15.705737,11.9282847 C15.8894428,12.0239051 16.1105572,12.0239051 16.294263,11.9282847 L21.6734654,9.12836619 C21.9752826,8.9712679 22.0882077,8.60740125 21.9256908,8.31564728 C21.7631738,8.02389331 21.3867567,7.91473331 21.0849395,8.0718316 Z"
                                                id="Combined-Shape"
                                                fill="#000000"
                                              />
                                            </g>
                                          </svg>
                                        </span>
                                      </div>
                                      <input
                                        type="email"
                                        className="form-control form-control-lg form-control-solid"
                                        name="email"
                                        defaultValue={user.email}
                                        // onChange={handleEmailChange}
                                        placeholder="Email"
                                        disabled
                                      />
                                    </div>
                                  </div>
                                </div>

                                {/*begin::Group*/}
                                <div className="form-group row">
                                  <div className="col-xxl">
                                    <div className="input-group input-group-lg input-group-solid">
                                      <input
                                        type="text"
                                        className="form-control form-control-lg form-control-solid"
                                        name="subject"
                                        onChange={handleSubjectChange}
                                        placeholder="Subject"
                                        required
                                      />
                                    </div>
                                  </div>
                                </div>

                                {/*begin::Group */}
                                <div className="form-group row">
                                  <div className="col-xxl">
                                    <textarea
                                      className="form-control form-control-solid form-control-lg"
                                      id="exampleTextarea"
                                      placeholder="Message"
                                      rows={8}
                                      onChange={handleMessageChange}
                                    />
                                  </div>
                                </div>
                                {/*end::Group*/}
                                {/*end::Group*/}
                              </div>
                            </div>
                            {/*end::Row*/}
                          </div>
                          {/*end::Tab*/}
                        </div>
                        {/*begin::Footer*/}
                        <div
                          className="card-footer"
                          style={{ borderTop: "none" }}
                        >
                          <div className="row">
                            <div className="col-xxl">
                              <button
                                type="submit"
                                className="btn btn-success btn-lg btn-block font-weight-bold mr-2"
                              >
                                Send Message
                              </button>
                            </div>
                          </div>
                        </div>
                        {/*end::Footer*/}
                      </div>
                    </form>
                  </div>
                )}
              </>
            )}
          </div>
        </div>
      ) : null}
    </>
  );
};
