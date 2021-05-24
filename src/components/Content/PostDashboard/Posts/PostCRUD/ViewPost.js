import React, { useEffect, useState } from "react";
import axios from "../../../../../auxiliary/axios";

import { useDispatch, useSelector } from "react-redux";
import { TablePostAction, EditPostAction } from "../../../../../redux/actions";
import CommentTable from "../CommentTable/CommentTable";

export default function ViewPost() {
  var dateFormat = require("dateformat");
  const dispatch = useDispatch();

  // Posts
  const { postTab } = useSelector(({ postTab }) => ({
    postTab: postTab,
  }));
  const [post, setPost] = useState([]);
  const [postPage, setPostPage] = useState([]);
  // Images
  const [imagesOrVideos, setImagesOrVideos] = useState([]);
  const [imagesOrVideosEmpty, setImagesOrVideosEmpty] = useState(false);
  // Comments
  const [comments, setComments] = useState([]);
  const [page, setPage] = useState(1);

  const handleTableClick = () => {
    dispatch(TablePostAction());
  };

  const handleEditClick = (id, option, type) => {
    console.log(id, option, type);
    dispatch(EditPostAction({ id, option, type }));
  };

  const fetchComments = (page) => {
    axios
      .get(`/api/v1/admin/comments`, { params: { page: page, id: post.id } })
      .then((response) => {
        console.log("Comments: ", response.data);
        setComments(response.data.comments);
        // setMemorialPosts(memorials);
        // setPosts(response.data.posts);

        // console.log("Response: ", response.data.posts);
      })
      .catch((error) => {
        console.log(error.response);
      });
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
            margin: "auto",
          }}
        >
          <img
            src={iOV}
            alt="image"
            style={{
              height: "100%",
              backgroundColor: "#f3f6f9",
              margin: "auto",
            }}
          />
        </div>
      </div>
    );
  });

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
    fetchComments(page);
  }, post.id);

  return (
    <div className="d-flex flex-column flex-column-fluid mt-25">
      <div className="container mt-n15 gutter-b">
        <div className="card card-custom">
          <div className="card-body">
            <form className="form">
              <div className="tab-content">
                {/*begin::Tab*/}
                <div className="tab-pane show active px-7 mt-5">
                  <div className="card-header py-3 pl-5">
                    <div className="card-title align-items-start flex-column mb-2">
                      <h3 className="card-label font-weight-bolder text-dark">
                        Post Information
                      </h3>

                      <span className="text-muted font-weight-bold font-size-sm mt-1">
                        User's post information
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
                            <h1>No Images/Videos Attached</h1>
                            {/*end::Pic*/}
                          </div>
                        </div>
                      ) : (
                        <div className="form-group row pl-4">
                          {renderedImagesOrVideos}
                        </div>
                      )}
                      {/*end::Group*/}
                      {/*end::Row*/}
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
                            className="form-control form-control-lg border-0 placeholder-dark-75"
                            type="username"
                            name="username"
                            defaultValue={postPage.name}
                            disabled
                          />
                        </div>
                      </div>
                      {/*end::Group*/}
                      {/*begin::Group*/}
                      <div className="form-group row">
                        <label className="col-form-label col-3 text-lg-right text-left">
                          Page Type
                        </label>
                        <div className="col-9">
                          <div
                            className="btn-group btn-group-toggle"
                            data-toggle="buttons"
                          >
                            {postPage.page_type === "Memorial" ? (
                              <button
                                type="button"
                                className={"btn active btn-outline-info mr-2"}
                                style={{ width: "206px" }}
                              >
                                ALM
                              </button>
                            ) : (
                              <button
                                type="button"
                                className={"btn btn-outline-info mr-2"}
                                style={{ width: "206px" }}
                                disabled
                              >
                                ALM
                              </button>
                            )}
                            {postPage.page_type === "Blm" ? (
                              <button
                                type="button"
                                className={"btn active btn-outline-info mr-2"}
                                style={{ width: "206px" }}
                              >
                                Blm
                              </button>
                            ) : (
                              <button
                                type="button"
                                className={"btn btn-outline-info mr-2"}
                                style={{ width: "206px" }}
                                disabled
                              >
                                Blm
                              </button>
                            )}
                          </div>
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
                            defaultValue={post.location}
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
                            defaultValue={post.body}
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
                            className="form-control form-control-lg border-0 placeholder-dark-75"
                            type="text"
                            name="latitude"
                            defaultValue={post.latitude}
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
                            type="text"
                            name="longitude"
                            defaultValue={post.longitude}
                            disabled
                          />
                        </div>
                      </div>
                      {/*end::Group*/}
                      {/*begin::Group*/}
                      <div className="form-group row">
                        <label className="col-form-label col-3 text-lg-right text-left">
                          Date Created
                        </label>
                        <div className="col-9">
                          <input
                            className="form-control form-control-lg border-0 placeholder-dark-75"
                            name="created-at"
                            defaultValue={dateFormat(
                              post.created_at,
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
                                    handleEditClick(post.id, "e", 2)
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
      <CommentTable comments={comments} />
    </div>
  );
}
