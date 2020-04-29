const filters = document.querySelector(".filters");
const exportButton = document.querySelector("#btnExport");

let control = filters.querySelector(".filters__controls");
let contents = filters.querySelector(".filters__content");

control && control.addEventListener("click", e  => {
    if(contents.hasAttribute("hidden")){
        control.setAttribute("aria-expanded", "true");
        control.innerHTML = "Close filters"
        contents.removeAttribute("hidden")
        filters.setAttribute("data-open", "true");
        exportButton.setAttribute("data-open", "true");
    } else {
        control.setAttribute("aria-expanded", "false")
        control.innerHTML = "Filters";
        contents.setAttribute("hidden", "true");
        filters.removeAttribute("data-open");
        exportButton.removeAttribute("data-open");
    }
})

let form = filters.querySelector("form")

form.addEventListener("change", () => {
    form.submit()
})