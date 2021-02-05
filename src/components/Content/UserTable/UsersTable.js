import React from "react";
import Header from "./Header";
import Body from "./Body";

export default function UsersTable() {
  return (
    <div className="container">
      <div className="card card-custom">
        <Header />
        <Body />
      </div>
    </div>
  );
}
