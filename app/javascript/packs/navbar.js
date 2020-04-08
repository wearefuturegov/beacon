const sections = Object.assign({}, ...Array.from(document.querySelectorAll("a.anchor-point"))
    .map(section => ({ [section.id]: section.offsetTop })));

// todo: this should use a proper library, e.g. scrollspy
const updateHighlightedAnchor = () => {
    const scrollPosition = document.documentElement.scrollTop || document.body.scrollTop;
    const scrollSections = Object.entries(sections).filter(e => scrollPosition > e[1] - 50);
    const scrollSection = scrollSections[scrollSections.length - 1];
    if (scrollSection != null) {
        let currentlyActive = document.querySelector('.sidenav .active');
        if (currentlyActive != null) {
            //currentlyActive.classList.remove('active');
        }
        //document.querySelector('.sidenav a[href*=' + scrollSection[0] + ']').setAttribute('class', 'active');
    }
};

window.onscroll = () => {
    updateHighlightedAnchor();
};