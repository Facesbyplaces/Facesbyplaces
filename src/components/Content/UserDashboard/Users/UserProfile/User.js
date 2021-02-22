import React, { useEffect, useState } from "react";
import axios from "../../../../../auxiliary/axios";

import { useDispatch, useSelector } from "react-redux";
import { TableUserAction } from "../../../../../redux/actions";
import EditUser from "./EditUser";

export default function User() {
  const dispatch = useDispatch();
  const [user, setUser] = useState([]);
  const [image, setImage] = useState(null);
  const [profile, setProfile] = useState(true);
  const { tab } = useSelector(({ tab }) => ({
    tab: tab,
  }));
  console.log(profile);

  const handleTableClick = () => {
    dispatch(TableUserAction());
  };

  const handleProfileClick = () => {
    setProfile((prev) => !prev);
    console.log(profile);
  };

  useEffect(() => {
    axios
      .get(`/api/v1/admin/users/show`, {
        params: { id: tab.id, account_type: tab.account_type },
      })
      .then((response) => {
        setUser(response.data);
        setImage(response.data.image);
        console.log("Response: ", response.data);
      })
      .catch((error) => {
        console.log(error);
      });
  }, user.id);

  return (
    <div
      className="content content-height d-flex flex-column flex-column-fluid"
      id="kt_content"
    >
      <div className="d-flex flex-column-fluid">
        {/*begin::Container*/}
        <div className="container">
          {/*begin::Card*/}
          <div className="card card-custom gutter-b">
            <div className="pt-5 pl-8">
              <a
                className="btn btn-sm btn-light-primary font-weight-bolder text-uppercase mr-3"
                onClick={() => handleTableClick()}
              >
                back
              </a>
            </div>
            <div className="card-body">
              {/*begin::Details*/}
              <div className="d-flex mb-9">
                {/*begin: Pic*/}
                <div className="flex-shrink-0 mr-7 mt-lg-0 mt-3">
                  <div className="symbol symbol-50 symbol-lg-120">
                    {/* <img src={user.image} alt="assets/media/users/300_16.jpg" /> */}
                    {image ? (
                      <div
                        className="symbol-label"
                        style={{
                          backgroundImage: `url(${image})`,
                        }}
                      />
                    ) : (
                      <div
                        className="symbol-label"
                        style={{
                          backgroundImage:
                            'url("assets/media/users/blank.png")',
                        }}
                      />
                    )}
                  </div>
                </div>
                {/*end::Pic*/}
                {/*begin::Info*/}
                <div className="flex-grow-1">
                  {/*begin::Title*/}
                  <div className="d-flex justify-content-between flex-wrap mt-1">
                    <div className="d-flex mr-3">
                      <a
                        href="#"
                        className="text-dark-75 text-hover-primary font-size-h5 font-weight-bold mr-3"
                      >
                        {user.first_name} {user.last_name}
                      </a>
                      <a href="#">
                        <span className="svg-icon svg-icon-lg svg-icon-success">
                          <svg
                            width="24px"
                            height="24px"
                            viewBox="0 0 24 24"
                            version="1.1"
                            xmlns="http://www.w3.org/2000/svg"
                            xmlnsXlink="http://www.w3.org/1999/xlink"
                          >
                            {/* Generator: Sketch 50.2 (55047) - http://www.bohemiancoding.com/sketch */}
                            <title>Stockholm-icons / General / Star</title>
                            <desc>Created with Sketch.</desc>
                            <defs />
                            <g
                              id="Stockholm-icons-/-General-/-Star"
                              stroke="none"
                              strokeWidth={1}
                              fill="none"
                              fillRule="evenodd"
                            >
                              <polygon
                                id="Shape"
                                points="0 0 24 0 24 24 0 24"
                              />
                              <path
                                d="M12,18 L7.91561963,20.1472858 C7.42677504,20.4042866 6.82214789,20.2163401 6.56514708,19.7274955 C6.46280801,19.5328351 6.42749334,19.309867 6.46467018,19.0931094 L7.24471742,14.545085 L3.94038429,11.3241562 C3.54490071,10.938655 3.5368084,10.3055417 3.92230962,9.91005817 C4.07581822,9.75257453 4.27696063,9.65008735 4.49459766,9.61846284 L9.06107374,8.95491503 L11.1032639,4.81698575 C11.3476862,4.32173209 11.9473121,4.11839309 12.4425657,4.36281539 C12.6397783,4.46014562 12.7994058,4.61977315 12.8967361,4.81698575 L14.9389263,8.95491503 L19.5054023,9.61846284 C20.0519472,9.69788046 20.4306287,10.2053233 20.351211,10.7518682 C20.3195865,10.9695052 20.2170993,11.1706476 20.0596157,11.3241562 L16.7552826,14.545085 L17.5353298,19.0931094 C17.6286908,19.6374458 17.263103,20.1544017 16.7187666,20.2477627 C16.5020089,20.2849396 16.2790408,20.2496249 16.0843804,20.1472858 L12,18 Z"
                                id="Star"
                                fill="#000000"
                              />
                            </g>
                          </svg>
                        </span>
                      </a>
                    </div>
                    <div className="my-lg-0 my-3">
                      {user.account_type == 1 ? (
                        <a className="btn btn-md btn-light-primary font-weight-bolder text-uppercase mr-3">
                          blm
                        </a>
                      ) : (
                        <a className="btn btn-md btn-light-warning font-weight-bolder text-uppercase">
                          alm
                        </a>
                      )}
                    </div>
                  </div>
                  {/*end::Title*/}
                  {/*begin::Content*/}
                  <div className="d-flex flex-wrap justify-content-between mt-1">
                    <div className="d-flex flex-column flex-grow-1 pr-8">
                      <div className="d-flex flex-wrap mb-4">
                        <a className="text-dark-50 text-hover-primary font-weight-bold mr-lg-8 mr-5 mb-lg-0 mb-2">
                          <span className="svg-icon svg-icon-md svg-icon-info mr-1">
                            <svg
                              width="24px"
                              height="24px"
                              viewBox="0 0 24 24"
                              version="1.1"
                              xmlns="http://www.w3.org/2000/svg"
                              xmlnsXlink="http://www.w3.org/1999/xlink"
                            >
                              {/* Generator: Sketch 50.2 (55047) - http://www.bohemiancoding.com/sketch */}
                              <title>
                                Stockholm-icons / Communication / Mail
                              </title>
                              <desc>Created with Sketch.</desc>
                              <defs />
                              <g
                                id="Stockholm-icons-/-Communication-/-Mail"
                                stroke="none"
                                strokeWidth={1}
                                fill="none"
                                fillRule="evenodd"
                              >
                                <rect
                                  id="bound"
                                  x={0}
                                  y={0}
                                  width={24}
                                  height={24}
                                />
                                <path
                                  d="M5,6 L19,6 C20.1045695,6 21,6.8954305 21,8 L21,17 C21,18.1045695 20.1045695,19 19,19 L5,19 C3.8954305,19 3,18.1045695 3,17 L3,8 C3,6.8954305 3.8954305,6 5,6 Z M18.1444251,7.83964668 L12,11.1481833 L5.85557487,7.83964668 C5.4908718,7.6432681 5.03602525,7.77972206 4.83964668,8.14442513 C4.6432681,8.5091282 4.77972206,8.96397475 5.14442513,9.16035332 L11.6444251,12.6603533 C11.8664074,12.7798822 12.1335926,12.7798822 12.3555749,12.6603533 L18.8555749,9.16035332 C19.2202779,8.96397475 19.3567319,8.5091282 19.1603533,8.14442513 C18.9639747,7.77972206 18.5091282,7.6432681 18.1444251,7.83964668 Z"
                                  id="Combined-Shape"
                                  fill="#000000"
                                />
                              </g>
                            </svg>
                          </span>
                          {user.email}
                        </a>
                        <a className="text-dark-50 text-hover-primary font-weight-bold mr-lg-8 mr-5 mb-lg-0 mb-2">
                          <span className="svg-icon svg-icon-md svg-icon-info mr-1">
                            <svg
                              width="24px"
                              height="24px"
                              viewBox="0 0 24 24"
                              version="1.1"
                              xmlns="http://www.w3.org/2000/svg"
                              xmlnsXlink="http://www.w3.org/1999/xlink"
                            >
                              {/* Generator: Sketch 50.2 (55047) - http://www.bohemiancoding.com/sketch */}
                              <title>
                                Stockholm-icons / Communication / Adress-book2
                              </title>
                              <desc>Created with Sketch.</desc>
                              <defs />
                              <g
                                id="Stockholm-icons-/-Communication-/-Adress-book2"
                                stroke="none"
                                strokeWidth={1}
                                fill="none"
                                fillRule="evenodd"
                              >
                                <rect
                                  id="bound"
                                  x={0}
                                  y={0}
                                  width={24}
                                  height={24}
                                />
                                <path
                                  d="M18,2 L20,2 C21.6568542,2 23,3.34314575 23,5 L23,19 C23,20.6568542 21.6568542,22 20,22 L18,22 L18,2 Z"
                                  id="Rectangle-161-Copy"
                                  fill="#000000"
                                  opacity="0.3"
                                />
                                <path
                                  d="M5,2 L17,2 C18.6568542,2 20,3.34314575 20,5 L20,19 C20,20.6568542 18.6568542,22 17,22 L5,22 C4.44771525,22 4,21.5522847 4,21 L4,3 C4,2.44771525 4.44771525,2 5,2 Z M12,11 C13.1045695,11 14,10.1045695 14,9 C14,7.8954305 13.1045695,7 12,7 C10.8954305,7 10,7.8954305 10,9 C10,10.1045695 10.8954305,11 12,11 Z M7.00036205,16.4995035 C6.98863236,16.6619875 7.26484009,17 7.4041679,17 C11.463736,17 14.5228466,17 16.5815,17 C16.9988413,17 17.0053266,16.6221713 16.9988413,16.5 C16.8360465,13.4332455 14.6506758,12 11.9907452,12 C9.36772908,12 7.21569918,13.5165724 7.00036205,16.4995035 Z"
                                  id="Combined-Shape"
                                  fill="#000000"
                                />
                              </g>
                            </svg>
                          </span>
                          {user.phone_number}
                        </a>
                        <a className="text-dark-50 text-hover-primary font-weight-bold">
                          <span className="svg-icon svg-icon-md svg-icon-info mr-1">
                            <svg
                              width="24px"
                              height="24px"
                              viewBox="0 0 24 24"
                              version="1.1"
                              xmlns="http://www.w3.org/2000/svg"
                              xmlnsXlink="http://www.w3.org/1999/xlink"
                            >
                              {/* Generator: Sketch 50.2 (55047) - http://www.bohemiancoding.com/sketch */}
                              <title>Stockholm-icons / Food / Cake</title>
                              <desc>Created with Sketch.</desc>
                              <defs />
                              <g
                                id="Stockholm-icons-/-Food-/-Cake"
                                stroke="none"
                                strokeWidth={1}
                                fill="none"
                                fillRule="evenodd"
                              >
                                <rect
                                  id="bound"
                                  x={0}
                                  y={0}
                                  width={24}
                                  height={24}
                                />
                                <path
                                  d="M13,11 L17,11 C19.0758626,11 20.7823939,12.5812954 20.980747,14.6050394 L20.2928932,15.2928932 C19.1327768,16.4530096 18.0387961,17 17,17 C16.5220296,17 16.1880664,16.8518214 15.5648598,16.401988 C15.504386,16.3583378 15.425236,16.3005045 15.2756717,16.1912639 C14.1361881,15.3625486 13.3053476,15 12,15 C10.7177731,15 9.87894492,15.3373247 8.58005831,16.1531954 C8.42732855,16.2493619 8.35077622,16.2975179 8.28137728,16.3407226 C7.49918122,16.8276828 7.06530257,17 6.5,17 C5.8272085,17 5.18146841,16.7171497 4.58539107,16.2273674 C4.21125802,15.9199514 3.94722374,15.6135435 3.82536894,15.4354062 C3.58523105,15.132389 3.4977165,15.0219591 3.03793571,14.4468552 C3.3073102,12.4994956 4.97854212,11 7,11 L11,11 L11,9 L13,9 L13,11 Z"
                                  id="Combined-Shape"
                                  fill="#000000"
                                />
                                <path
                                  d="M12,7 C13.1045695,7 14,6.1045695 14,5 C14,4.26362033 13.3333333,3.26362033 12,2 C10.6666667,3.26362033 10,4.26362033 10,5 C10,6.1045695 10.8954305,7 12,7 Z"
                                  id="Oval-39"
                                  fill="#000000"
                                  opacity="0.3"
                                />
                                <path
                                  d="M21,17.3570374 L21,21 C21,21.5522847 20.5522847,22 20,22 L4,22 C3.44771525,22 3,21.5522847 3,21 L3,17.4976746 C3.098145,17.5882704 3.2035241,17.6804734 3.31568417,17.7726326 C4.24088818,18.5328503 5.30737928,19 6.5,19 C7.52608715,19 8.26628185,18.7060277 9.33838848,18.0385822 C9.41243034,17.9924871 9.49377318,17.9413176 9.64386645,17.8468046 C10.6511414,17.2141042 11.1835561,17 12,17 C12.7988191,17 13.2700619,17.2056332 14.0993283,17.8087361 C14.2431314,17.9137812 14.3282387,17.9759674 14.3943239,18.0236679 C15.3273176,18.697107 16.0099741,19 17,19 C18.3748985,19 19.7104312,18.4390637 21,17.3570374 Z"
                                  id="Path"
                                  fill="#000000"
                                  opacity="0.3"
                                />
                              </g>
                            </svg>
                          </span>
                          {user.birthdate}
                        </a>
                      </div>
                      <span className="font-weight-bold text-dark-50">
                        I distinguish three main text objectives could be merely
                        to inform people.
                      </span>
                      <span className="font-weight-bold text-dark-50">
                        A second could be persuade people.You want people to bay
                        objective
                      </span>
                    </div>
                  </div>
                  {/*end::Content*/}
                </div>
                {/*end::Info*/}
              </div>
              {/*end::Details*/}
              <div className="separator separator-solid" />
              <div className="header-menu header-menu-mobile header-menu-layout-default pt-5">
                <ul className="menu-nav">
                  <li
                    className="menu-item menu-item-active"
                    aria-haspopup="true"
                  >
                    <a className="menu-link">
                      <span className="svg-icon svg-icon-md svg-icon-primary mr-2">
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
                          <title>Stockholm-icons / General / User</title>
                          <desc>Created with Sketch.</desc>
                          <defs />
                          <g
                            id="Stockholm-icons-/-General-/-User"
                            stroke="none"
                            strokeWidth={1}
                            fill="none"
                            fillRule="evenodd"
                          >
                            <polygon id="Shape" points="0 0 24 0 24 24 0 24" />
                            <path
                              d="M12,11 C9.790861,11 8,9.209139 8,7 C8,4.790861 9.790861,3 12,3 C14.209139,3 16,4.790861 16,7 C16,9.209139 14.209139,11 12,11 Z"
                              id="Mask"
                              fill="#000000"
                              fillRule="nonzero"
                              opacity="0.3"
                            />
                            <path
                              d="M3.00065168,20.1992055 C3.38825852,15.4265159 7.26191235,13 11.9833413,13 C16.7712164,13 20.7048837,15.2931929 20.9979143,20.2 C21.0095879,20.3954741 20.9979143,21 20.2466999,21 C16.541124,21 11.0347247,21 3.72750223,21 C3.47671215,21 2.97953825,20.45918 3.00065168,20.1992055 Z"
                              id="Mask-Copy"
                              fill="#000000"
                              fillRule="nonzero"
                            />
                          </g>
                        </svg>

                        {/*end::Svg Icon*/}
                      </span>

                      <span className="menu-text" style={{ fontSize: "17px" }}>
                        Profile
                      </span>
                    </a>
                  </li>
                  <li
                    className="menu-item menu-item-submenu menu-item-rel"
                    data-menu-toggle="click"
                    aria-haspopup="true"
                  >
                    <a className="menu-link menu-toggle">
                      <span className="menu-text" style={{ fontSize: "17px" }}>
                        Features
                      </span>
                    </a>
                  </li>
                  <li
                    className="menu-item menu-item-submenu menu-item-rel"
                    data-menu-toggle="click"
                    aria-haspopup="true"
                  >
                    <a className="menu-link menu-toggle">
                      <span className="menu-text" style={{ fontSize: "17px" }}>
                        Crud
                      </span>
                    </a>
                  </li>
                  <li
                    className="menu-item menu-item-submenu menu-item-rel"
                    data-menu-toggle="click"
                    aria-haspopup="true"
                  >
                    <a className="menu-link menu-toggle">
                      <span className="menu-text" style={{ fontSize: "17px" }}>
                        Apps
                      </span>
                    </a>
                  </li>
                  <li
                    className="menu-item menu-item-submenu"
                    data-menu-toggle="click"
                    aria-haspopup="true"
                  >
                    <a className="menu-link menu-toggle">
                      <span className="menu-text" style={{ fontSize: "17px" }}>
                        Pages
                      </span>
                    </a>
                  </li>
                </ul>
              </div>
            </div>
          </div>
          {/*end::Card*/}
          {profile ? <EditUser user={user} image={image} /> : ""}
        </div>
        {/*end::Container*/}
      </div>
      {/*end::Entry*/}
    </div>
  );
}
