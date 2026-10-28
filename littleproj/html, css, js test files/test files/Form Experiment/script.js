function Submit(){
    let firstname = document.getElementById("firstname").value;
    let lastname = document.getElementById("lastname").value;
    let country = document.querySelector("#country").value;
    let birthdate = document.getElementById("birthdate").value;
    let sex = document.querySelector("input[name=sex]:checked").value;
    let terms = document.querySelector("#checkbox").checked;

    let p = document.querySelector("p");

    if(firstname !== "Erwin Gail"){
        p.innerHTML = "You are not Erwin Gail. Incorrect Credential.";
    } else if(lastname !== "Orquillano"){
        p.innerHTML = "You are not Orquillano. Incorrect Credential.";
    } else if(country !== "PH"){
        p.innerHTML = "Incorrect Country.";
    } else if(birthdate !== "2006-04-12"){
        p.innerHTML = "Incorrect Birthdate.";
    } else if(sex !== "Male"){
        p.innerHTML = "You are not Gay. Incorrect credential.";
    } else if(!terms){
        p.innerHTML = "Please accept the Terms and Conditions.";
    } else {
        p.innerHTML = "Correct all";
    }
}