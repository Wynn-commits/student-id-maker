<template>
  <section class="about">
    <img
      src="../assets/bairan.jpg"
      alt="Profile Picture"
      class="profile"
    />

    <h2>Hello, I'm Mark Varian</h2>

    <p>
      Welcome to my personal website! I'm a passionate web developer who enjoys
      creating beautiful and responsive web applications using Vue.js,
      JavaScript, and modern web technologies.
    </p>

    <button>Learn More</button>
  </section>
</template>

<style scoped>
.about {
  text-align: center;
  padding: 60px 20px;
  background: white;
  max-width: 900px;
  margin: 40px auto;
  border-radius: 12px;
  box-shadow: 0 5px 15px rgba(0,0,0,.1);
}

.profile {
  width: 180px;
  height: 180px;
  border-radius: 50%;
  margin-bottom: 20px;
}

h2 {
  margin-bottom: 15px;
}

p {
  color: #555;
  line-height: 1.8;
  margin-bottom: 25px;
}

button {
  padding: 12px 25px;
  border: none;
  background: #42b983;
  color: white;
  border-radius: 5px;
  cursor: pointer;
  font-size: 16px;
}

button:hover {
  background: #369b6d;
}
</style>