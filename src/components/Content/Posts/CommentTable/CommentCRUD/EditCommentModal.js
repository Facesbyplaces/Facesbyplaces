import React, { useState } from "react";
import axios from "../../../../../auxiliary/axios";

//Loader
import HashLoader from "react-spinners/HashLoader";

export const EditCommentModal = ({
  showEditModal,
  setShowEditModal,
  comment,
}) => {
  var dateFormat = require("dateformat");

  const [editComment, setEditComment] = useState("");

  const handleCommentChange = (e) => {
    setEditComment(e.target.value);
  };

  const handleSaveClick = (id) => {
    console.log(id);
    console.log(editComment);
    const finalComment = editComment ? editComment : comment.body;
    axios
      .put(`/api/v1/admin/comments/edit/${id}`, {
        comment: {
          body: finalComment,
        },
      })
      .then((response) => {
        console.log(response.data);
        window.location.reload(false);
      })
      .catch((error) => {
        console.log(error.response);
      });
  };

  return (
    <>
      {showEditModal ? (
        <div className="modal" showModal={showEditModal}>
          <div className="modal-dialog modal-dialog-centered" role="document">
            <div className="modal-content">
              <div className="modal-header" style={{ textAlign: "left" }}>
                <h4 className="modal-dialog">
                  <b>Edit Comment Info:</b>
                </h4>
              </div>
              <div className="modal-body">
                <form className="form">
                  <div className="card-body pt-0 pb-0">
                    <div className="form-group" style={{ textAlign: "left" }}>
                      <label>Comment:</label>
                      <input
                        type="text"
                        className="form-control form-control-solid"
                        onChange={handleCommentChange}
                        defaultValue={comment.body}
                      />
                    </div>
                    <div className="form-group" style={{ textAlign: "left" }}>
                      <label>User:</label>
                      <input
                        type="email"
                        className="form-control form-control-solid"
                        value={
                          comment.user.first_name + " " + comment.user.last_name
                        }
                        disabled
                      />
                      <span className="form-text text-muted">
                        User cannot be edited.
                      </span>
                    </div>
                    <div className="form-group" style={{ textAlign: "left" }}>
                      <label>Commented on:</label>
                      <div className="input-group input-group-lg">
                        <input
                          type="text"
                          className="form-control form-control-solid"
                          value={dateFormat(comment.created_at, "mmmm d, yyyy")}
                          disabled
                        />
                      </div>
                      <span className="form-text text-muted">
                        Date cannot be edited.
                      </span>
                    </div>
                  </div>
                  <div className="card-footer">
                    <button
                      type="button"
                      className="btn btn-success font-weight-bold mr-2"
                      onClick={() => handleSaveClick(comment.id)}
                    >
                      Save changes
                    </button>
                    <button
                      type="button"
                      className="btn btn-secondary font-weight-bold"
                      data-dismiss="modal"
                      onClick={() => setShowEditModal((prev) => !prev)}
                    >
                      Close
                    </button>
                  </div>
                </form>
              </div>
            </div>
          </div>
          )}
        </div>
      ) : null}
    </>
  );
};
