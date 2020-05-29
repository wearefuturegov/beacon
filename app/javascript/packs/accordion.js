document.startAccordions = function(){
    const accordions = $(".accordion");
    let controls = accordions.find(".accordion__control");
    let contents = accordions.find(".accordion__content");
    $.each(controls, (index, control) => {
        control.addEventListener("click", () => {
            if (contents[index].hasAttribute("hidden")) {
                control.setAttribute("aria-expanded", "true");
                contents[index].removeAttribute("hidden");
            } else {
                control.setAttribute("aria-expanded", "false");
                contents[index].setAttribute("hidden", "hidden");
            }
        });
    });

    const assessmentAccordion = $(".accordion.assessment");
    const assessmentAccordionContent = assessmentAccordion.find(".accordion__content");
    if (assessmentAccordion.find(".checkbox__input.need-checkbox[type=checkbox][checked=checked]").length > 0) {
        assessmentAccordionContent.attr("aria-expanded", "true");
        assessmentAccordionContent.removeAttr("hidden");
    }
};

$( document ).ready(() => {
    document.startAccordions();
});