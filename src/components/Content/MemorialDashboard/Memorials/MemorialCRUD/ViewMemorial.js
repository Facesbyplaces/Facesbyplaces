import React, { useEffect, useState } from "react";
import axios from "../../../../../auxiliary/axios";

import { useDispatch, useSelector } from "react-redux";
import {
  TableUserAction,
  EditMemorialAction,
} from "../../../../../redux/actions";

export default function ViewMemorial() {
  const dispatch = useDispatch();
  const [memorial, setMemorial] = useState([]);
  const [memorialDetails, setMemorialDetails] = useState([]);
  const [imagesOrVideos, setImagesOrVideos] = useState([]);
  const { memorialTab } = useSelector(({ memorialTab }) => ({
    memorialTab: memorialTab,
  }));

  const handleTableClick = () => {
    dispatch(TableUserAction());
  };

  const handleEditClick = (id, page, option) => {
    dispatch(EditMemorialAction({ id, page, option }));
  };

  const renderedImagesOrVideos = () => {
    if (imagesOrVideos) {
      imagesOrVideos.map((iOV) => {
        <div
          className="d-flex flex-row-fluid bgi-size-cover bgi-position-top"
          style={{
            backgroundImage: `url(${iOV})`,
            height: "300px",
            borderRadius: "0.5rem",
          }}
        >
          <div className="container">
            <div className="d-flex justify-content-between align-items-center pt-25 pb-35"></div>
          </div>
        </div>;
        console.log(iOV);
      });
    }
  };

  useEffect(() => {
    axios
      .get(`/api/v1/admin/memorials/${memorialTab.id}/${memorialTab.page}`)
      .then((response) => {
        setMemorial(response.data.page);
        setMemorialDetails(response.data.page.details);
        setImagesOrVideos(response.data.page.imagesOrVideos);
        console.log("Response: ", response.data);
      })
      .catch((error) => {
        console.log(error.errors);
      });
  }, memorial.id);

  return (
    <div className="d-flex flex-column flex-column-fluid">
      {/*begin::Entry*/}
      {/*begin::Hero*/}
      <div
        className="d-flex flex-row-fluid bgi-size-cover bgi-position-top"
        style={{
          backgroundImage: memorial.backgroundImage
            ? `url( ${memorial.backgroundImage})`
            : `url("assets/media/bg/bg-1.jpg")`,
          height: "350px",
        }}
      >
        <div className="container">
          <div className="d-flex justify-content-between align-items-center pt-25 pb-35"></div>
        </div>
      </div>
      {/*end::Hero*/}
      {/*begin::Section*/}
      <div className="container mt-n15 gutter-b">
        <div className="card card-custom">
          <div className="card-body">
            <form className="form">
              <div className="tab-content">
                {/*begin::Group*/}
                <div className="form-group mt-n15 row">
                  <div
                    className="col-10 pl-15"
                    style={{
                      flex: "0",
                      maxWidth: "100%",
                      borderRadius: "6rem",
                      marginRight: "auto",
                    }}
                  >
                    <div
                      className="image-input image-input-empty image-input-outline"
                      style={{
                        backgroundImage: memorial.profileImage
                          ? `url( ${memorial.profileImage})`
                          : `url( "assets/media/users/blank.png" )`,
                        borderRadius: "6rem",
                      }}
                    >
                      <div
                        className="image-input-wrapper"
                        style={{
                          borderRadius: "6rem",
                        }}
                      />
                    </div>
                  </div>
                </div>
                {/*end::Group*/}
                {/*begin::Tab*/}
                <div className="tab-pane show active px-7 mt-5">
                  <div className="card-header py-3 pl-5">
                    <div className="card-title align-items-start flex-column mb-2">
                      <h3 className="card-label font-weight-bolder text-dark">
                        Memorial Information
                      </h3>

                      <span className="text-muted font-weight-bold font-size-sm mt-1">
                        User's memorial information
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
                  <div className="row mt-10 mb-10">
                    <div className="col-xl-2" />
                    <div className="col-xl-7 my-2">
                      {/*begin::Row*/}
                      <div className="row">
                        <div className="col-9">
                          <h6 className="text-dark font-weight-bold mb-10">
                            Images/Videos:
                          </h6>
                        </div>
                      </div>
                      {/*end::Row*/}
                      {/*begin::Row*/}
                      <div className="form-group row">
                        {/*begin: Pic*/}
                        <label className="col-form-label col-3 text-lg-right text-left"></label>

                        {memorial.imagesOrVideos ? (
                          <div className="col-9 pb-5">
                            {renderedImagesOrVideos()}
                          </div>
                        ) : (
                          <div className="col-9 pb-5">
                            <div
                              className="d-flex flex-row-fluid bgi-size-cover bgi-position-top"
                              style={{
                                backgroundImage: `url("assets/media/bg/bg-1.jpg")`,
                                height: "300px",
                                borderRadius: "0.5rem",
                              }}
                            >
                              <div className="container">
                                <div className="d-flex justify-content-between align-items-center pt-25 pb-35"></div>
                              </div>
                            </div>
                          </div>
                        )}
                        {/*end::Pic*/}
                      </div>
                      {/*end::Group*/}
                      <div className="separator separator-solid my-10" />
                      {/*begin::Row*/}
                      <div className="row">
                        <div className="col-9">
                          <h6 className="text-dark font-weight-bold mb-10">
                            Memorial Info:
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
                          Page Name
                        </label>
                        <div className="col-9">
                          <input
                            className="form-control form-control-lg border-0 placeholder-dark-75"
                            type="username"
                            name="username"
                            defaultValue={memorial.name}
                            disabled
                          />
                        </div>
                      </div>
                      {/*end::Group*/}
                      {/*begin::Group*/}
                      <div className="form-group row">
                        <label className="col-form-label col-3 text-lg-right text-left">
                          Description
                        </label>
                        <div className="col-9">
                          <textarea
                            className="form-control form-control-solid form-control-lg"
                            id="exampleTextarea"
                            rows={6}
                            defaultValue={memorialDetails.description}
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
                            Memorial Dates:
                          </h6>
                        </div>
                      </div>
                      {/*end::Row*/}
                      {/*begin::Group*/}
                      <div className="form-group row">
                        <label className="col-form-label col-3 text-lg-right text-left">
                          Date of Birth
                        </label>
                        <div className="col-9">
                          <input
                            className="form-control form-control-lg border-0 placeholder-dark-75"
                            type="last_name"
                            name="last_name"
                            defaultValue={memorialDetails.dob}
                            disabled
                          />
                        </div>
                      </div>
                      {/*end::Group*/}
                      {/*begin::Group*/}
                      <div className="form-group row">
                        <label className="col-form-label col-3 text-lg-right text-left">
                          Date of Death
                        </label>
                        <div className="col-9">
                          <input
                            className="form-control form-control-lg border-0 placeholder-dark-75"
                            type="last_name"
                            name="last_name"
                            defaultValue={memorialDetails.rip}
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
                            Memorial Places:
                          </h6>
                        </div>
                      </div>
                      {/*end::Row*/}
                      {/*begin::Group*/}
                      <div className="form-group row">
                        <label className="col-form-label col-3 text-lg-right text-left">
                          Birthplace
                        </label>
                        <div className="col-9">
                          <input
                            className="form-control form-control-lg border-0 placeholder-dark-75"
                            type="last_name"
                            name="last_name"
                            defaultValue={memorialDetails.birthplace}
                            disabled
                          />
                        </div>
                      </div>
                      {/*end::Group*/}
                      {/*begin::Group*/}
                      <div className="form-group row">
                        <label className="col-form-label col-3 text-lg-right text-left">
                          Cemetery
                        </label>
                        <div className="col-9">
                          <input
                            className="form-control form-control-lg border-0 placeholder-dark-75"
                            type="last_name"
                            name="last_name"
                            defaultValue={memorialDetails.cemetery}
                            disabled
                          />
                        </div>
                      </div>
                      {/*end::Group*/}
                      {/*begin::Group*/}
                      <div className="form-group row">
                        <label className="col-form-label col-3 text-lg-right text-left">
                          Country
                        </label>
                        <div className="col-9">
                          <input
                            className="form-control form-control-lg border-0 placeholder-dark-75"
                            type="last_name"
                            name="last_name"
                            defaultValue={memorialDetails.country}
                            disabled
                          />
                        </div>
                      </div>
                      {/*end::Group*/}
                      {/*begin::Group*/}
                      <div className="form-group row">
                        <label className="col-form-label col-3 text-lg-right text-left">
                          Latitude
                        </label>
                        <div className="col-9">
                          <input
                            className="form-control form-control-lg border-0 placeholder-dark-75"
                            type="last_name"
                            name="last_name"
                            defaultValue={memorialDetails.latitude}
                            disabled
                          />
                        </div>
                      </div>
                      {/*end::Group*/}
                      {/*begin::Group*/}
                      <div className="form-group row">
                        <label className="col-form-label col-3 text-lg-right text-left">
                          Longitude
                        </label>
                        <div className="col-9">
                          <input
                            className="form-control form-control-lg border-0 placeholder-dark-75"
                            type="last_name"
                            name="last_name"
                            defaultValue={memorialDetails.longitude}
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
                                    handleEditClick(
                                      memorial.id,
                                      memorial.page_type,
                                      "e"
                                    )
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
      {/*end::Section*/}
      {/*end::Entry*/}
    </div>
  );
}
