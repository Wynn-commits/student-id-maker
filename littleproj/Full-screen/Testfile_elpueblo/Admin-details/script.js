function changeImage(element){
    const mainImage = document.getElementById("mainImage");

    mainImage.classList.add("slide");

    setTimeout(()=>{
        mainImage.src = element.src;
        mainImage.classList.remove("slide");
    },200);
}