$( document ).ready(function() {
  $(".need-checkbox").click(function() {
    let className = ".need-accordion-" + $(this).attr("data")
    if ($(this).prop("checked")) showAllElmsByClass(className)
    else hideAllElmsByClass(className)
  })
});

function showAllElmsByClass(className) {
  for (let i = 0; i < $(className).length; i++) {
    $(className)[i].removeAttribute("hidden")
  }
}

function hideAllElmsByClass(className) {
  for (let i = 0; i < $(className).length; i++) {
    $(className)[i].setAttribute("hidden", "true")
  }
}
