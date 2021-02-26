import React, { useState } from "react";
import { useSelector } from "react-redux";

import Header from "./Header";
import Body from "./Body";
// Memorial CRUD
import ViewMemorial from "../MemorialCRUD/ALM/ViewMemorial";
import EditMemorial from "../MemorialCRUD/ALM/EditMemorial";
import AddMemorial from "../MemorialCRUD/ALM/AddMemorial";
// BLM CRUD
import ViewBlm from "../MemorialCRUD/BLM/ViewBlm";
import EditBlm from "../MemorialCRUD/BLM/EditBlm";
import AddBlm from "../MemorialCRUD/BLM/AddBlm";
import { SuccessModal } from "../MemorialCRUD/SuccessModal";

export default function MemorialsTable() {
  const [showModal, setShowModal] = useState(true);
  const { memorialTab } = useSelector(({ memorialTab }) => ({
    memorialTab: memorialTab,
  }));

  return (
    <div
      className="content content-height d-flex flex-column flex-column-fluid"
      id="kt_content"
    >
      {(() => {
        if (memorialTab.type === 2) {
          switch (memorialTab.option) {
            case "v":
              return <ViewMemorial />;
            case "e":
              return <EditMemorial />;
            case "a":
              return <AddMemorial />;
            case "d":
              return (
                <div className="container">
                  <SuccessModal
                    showModal={showModal}
                    setShowModal={setShowModal}
                  />
                  <div className="card card-custom">
                    <Header />
                    <Body />
                  </div>
                </div>
              );
            default:
              return (
                <div className="container">
                  <div className="card card-custom">
                    <Header />
                    <Body />
                  </div>
                </div>
              );
          }
        } else {
          switch (memorialTab.option) {
            case "v":
              return <ViewBlm />;
            case "e":
              return <EditBlm />;
            case "a":
              return <AddBlm />;
            case "d":
              return (
                <div className="container">
                  <SuccessModal
                    showModal={showModal}
                    setShowModal={setShowModal}
                  />
                  <div className="card card-custom">
                    <Header />
                    <Body />
                  </div>
                </div>
              );
            default:
              return (
                <div className="container">
                  <div className="card card-custom">
                    <Header />
                    <Body />
                  </div>
                </div>
              );
          }
        }
      })()}
    </div>
  );
}
