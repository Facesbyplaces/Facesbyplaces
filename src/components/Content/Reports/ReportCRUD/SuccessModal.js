import React from "react";
import { useSelector, useDispatch } from "react-redux";
import { TableReportAction, ViewReportAction } from "../../../../redux/actions";

export const SuccessModal = ({ showModal, setShowModal }) => {
  const dispatch = useDispatch();
  const { reportTab } = useSelector(({ reportTab }) => ({
    reportTab: reportTab,
  }));

  const handleAdd = () => {
    console.log("ADD");
    setShowModal((prev) => !prev);
    dispatch(TableReportAction());
  };
  const handleDelete = () => {
    console.log("DELETE");
    setShowModal((prev) => !prev);
    dispatch(TableReportAction());
  };
  const handleEdit = (id, option1, type) => {
    console.log("EDIT");
    const option = "v";
    setShowModal((prev) => !prev);
    dispatch(ViewReportAction({ id, option, type }));
  };

  const handleActionClick = (id, option, type) => {
    switch (reportTab.option) {
      case "a":
        return handleAdd();
      case "d":
        return handleDelete();
      case "e":
        return handleEdit(id, option, type);
    }
  };

  console.log("Action: ", reportTab.option);

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
                    <title>Stockholm-icons / Code / Done-circle</title>
                    <desc>Created with Sketch.</desc>
                    <defs />
                    <g
                      id="Stockholm-icons-/-Code-/-Done-circle"
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
                        d="M16.7689447,7.81768175 C17.1457787,7.41393107 17.7785676,7.39211077 18.1823183,7.76894473 C18.5860689,8.1457787 18.6078892,8.77856757 18.2310553,9.18231825 L11.2310553,16.6823183 C10.8654446,17.0740439 10.2560456,17.107974 9.84920863,16.7592566 L6.34920863,13.7592566 C5.92988278,13.3998345 5.88132125,12.7685345 6.2407434,12.3492086 C6.60016555,11.9298828 7.23146553,11.8813212 7.65079137,12.2407434 L10.4229928,14.616916 L16.7689447,7.81768175 Z"
                        id="Path-92"
                        fill="#000000"
                        fillRule="nonzero"
                      />
                    </g>
                  </svg>
                </span>
              </div>
              <div className="modal-body">
                <h2 className="modal-dialog">
                  <b>Success!</b>
                </h2>
                {
                  {
                    a: (
                      <h5 className="modal-dialog">
                        You have successfully added a report.
                      </h5>
                    ),
                    v: (
                      <h5 className="modal-dialog">
                        You have successfully edited a report.
                      </h5>
                    ),
                    e: (
                      <h5 className="modal-dialog">
                        You have successfully edited a report.
                      </h5>
                    ),
                    d: (
                      <h5 className="modal-dialog">
                        You have successfully deleted a report.
                      </h5>
                    ),
                  }[reportTab.option]
                }
              </div>
              <div className="modal-footer">
                <button
                  type="button"
                  className="btn btn-md btn-primary font-weight-bold"
                  style={{ width: "200px" }}
                  data-dismiss="modal"
                  onClick={() =>
                    handleActionClick(
                      reportTab.id,
                      reportTab.option,
                      reportTab.type
                    )
                  }
                >
                  Okay
                </button>
              </div>
            </div>
          </div>
        </div>
      ) : null}
    </>
  );
};
