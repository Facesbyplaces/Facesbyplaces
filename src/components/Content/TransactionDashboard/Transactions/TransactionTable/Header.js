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
          Transactions Datatable
          <span className="d-block text-muted pt-2 font-size-sm">
            List of memorial's gift transactions.
          </span>
        </h3>
      </div>
    </div>
  );
}
