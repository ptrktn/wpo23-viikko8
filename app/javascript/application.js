//= require jquery3
//= require popper
//= require bootstrap-sprockets

// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import { beers, breweries } from "custom/utils";

beers();
breweries();

// https://www.youtube.com/watch?v=jn22KyMEdwg
// https://www.beflagrant.com/blog/turbo-confirmation-bias-2024-01-10
// https://github.com/gorails-screencasts/custom-turbo-confirm-modal/blob/master/app/javascript/application.js
Turbo.setConfirmMethod((message, element, submitter) => {
	let dialog = document.getElementById("turbo-confirm-custom");
	let [messageText, confirmText, cancelText] = message.split(';');
	dialog.querySelector("#message").innerHTML = messageText;
	dialog.querySelector("#confirm").textContent =
		submitter?.dataset.confirmButton || confirmText || 'Yes' ;
	dialog.querySelector("#cancel").textContent =
		submitter?.dataset.cancelButton || cancelText || 'No' ;
	dialog.showModal();

	return new Promise((resolve, reject) => {
		dialog.addEventListener("close", () => {
			resolve(dialog.returnValue == "confirm")
		}, { once: true })
	});
});
