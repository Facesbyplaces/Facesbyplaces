import React, { useEffect, useState, useRef } from "react";
import axios from "../../../../../auxiliary/axios";
import { SuccessModal } from "./SuccessModal";
import HashLoader from "react-spinners/HashLoader";
import { useDispatch, useSelector } from "react-redux";
import { TablePostAction, ViewPostAction } from "../../../../../redux/actions";

export default function EditPost() {
  var dateFormat = require("dateformat");
  const dispatch = useDispatch();
  const { postTab } = useSelector(({ postTab }) => ({
    postTab: postTab,
  }));
  const [errors, setErrors] = useState("");
  const [showModal, setShowModal] = useState(false);
  const [loading, setLoading] = useState(false);
  const type = postTab.type == 2 ? "Memorial" : "Blm";

  // Fetched Data
  const [post, setPost] = useState([]);
  const [postPage, setPostPage] = useState([]);

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

  const uploadImage = () => {
    console.log(post);
    console.log("Images or Videos: ", imagesOrVideosFilesSelected);
    const formData = new FormData();
    imagesOrVideosFilesSelected
      ? formData.append("imagesOrVideos[]", imagesOrVideosFilesSelected)
      : console.log("No Images or Videos Uploaded");
    formData.append("id", postTab.id);
    axios
      .put(`/api/v1/admin/posts/image/${postTab.id}`, formData)
      .then((response) => {
        console.log(response.data);
      })
      .catch((error) => {
        console.log(error.response.data.errors);
        setErrors(error.response.data.errors);
      });
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
                  {/* Generator: Sketch 50.2 (55047) - http://www.bohemiancoding.com/sketch */}
                  <title>Stockholm-icons / Navigation / Close</title>
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

              <input
                type="file"
                accept=".png, .jpg, .jpeg"
                onChange={imageOrVideosSelectedHandler}
              />
              <input type="hidden" name="profile_avatar_remove" />
            </label>
          </div>
        </div>
      </div>
    );
  });

  // Form Data Handlers
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
    axios
      .get(`/api/v1/admin/posts/${postTab.id}`)
      .then((response) => {
        setPost(response.data);
        setPostPage(response.data.page);
        response.data.imagesOrVideos
          ? setImagesOrVideos(response.data.imagesOrVideos)
          : setImagesOrVideosEmpty(true);
        console.log("Response: ", response.data);
      })
      .catch((error) => {
        console.log(error.errors);
      });
  }, post.id);

  const handleSubmit = (e) => {
    // If Form Data empty
    const memorialPostBody = body ? body : post.body;
    const postPageLocation = location ? location : post.location;
    const memorialPostLatitude = latitude ? latitude : post.latitude;
    const memorialPostLongitude = longitude ? longitude : post.longitude;

    console.log("Body: ", memorialPostBody);
    console.log("Location: ", postPageLocation);
    console.log("Latitude: ", memorialPostLatitude);
    console.log("Longitude: ", memorialPostLongitude);
    setLoading(true);

    axios
      .put(`/api/v1/admin/posts/edit/${post.id}`, {
        post: {
          page_type: type,
          page_id: post.page.id,
          body: memorialPostBody,
          location: postPageLocation,
          latitude: memorialPostLatitude,
          longitude: memorialPostLongitude,
        },
      })
      .then((response) => {
        console.log(response.data);
        setTimeout(() => {
          uploadImage();
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
                              Edit Post Information
                            </h3>

                            <span className="text-muted font-weight-bold font-size-sm mt-1">
                              Edit user's post information
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
                            <div className="form-group row">
                              <label className="col-form-label col-3 text-lg-right text-left">
                                Memorial Name
                              </label>
                              <div className="col-9">
                                <input
                                  className="form-control form-control-lg form-control-solid placeholder-dark-75"
                                  type="text"
                                  name="page_name"
                                  defaultValue={postPage.name}
                                  disabled
                                />
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
                                  defaultValue={post.location}
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
                                  defaultValue={post.body}
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
                                  defaultValue={post.latitude}
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
                                  defaultValue={post.longitude}
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
                                          handleViewClick(post.id, "v", 2)
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
