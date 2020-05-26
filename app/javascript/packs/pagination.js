$(document).ready(() => {
    const pageSelect = $(".page-select");
    pageSelect.val("");

    const link = $("a.button.button--blue");
    link.addClass("disabled");

    const pageInQueryStringRegex = /page=\d+/;
    const hasQueryStringRegex = /[?&]/;

    pageSelect.keyup((event) => {
       if (event.currentTarget.value && event.currentTarget.validity.valid) {
           link.removeClass("disabled");
       } else {
           link.addClass("disabled");
       }
    });

    link.click(() => {
        const pageValue = +pageSelect.val();
        if (!pageValue) {
            return;
        }

        let currentHref = window.location.href;
        if (pageInQueryStringRegex.test(currentHref)) {
            currentHref = currentHref.replace(pageInQueryStringRegex, `page=${pageValue}`);

        } else {
            let separator = hasQueryStringRegex.test(currentHref)
                ? '&' : '?';
            currentHref = `${currentHref}${separator}page=${pageValue}`
        }
        link.attr("href", currentHref);
    });
});