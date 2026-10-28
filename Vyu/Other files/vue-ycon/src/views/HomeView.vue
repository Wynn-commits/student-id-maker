<template>
  <section class="hero">
    <img src="../assets/YConblue.png" class="profile">

    <h2>Hello! I'm Ycon Samson</h2>

    <p>
      A Front-End Developer passionate about creating
      beautiful and responsive web applications using Vue.js.
    </p>

    <button>Download Resume</button>
  </section>
</template>

<style scoped>
.hero{
    min-height:calc(100vh - 140px);

    display:flex;
    flex-direction:column;
    justify-content:center;
    align-items:center;

    text-align:center;

    padding:40px 20px;
}

h2 {
color: rgb(2, 64, 98);

}

.profile{
    width:200px;
    height:200px;
    border-radius: 50%;
    object-fit:cover;
    margin-bottom:20px;
}

p{
  color: rgb(2, 67, 51);
    max-width:500px;
    line-height:1.8;
    margin:20px 0;
}

button{
    padding:12px 30px;
    background-color: aqua;
    border: none;
    transition: all 0.3s;
    
}
button:hover{
  background-color: rgb(12, 185, 127);
  text-decoration: underline;
  color: rgb(243, 248, 248);
      border-radius: 30px;
}
</style>