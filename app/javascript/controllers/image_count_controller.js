import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="image-count"
export default class extends Controller {

  static targets = ["imageCount"]
  static values = {
    totalImage: Number
  }

  connect() {
    this.startNumber = 1
    this.imageCountTarget.innerText = `1/${this.totalImageValue}`
  }

  subtract() {
    this.startNumber -= 1
    if (this.startNumber === 0) {
      this.startNumber = this.totalImageValue
    }
    this.imageCountTarget.innerText = `${this.startNumber}/${this.totalImageValue}`
    // this.imageCountTarget.innerText =
  }

  add() {
    this.startNumber += 1
    if (this.startNumber === (this.totalImageValue + 1)) {
      this.startNumber = 1
    }
    this.imageCountTarget.innerText = `${this.startNumber}/${this.totalImageValue}`
  }
}
