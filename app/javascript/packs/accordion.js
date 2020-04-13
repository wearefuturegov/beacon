const accordion = document.querySelector(".accordion")

let controls = accordion.querySelectorAll(".accordion__control")
let contents = accordion.querySelectorAll(".accordion__content")

controls.forEach((control, i) => control.addEventListener("click", e  => {
    if(contents[i].hasAttribute("hidden")){
        control.setAttribute("aria-expanded", "true")
        contents[i].removeAttribute("hidden")
    } else {
        control.setAttribute("aria-expanded", "false")
        contents[i].setAttribute("hidden", "true")
    }
}))