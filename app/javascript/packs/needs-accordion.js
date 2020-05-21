$( document ).ready(function() {

$(".need-checkbox").each(function() {
    triggerClick($(this));
})

$(".need-checkbox").click(function() {
    triggerClick($(this));
  })
});

function triggerClick(el){
  let className = ".need-accordion-" + el.attr("data")
    if (el.prop("checked")) showAllElmsByClass(className)
    else hideAllElmsByClass(className)
}

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
