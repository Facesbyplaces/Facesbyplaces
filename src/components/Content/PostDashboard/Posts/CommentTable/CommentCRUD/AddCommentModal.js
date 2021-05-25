import React, { useState } from "react";

export const AddCommentModal = ({ id, showAddModal, setShowAddModal }) => {
  const [body, setBody] = useState("");

  const handleBodyChange = (e) => {
    setBody(e.target.value);
  };

  const handleSaveClick = (id) => {
    console.log("ID: ", id);
    console.log("Body: ", body);
  };

  return (
    <>
      {showAddModal ? (
        <div className="modal" showAddModal={showAddModal}>
          <div className="modal-dialog modal-dialog-centered" role="document">
            <div className="modal-content">
              <div className="modal-header" style={{ textAlign: "left" }}>
                <h4 className="modal-dialog">
                  <b>Add Comment Info:</b>
                </h4>
              </div>
              <div className="modal-body">
                <form className="form">
                  <div className="card-body pt-0 pb-0">
                    <div className="form-group" style={{ textAlign: "left" }}>
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
          </div>
          )}
        </div>
      ) : null}
    </>
  );
};
