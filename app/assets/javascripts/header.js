$(document).ready(function () {
  $body = $("body");
  $headerSubTab = $body.find(".header-sub-tab");
  $headerSub = $body.find(".header-sub-menu");
  $headerSub.find(".logo-container .logo").on("click", function () {
    if ($headerSubTab.find(".tabs-container").hasClass("opened")) {
      $headerSubTab
        .find(".tabs-container")
        .hide("slide", { direction: "up" }, 500);
      setTimeout(function () {
        $body.find(".tabs-container").removeClass("opened").hide();
        $headerSubTab.show();
      }, 500);
    } else {
      console.log("something");
      $headerSubTab
        .find(".tabs-container")
        .show("slide", { direction: "up" }, 500);
      $headerSubTab.find(".tabs-container").addClass("opened");
    }
  });
});
