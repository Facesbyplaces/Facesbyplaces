import React, { useEffect, useState } from "react";
import axios from "../../../../../../auxiliary/axios";

import { useDispatch, useSelector } from "react-redux";
import {
  TableMemorialAction,
  EditMemorialAction,
} from "../../../../../../redux/actions";

export default function ViewMemorial() {
  const dispatch = useDispatch();
  const [memorial, setMemorial] = useState([]);
  const [memorialDetails, setMemorialDetails] = useState([]);
  const [imagesOrVideos, setImagesOrVideos] = useState([]);
  const [imagesOrVideosEmpty, setImagesOrVideosEmpty] = useState(false);
  const { memorialTab } = useSelector(({ memorialTab }) => ({
    memorialTab: memorialTab,
  }));

  const handleTableClick = () => {
    dispatch(TableMemorialAction());
  };

  const handleEditClick = (id, page, option, type) => {
    dispatch(EditMemorialAction({ id, page, option, type }));
  };

  const renderedImagesOrVideos = imagesOrVideos.map((iOV) => {
    return (
      <div className="card card-custom pb-3 card-stretch pr-3">
        <div
          className="symbol symbol-lg-75"
          style={{
            height: "200px",
            width: "200px",
            backgroundColor: "#f3f6f9",
            opacity: "1",
          }}
        >
          <img src={iOV} alt="image" />
        </div>
      </div>
    );
  });

  useEffect(() => {
    axios
      .get(`/api/v1/admin/memorials/${memorialTab.id}/${memorialTab.page}`)
      .then((response) => {
        setMemorial(response.data.page);
        setMemorialDetails(response.data.page.details);
        response.data.page.imagesOrVideos
          ? setImagesOrVideos(response.data.page.imagesOrVideos)
          : setImagesOrVideosEmpty(true);
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
                        BLM Information
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
                      {imagesOrVideosEmpty ? (
                        <div className="form-group row pl-4">
                          <div
                            className="card card-custom pb-3 card-stretch pr-3"
                            style={{
                              marginRight: "auto",
                              marginLeft: "auto",
                            }}
                          >
                            {/*begin: Pic*/}
                            <h1>No Images Attached</h1>
                            {/*end::Pic*/}
                          </div>
                        </div>
                      ) : (
                        <div className="form-group row pl-4">
                          {renderedImagesOrVideos}
                          {/*begin: Pic*/}
                          <div
                            className="card card-custom pb-3 card-stretch pr-3"
                            style={{
                              height: "200px",
                              width: "200px",
                              backgroundColor: "#f3f6f9",
                              opacity: "1",
                            }}
                          >
                            {/*begin::User*/}
                            <div className="card-body text-center pt-4">
                              {/*begin::User*/}
                              <div
                                className=""
                                style={{
                                  marginTop: "70px",
                                  marginLeft: "10px",
                                }}
                              >
                                <div className="symbol symbol-lg-75">
                                  <span className="svg-icon svg-icon-xxl svg-icon-light-secondary ml-3 mr-3">
                                    <svg
                                      width="24px"
                                      height="24px"
                                      viewBox="0 0 24 24"
                                      version="1.1"
                                      xmlns="http://www.w3.org/2000/svg"
                                      xmlnsXlink="http://www.w3.org/1999/xlink"
                                    >
                                      Generator: Sketch 50.2 (55047) -
                                      http://www.bohemiancoding.com/sketch
                                      <title>
                                        Stockholm-icons / Design / Edit
                                      </title>
                                      <desc>Created with Sketch.</desc>
                                      <defs />
                                      <g
                                        id="Stockholm-icons-/-Design-/-Edit"
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
                                          d="M8,17.9148182 L8,5.96685884 C8,5.56391781 8.16211443,5.17792052 8.44982609,4.89581508 L10.965708,2.42895648 C11.5426798,1.86322723 12.4640974,1.85620921 13.0496196,2.41308426 L15.5337377,4.77566479 C15.8314604,5.0588212 16,5.45170806 16,5.86258077 L16,17.9148182 C16,18.7432453 15.3284271,19.4148182 14.5,19.4148182 L9.5,19.4148182 C8.67157288,19.4148182 8,18.7432453 8,17.9148182 Z"
                                          id="Path-11"
                                          fill="#000000"
                                          fillRule="nonzero"
                                          transform="translate(12.000000, 10.707409) rotate(-135.000000) translate(-12.000000, -10.707409) "
                                        />
                                        <rect
                                          id="Rectangle"
                                          fill="#000000"
                                          opacity="0.3"
                                          x={5}
                                          y={20}
                                          width={15}
                                          height={2}
                                          rx={1}
                                        />
                                      </g>
                                    </svg>
                                  </span>
                                </div>
                              </div>
                              {/* <img src="assets/media/bg/bg-1.jpg" alt="image" /> */}
                            </div>
                            {/*end::User*/}
                          </div>
                          {/*end::Pic*/}
                        </div>
                      )}
                      {/*end::Group*/}
                      {/*end::Row*/}
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
                          Location
                        </label>
                        <div className="col-9">
                          <input
                            className="form-control form-control-lg border-0 placeholder-dark-75"
                            type="last_name"
                            name="last_name"
                            defaultValue={memorialDetails.location}
                            disabled
                          />
                        </div>
                      </div>
                      {/*end::Group*/}
                      {/*begin::Group*/}
                      <div className="form-group row">
                        <label className="col-form-label col-3 text-lg-right text-left">
                          Precinct
                        </label>
                        <div className="col-9">
                          <input
                            className="form-control form-control-lg border-0 placeholder-dark-75"
                            type="last_name"
                            name="last_name"
                            defaultValue={memorialDetails.precinct}
                            disabled
                          />
                        </div>
                      </div>
                      {/*end::Group*/}
                      {/*begin::Group*/}
                      <div className="form-group row">
                        <label className="col-form-label col-3 text-lg-right text-left">
                          State
                        </label>
                        <div className="col-9">
                          <input
                            className="form-control form-control-lg border-0 placeholder-dark-75"
                            type="last_name"
                            name="last_name"
                            defaultValue={memorialDetails.state}
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
                                      "e",
                                      1
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
