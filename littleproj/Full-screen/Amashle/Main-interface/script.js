const header = document.getElementById("site-header");
const homeSection = document.getElementById("home");
const navItems = document.querySelectorAll("nav li");

window.addEventListener("scroll", function () {
    if(window.scrollY > homeSection.offsetHeight - 120){
        header.classList.add("scrolled");
    } else{
        header.classList.remove("scrolled");
    }

    let currentSection = "";

    document.querySelectorAll("section").forEach(function(section){
        const sectionTop = section.offsetTop - 140;
        if (window.scrollY >= sectionTop){
            currentSection = section.getAttribute("id");
        }
    });

    navItems.forEach(function (li){
        li.classList.remove("active");
        const link = li.querySelector("a");
        if(link.getAttribute("href") === "#" + currentSection) {
            li.classList.add("active");
        }
    });
});