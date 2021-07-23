import React, { useState } from "react";
import { useSelector, useDispatch } from "react-redux";
import { ViewUserAction, EditUserAction } from "../../../../redux/actions";
import axios from "../../../../auxiliary/axios";
import { SuccessModal } from "../Modals/SuccessModal";

//Loader
import HashLoader from "react-spinners/HashLoader";

export default function EditUser({ user, image }) {
  const [showModal, setShowModal] = useState(false);
  const [loading, setLoading] = useState(false);
  const dispatch = useDispatch();
  const [edit, setEdit] = useState(false);
  const [selectedFile, setSelectedFile] = useState(null);
  const [username, setUsername] = useState("");
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [phoneNumber, setPhoneNumber] = useState("");
  const [errors, setErrors] = useState("");
  const { tab } = useSelector(({ tab }) => ({
    tab: tab,
  }));

  const fileSelectedHandler = (e) => {
    setSelectedFile(e.target.files[0]);
    console.log(e.target.files[0]);
    const formData = new FormData();
    formData.append("image", e.target.files[0]);
    formData.append("user_id", user.id);
    formData.append("account_type", user.account_type);
    console.log("Form Data: ", formData);
    axios
      .put("/api/v1/users/image_upload", formData)
      .then((response) => {
        console.log(response.data);
        window.location.reload(false);
      })
      .catch((error) => {
        console.log(error.response);
        setErrors(error.response);
      });
  };

  const handleUsernameChange = (e) => {
    setUsername(e.target.value);
  };

  const handleFirstNameChange = (e) => {
    setFirstName(e.target.value);
  };

  const handleLastNameChange = (e) => {
    setLastName(e.target.value);
  };

  const handlePhoneNumberChange = (e) => {
    setPhoneNumber(e.target.value);
  };

  const handleViewClick = (id, account_type, option) => {
    setEdit((prev) => !prev);
    dispatch(ViewUserAction({ id, account_type, option }));
  };

  const handleEditClick = (id, account_type, option) => {
    setEdit((prev) => !prev);
    dispatch(EditUserAction({ id, account_type, option }));
  };

  const openModal = () => {
    setShowModal((prev) => !prev);
  };

  const handleSubmit = (e) => {
    const user_name = username ? username : user.username;
    const first_name = firstName ? firstName : user.first_name;
    const last_name = lastName ? lastName : user.last_name;
    const phone_number = phoneNumber ? phoneNumber : user.phone_number;
    console.log("ID: ", user.id);
    console.log("Account Type: ", user.account_type);
    console.log("Username: ", user_name);
    console.log("First Name: ", first_name);
    console.log("Last Name: ", last_name);
    console.log("Phone Number: ", phone_number);
    // console.log("Email: ", email);
    setLoading(true);
    axios
      .put("/api/v1/admin/users/edit", {
        id: user.id,
        account_type: user.account_type,
        username: user_name,
        first_name: first_name,
        last_name: last_name,
        phone_number: phone_number,
      })
      .then((response) => {
        console.log(response.data);
        setTimeout(() => {
          setLoading(false);
        }, 1000);
        openModal();
      })
      .catch((error) => {
        console.log(error);
        setErrors(error.response.statusText);
      });

    e.preventDefault();
  };

  return (
    <div className="container">
      {loading ? (
        <div className="loader-container">
          <HashLoader color={"#04ECFF"} loading={loading} size={90} />
        </div>
      ) : (
        <div className="card card-custom">
          <SuccessModal showModal={showModal} setShowModal={setShowModal} />
          <form className="form" onSubmit={handleSubmit}>
            <div className="tab-content">
              {/*begin::Tab*/}
              <div className="tab-pane show active px-7 mt-5">
                <div className="card-header py-3 pl-5">
                  <div className="card-title align-items-start flex-column mb-2">
                    <h3 className="card-label font-weight-bolder text-dark">
                      Personal Information
                    </h3>
                    {edit || tab.option === "e" ? (
                      <span className="text-muted font-weight-bold font-size-sm mt-1">
                        Update user's personal information
                      </span>
                    ) : (
                      <span className="text-muted font-weight-bold font-size-sm mt-1">
                        User's personal information
                      </span>
                    )}
                  </div>
                </div>
              </div>
              <div className="tab-pane show active px-7" role="tabpanel">
                {/*begin::Row*/}
                <div className="row mt-10 mb-10">
                  <div className="col-xl-2" />
                  <div className="col-xl-7 my-2">
                    {/*begin::Row*/}
                    <div className="row">
                      <div className="col-9">
                        <h6 className="text-dark font-weight-bold mb-10">
                          User Info:
                        </h6>
                      </div>
                    </div>
                    {/*end::Row*/}
                    {/*begin::Group*/}
                    <div className="form-group row">
                      <label className="col-form-label col-3 text-lg-right text-left">
                        Avatar
                      </label>
                      <div className="col-9">
                        <div
                          className="image-input image-input-empty image-input-outline"
                          style={{
                            backgroundImage: image
                              ? `url( ${image})` || `url( ${selectedFile})`
                              : `url( "assets/media/users/blank.png" )`,
                          }}
                        >
                          <div className="image-input-wrapper" />
                          {edit || tab.option === "e" ? (
                            <label
                              className="btn btn-xs btn-icon btn-circle btn-white btn-hover-text-primary btn-shadow"
                              data-action="change"
                              data-toggle="tooltip"
                              title
                              data-original-title="Change avatar"
                            >
                              <span className="svg-icon svg-icon-xs svg-icon-light-secondary ml-3 mr-3">
                                <svg
                                  width="24px"
                                  height="24px"
                                  viewBox="0 0 24 24"
                                  version="1.1"
                                  xmlns="http://www.w3.org/2000/svg"
                                  xmlnsXlink="http://www.w3.org/1999/xlink"
                                >
                                  {/* Generator: Sketch 50.2 (55047) - http://www.bohemiancoding.com/sketch */}
                                  <title>Stockholm-icons / Design / Edit</title>
                                  <desc>Created with Sketch.</desc>
                                  <defs />
                                  <g
                                    id="Stockholm-icons-/-Design-/-Edit"
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
                                      d="M8,17.9148182 L8,5.96685884 C8,5.56391781 8.16211443,5.17792052 8.44982609,4.89581508 L10.965708,2.42895648 C11.5426798,1.86322723 12.4640974,1.85620921 13.0496196,2.41308426 L15.5337377,4.77566479 C15.8314604,5.0588212 16,5.45170806 16,5.86258077 L16,17.9148182 C16,18.7432453 15.3284271,19.4148182 14.5,19.4148182 L9.5,19.4148182 C8.67157288,19.4148182 8,18.7432453 8,17.9148182 Z"
                                      id="Path-11"
                                      fill="#000000"
                                      fillRule="nonzero"
                                      transform="translate(12.000000, 10.707409) rotate(-135.000000) translate(-12.000000, -10.707409) "
                                    />
                                    <rect
                                      id="Rectangle"
                                      fill="#000000"
                                      opacity="0.3"
                                      x={5}
                                      y={20}
                                      width={15}
                                      height={2}
                                      rx={1}
                                    />
                                  </g>
                                </svg>
                              </span>
                              <input
                                type="file"
                                accept=".png, .jpg, .jpeg"
                                onChange={fileSelectedHandler}
                              />
                            </label>
                          ) : (
                            ""
                          )}
                        </div>
                      </div>
                    </div>
                    {/*end::Group*/}
                    {/*begin::Group*/}
                    {/* Show Errors if existing */}
                    <div className="form-group row">
                      <label className="col-form-label col-3 text-lg-right text-left"></label>
                      <div className="col-9">
                        {errors ? (
                          <p
                            className="opacity-80 font-weight-bold"
                            style={{ color: "red" }}
                          >
                            {errors}
                          </p>
                        ) : (
                          ""
                        )}
                      </div>
                    </div>
                    <div className="form-group row">
                      <label className="col-form-label col-3 text-lg-right text-left">
                        Username
                      </label>
                      <div className="col-9">
                        {edit || tab.option === "e" ? (
                          <input
                            className="form-control form-control-lg form-control-solid placeholder-dark-75"
                            type="username"
                            name="username"
                            defaultValue={user.username}
                            onChange={handleUsernameChange}
                            required
                          />
                        ) : (
                          <input
                            className="form-control form-control-lg border-0 placeholder-dark-75"
                            type="username"
                            name="username"
                            defaultValue={user.username}
                            disabled
                          />
                        )}
                      </div>
                    </div>
                    {/*end::Group*/}
                    {/*begin::Group*/}
                    <div className="form-group row">
                      <label className="col-form-label col-3 text-lg-right text-left">
                        First Name
                      </label>
                      <div className="col-9">
                        {edit || tab.option === "e" ? (
                          <input
                            className="form-control form-control-lg form-control-solid"
                            type="first_name"
                            name="first_name"
                            onChange={handleFirstNameChange}
                            defaultValue={user.first_name}
                            required
                          />
                        ) : (
                          <input
                            className="form-control form-control-lg border-0 placeholder-dark-75"
                            type="first_name"
                            name="first_name"
                            defaultValue={user.first_name}
                            disabled
                          />
                        )}
                      </div>
                    </div>
                    {/*end::Group*/}
                    {/*begin::Group*/}
                    <div className="form-group row">
                      <label className="col-form-label col-3 text-lg-right text-left">
                        Last Name
                      </label>
                      <div className="col-9">
                        {edit || tab.option === "e" ? (
                          <input
                            className="form-control form-control-lg form-control-solid"
                            type="last_name"
                            name="last_name"
                            onChange={handleLastNameChange}
                            defaultValue={user.last_name}
                            required
                          />
                        ) : (
                          <input
                            className="form-control form-control-lg border-0 placeholder-dark-75"
                            type="last_name"
                            name="last_name"
                            defaultValue={user.last_name}
                            disabled
                          />
                        )}
                      </div>
                    </div>
                    {/*end::Group*/}
                    {/*begin::Group*/}
                    <div className="form-group row">
                      <label className="col-form-label col-3 text-lg-right text-left">
                        Contact Phone
                      </label>
                      <div className="col-9">
                        <div className="input-group input-group-lg input-group-solid">
                          <div className="input-group-prepend">
                            <span className="svg-icon svg-icon-md svg-icon-light-secondary ml-3 mr-3">
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
                                  Stockholm-icons / Communication / Call#1
                                </title>
                                <desc>Created with Sketch.</desc>
                                <defs />
                                <g
                                  id="Stockholm-icons-/-Communication-/-Call#1"
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
                                    d="M11.914857,14.1427403 L14.1188827,11.9387145 C14.7276032,11.329994 14.8785122,10.4000511 14.4935235,9.63007378 L14.3686433,9.38031323 C13.9836546,8.61033591 14.1345636,7.680393 14.7432841,7.07167248 L17.4760882,4.33886839 C17.6713503,4.14360624 17.9879328,4.14360624 18.183195,4.33886839 C18.2211956,4.37686904 18.2528214,4.42074752 18.2768552,4.46881498 L19.3808309,6.67676638 C20.2253855,8.3658756 19.8943345,10.4059034 18.5589765,11.7412615 L12.560151,17.740087 C11.1066115,19.1936265 8.95659008,19.7011777 7.00646221,19.0511351 L4.5919826,18.2463085 C4.33001094,18.1589846 4.18843095,17.8758246 4.27575484,17.613853 C4.30030124,17.5402138 4.34165566,17.4733009 4.39654309,17.4184135 L7.04781491,14.7671417 C7.65653544,14.1584211 8.58647835,14.0075122 9.35645567,14.3925008 L9.60621621,14.5173811 C10.3761935,14.9023698 11.3061364,14.7514608 11.914857,14.1427403 Z"
                                    id="Path-76"
                                    fill="#000000"
                                  />
                                </g>
                              </svg>
                            </span>
                          </div>
                          {edit || tab.option === "e" ? (
                            <input
                              type="text"
                              className="form-control form-control-lg form-control-solid"
                              type="phone_number"
                              name="phone_number"
                              onChange={handlePhoneNumberChange}
                              defaultValue={user.phone_number}
                              required
                            />
                          ) : (
                            <input
                              type="text"
                              className="form-control form-control-lg border-0 placeholder-dark-75"
                              type="phone_number"
                              name="phone_number"
                              defaultValue={user.phone_number}
                              disabled
                            />
                          )}
                        </div>
                      </div>
                    </div>
                    {/*end::Group*/}
                    {/*begin::Footer*/}
                    <div className="card-footer pb-0">
                      <div className="row">
                        <div className="col-xl-2 pt-5" />
                        <div className="col-xl-7">
                          <div className="row">
                            <div className="col-3" />
                            {edit || tab.option === "e" ? (
                              <div className="col-9">
                                <button
                                  type="submit"
                                  className="btn btn-success font-weight-bold mr-2"
                                >
                                  Save changes
                                </button>
                                <a
                                  className="btn btn-secondary font-weight-bold"
                                  onClick={() =>
                                    handleViewClick(
                                      user.id,
                                      user.account_type,
                                      "v"
                                    )
                                  }
                                >
                                  Cancel
                                </a>
                              </div>
                            ) : (
                              <div className="col-9">
                                <a
                                  className="btn btn-success btn-md btn-block font-weight-bold mr-2"
                                  onClick={() =>
                                    handleEditClick(
                                      user.id,
                                      user.account_type,
                                      "e"
                                    )
                                  }
                                >
                                  Edit
                                </a>
                              </div>
                            )}
                          </div>
                        </div>
                      </div>
                    </div>
                    {/*end::Footer*/}
                  </div>
                </div>
                {/*end::Row*/}
              </div>
              {/*end::Tab*/}
            </div>
          </form>
        </div>
      )}
    </div>
  );
}
