const filters = document.querySelector(".filters")

let control = filters.querySelector(".filters__controls")
let contents = filters.querySelector(".filters__content")

control.addEventListener("click", e  => {
    if(contents.hasAttribute("hidden")){
        control.setAttribute("aria-expanded", "true")
        control.innerHTML = "Close filters"
        contents.removeAttribute("hidden")
    } else {
        control.setAttribute("aria-expanded", "false")
        control.innerHTML = "Filters"
        contents.setAttribute("hidden", "true")
    }
})

let form = filters.querySelector("form")

form.addEventListener("change", () => {
    form.submit()
})