import React, { useState } from "react";
import { useSelector, useDispatch } from "react-redux";
import { TableUserAction } from "../../../../../redux/actions";
import axios from "../../../../../auxiliary/axios";
//Loader
import HashLoader from "react-spinners/HashLoader";
import { SuccessModal } from "./SuccessModal";

export default function AddUser() {
  const dispatch = useDispatch();
  const [showModal, setShowModal] = useState(false);
  const [loading, setLoading] = useState(false);
  const [errors, setErrors] = useState("");
  const [accountType, setAccountType] = useState(0);
  const [selectedFile, setSelectedFile] = useState(null);
  const [image, setImage] = useState(null);
  const [username, setUsername] = useState("");
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [phoneNumber, setPhoneNumber] = useState("");
  const [email, setEmail] = useState("");
  const [user, setUser] = useState("");
  const [password, setPassword] = useState("");
  const { tab } = useSelector(({ tab }) => ({
    tab: tab,
  }));

  const handleAccountTypeClicked = (e) => {
    setAccountType(e);
  };

  const fileSelectedHandler = (e) => {
    setImage(URL.createObjectURL(e.target.files[0]));
    setSelectedFile(e.target.files[0]);
    console.log(URL.createObjectURL(e.target.files[0]));
  };

  const uploadImage = (user) => {
    console.log(user);
    const formData = new FormData();
    formData.append("image", selectedFile);
    formData.append("user_id", user.id);
    formData.append("account_type", user.account_type);
    console.log("Form Data: ", formData);
    axios
      .post("/api/v1/users/image_upload", formData)
      .then((response) => {
        console.log(response.data);
      })
      .catch((error) => {
        console.log(error.response.data.errors);
        setErrors(error.response.data.errors);
      });
  };

  const handleEmailChange = (e) => {
    setEmail(e.target.value);
  };

  const handlePasswordChange = (e) => {
    setPassword(e.target.value);
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

  const handleTableClick = () => {
    dispatch(TableUserAction());
  };

  const openModal = () => {
    setShowModal((prev) => !prev);
  };

  const handleSubmit = (e) => {
    setLoading(true);
    const url = accountType == 1 ? "/auth" : "/alm_auth";
    console.log("Username: ", username);
    console.log("First Name: ", firstName);
    console.log("Last Name: ", lastName);
    console.log("Phone Number: ", phoneNumber);
    console.log("Email: ", email);
    console.log("Password: ", password);
    console.log("Account Type: ", accountType);
    console.log("Tab Option: ", tab);

    axios
      .post(url, {
        email: email,
        password: password,
        username: username,
        first_name: firstName,
        last_name: lastName,
        phone_number: phoneNumber,
        account_type: accountType,
      })
      .then((response) => {
        console.log(response.data);
        uploadImage(response.data.data);
        setTimeout(() => {
          setLoading(false);
        }, 1000);
        openModal();
      })
      .catch((error) => {
        console.log(error.response);
        setErrors(error.response);
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
                    <span className="text-muted font-weight-bold font-size-sm mt-1">
                      Add user's personal information
                    </span>
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
                              ? `url( ${image})`
                              : `url( "assets/media/users/blank.png" )`,
                          }}
                        >
                          <div className="image-input-wrapper" />

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
                        </div>
                      </div>
                    </div>
                    {/*end::Group*/}
                    {/*begin::Group*/}
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
                        First Name
                      </label>
                      <div className="col-9">
                        <input
                          className="form-control form-control-lg form-control-solid"
                          type="first_name"
                          name="first_name"
                          value={firstName}
                          onChange={handleFirstNameChange}
                          placeholder="First Name"
                          required
                        />
                      </div>
                    </div>
                    {/*end::Group*/}
                    {/*begin::Group*/}
                    <div className="form-group row">
                      <label className="col-form-label col-3 text-lg-right text-left">
                        Last Name
                      </label>
                      <div className="col-9">
                        <input
                          className="form-control form-control-lg form-control-solid"
                          type="last_name"
                          name="last_name"
                          value={lastName}
                          onChange={handleLastNameChange}
                          placeholder="Last Name"
                          required
                        />
                      </div>
                    </div>
                    {/*end::Group*/}
                    {/*begin::Group*/}
                    <div className="form-group row">
                      <label className="col-form-label col-3 text-lg-right text-left">
                        Username
                      </label>
                      <div className="col-9">
                        <input
                          className="form-control form-control-lg form-control-solid placeholder-dark-75"
                          type="username"
                          name="username"
                          placeholder="Username"
                          value={username}
                          onChange={handleUsernameChange}
                          required
                        />
                      </div>
                    </div>
                    {/*end::Group*/}
                    {/*begin::Group*/}
                    <div className="form-group row">
                      <label className="col-form-label col-3 text-lg-right text-left">
                        Password
                      </label>
                      <div className="col-9">
                        <input
                          className="form-control form-control-lg form-control-solid placeholder-dark-75"
                          type="password"
                          name="password"
                          placeholder="Password"
                          value={password}
                          onChange={handlePasswordChange}
                          required
                        />
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
                          <input
                            type="text"
                            className="form-control form-control-lg form-control-solid"
                            type="phone_number"
                            name="phone_number"
                            value={phoneNumber}
                            onChange={handlePhoneNumberChange}
                            placeholder="Contact Number"
                            required
                          />
                        </div>
                      </div>
                    </div>
                    {/*end::Group*/}
                    {/*begin::Group*/}
                    <div className="form-group row">
                      <label className="col-form-label col-3 text-lg-right text-left">
                        Email Address
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
                                  Stockholm-icons / Communication / Mail-at
                                </title>
                                <desc>Created with Sketch.</desc>
                                <defs />
                                <g
                                  id="Stockholm-icons-/-Communication-/-Mail-at"
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
                                    d="M11.575,21.2 C6.175,21.2 2.85,17.4 2.85,12.575 C2.85,6.875 7.375,3.05 12.525,3.05 C17.45,3.05 21.125,6.075 21.125,10.85 C21.125,15.2 18.825,16.925 16.525,16.925 C15.4,16.925 14.475,16.4 14.075,15.65 C13.3,16.4 12.125,16.875 11,16.875 C8.25,16.875 6.85,14.925 6.85,12.575 C6.85,9.55 9.05,7.1 12.275,7.1 C13.2,7.1 13.95,7.35 14.525,7.775 L14.625,7.35 L17,7.35 L15.825,12.85 C15.6,13.95 15.85,14.825 16.925,14.825 C18.25,14.825 19.025,13.725 19.025,10.8 C19.025,6.9 15.95,5.075 12.5,5.075 C8.625,5.075 5.05,7.75 5.05,12.575 C5.05,16.525 7.575,19.1 11.575,19.1 C13.075,19.1 14.625,18.775 15.975,18.075 L16.8,20.1 C15.25,20.8 13.2,21.2 11.575,21.2 Z M11.4,14.525 C12.05,14.525 12.7,14.35 13.225,13.825 L14.025,10.125 C13.575,9.65 12.925,9.425 12.3,9.425 C10.65,9.425 9.45,10.7 9.45,12.375 C9.45,13.675 10.075,14.525 11.4,14.525 Z"
                                    id="@"
                                    fill="#000000"
                                  />
                                </g>
                              </svg>
                            </span>
                          </div>
                          <input
                            type="email"
                            className="form-control form-control-lg form-control-solid"
                            name="email"
                            value={email}
                            onChange={handleEmailChange}
                            placeholder="Email"
                            required
                          />
                        </div>
                      </div>
                    </div>
                    {/*end::Group*/}
                    {/*begin::Group*/}
                    <div className="form-group row">
                      <label className="col-form-label col-3 text-lg-right text-left">
                        Account Type
                      </label>
                      <div className="col-9">
                        <div
                          className="btn-group btn-group-toggle"
                          data-toggle="buttons"
                        >
                          <button
                            type="button"
                            className="btn btn-outline-info mr-2"
                            style={{ width: "100px" }}
                            onClick={() => handleAccountTypeClicked(2)}
                          >
                            ALM
                          </button>
                          <button
                            type="button"
                            className="btn btn-outline-info mr-2"
                            style={{ width: "100px" }}
                            onClick={() => handleAccountTypeClicked(1)}
                          >
                            BLM
                          </button>
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
                            <div className="col-9">
                              <button
                                type="submit"
                                className="btn btn-success font-weight-bold mr-2"
                                style={{ width: "100px" }}
                              >
                                Save
                              </button>
                              <a
                                className="btn btn-secondary font-weight-bold"
                                style={{ width: "100px" }}
                                onClick={() => handleTableClick()}
                              >
                                Cancel
                              </a>
                            </div>
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