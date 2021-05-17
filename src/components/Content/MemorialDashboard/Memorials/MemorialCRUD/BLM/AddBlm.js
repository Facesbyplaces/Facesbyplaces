import React, { useEffect, useState } from "react";
import axios from "../../../../../../auxiliary/axios";
import { SuccessModal } from "../SuccessModal";
import HashLoader from "react-spinners/HashLoader";
import { useDispatch, useSelector } from "react-redux";
import {
  TableMemorialAction,
  ViewMemorialAction,
} from "../../../../../../redux/actions";

export default function EditMemorial() {
  const dispatch = useDispatch();
  const { memorialTab } = useSelector(({ memorialTab }) => ({
    memorialTab: memorialTab,
  }));
  const [errors, setErrors] = useState("");
  const [showModal, setShowModal] = useState(false);
  const [loading, setLoading] = useState(false);

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
  const [users, setUsers] = useState([]);
  const [user, setUser] = useState([]);
  const [blmLocation, setBlmLocation] = useState("");
  const [dateOfBirth, setDateOfBirth] = useState("");
  const [dateOfDeath, setDateOfDeath] = useState("");
  const [blmPrecinct, setBlmPrecinct] = useState("");
  const [blmState, setBlmState] = useState("");
  const [blmCountry, setBlmCountry] = useState("");
  const [blmName, setBlmName] = useState("");
  const [blmDescription, setBlmDescription] = useState("");
  const [blmRelationship, setBlmRelationship] = useState("");
  const [blmLatitude, setBlmLatitude] = useState("");
  const [blmLongitude, setBlmLongitude] = useState("");

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
    backgroundImageSelectedFile
      ? formData.append("backgroundImage", backgroundImageSelectedFile)
      : console.log("No Background Image Uploaded");
    imagesOrVideosFilesSelected
      ? formData.append("imagesOrVideos[]", imagesOrVideosFilesSelected)
      : console.log("No Images or Videos Uploaded");
    formData.append("memorial_id", memorial.id);
    console.log("Form Data: ", formData);
    axios
      .put(`/api/v1/admin/memorials/blm/image/${memorial.id}`, formData)
      .then((response) => {
        console.log(response.data);
      })
      .catch((error) => {
        console.log(error.response.data.errors);
        setErrors(error.response.data.errors);
      });
  };

  // Form Data Handlers
  const handleUserChange = (e) => {
    setUser(e.target.value);
    console.log("User: ", e.target.value);
  };
  const handleLocationChange = (e) => {
    setBlmLocation(e.target.value);
  };
  const handleDateOfBirthChange = (e) => {
    setDateOfBirth(e.target.value);
  };
  const handleDateOfDeathChange = (e) => {
    setDateOfDeath(e.target.value);
  };
  const handlePrecinctChange = (e) => {
    setBlmPrecinct(e.target.value);
  };
  const handleStateChange = (e) => {
    setBlmState(e.target.value);
  };
  const handleCountryChange = (e) => {
    setBlmCountry(e.target.value);
  };
  const handleNameChange = (e) => {
    setBlmName(e.target.value);
  };
  const handleDescriptionChange = (e) => {
    setBlmDescription(e.target.value);
  };
  const handleRelationshipChange = (e) => {
    setBlmRelationship(e.target.value);
  };
  const handleLatitudeChange = (e) => {
    setBlmLatitude(e.target.value);
  };
  const handleLongitudeChange = (e) => {
    setBlmLongitude(e.target.value);
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

  useEffect(() => {
    axios
      .get(`/api/v1/admin/memorials/users/selection`)
      .then((response) => {
        setUsers(response.data.users);
        console.log("Response: ", response.data.users);
      })
      .catch((error) => {
        console.log(error.response);
      });
  }, [users.id]);

  const renderedUsers = users.map((user) =>
    user.account_type == 1 ? (
      <option value={user.id}>
        {user.first_name} {user.last_name}
      </option>
    ) : (
      console.log("Not a Blm User")
    )
  );

  const handleSubmit = (e) => {
    const user_id = parseInt(user, 10);
    const page_type = memorialTab.type;
    const location = blmLocation;
    const dob = dateOfBirth;
    const rip = dateOfDeath;
    const precinct = blmPrecinct;
    const state = blmState;
    const country = blmCountry;
    const name = blmName;
    const description = blmDescription;
    const relationship = blmRelationship;
    const latitude = blmLatitude;
    const longitude = blmLongitude;

    console.log("User ID: ", user_id);
    console.log("Page Type: ", page_type);
    console.log("Location: ", location);
    console.log("Date of Birth: ", dateOfBirth);
    console.log("Date of Death: ", dateOfDeath);
    console.log("Precinct: ", precinct);
    console.log("State: ", state);
    console.log("Country: ", country);
    console.log("Page Name: ", name);
    console.log("Description: ", description);
    console.log("Relationship: ", relationship);
    console.log("Latitude: ", latitude);
    console.log("Longitude: ", longitude);

    setLoading(true);
    axios
      .post(`/api/v1/admin/memorials/add`, {
        user_id,
        page_type,
        blm: {
          location,
          dob,
          rip,
          precinct,
          country,
          name,
          description,
          relationship,
          latitude,
          longitude,
        },
      })
      .then((response) => {
        console.log(response.data);
        setTimeout(() => {
          uploadImage(response.data.blm);
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

            <div
              className="d-flex flex-row-fluid bgi-size-cover bgi-position-top"
              style={{
                backgroundImage: backgroundImageTemporaryDisplay
                  ? `url( ${backgroundImageTemporaryDisplay})`
                  : `url( "assets/media/bg/bg-1.jpg" )`,
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
                            <div
                              className="image-input-wrapper"
                              style={{
                                backgroundImage: profileImageTemporaryDisplay
                                  ? `url( ${profileImageTemporaryDisplay})`
                                  : `url( "assets/media/users/blank.png" )`,
                              }}
                            />
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
                              Add BLM Information
                            </h3>

                            <span className="text-muted font-weight-bold font-size-sm mt-1">
                              Add user's blm information
                            </span>
                          </div>
                        </div>
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
                                      accept=".png, .jpg, .jpeg, .mov, .mp4, .avi"
                                      multiple
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
                                  Memorial User:
                                </h6>
                              </div>
                            </div>
                            {/*end::Row*/}
                            {/*begin::Group*/}
                            <div className="form-group row">
                              <label className="col-form-label col-3 text-lg-right text-left">
                                User
                              </label>
                              <div className="col-9">
                                <div className="input-group input-group-lg input-group-solid">
                                  <select
                                    id="users"
                                    className="form-control form-control-lg form-control-solid"
                                    name="users"
                                    onChange={handleUserChange}
                                  >
                                    <option selected>Select a User</option>
                                    {renderedUsers}
                                  </select>
                                </div>
                              </div>
                            </div>
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
                                />
                              </div>
                            </div>
                            {/*end::Group*/}
                            {/*begin::Group*/}
                            <div className="form-group row">
                              <label className="col-form-label col-3 text-lg-right text-left">
                                Relationship
                              </label>
                              <div className="col-9">
                                <input
                                  className="form-control form-control-lg form-control-solid placeholder-dark-75"
                                  type="text"
                                  name="relationship"
                                  onChange={handleRelationshipChange}
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
                                  onChange={handleDescriptionChange}
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
                                  type="date"
                                  name="dateOfBirth"
                                  onChange={handleDateOfBirthChange}
                                  required
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
                                  type="date"
                                  name="dateOfDeath"
                                  onChange={handleDateOfDeathChange}
                                  required
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
                                  type="text"
                                  name="location"
                                  onChange={handleLocationChange}
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
                                  type="text"
                                  name="precinct"
                                  onChange={handlePrecinctChange}
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
                                  type="text"
                                  name="state"
                                  onChange={handleStateChange}
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
                                  type="text"
                                  name="country"
                                  onChange={handleCountryChange}
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
                                  type="text"
                                  name="latitude"
                                  onChange={handleLatitudeChange}
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
                                  type="text"
                                  name="longitude"
                                  onChange={handleLongitudeChange}
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
            {/*end::Entry*/}
          </>
        )}
      </>
    </div>
  );
}
