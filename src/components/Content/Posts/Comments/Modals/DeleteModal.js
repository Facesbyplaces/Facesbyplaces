import React, { useState, memo } from "react";
import { useSelector, useDispatch } from "react-redux";
import { DeletePostAction } from "../../../../../../redux/actions";
import axios from "../../../../../auxiliary/axios";

//Loader
import HashLoader from "react-spinners/HashLoader";

export const DeleteModal = ({ showModal, setShowModal }) => {
  const dispatch = useDispatch();
  const [loading, setLoading] = useState(false);
  const { postTab } = useSelector(({ postTab }) => ({
    postTab: postTab,
  }));

  const handleDeleteMemorial = (id, page, option) => {
    setLoading(true);
    console.log("ID: ", postTab.id);
    axios
      .delete(`/api/v1/admin/posts/${postTab.id}`, {
        id: postTab.id,
      })
      .then((response) => {
        console.log(response.data);
        setLoading(false);
        dispatch(DeletePostAction({ id, page, option }));
      })
      .catch((error) => {
        console.log(error.response);
      });
  };

  return (
    <>
      {showModal ? (
        <div className="modal" showModal={showModal}>
          {loading ? (
            <div className="loader-container">
              <HashLoader color={"#04ECFF"} loading={loading} size={90} />
            </div>
          ) : (
            <div className="modal-dialog modal-dialog-centered" role="document">
              <div className="modal-content">
                <div className="pt-10">
                  <span className="svg-icon svg-icon-10x svg-icon-danger">
                    <svg
                      width="24px"
                      height="24px"
                      viewBox="0 0 24 24"
                      version="1.1"
                      xmlns="http://www.w3.org/2000/svg"
                      xmlnsXlink="http://www.w3.org/1999/xlink"
                    >
                      {/* Generator: Sketch 50.2 (55047) - http://www.bohemiancoding.com/sketch */}
                      <title>Stockholm-icons / Code / Error-circle</title>
                      <desc>Created with Sketch.</desc>
                      <defs />
                      <g
                        id="Stockholm-icons-/-Code-/-Error-circle"
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
                          d="M12.0355339,10.6213203 L14.863961,7.79289322 C15.2544853,7.40236893 15.8876503,7.40236893 16.2781746,7.79289322 C16.6686989,8.18341751 16.6686989,8.81658249 16.2781746,9.20710678 L13.4497475,12.0355339 L16.2781746,14.863961 C16.6686989,15.2544853 16.6686989,15.8876503 16.2781746,16.2781746 C15.8876503,16.6686989 15.2544853,16.6686989 14.863961,16.2781746 L12.0355339,13.4497475 L9.20710678,16.2781746 C8.81658249,16.6686989 8.18341751,16.6686989 7.79289322,16.2781746 C7.40236893,15.8876503 7.40236893,15.2544853 7.79289322,14.863961 L10.6213203,12.0355339 L7.79289322,9.20710678 C7.40236893,8.81658249 7.40236893,8.18341751 7.79289322,7.79289322 C8.18341751,7.40236893 8.81658249,7.40236893 9.20710678,7.79289322 L12.0355339,10.6213203 Z"
                          id="Combined-Shape"
                          fill="#000000"
                        />
                      </g>
                    </svg>
                  </span>
                </div>
                <div className="modal-header">
                  <h2 className="modal-dialog">
                    <b>Are you sure?</b>
                  </h2>
                </div>
                <div className="modal-body">
                  <h5 className="modal-dialog">
                    Do you really want to delete this post? This process cannot
                    be undone.
                  </h5>
                </div>
                <div className="modal-footer">
                  <button
                    type="button"
                    className="btn btn-primary font-weight-bold"
                    data-dismiss="modal"
                    onClick={() => setShowModal((prev) => !prev)}
                  >
                    Close
                  </button>
                  <button
                    type="button"
                    className="btn btn-danger font-weight-bold"
                    onClick={() => handleDeleteMemorial("", "", "d")}
                  >
                    Delete
                  </button>
                </div>
              </div>
            </div>
          )}
          )}
        </div>
      ) : null}
    </>
  );
};
