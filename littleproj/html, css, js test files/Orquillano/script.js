function openModal(modal){
    document.getElementById(modal).style.display = "flex";
    document.getElementById('overlay').style.display = "block";
}

function closeModal(modal){
    document.getElementById(modal).style.display = "none";
    document.getElementById('overlay').style.display = "none";
}


function hoverImage(unhoverID, hoverID){
    document.getElementById(unhoverID).style.display = "none";
    document.getElementById(hoverID).style.display = "block";
}

function unhoverImage(unhoverID, hoverID){
    document.getElementById(unhoverID).style.display = "block";
    document.getElementById(hoverID).style.display = "none";
}

function modalhoverImage(unhoverId, hoverId){
    document.getElementById(unhoverId).style.display = "none";
    document.getElementById(hoverId).style.display = "block";
}

function modalunhoverImage(unhoverId, hoverId){
    document.getElementById(unhoverId).style.display = "block";
    document.getElementById(hoverId).style.display = "none";
}