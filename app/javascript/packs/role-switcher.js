const form = document.querySelector(".role-switcher")
const submitBtn = document.querySelector(".role-switcher input[type='submit']");
if(submitBtn){
    submitBtn.style.display = "none";
}
if(form){
    form.addEventListener("change", () => {
        form.submit()
    });
}