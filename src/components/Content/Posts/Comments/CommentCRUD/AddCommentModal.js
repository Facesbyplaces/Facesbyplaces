import React, { useState } from "react";
import axios from "../../../../../auxiliary/axios";
import HashLoader from "react-spinners/HashLoader";
import { SuccessModal } from "../Modals/SuccessModal";

export const AddCommentModal = ({
  id,
  showAddModal,
  setShowAddModal,
  fetched,
  setFetched,
}) => {
  const [body, setBody] = useState("");
  const [users, setUsers] = useState([]);
  const [user, setUser] = useState();
  const [pageType, setPageType] = useState(2);

  const [showModal, setShowModal] = useState(false);
  const [action, setAction] = useState("add");
  const [loader, setLoader] = useState(false);

  const fetchUsers = (e) => {
    axios
      .get(`/api/v1/admin/comments/users/selection/${e}`)
      .then((response) => {
        console.log(response);
        setUsers(response.data.users);
        setFetched(true);
      })
      .catch((error) => {
        console.log(error.response);
      });
  };

  const createComment = (id, user, body) => {
    setLoader(true);
    axios
      .post(`/api/v1/admin/comments/add`, {
        user_id: user,
        comment: {
          post_id: id,
          body: body,
        },
        page_type: pageType,
      })
      .then((response) => {
        setLoader(false);
        setShowModal((prev) => !prev);
      })
      .catch((error) => {
        console.log(error.response);
      });
  };

  const handleBodyChange = (e) => {
    setBody(e.target.value);
  };

  const handleUserChange = (e) => {
    setUser(e.target.value);
  };

  const handleSaveClick = (id) => {
    console.log("Post ID: ", id);
    console.log("User ID: ", user);
    console.log("Body: ", body);

    createComment(id, user, body);
  };

  const handlePageTypeClick = (e) => {
    setPageType(e);
    fetchUsers(e);
  };

  {
    fetched ? console.log() : fetchUsers(2);
  }

  const renderedUsers = users.map((user) => (
    <option value={user.id}>
      {user.first_name} {user.last_name}
    </option>
  ));

  return (
    <>
      {showAddModal ? (
        <>
          <div className="modal" showAddModal={showAddModal}>
            <div className="modal-dialog modal-dialog-centered" role="document">
              {loader ? (
                <div
                  className="modal-content"
                  style={{ height: "500px", width: "448px" }}
                >
                  <HashLoader
                    color={"#04ECFF"}
                    loading={loader}
                    size={70}
                    css={{ margin: "auto" }}
                  />
                </div>
              ) : (
                <div className="modal-content">
                  <div className="modal-header" style={{ textAlign: "left" }}>
                    <h4 className="modal-dialog">
                      <b>Add Comment Info:</b>
                    </h4>
                  </div>
                  <div className="modal-body">
                    <form className="form">
                      <div className="card-body pt-0 pb-0">
                        <div
                          className="form-group"
                          style={{ textAlign: "left" }}
                        >
                          <label>Account Type:</label>
                          <div className="input-group input-group-lg">
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
                                style={{ width: "198px" }}
                                onClick={() => handlePageTypeClick(2)}
                              >
                                <input type="radio" name="options" />
                                ALM
                              </label>
                              <label
                                className={`btn btn-outline-warning ${
                                  pageType === 1 ? "active" : ""
                                }`}
                                style={{ width: "198px" }}
                              >
                                <input
                                  type="radio"
                                  name="options"
                                  onClick={() => handlePageTypeClick(1)}
                                />
                                BLM
                              </label>
                            </div>
                            <span className="form-text text-muted">
                              Pick an account type first before choosing a user.
                            </span>
                          </div>
                        </div>
                      </div>
                      <div className="card-body pt-0 pb-0">
                        <div
                          className="form-group"
                          style={{ textAlign: "left" }}
                        >
                          <label>User:</label>
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
                      <div className="card-body pt-0 pb-0">
                        <div
                          className="form-group"
                          style={{ textAlign: "left" }}
                        >
                          <label>Write a comment:</label>
                          <textarea
                            className="form-control form-control-solid form-control-lg"
                            id="exampleTextarea"
                            rows={6}
                            onChange={handleBodyChange}
                          />
                        </div>
                      </div>
                      <div className="card-footer">
                        <button
                          type="button"
                          className="btn btn-success font-weight-bold mr-2"
                          onClick={() => handleSaveClick(id)}
                        >
                          Save changes
                        </button>
                        <button
                          type="button"
                          className="btn btn-secondary font-weight-bold"
                          data-dismiss="modal"
                          onClick={() => setShowAddModal((prev) => !prev)}
                        >
                          Close
                        </button>
                      </div>
                    </form>
                  </div>
                </div>
              )}
            </div>
            )}
            <SuccessModal
              showModal={showModal}
              setShowModal={setShowModal}
              setShowAddModal={setShowAddModal}
              action={action}
            />
          </div>
        </>
      ) : null}
    </>
  );
};
