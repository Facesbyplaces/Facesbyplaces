import React from "react";
import { useDispatch } from "react-redux";
import { AddReportAction } from "../../../../../redux/actions";

export default function Header({ pageType }) {
  const dispatch = useDispatch();
  console.log(pageType);

  const handleAddClick = (option) => {
    console.log(option);
    const type = pageType;
    dispatch(AddReportAction({ option, type }));
  };

  return (
    <div className="card-header flex-wrap border-0 pt-6 pb-0">
      <div className="card-title">
        <h3 className="card-label">
          Reports Datatable
          <span className="d-block text-muted pt-2 font-size-sm">
            List of ALM, BLM memorials' and Posts' reports.
          </span>
        </h3>
      </div>
      <div className="card-toolbar">
        {/*begin::Button*/}
        <a
          className="btn btn-primary font-weight-bolder"
          onClick={() => handleAddClick("a")}
        >
          <span className="svg-icon svg-icon-md">
            {/*begin::Svg Icon | path:assets/media/svg/icons/Design/Flatten.svg*/}
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
                <circle fill="#000000" cx={9} cy={15} r={6} />
                <path
                  d="M8.8012943,7.00241953 C9.83837775,5.20768121 11.7781543,4 14,4 C17.3137085,4 20,6.6862915 20,10 C20,12.2218457 18.7923188,14.1616223 16.9975805,15.1987057 C16.9991904,15.1326658 17,15.0664274 17,15 C17,10.581722 13.418278,7 9,7 C8.93357256,7 8.86733422,7.00080962 8.8012943,7.00241953 Z"
                  fill="#000000"
                  opacity="0.3"
                />
              </g>
            </svg>
            {/*end::Svg Icon*/}
          </span>
          Create Report
        </a>
        {/*end::Button*/}
      </div>
    </div>
  );
}
