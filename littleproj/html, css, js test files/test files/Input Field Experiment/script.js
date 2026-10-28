let positionX = 0;
let positionY = 0;
// for box rotation:
let deg = 0;

function loadpage(){
    alert("Reloaded. Enjoy!");
}

function Triggerfocus() {
    let box = document.querySelector(".box");
    //box.style.backgroundColor = "red";
}

function Triggerblur() {
    let box = document.querySelector(".box");
    //box.style.backgroundColor = "blue";
}

function Triggerinput(){
    let box = document.querySelector(".box");

    if(positionX < 700 && positionY === 0){
        positionX += 50;
    }

    if(positionX === 700 && positionY < 500){
        positionY += 50;
    }

    if(positionX > 0 && positionY === 500){
        positionX -= 50;
    }

    if(positionX === 0 && positionY > 0){
        positionY -= 50;
    }

    // for box rotation: 
    deg += 50;

    // add: rotate("+deg+"deg) if you want to rotate the box as well.
    box.style.transform = "translate("+positionX+"px, "+positionY+"px) rotate("+deg+"deg)";

}