<template>
  <div>

    <Header />

    <!-- Hero -->
    <section class="hero">
        <img src="https://i.pinimg.com/originals/5d/24/4d/5d244d864f4bf023ef13f5bca9d9a99c.jpg" style="height: 200px; width:200px;"/>
      <div class="container">
        <h2>Hello, I'm <span>Gavin Calumba</span></h2>

        <p>
          I am an aspiring Developer passionate about building modern web
          applications.
        </p>

        <button @click="showMessage">
          Hire Me
        </button>
      </div>
    </section>

    <!-- About -->
    <section id="about" class="section">
      <div class="container">
        <h2>About Me</h2>

        <p>
          I am currently looking for an opportunity as a Developer where I can
          improve my skills and contribute to meaningful projects.
        </p>
      </div>
    </section>

    <!-- Skills -->
    <section id="skills" class="section light">
      <div class="container">
        <h2>Skills</h2>

        <div class="cards">
          <div
            class="card"
            v-for="skill in skills"
            :key="skill"
          >
            {{ skill }}
          </div>
        </div>
      </div>
    </section>

    <!-- Projects -->
    <section id="projects" class="section">
      <div class="container">
        <h2>Projects</h2>

        <div
          class="project-card"
          v-for="project in projects"
          :key="project.title"
        >
          <h3>{{ project.title }}</h3>
          <p>{{ project.description }}</p>
        </div>
      </div>
    </section>

    <!-- Contact -->
    <section id="contact" class="section light">
      <div class="container">
        <h2>Contact</h2>

        <p>Email: GavinGallagher@email.com</p>
        <p>GitHub: github.com/GavinGallagher</p>
      </div>
    </section>

    <Footer />

  </div>
</template>

  <style>
    img{
        transition: all 0.3s ease-in-out;
    }

    img:hover{
        transform:translateX(600px) rotate(4turn);
    }
  </style>


<script setup>
import Header from "../components/AppHeader.vue";
import Footer from "../components/AppFooter.vue";

import { ref } from "vue";

const skills = ref([
  "HTML",
  "CSS",
  "JavaScript",
  "Vue.js",
  "Node.js",
  "Git",
]);

const projects = ref([
  {
    title: "Portfolio Website",
    description: "A responsive portfolio built with Vue.",
  },
  {
    title: "To-Do App",
    description: "Task management application.",
  },
]);

const showMessage = () => {
  alert("Thank you for your interest!");
};
</script>