const body = document.body;
const aboutSection = document.getElementById("about");
const navItems = document.querySelectorAll("nav li");

window.addEventListener('scroll', () => { 
    if (window.scrollY >= aboutSection.offsetTop - 30) { 
        body.classList.add('in-about');
        document.body.classList.add('not-in-home');

    } else { 
        body.classList.remove('in-about');
        document.body.classList.remove('not-in-home');
    }

});

const track = document.querySelector('.features-track');
const cards = document.querySelectorAll('.feature-card');
const container = document.querySelector('.carousel-container');

const btnNext = document.querySelector('.carousel-btn.right');
const btnPrev = document.querySelector('.carousel-btn.left');

let position = 0;

function getCardWidth(){
    return cards[0].offsetWidth + 40; 
}

function getMaxTranslate(){

    const trackWidth = track.scrollWidth;
    const containerWidth = container.offsetWidth;

    return trackWidth - containerWidth;

}

function updateCarousel(){ 
    track.style.transform = `translateX(-${position}px)`;
}

btnNext.addEventListener("click", () => {

    const cardWidth = getCardWidth(); 
    const maxTranslate = getMaxTranslate(); 

    if(position + cardWidth <= maxTranslate){ 
        position += cardWidth; 
    } else {
        position = maxTranslate;
    }

    updateCarousel(); 

});

btnPrev.addEventListener("click", () => {

    const cardWidth = getCardWidth();

    if(position - cardWidth >= 0){
        position -= cardWidth;
    } else {
        position = 0;
    }

    updateCarousel();

});

window.addEventListener("resize", () => {

    const maxTranslate = getMaxTranslate();

    if(position > maxTranslate){
        position = maxTranslate;
    }

    updateCarousel();

});