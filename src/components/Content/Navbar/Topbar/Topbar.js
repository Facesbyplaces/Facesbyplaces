import React, { useState } from "react";
import { useDispatch, useSelector } from "react-redux";

//React Icons
import { GrClose } from "react-icons/gr";

//Actions
import { LogoutAction } from "../../../../redux/actions";

export default function Topbar() {
  const { user } = useSelector(({ auth_data }) => ({
    user: auth_data.user,
  }));

  const dispatch = useDispatch();
  const [sideBar, setSideBar] = useState(false);
  const image = (user.image = !null);

  const onDivClick = (value) => {
    setSideBar(value);
  };

  const onLogOutClicked = () => {
    dispatch(LogoutAction({}));
  };

  console.log("Top Bar User", user);

  return (
    <div className="topbar">
      <div className="topbar-item">
        <div
          className="btn btn-icon w-auto btn-clean d-flex align-items-center btn-lg px-2"
          onClick={() => onDivClick(!sideBar)}
        >
          <span className="text-muted font-weight-bold font-size-base d-none d-md-inline mr-1">
            Hi,
          </span>
          <span className="text-dark-50 font-weight-bolder font-size-base d-none d-md-inline mr-3">
            {user.first_name}
          </span>
          <span className="symbol symbol-35 symbol-light-success">
            <span className="symbol-label font-size-h5 font-weight-bold">
              {user.first_name.charAt(0)}
            </span>
          </span>
        </div>
      </div>
      <div
        className={
          sideBar
            ? "offcanvas offcanvas-right p-10 offcanvas-on"
            : "offcanvas offcanvas-right p-10"
        }
      >
        <div className="offcanvas-header d-flex align-items-center justify-content-between pb-5">
          <h3 className="font-weight-bold m-0">User Profile</h3>
          <a
            className="btn btn-xs btn-icon btn-light btn-hover-primary"
            onClick={() => onDivClick(!sideBar)}
          >
            <b className="ki ki-close icon-xs text-muted">&#88;</b>
          </a>
        </div>
        <div className="offcanvas-content pr-5 mr-n5">
          {/*begin::Header*/}
          <div className="d-flex align-items-center mt-5">
            <div className="symbol symbol-100 mr-5">
              {image ? (
                <div
                  className="symbol-label"
                  style={{
                    backgroundImage: 'url("assets/media/users/300_16.jpg")',
                  }}
                />
              ) : (
                <div
                  className="symbol-label"
                  style={{
                    backgroundImage: 'url("assets/media/users/blank.png")',
                  }}
                />
              )}

              <i className="symbol-badge bg-success" />
            </div>
            <div className="d-flex flex-column">
              <a
                href="#"
                className="font-weight-bold font-size-h5 text-dark-75 text-hover-primary"
              >
                {user.first_name} {user.last_name}
              </a>
              <div className="text-muted mt-1">Application Developer</div>
              <div className="navi mt-2">
                <a href="#" className="navi-item">
                  <span className="navi-link p-0 pb-2">
                    <span className="navi-icon mr-1">
                      <span className="svg-icon svg-icon-lg svg-icon-primary">
                        {/*begin::Svg Icon | path:assets/media/svg/icons/Communication/Mail-notification.svg*/}
                        <svg
                          xmlns="http://www.w3.org/2000/svg"
                          xmlnsXlink="http://www.w3.org/1999/xlink"
                          width="24px"
                          height="24px"
                          viewBox="0 0 24 24"
                          version="1.1"
                        >
                          <g
                            stroke="none"
                            strokeWidth={1}
                            fill="none"
                            fillRule="evenodd"
                          >
                            <rect x={0} y={0} width={24} height={24} />
                            <path
                              d="M21,12.0829584 C20.6747915,12.0283988 20.3407122,12 20,12 C16.6862915,12 14,14.6862915 14,18 C14,18.3407122 14.0283988,18.6747915 14.0829584,19 L5,19 C3.8954305,19 3,18.1045695 3,17 L3,8 C3,6.8954305 3.8954305,6 5,6 L19,6 C20.1045695,6 21,6.8954305 21,8 L21,12.0829584 Z M18.1444251,7.83964668 L12,11.1481833 L5.85557487,7.83964668 C5.4908718,7.6432681 5.03602525,7.77972206 4.83964668,8.14442513 C4.6432681,8.5091282 4.77972206,8.96397475 5.14442513,9.16035332 L11.6444251,12.6603533 C11.8664074,12.7798822 12.1335926,12.7798822 12.3555749,12.6603533 L18.8555749,9.16035332 C19.2202779,8.96397475 19.3567319,8.5091282 19.1603533,8.14442513 C18.9639747,7.77972206 18.5091282,7.6432681 18.1444251,7.83964668 Z"
                              fill="#000000"
                            />
                            <circle
                              fill="#000000"
                              opacity="0.3"
                              cx="19.5"
                              cy="17.5"
                              r="2.5"
                            />
                          </g>
                        </svg>
                        {/*end::Svg Icon*/}
                      </span>
                    </span>
                    <span className="navi-text text-muted text-hover-primary">
                      {user.email}
                    </span>
                  </span>
                </a>
                <a
                  href="#"
                  className="btn btn-sm btn-light-primary font-weight-bolder py-2 px-5"
                  onClick={onLogOutClicked}
                >
                  Sign Out
                </a>
              </div>
            </div>
          </div>
          {/*end::Header*/}
          {/*begin::Separator*/}
          <div className="separator separator-dashed mt-8 mb-5" />
          {/*end::Separator*/}
        </div>
      </div>
    </div>
  );
}
