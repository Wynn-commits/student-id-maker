function changeImage(element){
    const mainImage = document.getElementById("mainImage");

    mainImage.classList.add("slide");

    setTimeout(()=>{
        mainImage.src = element.src;
        mainImage.classList.remove("slide");
    },200);
}

function showStep(step){
    document.querySelectorAll('.step').forEach(s => s.classList.remove('active'));
    document.getElementById('step' + step).classList.add('active');
}

function showConfirmation(){
    showStep(2);
}

function showSuccess(){
    showStep(3);
}

window.onload = () => {
    document.body.style.overflow = 'auto';
};