import React, { useEffect, useState } from "react";
import axios from "../../../../../auxiliary/axios";
import { SuccessModal } from "../../Modals/SuccessModal";
import HashLoader from "react-spinners/HashLoader";
import { useDispatch, useSelector } from "react-redux";
import {
  TableMemorialAction,
  ViewMemorialAction,
} from "../../../../../redux/actions";

export default function EditMemorial() {
  const dispatch = useDispatch();
  const { memorialTab } = useSelector(({ memorialTab }) => ({
    memorialTab: memorialTab,
  }));
  const [errors, setErrors] = useState("");
  const [showModal, setShowModal] = useState(false);
  const [loading, setLoading] = useState(false);

  // Fetched Data
  const [memorial, setMemorial] = useState([]);
  const [memorialDetails, setMemorialDetails] = useState([]);
  const [pageCreator, setPageCreator] = useState([]);

  // ProfileImage Variables
  const [
    profileImageTemporaryDisplay,
    setProfileImageTemporaryDisplay,
  ] = useState(null);
  const [profileImageSelectedFile, setProfileImageSelectedFile] = useState(
    null
  );
  // BackgroundImage Variables
  const [
    backgroundImageTemporaryDisplay,
    setBackgroundImageTemporaryDisplay,
  ] = useState(null);
  const [
    backgroundImageSelectedFile,
    setBackgroundImageSelectedFile,
  ] = useState(null);
  // ImageOrVideos Variables
  const [imagesOrVideosEmpty, setImagesOrVideosEmpty] = useState([]);
  const [imagesOrVideos, setImagesOrVideos] = useState([]);
  const [
    imagesOrVideosTemporaryImageDisplay,
    setImagesOrVideosTemporaryImageDisplay,
  ] = useState([]);
  const [
    imagesOrVideosFilesSelected,
    setImagesOrVideosFilesSelected,
  ] = useState(null);

  // Form Data
  const [location, setLocation] = useState("");
  const [dateOfBirth, setDateOfBirth] = useState("");
  const [dateOfDeath, setDateOfDeath] = useState("");
  const [precinct, setPrecinct] = useState("");
  const [state, setState] = useState("");
  const [country, setCountry] = useState("");
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");
  const [relationship, setRelationship] = useState("");
  const [latitude, setLatitude] = useState("");
  const [longitude, setLongitude] = useState("");

  // Form Data Images
  const imageOrVideosSelectedHandler = (e) => {
    setImagesOrVideosTemporaryImageDisplay(
      URL.createObjectURL(e.target.files[0])
    );
    setImagesOrVideosFilesSelected(e.target.files[0]);
    console.log("Images Or Videos", imagesOrVideosFilesSelected);
  };
  const profileImageSelectedHandler = (e) => {
    setProfileImageTemporaryDisplay(URL.createObjectURL(e.target.files[0]));
    setProfileImageSelectedFile(e.target.files[0]);
    console.log("Profile Image: ", profileImageSelectedFile);
  };
  const backgroundImageSelectedHandler = (e) => {
    setBackgroundImageTemporaryDisplay(URL.createObjectURL(e.target.files[0]));
    setBackgroundImageSelectedFile(e.target.files[0]);
    // console.log(URL.createObjectURL(e.target.files[0]));
  };

  const uploadImage = (memorial) => {
    console.log("Images or Videos: ", imagesOrVideosFilesSelected);
    const formData = new FormData();
    profileImageSelectedFile != null
      ? formData.append("profileImage", profileImageSelectedFile)
      : console.log("No Profile Image Uploaded");
    backgroundImageSelectedFile != null
      ? formData.append("backgroundImage", backgroundImageSelectedFile)
      : console.log("No Background Image Uploaded");
    imagesOrVideosFilesSelected != null
      ? formData.append("imagesOrVideos[]", imagesOrVideosFilesSelected)
      : console.log("No Images or Videos Uploaded");
    formData.append("memorial_id", memorial.id);
    console.log("Form Data: ", formData);
    axios
      .put(
        `/api/v1/admin/memorials/blm/image/${memorialTab.id}/${memorialTab.page}`,
        formData
      )
      .then((response) => {
        console.log(response.data);
      })
      .catch((error) => {
        console.log(error);
        setErrors(error);
      });
  };

  // Form Data Handlers
  const handleLocationChange = (e) => {
    setLocation(e.target.value);
  };
  const handleDateOfBirthChange = (e) => {
    setDateOfBirth(e.target.value);
  };
  const handleDateOfDeathChange = (e) => {
    setDateOfDeath(e.target.value);
  };
  const handlePrecinctChange = (e) => {
    setPrecinct(e.target.value);
  };
  const handleStateChange = (e) => {
    setState(e.target.value);
  };
  const handleCountryChange = (e) => {
    setCountry(e.target.value);
  };
  const handleNameChange = (e) => {
    setName(e.target.value);
  };
  const handleDescriptionChange = (e) => {
    setDescription(e.target.value);
  };
  const handleRelationshipChange = (e) => {
    setRelationship(e.target.value);
  };
  const handleLatitudeChange = (e) => {
    setLatitude(e.target.value);
  };
  const handleLongitudeChange = (e) => {
    setLongitude(e.target.value);
  };

  // Tab Data
  const handleTableClick = () => {
    dispatch(TableMemorialAction());
  };
  const handleViewClick = (id, page, option, type) => {
    dispatch(ViewMemorialAction({ id, page, option, type }));
  };

  // Modal
  const openModal = () => {
    setShowModal((prev) => !prev);
  };

  const renderedImagesOrVideos = imagesOrVideos.map((iOV) => {
    return (
      <div className="image-input image-input-empty image-input-outline pr-3 pb-3">
        <div
          className="card card-custom pb-3 card-stretch pr-3"
          style={{
            height: "200px",
            width: "200px",
            backgroundColor: "#f3f6f9",
            backgroundImage: `url( ${iOV})`,
            backgroundSize: "cover",
            opacity: "1",
          }}
        >
          <label
            className="btn btn-lg btn-icon btn-hover-text-primary"
            data-action="change"
            data-toggle="tooltip"
            title
            data-original-title="Change avatar"
            style={{
              marginTop: "90px",
              marginRight: "85px",
            }}
          >
            <span className="svg-icon svg-icon-xs svg-icon-light-secondary ml-3 mr-3">
              <svg
                width="24px"
                height="24px"
                viewBox="0 0 24 24"
                version="1.1"
                xmlns="http://www.w3.org/2000/svg"
                xmlnsXlink="http://www.w3.org/1999/xlink"
              >
                {/* Generator: Sketch 50.2 (55047) - http://www.bohemiancoding.com/sketch */}
                <title>Stockholm-icons / Design / Edit</title>
                <desc>Created with Sketch.</desc>
                <defs />
                <g
                  id="Stockholm-icons-/-Design-/-Edit"
                  stroke="none"
                  strokeWidth={1}
                  fill="none"
                  fillRule="evenodd"
                >
                  <rect id="bound" x={0} y={0} width={24} height={24} />
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
            <input
              type="file"
              accept=".png, .jpg, .jpeg"
              onChange={imageOrVideosSelectedHandler}
            />
          </label>
        </div>
      </div>
    );
  });

  useEffect(() => {
    axios
      .get(`/api/v1/admin/memorials/${memorialTab.id}/${memorialTab.page}`)
      .then((response) => {
        setMemorial(response.data);
        setMemorialDetails(response.data.details);
        response.data.imagesOrVideos
          ? setImagesOrVideos(response.data.imagesOrVideos)
          : setImagesOrVideosEmpty(true);
        setPageCreator(response.data.page_creator.id);
      })
      .catch((error) => {
        console.log(error);
      });
  }, memorial.id);

  const handleSubmit = (e) => {
    // If Form Data empty
    const memorialLocation = location ? location : memorialDetails.location;
    const memorialDateOfBirth = dateOfBirth ? dateOfBirth : memorialDetails.dob;
    const memorialDateOfDeath = dateOfDeath ? dateOfDeath : memorialDetails.rip;
    const memorialPrecinct = precinct ? precinct : memorialDetails.precinct;
    const memorialState = state ? state : memorialDetails.state;
    const memorialCountry = country ? country : memorialDetails.country;
    const pageName = name ? name : memorial.name;
    const memorialDescription = description
      ? description
      : memorialDetails.description;
    const pageRelationship = relationship
      ? relationship
      : memorial.relationship;
    const memorialLatitude = latitude ? latitude : memorialDetails.latitude;
    const memorialLongitude = longitude ? longitude : memorialDetails.longitude;

    setLoading(true);
    axios
      .put(`/api/v1/admin/memorials/blm/${memorial.id}`, {
        user_id: pageCreator,
        location: memorialLocation,
        dob: memorialDateOfBirth,
        rip: memorialDateOfDeath,
        precinct: memorialPrecinct,
        country: memorialCountry,
        name: pageName,
        description: memorialDescription,
        relationship: pageRelationship,
        latitude: memorialLatitude,
        longitude: memorialLongitude,
      })
      .then((response) => {
        console.log(response);
        setTimeout(() => {
          uploadImage(response.data);
          setLoading(false);
        }, 1000);
        openModal();
      })
      .catch((error) => {
        console.log(error);
        setErrors(error.response);
      });

    e.preventDefault();
  };

  return (
    <div className="d-flex flex-column flex-column-fluid">
      <SuccessModal showModal={showModal} setShowModal={setShowModal} />
      <>
        {loading ? (
          <div className="loader-container">
            <HashLoader color={"#04ECFF"} loading={loading} size={90} />
          </div>
        ) : (
          <>
            {/*begin::Entry*/}
            {/*begin::Hero*/}
            <div className="image-input image-input-outline image-input-circle">
              <label
                className="btn btn-xs btn-icon btn-circle btn-white btn-hover-text-primary btn-shadow"
                data-action="change"
                data-toggle="tooltip"
                title
                data-original-title="Change avatar"
              >
                <i className="fa fa-pen icon-sm text-muted" />
                <span className="svg-icon svg-icon-xs svg-icon-light-secondary ml-3 mr-3">
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
                    <title>Stockholm-icons / Design / Edit</title>
                    <desc>Created with Sketch.</desc>
                    <defs />
                    <g
                      id="Stockholm-icons-/-Design-/-Edit"
                      stroke="none"
                      strokeWidth={1}
                      fill="none"
                      fillRule="evenodd"
                    >
                      <rect id="bound" x={0} y={0} width={24} height={24} />
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

                <input
                  type="file"
                  accept=".png, .jpg, .jpeg"
                  onChange={backgroundImageSelectedHandler}
                />
                <input type="hidden" name="profile_avatar_remove" />
              </label>
            </div>

            {backgroundImageTemporaryDisplay || memorial.backgroundImage ? (
              <div
                className="d-flex flex-row-fluid bgi-size-cover bgi-position-top"
                style={{
                  backgroundImage:
                    `url( ${backgroundImageTemporaryDisplay})` ||
                    `url( ${memorial.backgroundImage})`,
                  height: "350px",
                }}
              >
                <div className="container">
                  <div className="d-flex justify-content-between align-items-center pt-25 pb-35"></div>
                </div>
              </div>
            ) : (
              <div
                className="d-flex flex-row-fluid bgi-size-cover bgi-position-top"
                style={{
                  backgroundImage: `url( "assets/media/bg/bg-1.jpg" )`,
                  height: "350px",
                }}
              >
                <div className="container">
                  <div className="d-flex justify-content-between align-items-center pt-25 pb-35"></div>
                </div>
              </div>
            )}
            {/*end::Hero*/}
            {/*begin::Section*/}
            <div className="container mt-n15 gutter-b">
              <div className="card card-custom">
                <div className="card-body">
                  <form className="form" onSubmit={handleSubmit}>
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
                          <div className="image-input image-input-outline image-input-circle">
                            {profileImageTemporaryDisplay ||
                            memorial.profileImage ? (
                              <div
                                className="image-input-wrapper"
                                style={{
                                  backgroundImage:
                                    `url( ${profileImageTemporaryDisplay})` ||
                                    `url( ${memorial.profileImage})`,
                                }}
                              />
                            ) : (
                              <div
                                className="image-input-wrapper"
                                style={{
                                  backgroundImage: `url( "assets/media/users/blank.png" )`,
                                }}
                              />
                            )}
                            <label
                              className="btn btn-xs btn-icon btn-circle btn-white btn-hover-text-primary btn-shadow"
                              data-action="change"
                              data-toggle="tooltip"
                              title
                              data-original-title="Change avatar"
                            >
                              <i className="fa fa-pen icon-sm text-muted" />
                              <span className="svg-icon svg-icon-xs svg-icon-light-secondary ml-3 mr-3">
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
                                  <title>Stockholm-icons / Design / Edit</title>
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

                              <input
                                type="file"
                                accept=".png, .jpg, .jpeg"
                                onChange={profileImageSelectedHandler}
                              />
                              <input
                                type="hidden"
                                name="profile_avatar_remove"
                              />
                            </label>
                          </div>
                        </div>
                      </div>
                      {/*end::Group*/}
                      {/*begin::Tab*/}
                      <div className="tab-pane show active px-7 mt-5">
                        <div className="card-header py-3 pl-5">
                          <div className="card-title align-items-start flex-column mb-2">
                            <h3 className="card-label font-weight-bolder text-dark">
                              Edit BLM Information
                            </h3>

                            <span className="text-muted font-weight-bold font-size-sm mt-1">
                              Edit user's blm information
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
                            <div className="form-group row pl-4">
                              {renderedImagesOrVideos}
                              <div className="image-input image-input-empty image-input-outline">
                                <div
                                  className="card card-custom pb-3 card-stretch pr-3"
                                  style={{
                                    height: "200px",
                                    width: "200px",
                                    backgroundColor: "#f3f6f9",
                                    backgroundImage: imagesOrVideosTemporaryImageDisplay
                                      ? `url( ${imagesOrVideosTemporaryImageDisplay})`
                                      : ``,
                                    backgroundSize: "cover",
                                    opacity: "1",
                                  }}
                                >
                                  <label
                                    className="btn btn-lg btn-icon btn-hover-text-primary"
                                    data-action="change"
                                    data-toggle="tooltip"
                                    title
                                    data-original-title="Change avatar"
                                    style={{
                                      marginTop: "90px",
                                      marginRight: "85px",
                                    }}
                                  >
                                    <span className="svg-icon svg-icon-xs svg-icon-light-secondary ml-3 mr-3">
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
                                    <input
                                      type="file"
                                      accept=".png, .jpg, .jpeg"
                                      onChange={imageOrVideosSelectedHandler}
                                    />
                                  </label>
                                </div>
                              </div>
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
                                  className="form-control form-control-lg form-control-solid placeholder-dark-75"
                                  type="username"
                                  name="username"
                                  onChange={handleNameChange}
                                  defaultValue={memorial.name}
                                />
                              </div>
                            </div>
                            {/*end::Group*/}
                            {/*begin::Group*/}
                            {/* <div className="form-group row">
                        <label className="col-form-label col-3 text-lg-right text-left">
                          Relationship
                        </label>
                        <div className="col-9">
                          <input
                            className="form-control form-control-lg form-control-solid placeholder-dark-75"
                            type="relationship"
                            name="relationship"
                            onChange={handleRelationshipChange}
                            defaultValue={memorial.relationship}
                          />
                        </div>
                      </div> */}
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
                                  onChange={handleDescriptionChange}
                                  defaultValue={memorialDetails.description}
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
                                  className="form-control form-control-lg form-control-solid placeholder-dark-75"
                                  type="last_name"
                                  name="last_name"
                                  onChange={handleDateOfBirthChange}
                                  defaultValue={memorialDetails.dob}
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
                                  className="form-control form-control-lg form-control-solid placeholder-dark-75"
                                  type="last_name"
                                  name="last_name"
                                  onChange={handleDateOfDeathChange}
                                  defaultValue={memorialDetails.rip}
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
                                  className="form-control form-control-lg form-control-solid placeholder-dark-75"
                                  type="last_name"
                                  name="last_name"
                                  onChange={handleLocationChange}
                                  defaultValue={memorialDetails.location}
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
                                  className="form-control form-control-lg form-control-solid placeholder-dark-75"
                                  type="last_name"
                                  name="last_name"
                                  onChange={handlePrecinctChange}
                                  defaultValue={memorialDetails.precinct}
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
                                  className="form-control form-control-lg form-control-solid placeholder-dark-75"
                                  type="last_name"
                                  name="last_name"
                                  onChange={handleStateChange}
                                  defaultValue={memorialDetails.state}
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
                                  className="form-control form-control-lg form-control-solid placeholder-dark-75"
                                  type="last_name"
                                  name="last_name"
                                  onChange={handleCountryChange}
                                  defaultValue={memorialDetails.country}
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
                                  className="form-control form-control-lg form-control-solid placeholder-dark-75"
                                  type="last_name"
                                  name="last_name"
                                  onChange={handleLatitudeChange}
                                  defaultValue={memorialDetails.latitude}
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
                                  className="form-control form-control-lg form-control-solid placeholder-dark-75"
                                  type="last_name"
                                  name="last_name"
                                  onChange={handleLongitudeChange}
                                  defaultValue={memorialDetails.longitude}
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
                                          handleViewClick(
                                            memorial.id,
                                            memorial.page_type,
                                            "v",
                                            1
                                          )
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
            {/*end::Entry*/}
          </>
        )}
      </>
    </div>
  );
}
