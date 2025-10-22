// Define const variables
const access_key = "GnOhf2hDnbFLoRsXbw_8H9teH9dyH2TXNYy6gT3-QPo";
const form_el = document.querySelector("form");
const input_el = document.getElementById("search-input");
const search_results = document.querySelector(".images");
const show_more = document.getElementById("show-button");

let input_data = "";
let page = 1;

// Search image function
async function search_images(){
    input_data = input_el.value;
    const url = `https://api.unsplash.com/search/photos?page=${page}&query=${input_data}&client_id=${access_key}`;

    // Fetch, get, and transform input data into a json and store json data
    const response = await fetch(url);
    const data = await response.json();
    const results = data.results;

    if (page === 1) {
        search_results.innerHTML = "";
    }

    // Push json data into the template
    results.map((result) => {
        const image_wrapper = document.createElement("div");
        image_wrapper.classList.add("image-example0");
        const image = document.createElement("img");
        image.src = result.urls.small;
        image.alt = result.alt_description;
        const image_link = document.createElement("a");
        image_link.href = result.links.html;
        image_link.target = "_blank";
        image_link.textContent = result.alt_description;

        // Append elements into html
        image_wrapper.appendChild(image);
        image_wrapper.appendChild(image_link);
        search_results.appendChild(image_wrapper);
    });

    // Show more pages
    page++;
    if (page > 1) {
        show_more.style.display = "block";
    }
}

// show more button function
form_el.addEventListener("submit", (event) => {
    event.preventDefault();
    page = 1;
    search_images();
});
// If clicked
show_more.addEventListener("click", () => {
    search_images();
});