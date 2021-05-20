import React, { useState, useEffect } from "react";
import axios from "../../../../../../auxiliary/axios";

//Loader
import HashLoader from "react-spinners/HashLoader";

export const TransactionModal = ({ showModal, setShowModal, transaction }) => {
  var dateFormat = require("dateformat");

  return (
    <>
      {showModal ? (
        <div className="modal" showModal={showModal}>
          <div className="modal-dialog modal-dialog-centered" role="document">
            <div className="modal-content">
              <div className="modal-header" style={{ textAlign: "left" }}>
                <h4 className="modal-dialog">
                  <b>Transaction Info:</b>
                </h4>
              </div>
              <div className="modal-body">
                <form className="form">
                  <div className="card-body pt-0 pb-0">
                    <div className="form-group" style={{ textAlign: "left" }}>
                      <label>Memorial:</label>
                      <input
                        type="email"
                        className="form-control form-control-solid"
                        value={transaction.page.name}
                        disabled
                      />
                    </div>
                    <div className="form-group" style={{ textAlign: "left" }}>
                      <label>Sender:</label>
                      <input
                        type="email"
                        className="form-control form-control-solid"
                        value={
                          transaction.user.first_name +
                          " " +
                          transaction.user.last_name
                        }
                        disabled
                      />
                      {/* <span className="form-text text-muted">
                        We'll never share your email with anyone else
                      </span> */}
                    </div>
                    <div className="form-group" style={{ textAlign: "left" }}>
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
                    </div>
                    <div className="form-group" style={{ textAlign: "left" }}>
                      <label>Date Donated:</label>
                      <div className="input-group input-group-lg">
                        <input
                          type="text"
                          className="form-control form-control-solid"
                          value={dateFormat(
                            transaction.created_at,
                            "mmmm d, yyyy"
                          )}
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
                      onClick={() => setShowModal((prev) => !prev)}
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
