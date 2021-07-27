import React, { useState } from "react";
import { DeleteModal } from "../../Modals/DeleteModal";
//Loader
import HashLoader from "react-spinners/HashLoader";

import { useDispatch } from "react-redux";
import {
  ViewPostAction,
  EditPostAction,
  DeletePostAction,
} from "../../../../../redux/actions";

export default function DataTableRowMemorialPostsData({
  posts,
  search,
  pageType,
}) {
  const [showModal, setShowModal] = useState(false);
  const dispatch = useDispatch();
  const page_type = pageType === 2 ? "Memorial" : "Blm";

  const handleViewClick = (id, option, type) => {
    console.log(id, option);
    dispatch(ViewPostAction({ id, option, type }));
  };

  const handleEditClick = (id, option, type) => {
    console.log(id, option, type);
    dispatch(EditPostAction({ id, option, type }));
  };

  const handleDeleteClick = (id, option) => {
    dispatch(DeletePostAction({ id, option }));
    setShowModal((prev) => !prev);
  };

  const renderedPosts = posts.map((post) => (
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
          {post.id}
        </a>
      </td>
      <td className="pl-0 py-6">
        <span className="text-dark-75 font-weight-bolder d-block font-size-lg">
          {post.page.name}
        </span>
      </td>
      <td className="pl-0 py-6">
        <span className="text-dark-75 font-weight-bolder d-block font-size-lg">
          {post.location}
        </span>
      </td>
      <td className="pl-0 py-6">
        <span className="text-dark-75 font-weight-bolder d-block font-size-lg">
          {post.page.relationship}
        </span>
      </td>
      <td>
        {post.page.privacy === "public" ? (
          <span
            className="btn btn-hover-transparent-success font-weight-bold mr-2"
            style={{ width: "70px", height: "38px" }}
          >
            public
          </span>
        ) : (
          <span
            className="btn btn-hover-transparent-danger font-weight-bold mr-2"
            style={{ width: "70px", height: "38px" }}
          >
            private
          </span>
        )}
      </td>
      <td>
        {post.page.page_type === "Memorial" ? (
          <span className="label label-lg label-light-warning label-inline">
            ALM
          </span>
        ) : (
          <span className="label label-lg label-light-primary label-inline">
            BLM
          </span>
        )}
      </td>
      <td className="pr-2 text-left">
        {/* View User Icon */}
        <a
          className="btn btn-icon btn-light btn-hover-primary btn-sm"
          onClick={() => handleViewClick(post.id, "v", 2)}
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
              <title>Stockholm-icons / Map / Location-arrow</title>
              <desc>Created with Sketch.</desc>
              <defs />
              <g
                id="Stockholm-icons-/-Map-/-Location-arrow"
                stroke="none"
                strokeWidth={1}
                fill="none"
                fillRule="evenodd"
              >
                <rect id="bound" x={0} y={0} width={24} height={24} />
                <path
                  d="M4.88230018,17.2353996 L13.2844582,0.431083506 C13.4820496,0.0359007077 13.9625881,-0.12427877 14.3577709,0.0733126292 C14.5125928,0.15072359 14.6381308,0.276261584 14.7155418,0.431083506 L23.1176998,17.2353996 C23.3152912,17.6305824 23.1551117,18.1111209 22.7599289,18.3087123 C22.5664522,18.4054506 22.3420471,18.4197165 22.1378777,18.3482572 L14,15.5 L5.86212227,18.3482572 C5.44509941,18.4942152 4.98871325,18.2744737 4.84275525,17.8574509 C4.77129597,17.6532815 4.78556182,17.4288764 4.88230018,17.2353996 Z"
                  id="Path-99"
                  fill="#000000"
                  fillRule="nonzero"
                  transform="translate(14.000087, 9.191034) rotate(-315.000000) translate(-14.000087, -9.191034) "
                />
              </g>
            </svg>
            {/*end::Svg Icon*/}
          </span>
        </a>
        {/* Edit Icon */}
        <a
          className="btn btn-icon btn-light btn-hover-primary btn-sm mx-3"
          onClick={() => handleEditClick(post.id, "e", 2)}
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
          onClick={() => handleDeleteClick(post.id, page_type)}
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
        <DeleteModal showModal={showModal} setShowModal={setShowModal} />
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
      {renderedPosts}
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
