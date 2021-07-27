import React from "react";

export const ViewCommentModal = ({
  showViewModal,
  setShowViewModal,
  comment,
}) => {
  var dateFormat = require("dateformat");

  return (
    <>
      {showViewModal ? (
        <div className="modal" showViewModal={showViewModal}>
          <div className="modal-dialog modal-dialog-centered" role="document">
            <div className="modal-content">
              <div className="modal-header" style={{ textAlign: "left" }}>
                <h4 className="modal-dialog">
                  <b>Comment Info:</b>
                </h4>
              </div>
              <div className="modal-body">
                <form className="form">
                  <div className="card-body pt-0 pb-0">
                    <div className="form-group" style={{ textAlign: "left" }}>
                      <label>Comment:</label>
                      <input
                        type="email"
                        className="form-control form-control-solid"
                        value={comment.body}
                        disabled
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
                      {/* <span className="form-text text-muted">
                        We'll never share your email with anyone else
                      </span> */}
                    </div>
                    {/* <div className="form-group" style={{ textAlign: "left" }}>
                      <label>Amount:</label>
                      <div className="input-group input-group-lg">
                        <div className="input-group-prepend">
                          <span className="input-group-text">$</span>
                        </div>
                        <input
                          type="text"
                          className="form-control form-control-solid"
                          value={transaction.amount}
                          disabled
                        />
                      </div>
                    </div> */}
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
                    </div>
                  </div>
                  <div className="card-footer">
                    <button
                      type="button"
                      className="btn btn-primary btn-md btn-block font-weight-bold"
                      data-dismiss="modal"
                      onClick={() => setShowViewModal((prev) => !prev)}
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
