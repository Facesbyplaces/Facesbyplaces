import React, { useState } from "react";
//Loader
import HashLoader from "react-spinners/HashLoader";

import { ViewCommentModal } from "../CommentCRUD/ViewCommentModal";
import { EditCommentModal } from "../CommentCRUD/EditCommentModal";
import { DeleteCommentModal } from "../CommentCRUD/DeleteCommentModal";

export default function DataTableRowPostCommentsData({ search, comments }) {
  const [showViewModal, setShowViewModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [postComment, setPostComment] = useState(false);

  const handleViewClick = (comment) => {
    // console.log(comment);
    setPostComment(comment);
    setShowViewModal((prev) => !prev);
  };

  const handleEditClick = (comment) => {
    // console.log(comment);
    setPostComment(comment);
    setShowEditModal((prev) => !prev);
  };

  const handleDeleteClick = (id) => {
    // console.log(id);
    setPostComment(id);
    setShowDeleteModal((prev) => !prev);
  };

  const renderedComments = comments.map((comment) => (
    <tr>
      <td className="pl-2 py-6">
        {/* <label className="checkbox checkbox-lg checkbox-inline">
          <input type="checkbox" defaultValue={1} />
          <span />
        </label> */}
      </td>
      <td>
        <a
          href="#"
          className="text-dark-75 font-weight-bolder text-hover-primary font-size-lg"
        >
          {comment.id}
        </a>
      </td>
      <td className="pl-0 py-6">
        <span className="text-dark-75 font-weight-bolder d-block font-size-lg">
          {comment.user.first_name + " " + comment.user.last_name}
        </span>
      </td>
      <td className="pl-0 py-6">
        <span className="text-dark-75 font-weight-bolder d-block font-size-lg">
          {comment.body}
        </span>
      </td>
      <td className="pr-2 text-left">
        {/* View User Icon */}
        <a
          className="btn btn-icon btn-light btn-hover-primary btn-sm"
          onClick={() => handleViewClick(comment)}
        >
          <span className="svg-icon svg-icon-md svg-icon-primary">
            {/*begin::Svg Icon | path:assets/media/svg/icons/General/Settings-1.svg*/}
            <svg
              width="24px"
              height="24px"
              viewBox="0 0 24 24"
              version="1.1"
              xmlns="http://www.w3.org/2000/svg"
              xmlnsXlink="http://www.w3.org/1999/xlink"
            >
              {/* Generator: Sketch 50.2 (55047) - http://www.bohemiancoding.com/sketch */}
              <title>Stockholm-icons / Communication / Chat4</title>
              <desc>Created with Sketch.</desc>
              <defs />
              <g
                id="Stockholm-icons-/-Communication-/-Chat4"
                stroke="none"
                strokeWidth={1}
                fill="none"
                fillRule="evenodd"
              >
                <rect id="bound" x={0} y={0} width={24} height={24} />
                <path
                  d="M21.9999843,15.009808 L22.0249378,15 L22.0249378,19.5857864 C22.0249378,20.1380712 21.5772226,20.5857864 21.0249378,20.5857864 C20.7597213,20.5857864 20.5053674,20.4804296 20.317831,20.2928932 L18.0249378,18 L5,18 C3.34314575,18 2,16.6568542 2,15 L2,6 C2,4.34314575 3.34314575,3 5,3 L19,3 C20.6568542,3 22,4.34314575 22,6 L22,15 C22,15.0032706 21.9999948,15.0065399 21.9999843,15.009808 Z M6.16794971,10.5547002 C7.67758127,12.8191475 9.64566871,14 12,14 C14.3543313,14 16.3224187,12.8191475 17.8320503,10.5547002 C18.1384028,10.0951715 18.0142289,9.47430216 17.5547002,9.16794971 C17.0951715,8.86159725 16.4743022,8.98577112 16.1679497,9.4452998 C15.0109146,11.1808525 13.6456687,12 12,12 C10.3543313,12 8.9890854,11.1808525 7.83205029,9.4452998 C7.52569784,8.98577112 6.90482849,8.86159725 6.4452998,9.16794971 C5.98577112,9.47430216 5.86159725,10.0951715 6.16794971,10.5547002 Z"
                  id="Combined-Shape"
                  fill="#000000"
                />
              </g>
            </svg>

            {/*end::Svg Icon*/}
          </span>
        </a>
        {/* Edit Icon */}
        <a
          className="btn btn-icon btn-light btn-hover-primary btn-sm mx-3"
          onClick={() => handleEditClick(comment)}
        >
          <span className="svg-icon svg-icon-md svg-icon-primary">
            {/*begin::Svg Icon | path:assets/media/svg/icons/Communication/Write.svg*/}
            <svg
              xmlns="http://www.w3.org/2000/svg"
              xmlnsXlink="http://www.w3.org/1999/xlink"
              width="24px"
              height="24px"
              viewBox="0 0 24 24"
              version="1.1"
            >
              <g stroke="none" strokeWidth={1} fill="none" fillRule="evenodd">
                <rect x={0} y={0} width={24} height={24} />
                <path
                  d="M12.2674799,18.2323597 L12.0084872,5.45852451 C12.0004303,5.06114792 12.1504154,4.6768183 12.4255037,4.38993949 L15.0030167,1.70195304 L17.5910752,4.40093695 C17.8599071,4.6812911 18.0095067,5.05499603 18.0083938,5.44341307 L17.9718262,18.2062508 C17.9694575,19.0329966 17.2985816,19.701953 16.4718324,19.701953 L13.7671717,19.701953 C12.9505952,19.701953 12.2840328,19.0487684 12.2674799,18.2323597 Z"
                  fill="#000000"
                  fillRule="nonzero"
                  transform="translate(14.701953, 10.701953) rotate(-135.000000) translate(-14.701953, -10.701953)"
                />
                <path
                  d="M12.9,2 C13.4522847,2 13.9,2.44771525 13.9,3 C13.9,3.55228475 13.4522847,4 12.9,4 L6,4 C4.8954305,4 4,4.8954305 4,6 L4,18 C4,19.1045695 4.8954305,20 6,20 L18,20 C19.1045695,20 20,19.1045695 20,18 L20,13 C20,12.4477153 20.4477153,12 21,12 C21.5522847,12 22,12.4477153 22,13 L22,18 C22,20.209139 20.209139,22 18,22 L6,22 C3.790861,22 2,20.209139 2,18 L2,6 C2,3.790861 3.790861,2 6,2 L12.9,2 Z"
                  fill="#000000"
                  fillRule="nonzero"
                  opacity="0.3"
                />
              </g>
            </svg>
            {/*end::Svg Icon*/}
          </span>
        </a>
        {/* Delete Icon */}
        <a
          className="btn btn-icon btn-light btn-hover-primary btn-sm"
          data-toggle="modal"
          data-target="#exampleModalSizeSm"
          onClick={() => handleDeleteClick(comment.id)}
        >
          <span className="svg-icon svg-icon-md svg-icon-primary">
            {/*begin::Svg Icon | path:assets/media/svg/icons/General/Trash.svg*/}
            <svg
              xmlns="http://www.w3.org/2000/svg"
              xmlnsXlink="http://www.w3.org/1999/xlink"
              width="24px"
              height="24px"
              viewBox="0 0 24 24"
              version="1.1"
            >
              <g stroke="none" strokeWidth={1} fill="none" fillRule="evenodd">
                <rect x={0} y={0} width={24} height={24} />
                <path
                  d="M6,8 L6,20.5 C6,21.3284271 6.67157288,22 7.5,22 L16.5,22 C17.3284271,22 18,21.3284271 18,20.5 L18,8 L6,8 Z"
                  fill="#000000"
                  fillRule="nonzero"
                />
                <path
                  d="M14,4.5 L14,4 C14,3.44771525 13.5522847,3 13,3 L11,3 C10.4477153,3 10,3.44771525 10,4 L10,4.5 L5.5,4.5 C5.22385763,4.5 5,4.72385763 5,5 L5,5.5 C5,5.77614237 5.22385763,6 5.5,6 L18.5,6 C18.7761424,6 19,5.77614237 19,5.5 L19,5 C19,4.72385763 18.7761424,4.5 18.5,4.5 L14,4.5 Z"
                  fill="#000000"
                  opacity="0.3"
                />
              </g>
            </svg>
            {/*end::Svg Icon*/}
          </span>
        </a>
        {/* <DeleteModal showModal={showModal} setShowModal={setShowModal} /> */}
      </td>
    </tr>
  ));

  return search ? (
    <tbody>
      <tr>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td>
          <div
            className="loader-container"
            style={{ width: "100%", height: "100vh" }}
          >
            <HashLoader color={"#04ECFF"} loading={search} size={70} />
          </div>
        </td>
        <td></td>
        <td></td>
        <td></td>
      </tr>
    </tbody>
  ) : (
    <tbody>
      {/* <h1>Hi</h1> */}
      {renderedComments}
      <ViewCommentModal
        showViewModal={showViewModal}
        setShowViewModal={setShowViewModal}
        comment={postComment}
      />
      <EditCommentModal
        showEditModal={showEditModal}
        setShowEditModal={setShowEditModal}
        comment={postComment}
      />
      <DeleteCommentModal
        showDeleteModal={showDeleteModal}
        setShowDeleteModal={setShowDeleteModal}
        id={postComment}
      />
    </tbody>
  );
  // <div>
  //   {props.users.length == 0 ? (
  //     <tbody>
  //       <tr>
  //         <td className="pl-0">
  //           <a
  //             href="#"
  //             className="text-dark-75 font-weight-bolder text-hover-primary font-size-lg"
  //           >
  //             No results found.
  //           </a>
  //         </td>
  //       </tr>
  //     </tbody>
  //   ) : (
  //     <tbody>{renderedUsers}</tbody>
  //   )}
  // </div>
}
