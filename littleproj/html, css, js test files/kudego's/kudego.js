b = 5; //number
a = 5.55; // still number
c =  "Hello";//string
f = 'erwin'; //also a string
j = true; //booolean
const d = 4; //can't redeclared
var e = "me"; //can be changed
let nickname; //a default when declaring variables. cant redeclared. //also a undefinded since it has no value.
var pets = ["Dog", "Cat", "Sigbin"]; // array
var pets = ["Dog", "Cat", 80.5, "Sigbin", 19, 21]; // multiple data type array
var empty = []; //empty array
var student = {Key: "Value", Age: 16}; //object (dictionary in python)

console.log(c + " " + f); //string concatenation
console.log("Age is: " + x); // numbers converted into strings

let num = parseInt("6"); //string to number
let deci = parseFloat("4.45"); //string to number with decimal
console.log(deci); //unsucessfull conversion will turn into a NaN(Not a Number) Value

let g = 0; //prefix
console.log(++g); // plus 1
console.log(--g); // minus 1

let word = "I am Erwin";
let len = word.length; //measures the length of the string
console.log(len); // output: 10 (including spaces)

var name = "erwin";
console.log(name[0]) //string indices
name.toUpperCase(); //turns to uppercase
name.toLowerCase(); // turns to lowercase

var name1 = "   erwin   ";
name1.trim(); //trims the spaces on start and end of string.
// //name.trimEnd(); - trims the spaces at the end pf string, //name.trimStart - trims the spaces at start of string

let s = "I have a cat.";
s = s.replace("cat", "dog"); // replaces the first matching word on a string. //syntax: s.replace(from, to)
// s.replaceAll("cat", "dog") - replaces all matching word on a string
s = s.slice(2, 6) //gets the part of the string by specifying the start and end of index

console.log(`Hello ${name}`); // string template using "`(backticks)" and with "${}"

var pets = ["Dog", "Cat", 80.5, "Sigbin", 19, 21];
console.log(pets.length); //measures the array length
pets[2] = "isda"; //updates array
console.log(pets[0]);//reads specific array
pets.push("Kulaknit"); //adds element to the last index
pets.unshift("pig");//adds element on the first index
pets.pop();//deletes the last element
pets.shift();//deletes the first element
pets.slice(0, 2);// gets the part of the array.  (start index, last index)

//comparison operators:
console.log(5 == "5"); // equal, true statement
console.log(5 === "5"); // equal value and type, false statement
console.log(5 != "5"); // not equal, false statement
console.log(5 !== "5"); // not equal value and type, true statement

/* let day = Number(prompt("Enter a number from 1-7: "));

switch(day){
    case 1:
        console.log("Monday");
    case 2:
        console.log("Tuesday");
    case 3:
        console.log("Wednesday");
    case 4:
        console.log("Thursday");
    case 5:
        console.log("Friday");
    case 6:
        console.log("Saturday");
    case 7:
        console.log("Sunday");
    default:
        console.log("Invalid day");
} */

// while loop with array
/* let names = ["Erwin", "Grace", "Justin", "Joao"];
let i = 0;

while(names[i]){
    console.log(names[i]);
    i++;
} */

    // name.length - measures the length of the array

// do - while example
/* let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
let sum = 0;
let i = 0;

do {
    sum += numbers[i];
    i++
} while(numbers[i]);
console.log("Total: " + sum);
let avrg = sum / numbers.length;
console.log("Average: " +avrg); */

//for loop
/*for(let i = 0; i <= 10; i++){
    console.log(i);
}*/

//for-in (for-each) loop with example
/* let num = [10,20,30,40,50,60,70,80,90,100];
let largest = num[0];
for(let i in num){
    if(num[i] > largest){
        largest = num[i];
        break;
    }
}
console.log(largest); */

// find person example
/* let people = ["Erwin", "Justin", "Bea", "Mae", "Arlando"];
let find = "mae";

for(let i = 0; i < people.length; i++){
    if(people[i].toLowerCase() === find.toLowerCase()){
        console.log(`Found ${people[i]}`);
        break;
    } 
} */

// for-of example:
/* let words = ["Justin", "Bea", "Erwin", "Redgie", "Kyle"];

for(let letter of words){
    console.log(`${letter} has a total letters of ${letter.length}.`);
} */

    //function parameter example
    /*
    let sum = 0;
function total(numbers){
    for(let nums in numbers){
        sum += numbers[nums];
    }
    return sum;
}
let numbers = [10, 20, 30, 40, 50];
console.log(total(numbers)); 

function CtoF(celcius){
    return (celcius * 9/5) + 32;
}

function FtoC(fahrenheit){
    return (fahrenheit - 32) * 5/9;
}
    */

// find even number using function and .push()
/* function even_numbers(numbers){
    let evenNumbers = []; //wala unod na array
    for(let i = 0; i < numbers.length; i++){
        if(numbers[i] % 2 === 0){
            evenNumbers.push(numbers[i]); // butngan unod ang array na evenNumbers tungod sa .push()
        }
    }
    return evenNumbers;
}
console.log(even_numbers([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])); */

//classes and constructor example
/*class Vehicle{
    constructor(vehicleType, made, model, year, color){
        this.vehicleType = vehicleType;
        this.made = made;
        this.model = model;
        this.year = year;
        this.color = color;
    }
    Info(){
        console.log("Vehicle type: " + this.vehicleType);
        console.log("Made from: " + this.made);
        console.log("Model: " + this.model);
        console.log("Year: " + this.year);
        console.log("color: " + this.color);
    }
}
const car1 = new Vehicle("Car", "Toyota", "Chevrolet", 2006, "red");
car1.Info(); */

/* Encapsulation

class User{
    #password; // in private
    constructor(username, password){
        this.username = username;
        this.#password = password;
    }

    //getters and setters
    setUID(input){
        this.#UID = input;
    }

    getUID(){
        return this.#UID;
    }
}

const u1 = new User("Erwin", 1233321);

console.log(u1.username);
console.log(u1.#password); // can't be acessed because it is in private. */

/* Inheritance

class Animal{
    constructor(name, age){
        this.name = name;
        this.age = age;
    }

    introduce(){
        console.log("Name: " + this.name);
        console.log("Age: " + this.age);
    }
}

class Dog extends Animal{ // extends the ability coming form it's parent class.
    constructor(name, age, breed){
        super(name, age); // copies it's parent's ability
        this.breed = breed;
    }

    introduce(){
        super.introduce(); // copies it's parent's ability
        console.log("Breed: " + this.breed);
    }

    bark(){
        console.log(this.name + " Barks."); // only exclusive to the child class but parent class can't do this
    }

}

const dog = new Dog("Iskol", "13", "Husky");

dog.introduce();
dog.bark(); */

/* Polymorphism

class Water{
    water(){
        console.log("This is pure liquid water.");
    }
}

class Ice extends Water{
    water(){
        console.log("This is pure Solid ice."); //same method name but with different behavior.
    }
}

class Vapor extends Water{
    water(){
        console.log("This is pure evaporated water."); //same method name but with different behavior.
    }
}

const variations = [new Water(), new Ice(), new Vapor()];
variations.forEach(variation => variation.water()); */

/* Abstraction

class CoffeeMachine {
  start() {
    this.#heatWater(); // hides complex logic and exposes only the essential parts.
    this.#brewCoffee(); // hides complex logic and exposes only the essential parts.
    console.log("Coffee is ready!");
  }

  #heatWater() { //  hides complex logic and exposes only the essential parts.
    console.log("Heating water...");
  }

  #brewCoffee() { //  hides complex logic and exposes only the essential parts.
    console.log("Brewing coffee...");
  }
}

const machine = new CoffeeMachine();
machine.start(); */


// DOM Manipulation

// .innerHTML - changing the content of an html element
// document.querySelectorAll() - selects all the elements in the html document - stores them in an Array
// document.querySelector() - selects the first element in the html document
// document.getElementById() - selects the element with the specified id
// document.getElementsByClassName() - selects all elements with the specified class name
// document.getElementsByTagName() - selects all elements with the specified tag name

// every after . can do many things like:
// .value - gets the value of the element or sets the value of the element
// .innerHTML - gets the content of the element or sets the content of the element
// .style - gets the style of the element or sets the style of the element
// .src - gets the source of the element or sets the source of the element
// .href - gets the href of the element or sets the href of the element
// .target - gets the target of the element or sets the target of the element

// can manipulate also CSS styles (and many attributes more):
// .style.color = "red"; // changes the color of the text
// .style.backgroundColor = "blue"; // changes the background color of the element
// .style.fontSize = "20px"; // changes the font size of the text
// .style.fontFamily = "Arial"; // changes the font family of the text
// .style.border = "1px solid black"; // changes the border of the element
// .style.padding = "10px"; // changes the padding of the element
// .style.transform = "rotate(45deg)"; // rotates the element (could also be used to scale, skew, translate, etc. and to add degrees too.)

// DOM events
/* 
onload - when the page is loaded -- usuially used in the <body> tag
onclick - when the element is clicked
onmouseover - when the mouse is hovered over the element
onmouseout - when the mouse is hovered out of the element
onfocus - when the element is focused
onblur - when the element has lost focus
onchange - triggers when input is detected.
oninput - triggers when input value has changed.
onsubmit - when the form is submitted

// classlist - It gives you access to the list of CSS classes applied to that element.
ex: let box = document.querySelector(".box");
box.classList.add("rotate");   // adds the class "rotate"
box.classList.remove("rotate"); // removes the class "rotate"

// sample funcitons:
function greet(){
    let name = document.getElementById("input").value;
    let greeting = "Hello, " + name + "! Welcome!";
    document.getElementById("greeting").innerHTML = greeting;
}

//selection specification:
    let selected = document.querySelector("input[name=sex]:checked").value; 
    - means that specifically in the input ("input..."), specifically choose the 
    name with "sex" ("...[name=sex]...") name that is checked (...:checked) and gets it's value ("... .value")

//passing event object: 
    <input type="text" oninput="TextInput(event)">
    <input type="text" oninput="TextInput(event)">
    <input type="text" oninput="TextInput(event)">
function TextInput(e){
    let value = e.target.value;
    let p = document.querySelector("p");

    p.innerHTML = value;
}

- what this will do is the "e" parameter recieves the object. usually used in modal designs.

//arrow functions (=>) - are used when you only have one line of code inside a function.
EX: from: function add(x,y){
    return x + y;
}
    let sum = add(5,2);

    to: let add = (x,y) => x + y;
        let sum = add(5,2);


//timeout event function - used to delay running a function
ex: setTimeout(namefunction, 2000); - setTimeout(name of the function, millisecond);
ex2: set timeout with arrow function (for shorter line of code):
setTimeout(()=>{

    //contents like:
    let body = document.querySelector("body");
    body.style.transition = "1s";
    body.style.background = "black";
    
    }, 2000);

//setInterval - continuously loops a function on a fixed interval. Ex: setInterval(functionName, 3000);
example with arrow function:
setInterval(()=>{

    //contents like:
    let body = document.querySelector("body");
    body.style.transition = "1s";
    if(body.style.background === "black") body.style.background = "white";
    else body.style.background = "black";
    body.style.background = "black";
    
    }, 2000);
    
//spread operator (...namearray1) - spreads an array into another variable, and copies it's values.
ex:
const fruits1 = ["Apple", "Mango"];
const fruits2 = ["Banana", "Guava"];

const allFruits = ["Bayabas", ...fruits1, "Orange", ...fruits2]; 
- so what happened here is basically the triple dots "..." is spreading the array. so it's copying the array's values.
- can also add another value like that Orange in the middle and the Bayabas in the left
- so the result of allFruits are: "Bayabas" + fruits1 + "Orange" + fruits2 syntax.


// rest operator - used in a function to accept any numbers of parameters (function name(...numbers)). only effective with same name parameters
NOTE: rest operator must be in the last section to the parameter. so it would be: namefunction(x,y, ...Numbers);.
ex:
function summation(..numbers){
    let total = 0;
    for(const num of numbers){
        total += num;
    }
    return total;
}

let sum = summations(5,4,3,2,1);    


//new way to destructure JSON:

from: //old ways do destructure - one by one pa
let id = user.id;
let name = user.name;

to: // the new way to destructure - karon kay gi usa na
let {id,name} = user;
//so when printing, pwede ra japon ma acces usa usa

*/
