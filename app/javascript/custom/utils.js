const BEERS = {};
const BREWERIES = {};

const handleResponse = (beers) => {
  BEERS.list = beers;
  BEERS.show();
};

const handleBreweryResponse = (breweries) => {
  BREWERIES.list = breweries;
  BREWERIES.show();
};

const createTableRow = (beer) => {
  const tr = document.createElement("tr");
  tr.classList.add("tablerow");
  const beername = tr.appendChild(document.createElement("td"));
  beername.innerHTML = beer.name;
  const style = tr.appendChild(document.createElement("td"));
  style.innerHTML = beer.style.name;
  const brewery = tr.appendChild(document.createElement("td"));
  brewery.innerHTML = beer.brewery.name;

  return tr;
};

const createBreweryTableRow = (brewery) => {
	const tr = document.createElement("tr");
	tr.classList.add("tablerow");
	const name = tr.appendChild(document.createElement("td"));
	name.innerHTML = brewery.name;
	const founded = tr.appendChild(document.createElement("td"));
	founded.innerHTML = brewery.year;
	const number_of_beers = tr.appendChild(document.createElement("td"));
	number_of_beers.innerHTML = brewery.number_of_beers;
	
	return tr;
};

BEERS.show = () => {
  document.querySelectorAll(".tablerow").forEach((el) => el.remove());
  const table = document.getElementById("beertable");

  BEERS.list.forEach((beer) => {
    const tr = createTableRow(beer);
    table.appendChild(tr);
  });
};

BREWERIES.show = () => {
  document.querySelectorAll(".tablerow").forEach((el) => el.remove());
  const table = document.getElementById("brewerytable");

  BREWERIES.list.forEach((brewery) => {
    const tr = createBreweryTableRow(brewery);
    table.appendChild(tr);
  });
};

BEERS.sortByName = () => {
  BEERS.list.sort((a, b) => {
    return a.name.toUpperCase().localeCompare(b.name.toUpperCase());
  });
};

BEERS.sortByStyle = () => {
  BEERS.list.sort((a, b) => {
    return a.style.name.toUpperCase().localeCompare(b.style.name.toUpperCase());
  });
};

BEERS.sortByBrewery = () => {
  BEERS.list.sort((a, b) => {
    return a.brewery.name
      .toUpperCase()
      .localeCompare(b.brewery.name.toUpperCase());
  });
};

BREWERIES.sortByName = () => {
  BREWERIES.list.sort((a, b) => {
    return a.name.toUpperCase().localeCompare(b.name.toUpperCase());
  });
};

// founded in ascending order
BREWERIES.sortByFounded = () => {
  BREWERIES.list.sort((a, b) => {
    return a.year - b.year
  });
};

// number of beers in descending order
BREWERIES.sortByNumberOfBeers = () => {
  BREWERIES.list.sort((a, b) => {
    return b.number_of_beers - a.number_of_beers
  });
};

const beers = () => {
	if (document.querySelectorAll("#beertable").length < 1) return;

	document.getElementById("name").addEventListener("click", (e) => {
		e.preventDefault;
		BEERS.sortByName();
		BEERS.show();
	});

	document.getElementById("style").addEventListener("click", (e) => {
		e.preventDefault;
		BEERS.sortByStyle();
		BEERS.show();
	});

	document.getElementById("brewery").addEventListener("click", (e) => {
		e.preventDefault;
		BEERS.sortByBrewery();
		BEERS.show();
	});

	fetch("beers.json")
		.then((response) => response.json())
		.then(handleResponse);
	
	// var request = new XMLHttpRequest();
	// request.onload = handleResponse;
	// request.open("get", "beers.json", true);
	// request.send();
};

const breweries = () => {
	if (document.querySelectorAll("#brewerytable").length < 1) return;

	document.getElementById("name").addEventListener("click", (e) => {
		e.preventDefault;
		BREWERIES.sortByName();
		BREWERIES.show();
	});

	document.getElementById("founded").addEventListener("click", (e) => {
		e.preventDefault;
		BREWERIES.sortByFounded();
		BREWERIES.show();
	});

	document.getElementById("number-of-beers").addEventListener("click", (e) => {
		e.preventDefault;
		BREWERIES.sortByNumberOfBeers();
		BREWERIES.show();
	});
	
	fetch("breweries.json")
	 .then((response) => response.json())
     .then(handleBreweryResponse);
};

export { beers };
export { breweries };
