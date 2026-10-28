function openLogout(modal){
    document.getElementById(modal).style.display = "flex";
    document.getElementById('overlay').style.display = "block";
}

function closeLogout(modal){
    document.getElementById(modal).style.display = "none";
    document.getElementById('overlay').style.display = "none";
}