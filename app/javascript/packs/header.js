$(document).ready(function(){
  $body = $("body");
  $headerSub = $body.find(".header-sub");
  $headerSub.find(".logo-container .logo").on("click", function(){
    if($headerSub.find(".tabs-container").hasClass("opened")) {
      $headerSub.hide("slide", { direction: "left" }, 500);
      setTimeout(
      function() 
      {
        $body.find(".tabs-container").removeClass("opened").hide();
        $headerSub.show();
      }, 600);
    }
    else {
      console.log("something")
      $headerSub.find(".tabs-container").show("slide", { direction: "left" }, 500);
      $headerSub.find(".tabs-container").addClass("opened");
    }
  });
});