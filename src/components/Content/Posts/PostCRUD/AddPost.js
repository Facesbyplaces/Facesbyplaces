import React, { useEffect, useState, useRef } from "react";
import axios from "../../../../auxiliary/axios";
import { SuccessModal } from "../Modals/SuccessModal";
import HashLoader from "react-spinners/HashLoader";
import { useDispatch, useSelector } from "react-redux";
import { TablePostAction, ViewPostAction } from "../../../../redux/actions";

export default function AddPost() {
  var dateFormat = require("dateformat");
  const dispatch = useDispatch();
  const { postTab } = useSelector(({ postTab }) => ({
    postTab: postTab,
  }));
  const [errors, setErrors] = useState("");
  const [showModal, setShowModal] = useState(false);
  const [loading, setLoading] = useState(false);
  const [pageType, setPageType] = useState(0);
  const type = postTab.type == 2 ? "Memorial" : "Blm";

  // ImageOrVideos Variables
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
  const [pageAdmin, setPageAdmin] = useState([]);
  const [pageId, setPageId] = useState([]);
  const [memorials, setMemorials] = useState([]);
  const [location, setLocation] = useState("");
  const [body, setBody] = useState("");
  const [latitude, setLatitude] = useState("");
  const [longitude, setLongitude] = useState("");

  // Form Data Images
  const imageOrVideosSelectedHandler = (e) => {
    {
      e.target.files[0]
        ? setImagesOrVideosTemporaryImageDisplay(
            URL.createObjectURL(e.target.files[0])
          )
        : console.log("No Images/Videos Attached.");
    }
    setImagesOrVideosFilesSelected(e.target.files[0]);
    console.log("Images Or Videos", imagesOrVideosFilesSelected);
  };

  const uploadImage = (postId) => {
    console.log("Images or Videos: ", imagesOrVideosFilesSelected);
    const formData = new FormData();
    imagesOrVideosFilesSelected
      ? formData.append("imagesOrVideos[]", imagesOrVideosFilesSelected)
      : console.log("No Images or Videos Uploaded");
    formData.append("id", postId);
    axios
      .put(`/api/v1/admin/posts/image/${postId}`, formData)
      .then((response) => {
        console.log(response.data);
      })
      .catch((error) => {
        console.log(error.response.data.errors);
        setErrors(error.response.data.errors);
      });
  };

  const fetchMemorial = (e) => {
    axios
      .get(
        `/api/v1/admin/posts/memorials?user_id=${e}&account_type=${postTab.type}`
      )
      .then((response) => {
        setMemorials(response.data.memorials);
        console.log("Response: ", response.data);
      })
      .catch((error) => {
        console.log(error.response);
      });
  };

  const fetchPageAdmin = (e) => {
    axios
      .get(`/api/v1/admin/posts/pageAdmins`)
      .then((response) => {
        response.data.pageadmins.map((pageadmin) =>
          pageadmin.account_type == e
            ? setUsers(response.data.pageadmins)
            : setUsers(response.data.pageadmins)
        );
        console.log("Response: ", response.data);
      })
      .catch((error) => {
        console.log(error.response);
      });
  };

  //
  const setPage = (e) => {
    setPageType(e);
    fetchPageAdmin(e);
  };

  // Form Data Handlers
  const handleUserChange = (e) => {
    setPageAdmin(e.target.value);
    fetchMemorial(e.target.value);
    console.log("User ID: ", e.target.value);
  };
  const handleMemorialChange = (e) => {
    setPageId(e.target.value);
  };
  const handleLocationChange = (e) => {
    setLocation(e.target.value);
  };
  const handleBodyChange = (e) => {
    setBody(e.target.value);
  };
  const handleLatitudeChange = (e) => {
    setLatitude(e.target.value);
  };
  const handleLongitudeChange = (e) => {
    setLongitude(e.target.value);
  };

  // Tab Data
  const handleTableClick = () => {
    dispatch(TablePostAction());
  };
  const handleViewClick = (id, option, type) => {
    dispatch(ViewPostAction({ id, option, type }));
  };

  // Modal
  const openModal = () => {
    setShowModal((prev) => !prev);
  };

  useEffect(() => {
    fetchPageAdmin(postTab.type);
    setPageType(postTab.type);
  }, [users.id]);

  const renderedUsers = users.map((user) =>
    user.account_type == pageType ? (
      <option value={user.id}>
        {user.first_name} {user.last_name}
      </option>
    ) : (
      console.log("Not a User")
    )
  );

  const renderedMemorials = memorials.map((memorial) => (
    <option value={memorial.id}>{memorial.name}</option>
  ));

  const handleSubmit = (e) => {
    // console.log("User ID: ", pageAdmin);
    // console.log("Account Type:", postTab.type);
    // console.log("Page Type: ", type);
    // console.log("Page ID: ", pageId);
    // console.log("Body: ", body);
    // console.log("Location: ", location);
    // console.log("Latitude: ", latitude);
    // console.log("Longitude: ", longitude);
    // console.log("ImagesOrVideos: ", imagesOrVideosFilesSelected);
    setLoading(true);

    axios
      .post(`/api/v1/admin/posts/create`, {
        user_id: pageAdmin,
        account_type: postTab.type,
        post: {
          page_type: type,
          page_id: pageId,
          body: body,
          location: location,
          latitude: latitude,
          longitude: longitude,
        },
      })
      .then((response) => {
        console.log(response.data);
        setTimeout(() => {
          uploadImage(response.data.post.id);
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
    <div className="d-flex flex-column flex-column-fluid mt-25">
      <SuccessModal showModal={showModal} setShowModal={setShowModal} />
      <>
        {loading ? (
          <div className="loader-container">
            <HashLoader color={"#04ECFF"} loading={loading} size={90} />
          </div>
        ) : (
          <>
            {/*begin::Entry*/}
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
                              Add Post Information
                            </h3>

                            <span className="text-muted font-weight-bold font-size-sm mt-1">
                              Add user's post information
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
                                  Memorial Post Info:
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
                                Post Type
                              </label>
                              <div className="col-9">
                                <div
                                  className="btn-group btn-group-toggle"
                                  style={{
                                    display: "inline-block",
                                    textAlign: "center",
                                  }}
                                  data-toggle="buttons"
                                >
                                  <label
                                    className={`btn btn-outline-warning ${
                                      pageType === 2 ? "active" : ""
                                    }`}
                                    style={{ width: "56px" }}
                                    onClick={() => setPage(2)}
                                  >
                                    <input type="radio" name="options" />
                                    ALM
                                  </label>
                                  <label
                                    className={`btn btn-outline-warning ${
                                      pageType === 1 ? "active" : ""
                                    }`}
                                    style={{ width: "56px" }}
                                  >
                                    <input
                                      type="radio"
                                      name="options"
                                      onClick={() => setPage(1)}
                                    />
                                    BLM
                                  </label>
                                </div>
                                <span className="form-text text-muted">
                                  Pick a post type first before choosing a page
                                  admin.
                                </span>
                              </div>
                            </div>
                            {/*end::Group*/}
                            {/*begin::Group*/}
                            <div className="form-group row">
                              <label className="col-form-label col-3 text-lg-right text-left">
                                Page Admins
                              </label>
                              <div className="col-9">
                                <div className="input-group input-group-lg input-group-solid">
                                  <select
                                    id="users"
                                    className="form-control form-control-lg form-control-solid"
                                    name="users"
                                    onChange={handleUserChange}
                                  >
                                    <option selected>Select Page Admin</option>
                                    {renderedUsers}
                                  </select>
                                </div>
                              </div>
                            </div>
                            {/*end::Group*/}
                            {/*begin::Group*/}
                            <div className="form-group row">
                              <label className="col-form-label col-3 text-lg-right text-left">
                                Memorial
                              </label>
                              <div className="col-9">
                                <div className="input-group input-group-lg input-group-solid">
                                  <select
                                    id="users"
                                    className="form-control form-control-lg form-control-solid"
                                    name="users"
                                    onChange={handleMemorialChange}
                                  >
                                    <option selected>Select a Memorial</option>
                                    {renderedMemorials}
                                  </select>
                                </div>
                                <span className="form-text text-muted">
                                  Pick a page admin first before choosing a
                                  memorial.
                                </span>
                              </div>
                            </div>
                            {/*end::Group*/}
                            {/*begin::Group*/}
                            <div className="form-group row">
                              <label className="col-form-label col-3 text-lg-right text-left">
                                Location
                              </label>
                              <div className="col-9">
                                <input
                                  className="form-control form-control-lg form-control-solid placeholder-dark-75"
                                  type="relationship"
                                  name="relationship"
                                  onChange={handleLocationChange}
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
                                  onChange={handleBodyChange}
                                />
                              </div>
                            </div>
                            {/*end::Group*/}
                            <div className="separator separator-solid my-10" />

                            {/*begin::Row*/}
                            <div className="row">
                              <div className="col-9">
                                <h6 className="text-dark font-weight-bold mb-10">
                                  Other Memorial Post Infos:
                                </h6>
                              </div>
                            </div>
                            {/*end::Row*/}
                            {/*begin::Group*/}
                            <div className="form-group row">
                              <label className="col-form-label col-3 text-lg-right text-left">
                                Lattitude
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
