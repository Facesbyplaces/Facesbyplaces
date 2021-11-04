$(document).ready(function () {
  const modal = document.getElementById("success-modal");
  const btn = document.getElementById("success-modal-button");
  const span = document.getElementsByClassName("close")[0];

  // When the user clicks on the button, open the modal
  btn.onclick = function () {
    modal.style.display = "block";
  };

  // When the user clicks on <span> (x), close the modal
  span.onclick = function () {
    modal.style.display = "none";
    location.reload();
  };

  // When the user clicks anywhere outside of the modal, close it
  window.onclick = function (event) {
    if (event.target == modal) {
      location.reload();
      modal.style.display = "none";
    }
  };
});
