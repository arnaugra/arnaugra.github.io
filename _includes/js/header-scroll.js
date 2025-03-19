document.addEventListener("scroll", () => {
    const header = document.querySelector("header");

    console.log(window.scrollY > 0, header);
    
    if (window.scrollY > 0) {
        header.classList.remove("after:!bottom-0");
    } else {
        header.classList.add("after:!bottom-0");
    }
});
