import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["amount", "abv", "price", "custom_amount"];
	static values = { vat: Number };

	change(event) {
		// a new option was selected!
		document.getElementById("custom-amount-input").style.visibility = (event.target.value === "" ? "visible" : "hidden");
	}
	
	calculate(event) {
		// Prevent the default form submission from reloading the page.
		event.preventDefault();
		const amount = (this.amountTarget.value !== "" ? parseFloat(this.amountTarget.value) : parseFloat(this.custom_amountTarget.value));
		const abv = parseFloat(this.abvTarget.value);
		const price = parseFloat(this.priceTarget.value);
		// numeric values are required to do the math
		if (isNaN(amount) || isNaN(abv) || isNaN(price)) return;
		// Amounts of alcohol tax per liter of pure alcohol for beers.
		let alcoholTax = 0;
		switch (true) {
        case (abv < 0.5):
            alcoholTax = 0;
        case (abv <= 3.5):
            alcoholTax = 0.2835;
        case (abv > 3.5):
            alcoholTax = 0.3805;
		}
		const beerTax = (amount * abv * alcoholTax);
		const vatAmount = (price - price / (1.0 + this.vatValue));
		const taxPercentage = ((beerTax + vatAmount) / price * 100.0);

		// search for the element where the result is shown
		const result = document.getElementById("result");
		result.innerHTML = `
        <p>Beer has ${beerTax.toFixed(2)} € of alcohol tax and ${vatAmount.toFixed(2)} € of value added tax.</p>
        <p> ${taxPercentage.toFixed(1)} % of the price is taxes.</p>`;
		console.log(amount, abv, price, this.vatValue, beerTax, vatAmount, taxPercentage);
	}

	reset(event) {
		event.preventDefault();
		this.amountTarget.value = "";
		this.abvTarget.value = 0;
		this.priceTarget.value = 0;
		document.getElementById("result").innerHTML = "";
	}
}
