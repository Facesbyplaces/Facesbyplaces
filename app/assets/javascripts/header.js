$(document).ready(function () {
  $body = $("body");
  $headerSubTab = $body.find(".header-sub-tab");
  $headerSub = $body.find(".header-sub-menu");
  $headerSubTab.hide();
  $headerSub.find(".logo-container .logo").on("click", function () {
    if ($headerSubTab.find(".tabs-container").hasClass("opened")) {
      $headerSubTab.hide("slide", { direction: "up" }, 500);
      setTimeout(function () {
        $body.find(".tabs-container").removeClass("opened").hide();
        $headerSubTab.hide("slide", { direction: "up" });
      }, 100);
    } else {
      console.log("something");
      $headerSubTab.show("slide", { direction: "up" }, 185);
      setTimeout(function () {
        $headerSubTab
          .find("tabs-container")
          .show("slide", { direction: "down" });
      }, 500);

      $headerSubTab.find(".tabs-container").addClass("opened");
    }
  });
});
