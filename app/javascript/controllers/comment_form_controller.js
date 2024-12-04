import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="comment-form"
export default class extends Controller {
  static targets = ["display", "formWrapper", "form", "textarea", "comment"];

  connect() {
    // Ensure the correct initial state
    this.toggleVisibility();
  }

  csrfToken() {
    return document.querySelector("meta[name='csrf-token']").content;
  }

  toggleVisibility() {
    const hasComment = this.commentTarget.textContent.trim() !== "";
    this.displayTarget.classList.toggle("hidden", !hasComment);
    this.formWrapperTarget.classList.toggle("hidden", hasComment);
  }

  edit() {
    this.formWrapperTarget.classList.remove("hidden");
    this.displayTarget.classList.add("hidden");
    this.textareaTarget.value = this.commentTarget.textContent.trim();
  }

  save(event) {
    // Prevent default form submission
    event.preventDefault();

    // Capture and save the comment
    const newComment = this.textareaTarget.value.trim();

    if (newComment) {
      // Simulate saving comment via AJAX
      this.commentTarget.textContent = newComment;
      this.toggleVisibility();
      console.log(this.formTarget.action)
      fetch(this.formTarget.action, {
        method: "PATCH",
        headers: {"Accept": "application/json", "X-CSRF-Token": this.csrfToken()},
        body: new FormData(this.formTarget)
      })
        .then(response => response.json())
        .then((data) => {
          console.log(data);
          document.querySelector("body").insertAdjacentHTML("beforeend", data.response)
        })

    } else {
      alert("Comment cannot be empty!");
    }
  }
}
