document.addEventListener("DOMContentLoaded", () => {
  $(".o-file-field").change(e => {
    e.currentTarget.setAttribute("data-selected", true);
    const value = $(e.currentTarget)
      .find("input")
      .val();
    $(e.currentTarget)
      .find(".filename")
      .html(value);
  });
});
