require("select2");

const form = $("form.need-actions-form");
const formDropdowns = form.find(".dropdown");
formDropdowns.select2();
formDropdowns.on("select2:select", () => {
   form.submit();
});