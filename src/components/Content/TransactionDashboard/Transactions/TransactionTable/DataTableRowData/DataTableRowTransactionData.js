import React, { useState } from "react";
import { DeleteModal } from "./DeleteModal";
//Loader
import HashLoader from "react-spinners/HashLoader";

import { useDispatch } from "react-redux";
import {
  ViewReportAction,
  EditReportAction,
  DeleteReportAction,
} from "../../../../../../redux/actions";

export default function DataTableRowTransactionData({
  transactions,
  search,
  pageType,
}) {
  const dispatch = useDispatch();

  const handleViewClick = (id, option, type) => {
    console.log(id, option);
    dispatch(ViewReportAction({ id, option, type }));
  };

  const renderedTransactions = transactions.map((transaction) => (
    <tr>
      <td className="pl-2 py-6">
        <label className="checkbox checkbox-lg checkbox-inline">
          <input type="checkbox" defaultValue={1} />
          <span />
        </label>
      </td>
      <td>
        <a
          href="#"
          className="text-dark-75 font-weight-bolder text-hover-primary font-size-lg"
        >
          {transaction.id}
        </a>
      </td>
      <td className="pl-0 py-6">
        <span className="text-dark-75 font-weight-bolder d-block font-size-lg">
          {transaction.page_id}
        </span>
      </td>
      <td className="pl-0 py-6">
        <span className="text-dark-75 font-weight-bolder d-block font-size-lg">
          {transaction.page_type}
        </span>
      </td>
      <td className="pl-0 py-6">
        <span className="text-dark-75 font-weight-bolder d-block font-size-lg">
          {transaction.amount}
        </span>
      </td>
      <td className="pl-0 py-6">
        <span className="text-dark-75 font-weight-bolder d-block font-size-lg">
          {transaction.account_id}
        </span>
      </td>
      <td className="pl-0 py-6">
        <span className="text-dark-75 font-weight-bolder d-block font-size-lg">
          {transaction.account_type}
        </span>
      </td>
      <td className="pr-2 text-left">
        {/* View User Icon */}
        <a
          className="btn btn-icon btn-light btn-hover-primary btn-sm"
          onClick={() => handleViewClick(transaction.id, "v", 2)}
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
              <title>Stockholm-icons / General / Heart</title>
              <desc>Created with Sketch.</desc>
              <defs />
              <g
                id="Stockholm-icons-/-General-/-Heart"
                stroke="none"
                strokeWidth={1}
                fill="none"
                fillRule="evenodd"
              >
                <polygon id="Shape" points="0 0 24 0 24 24 0 24" />
                <path
                  d="M16.5,4.5 C14.8905,4.5 13.00825,6.32463215 12,7.5 C10.99175,6.32463215 9.1095,4.5 7.5,4.5 C4.651,4.5 3,6.72217984 3,9.55040872 C3,12.6834696 6,16 12,19.5 C18,16 21,12.75 21,9.75 C21,6.92177112 19.349,4.5 16.5,4.5 Z"
                  id="Shape"
                  fill="#000000"
                  fillRule="nonzero"
                />
              </g>
            </svg>
            {/*end::Svg Icon*/}
          </span>
        </a>
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
    <tbody>{renderedTransactions}</tbody>
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
