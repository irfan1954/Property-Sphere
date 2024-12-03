import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  connect() {
    console.log('connected....');

  }

  static targets = ["input", "dropdown"];

  filter() {
    const searchText = this.inputTarget.value.toLowerCase();
    const options = Array.from(this.dropdownTarget.options);

    options.forEach((option) => {
      const text = option.textContent.toLowerCase();
      if (text.includes(searchText) || option.value === "") {
        option.hidden = false;
      } else {
        option.hidden = true;
      }
    });
  }
}
