import React, { useState } from "react";
import axios from "../../../../../../auxiliary/axios";

import { TransactionModal } from "./TransactionModal";
import HashLoader from "react-spinners/HashLoader";

export default function DataTableRowTransactionData({ transactions, search }) {
  const [showModal, setShowModal] = useState(false);
  const [gift, setGift] = useState();

  const handleViewClick = (transaction) => {
    setGift(transaction);
    setShowModal((prev) => !prev);
  };

  const renderedTransactions = transactions.map((transaction) => (
    <tr>
      {/* <td className="pl-2 py-6">
        <label className="checkbox checkbox-lg checkbox-inline">
          <input type="checkbox" defaultValue={1} />
          <span />
        </label>
      </td> */}
      <td>
        <a
          href="#"
          className="text-dark-75 font-weight-bolder text-hover-primary font-size-lg"
        >
          {transaction.id}
        </a>
      </td>
      <td>
        <span className="text-dark-75 font-weight-bolder d-block font-size-lg">
          {transaction.page.name}
        </span>
      </td>
      <td>
        <span className="text-dark-75 font-weight-bolder d-block font-size-lg">
          {transaction.page.page_type}
        </span>
      </td>
      <td>
        <span className="text-dark-75 font-weight-bolder d-block font-size-lg">
          {transaction.amount}
        </span>
      </td>
      <td>
        <span className="text-dark-75 font-weight-bolder d-block font-size-lg">
          {transaction.user.first_name} {transaction.user.last_name}
        </span>
      </td>
      <td>
        <span className="text-dark-75 font-weight-bolder d-block font-size-lg">
          {transaction.user.account_type == 2 ? "ALM" : "BLM"}
        </span>
      </td>
      <td className="pr-2 text-left">
        {/* View User Icon */}
        <a
          className="btn btn-icon btn-light btn-hover-primary btn-sm"
          onClick={() => handleViewClick(transaction)}
        >
          <span className="svg-icon svg-icon-lg svg-icon-primary">
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
              <title>Stockholm-icons / Shopping / Gift</title>
              <desc>Created with Sketch.</desc>
              <defs />
              <g
                id="Stockholm-icons-/-Shopping-/-Gift"
                stroke="none"
                strokeWidth={1}
                fill="none"
                fillRule="evenodd"
              >
                <rect id="bound" x={0} y={0} width={24} height={24} />
                <path
                  d="M4,6 L20,6 C20.5522847,6 21,6.44771525 21,7 L21,8 C21,8.55228475 20.5522847,9 20,9 L4,9 C3.44771525,9 3,8.55228475 3,8 L3,7 C3,6.44771525 3.44771525,6 4,6 Z M5,11 L10,11 C10.5522847,11 11,11.4477153 11,12 L11,19 C11,19.5522847 10.5522847,20 10,20 L5,20 C4.44771525,20 4,19.5522847 4,19 L4,12 C4,11.4477153 4.44771525,11 5,11 Z M14,11 L19,11 C19.5522847,11 20,11.4477153 20,12 L20,19 C20,19.5522847 19.5522847,20 19,20 L14,20 C13.4477153,20 13,19.5522847 13,19 L13,12 C13,11.4477153 13.4477153,11 14,11 Z"
                  id="Combined-Shape"
                  fill="#000000"
                />
                <path
                  d="M14.4452998,2.16794971 C14.9048285,1.86159725 15.5256978,1.98577112 15.8320503,2.4452998 C16.1384028,2.90482849 16.0142289,3.52569784 15.5547002,3.83205029 L12,6.20185043 L8.4452998,3.83205029 C7.98577112,3.52569784 7.86159725,2.90482849 8.16794971,2.4452998 C8.47430216,1.98577112 9.09517151,1.86159725 9.5547002,2.16794971 L12,3.79814957 L14.4452998,2.16794971 Z"
                  id="Path-31"
                  fill="#000000"
                  fillRule="nonzero"
                  opacity="0.3"
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
    <tbody>
      {renderedTransactions}{" "}
      <TransactionModal
        showModal={showModal}
        setShowModal={setShowModal}
        transaction={gift}
      />
      ;
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
