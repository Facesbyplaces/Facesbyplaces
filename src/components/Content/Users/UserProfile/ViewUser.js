import React, { useEffect, useState } from "react";
import axios from "../../../../auxiliary/axios";

import { useDispatch, useSelector } from "react-redux";
import { TableUserAction } from "../../../../redux/actions";
import EditUser from "./EditUser";
import { ContactUser } from "../Modals/ContactUser";

export default function ViewUser() {
  const dispatch = useDispatch();
  const [user, setUser] = useState([]);
  const [image, setImage] = useState(null);
  const [profile, setProfile] = useState(true);
  const [showModal, setShowModal] = useState(false);
  const { tab } = useSelector(({ tab }) => ({
    tab: tab,
  }));

  const handleTableClick = () => {
    dispatch(TableUserAction());
  };

  useEffect(() => {
    axios
      .get(`/api/v1/admin/users/show`, {
        params: { id: tab.id, account_type: tab.account_type },
      })
      .then((response) => {
        setUser(response.data);
        setImage(response.data.image);
      })
      .catch((error) => {
        console.log(error);
      });
  }, user.id);

  return (
    <div
      className="content content-height d-flex flex-column flex-column-fluid pb-0 pt-0"
      id="kt_content"
      style={{ height: "100%" }}
    >
      <ContactUser
        user={user}
        showModal={showModal}
        setShowModal={setShowModal}
      />
      <div
        className="d-flex flex-column-fluid"
        style={{ marginTop: "auto", marginBottom: "auto" }}
      >
        {/*begin::Container*/}
        <div className="container" style={{ margin: "auto" }}>
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
                      </div>
                      <div className="d-flex flex-wrap mt-2">
                        <div className="my-lg-0 my-3">
                          <a
                            className="btn btn-md btn-light-warning font-weight-bolder text-uppercase mr-3"
                            onClick={() => setShowModal((prev) => !prev)}
                          >
                            contact user
                          </a>
                        </div>
                      </div>
                    </div>
                  </div>
                  {/*end::Content*/}
                </div>
                {/*end::Info*/}
              </div>
              {/*end::Details*/}
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
