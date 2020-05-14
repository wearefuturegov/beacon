$( document ).ready(function() {
  const set_need_section_visibility = (e) => {
    let className = ".need-accordion-" + $(e).attr("data")
    if ($(e).prop("checked")) showAllElmsByClass(className)
    else hideAllElmsByClass(className)
  };

  $(".need-checkbox").click(function() { set_need_section_visibility(this) })
  $(".need-checkbox").each(function() { set_need_section_visibility(this) })
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
