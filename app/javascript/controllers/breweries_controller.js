import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["name", "year", "active"];

	reset(event) {
		event.preventDefault();
		this.nameTarget.value = "";
        this.yearTarget.value = "";
        this.activeTarget.checked = false;
	}
}
