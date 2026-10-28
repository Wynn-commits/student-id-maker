function openRemove(modal){
    document.getElementById(modal).style.display = "flex";
    document.getElementById('overlay').style.display = "block";
}

function closeRemove(modal){
    document.getElementById(modal).style.display = "none";
    document.getElementById('overlay').style.display = "none";
}