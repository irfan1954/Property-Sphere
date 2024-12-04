import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="comment-form"
export default class extends Controller {
  static targets = ["display", "form", "textarea", "comment"];

  connect() {
    // Ensure the correct initial state
    this.toggleVisibility();
  }

  toggleVisibility() {
    const hasComment = this.commentTarget.textContent.trim() !== "";
    this.displayTarget.classList.toggle("hidden", !hasComment);
    this.formTarget.classList.toggle("hidden", hasComment);
  }

  edit() {
    this.formTarget.classList.remove("hidden");
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
    } else {
      alert("Comment cannot be empty!");
    }
  }
}
