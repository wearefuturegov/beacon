document.addEventListener("turbolinks:load", makeClickableLinks);
document.addEventListener("onready", makeClickableLinks);

function makeClickableLinks() {
  $("[data-target]").click(e => {
    e.preventDefault();
    Turbolinks.visit(e.currentTarget.getAttribute("data-target"));
  });
}
