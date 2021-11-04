$(document).ready(function () {
  const openModalButtons = document.querySelectorAll("[data-modal-open]");
  console.log(openModalButtons);

  function openModal(modal) {
    console.log("clicked");
    modal.classList.add("show");
    console.log(modal);
  }

  // openModalButton.addEventListener("click", (event) => {
  //   event.preventDefault();
  //   openModal();
  // });

  openModalButtons.forEach((button) => {
    button.addEventListener("click", (event) => {
      event.preventDefault();

      const modal = document.querySelector(button.dataset.modalOpen);
      openModal(modal);
    });
  });

  // const openModalButtons = document.querySelectorAll("[data-modal-open]");
  // const closeModalButtons = document.querySelectorAll("[data-modal-close]");
  // const deleteUserButton = document.querySelector("[data-delete-user]");

  // // Open/Close Modal
  // function openModal(modal, link, token) {
  //   // console.log(modal);
  //   modal.classList.add("show");
  //   deleteUserButton.addEventListener("click", (event) => {
  //     event.preventDefault();
  //     delete_confirm(modal, link, token);
  //   });
  // }

  // function closeModal(modal) {
  //   // console.log(modal);
  //   modal.classList.remove("show");
  // }

  // // Delete User Data
  // function delete_confirm(modal, link, token) {
  //   console.log(modal);
  //   console.log(link);
  //   console.log(token);
  //   $.ajax({
  //     url: link,
  //     type: "DELETE",
  //     data: { auth_token: token, _method: "delete" },
  //     success: function (data) {
  //       console.log(data);
  //       modal.classList.remove("show");
  //     },
  //     error: function (err) {
  //       console.log(err);
  //       modal.classList.remove("show");
  //     },
  //   });
  // }

  // openModalButtons.forEach((button) => {
  //   button.addEventListener("click", (event) => {
  //     event.preventDefault();
  //     console.log("clicked");
  //     // openModal(modal, link, token);
  //   });
  // });

  // closeModalButtons.forEach((button) => {
  //   button.addEventListener("click", (event) => {
  //     event.preventDefault();

  //     const modal = button.closest(".modal");

  //     closeModal(modal);
  //   });
  // });
});
