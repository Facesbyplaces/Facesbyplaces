import React, { useState, useEffect } from "react";
import axios from "../../../../../../auxiliary/axios";

//Loader
import HashLoader from "react-spinners/HashLoader";

export const PayoutModal = ({
  showModal,
  setShowModal,
  setShowSuccessModal,
  transaction,
}) => {
  var dateFormat = require("dateformat");

  const updateTransactionStatus = (transaction) => {
    axios
      .put(`/api/v1/admin/transactions/payout/${transaction}`)
      .then((response) => {
        console.log("Response: ", response.data);
        setShowModal((prev) => !prev);
        setShowSuccessModal((prev) => !prev);
      })
      .catch((error) => {
        console.log(error.errors);
      });
  };

  const handlePayoutClick = (transaction) => {
    updateTransactionStatus(transaction);
  };

  return (
    <>
      {showModal ? (
        <div className="modal" showModal={showModal}>
          <div className="modal-dialog modal-dialog-centered" role="document">
            <div className="modal-content">
              <div className="pt-10">
                <span className="svg-icon svg-icon-10x svg-icon-success">
                  <svg
                    width="24px"
                    height="24px"
                    viewBox="0 0 24 24"
                    version="1.1"
                    xmlns="http://www.w3.org/2000/svg"
                    xmlnsXlink="http://www.w3.org/1999/xlink"
                  >
                    {/* Generator: Sketch 50.2 (55047) - http://www.bohemiancoding.com/sketch */}
                    <title>Stockholm-icons / Code / Question-circle</title>
                    <desc>Created with Sketch.</desc>
                    <defs />
                    <g
                      id="Stockholm-icons-/-Code-/-Question-circle"
                      stroke="none"
                      strokeWidth={1}
                      fill="none"
                      fillRule="evenodd"
                    >
                      <rect id="bound" x={0} y={0} width={24} height={24} />
                      <circle
                        id="Oval-5"
                        fill="#000000"
                        opacity="0.3"
                        cx={12}
                        cy={12}
                        r={10}
                      />
                      <path
                        d="M12,16 C12.5522847,16 13,16.4477153 13,17 C13,17.5522847 12.5522847,18 12,18 C11.4477153,18 11,17.5522847 11,17 C11,16.4477153 11.4477153,16 12,16 Z M10.591,14.868 L10.591,13.209 L11.851,13.209 C13.447,13.209 14.602,11.991 14.602,10.395 C14.602,8.799 13.447,7.581 11.851,7.581 C10.234,7.581 9.121,8.799 9.121,10.395 L7.336,10.395 C7.336,7.875 9.31,5.922 11.851,5.922 C14.392,5.922 16.387,7.875 16.387,10.395 C16.387,12.915 14.392,14.868 11.851,14.868 L10.591,14.868 Z"
                        id="Combined-Shape"
                        fill="#000000"
                      />
                    </g>
                  </svg>
                </span>
              </div>
              <div className="modal-body">
                <h1 className="modal-dialog">
                  <b>Payout?</b>
                </h1>

                <h4 className="modal-dialog">
                  Are you sure{" "}
                  <b style={{ color: "red" }}>you have transferred</b> the
                  donation of ${transaction.amount / 100} to{" "}
                  <b>
                    {transaction.owner.first_name +
                      " " +
                      transaction.owner.last_name}
                  </b>
                  ?
                </h4>
              </div>
              <div className="card-footer">
                <button
                  type="submit"
                  className="btn btn-success font-weight-bold mr-2"
                  style={{ width: "100px" }}
                  onClick={() => handlePayoutClick(transaction.id)}
                >
                  Payout
                </button>
                <button
                  type="button"
                  className="btn btn-secondary font-weight-bold"
                  style={{ width: "100px" }}
                  data-dismiss="modal"
                  onClick={() => setShowModal((prev) => !prev)}
                >
                  Cancel
                </button>
              </div>
            </div>
          </div>
        </div>
      ) : null}
    </>
  );
};
