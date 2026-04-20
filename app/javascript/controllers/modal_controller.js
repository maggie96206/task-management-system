import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener("turbo:frame-load", this.onLoad.bind(this))
    this.handleKeydown = this.closeOnEscape.bind(this)
    this.handleTurboLoad = this.onTurboLoad.bind(this)
    window.addEventListener("keydown", this.handleKeydown)
    document.addEventListener("turbo:load", this.handleTurboLoad)
  }

  disconnect() {
    window.removeEventListener("keydown", this.handleKeydown)
    document.removeEventListener("turbo:load", this.handleTurboLoad)
  }

  onLoad() {
    if (this.element.children.length > 0) {
      this.element.setAttribute("data-open", "")
    } else {
      this.element.removeAttribute("data-open")
    }
  }

  onTurboLoad() {
    if (this.element.children.length === 0) {
      this.element.removeAttribute("data-open")
    }
  }

  close(event) {
    event?.preventDefault()
    this.element.removeAttribute("data-open")
    this.element.innerHTML = ""
    Turbo.visit(this.element.dataset.returnUrl || "/")
  }

  closeOnBackdrop(event) {
    if (event.target === this.element) {
      this.close(event)
    }
  }

  closeOnEscape(event) {
    if (event.key === "Escape" && this.element.hasAttribute("data-open")) {
      this.close(event)
    }
  }
}
