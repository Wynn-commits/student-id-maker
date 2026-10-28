let display = document.getElementById("display");

function appendDisplay(input){
    if(display.value === "0" || display.value === "Error"){
        display.value = input;
    } else {
        display.value += input;
    }
}

function clearDisplay(){
    display.value = "0";
}

function deleteLast(){
    if(display.value.length === 1 || display.value === "Error"){
        display.value = "0";
    } else{
        display.value = display.value.slice(0, -1);
    }
}

function calculate(){
    try {
        if (display.value.includes('%')) {
            display.value = eval(display.value.replace(/%/g, '/100'));
        } else {
            display.value = eval(display.value);
        }
    } catch (error) {
        display.value = "Error";
    }
}