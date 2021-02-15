import React, { useState } from "react";
import EditUser from "./EditUser";

export default function ViewUser({ user }) {
  const [edit, setEdit] = useState(false);

  return (
    <div className="container">
      <div className="card card-custom">
        {edit ? (
          <EditUser user={user} setEdit={setEdit} />
        ) : (
          <form className="form">
            <div className="tab-content">
              {/*begin::Tab*/}
              <div className="tab-pane show active px-7 mt-5">
                <div className="card-header py-3 pl-5">
                  <div className="card-title align-items-start flex-column mb-2">
                    <h3 className="card-label font-weight-bolder text-dark">
                      Personal Information
                    </h3>
                    <span className="text-muted font-weight-bold font-size-sm mt-1">
                      User's personal information
                    </span>
                  </div>
                  <div className="card-title align-items-start flex-column mb-2"></div>
                </div>
              </div>
              <div className="tab-pane show active px-7" role="tabpanel">
                {/*begin::Row*/}
                <div className="row mt-10 mb-10">
                  <div className="col-xl-2" />
                  <div className="col-xl-7 my-2">
                    {/*begin::Row*/}
                    <div className="row">
                      <div className="col-9">
                        <h6 className="text-dark font-weight-bold mb-10">
                          User Info:
                        </h6>
                      </div>
                    </div>
                    {/*end::Row*/}
                    {/*begin::Group*/}
                    <div className="form-group row">
                      <label className="col-form-label col-3 text-lg-right text-left">
                        Avatar
                      </label>
                      <div className="col-9">
                        <div
                          className="image-input image-input-empty image-input-outline"
                          id="kt_user_edit_avatar"
                          style={{
                            backgroundImage:
                              'url("assets/media/users/300_16.jpg")',
                            //   backgroundImage: "url({user.image})",
                          }}
                        >
                          <div className="image-input-wrapper" />
                        </div>
                      </div>
                    </div>
                    {/*end::Group*/}
                    {/*begin::Group*/}
                    <div className="form-group row">
                      <label className="col-form-label col-3 text-lg-right text-left">
                        Username
                      </label>
                      <div className="col-9">
                        <input
                          className="form-control form-control-lg form-control-solid"
                          defaultValue={user.username}
                        />
                      </div>
                    </div>
                    {/*end::Group*/}
                    {/*begin::Group*/}
                    <div className="form-group row">
                      <label className="col-form-label col-3 text-lg-right text-left">
                        First Name
                      </label>
                      <div className="col-9">
                        <input
                          className="form-control form-control-lg form-control-solid"
                          defaultValue={user.first_name}
                        />
                      </div>
                    </div>
                    {/*end::Group*/}
                    {/*begin::Group*/}
                    <div className="form-group row">
                      <label className="col-form-label col-3 text-lg-right text-left">
                        Last Name
                      </label>
                      <div className="col-9">
                        <input
                          className="form-control form-control-lg form-control-solid"
                          defaultValue={user.last_name}
                        />
                      </div>
                    </div>
                    {/*end::Group*/}
                    {/*begin::Group*/}
                    <div className="form-group row">
                      <label className="col-form-label col-3 text-lg-right text-left">
                        Contact Phone
                      </label>
                      <div className="col-9">
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
                                  Stockholm-icons / Communication / Call#1
                                </title>
                                <desc>Created with Sketch.</desc>
                                <defs />
                                <g
                                  id="Stockholm-icons-/-Communication-/-Call#1"
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
                                    d="M11.914857,14.1427403 L14.1188827,11.9387145 C14.7276032,11.329994 14.8785122,10.4000511 14.4935235,9.63007378 L14.3686433,9.38031323 C13.9836546,8.61033591 14.1345636,7.680393 14.7432841,7.07167248 L17.4760882,4.33886839 C17.6713503,4.14360624 17.9879328,4.14360624 18.183195,4.33886839 C18.2211956,4.37686904 18.2528214,4.42074752 18.2768552,4.46881498 L19.3808309,6.67676638 C20.2253855,8.3658756 19.8943345,10.4059034 18.5589765,11.7412615 L12.560151,17.740087 C11.1066115,19.1936265 8.95659008,19.7011777 7.00646221,19.0511351 L4.5919826,18.2463085 C4.33001094,18.1589846 4.18843095,17.8758246 4.27575484,17.613853 C4.30030124,17.5402138 4.34165566,17.4733009 4.39654309,17.4184135 L7.04781491,14.7671417 C7.65653544,14.1584211 8.58647835,14.0075122 9.35645567,14.3925008 L9.60621621,14.5173811 C10.3761935,14.9023698 11.3061364,14.7514608 11.914857,14.1427403 Z"
                                    id="Path-76"
                                    fill="#000000"
                                  />
                                </g>
                              </svg>
                            </span>
                          </div>
                          <input
                            type="text"
                            className="form-control form-control-lg form-control-solid"
                            defaultValue={user.phone_number}
                            placeholder="Phone"
                          />
                        </div>
                      </div>
                    </div>
                    {/*end::Group*/}
                    {/*begin::Group*/}
                    <div className="form-group row">
                      <label className="col-form-label col-3 text-lg-right text-left">
                        Email Address
                      </label>
                      <div className="col-9">
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
                                  Stockholm-icons / Communication / Mail-at
                                </title>
                                <desc>Created with Sketch.</desc>
                                <defs />
                                <g
                                  id="Stockholm-icons-/-Communication-/-Mail-at"
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
                                    d="M11.575,21.2 C6.175,21.2 2.85,17.4 2.85,12.575 C2.85,6.875 7.375,3.05 12.525,3.05 C17.45,3.05 21.125,6.075 21.125,10.85 C21.125,15.2 18.825,16.925 16.525,16.925 C15.4,16.925 14.475,16.4 14.075,15.65 C13.3,16.4 12.125,16.875 11,16.875 C8.25,16.875 6.85,14.925 6.85,12.575 C6.85,9.55 9.05,7.1 12.275,7.1 C13.2,7.1 13.95,7.35 14.525,7.775 L14.625,7.35 L17,7.35 L15.825,12.85 C15.6,13.95 15.85,14.825 16.925,14.825 C18.25,14.825 19.025,13.725 19.025,10.8 C19.025,6.9 15.95,5.075 12.5,5.075 C8.625,5.075 5.05,7.75 5.05,12.575 C5.05,16.525 7.575,19.1 11.575,19.1 C13.075,19.1 14.625,18.775 15.975,18.075 L16.8,20.1 C15.25,20.8 13.2,21.2 11.575,21.2 Z M11.4,14.525 C12.05,14.525 12.7,14.35 13.225,13.825 L14.025,10.125 C13.575,9.65 12.925,9.425 12.3,9.425 C10.65,9.425 9.45,10.7 9.45,12.375 C9.45,13.675 10.075,14.525 11.4,14.525 Z"
                                    id="@"
                                    fill="#000000"
                                  />
                                </g>
                              </svg>
                            </span>
                          </div>
                          <input
                            type="email"
                            className="form-control form-control-lg form-control-solid"
                            defaultValue={user.email}
                            placeholder="Email"
                          />
                        </div>
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
                                onClick={() => setEdit((prev) => !prev)}
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
        )}
      </div>
    </div>
  );
}
