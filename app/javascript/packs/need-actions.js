require("select2");

const form = $("form.need-actions");
const formDropdowns = form.find(".dropdown");
formDropdowns.select2();
formDropdowns.on("select2:select", () => {
   form.submit();
});