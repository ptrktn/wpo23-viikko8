import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["name", "year", "active", "chosenbrewery"];
    cached_breweries = {};

    connect() {
        this.loadBreweries();
    }

    // a new option was selected
    change(event) {
        if (event.target.value === "") {
            this.nameTarget.value = "";
            this.yearTarget.value = "";
            this.activeTarget.checked = false;
            this.chosenbreweryTarget.value = "";
        } else {
            this.nameTarget.value = this.cached_breweries[event.target.value].name;
            this.yearTarget.value = this.cached_breweries[event.target.value].registrationDate.substring(0, 4);
        }
    }

    async loadBreweries() {
        try {
          const response = await fetch('https://avoindata.prh.fi/bis/v1?totalResults=true&maxResults=500&businessLine=Oluen%20valmistus');
          // Serve the file locally to avoid 429 Too Many Requests
          // const response = await fetch('http://localhost:8000/data.json');
          const breweries = await response.json();
          this.populateBreweries(breweries["results"]);
        } catch (error) {
          console.error('Error fetching breweries:', error);
        }
    }

    populateBreweries(breweries) {
        this.chosenbreweryTarget.innerHTML = '<option value="">Select brewery from the list</option>';
        breweries.forEach(brewery => {
          const option = document.createElement('option');
          option.value = brewery.businessId;
          option.textContent = brewery.name;
          this.chosenbreweryTarget.appendChild(option);
          // cache the brewery data for eventual later use in change()
          this.cached_breweries[brewery.businessId] = brewery;
        });
      }

	reset(event) {
		event.preventDefault();
		this.nameTarget.value = "";
        this.yearTarget.value = "";
        this.activeTarget.checked = false;
        this.chosenbreweryTarget.value = "";
	}
}
