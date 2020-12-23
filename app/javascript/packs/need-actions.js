require("select2");

const form = $("form.need-actions-form");
const formDropdowns = form.find(".dropdown");
formDropdowns.select2();
formDropdowns.on("select2:select", () => {
  form.submit();
});

$(document).on("turbolinks:load", () => {
  $(".submit-on-change").change(e => {
    $(e.currentTarget)
      .closest("form")
      .submit();
  });
});
