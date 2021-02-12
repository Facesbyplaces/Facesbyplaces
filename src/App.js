import React from "react";
import { Provider } from "react-redux";
import { BrowserRouter } from "react-router-dom";
import { PersistGate } from "redux-persist/integration/react";

import { Routes } from "./routes/Routes";

console.log("BASE_URL: ", process.env.REACT_APP_API_BASE_URL);
export default function App({ store, persistor }) {
  return (
    <Provider store={store}>
      <PersistGate persistor={persistor}>
        <BrowserRouter>
          <Routes />
        </BrowserRouter>
      </PersistGate>
    </Provider>
  );
}

// export default class App extends Component {
//   constructor() {
//     super();

//     this.state = {
//       loggedInStatus: "NOT_LOGGED_IN",
//       admin: {},
//       access_token: {},
//       client: {},
//     };

//     this.handleLogin = this.handleLogin.bind(this);
//   }

//   handleLogin(data, access_token, client) {
//     this.setState({
//       loggedInStatus: "LOGGED_IN",
//       admin: data.admin,
//       access_token: access_token,
//       client: client,
//     });
//   }

//   render() {
//     return (
//       <div className="App">
//         <BrowserRouter>
//           <Switch>
//             <Route
//               exact
//               path={"/admin"}
//               render={(props) => (
//                 <Home
//                   {...props}
//                   loggedInStatus={this.state.loggedInStatus}
//                   handleLogin={this.handleLogin}
//                 />
//               )}
//             />
//           </Switch>
//           <Switch>
//             <Route
//               exact
//               path={"/dashboard"}
//               render={(props) => (
//                 <Dashboard
//                   {...props}
//                   loggedInStatus={this.state.loggedInStatus}
//                   handleLogin={this.handleLogin}
//                 />
//               )}
//             />
//           </Switch>
//         </BrowserRouter>
//       </div>
//     );
//   }
// }
