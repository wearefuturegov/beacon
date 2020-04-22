const form = document.querySelector(".role-switcher")
document.querySelector(".role-switcher input[type='submit']").style.display = "none"

form.addEventListener("change", () => {
    form.submit()
})