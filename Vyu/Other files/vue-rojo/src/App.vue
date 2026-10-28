<script setup>
import AppHeader from './components/AppHeader.vue'
import AppFooter from './components/AppFooter.vue'
</script>

<template>
  <div class="portfolio">

    <!-- ================= HEADER ================= -->
    <AppHeader />


    <!-- ================= MAIN CONTENT ================= -->
    <main>

      <!-- ================= HOME ================= -->
      <section id="home" class="hero">

        <div class="hero-content">

          <p class="welcome-text">
            Hello, I'm
          </p>

          <h1>
            Rojo
          </h1>

          <h2>
            Aspiring Web Developer
          </h2>

          <p class="hero-description">
            I am a student and aspiring developer who enjoys
            creating websites, learning new technologies,
            and turning ideas into functional applications.
          </p>

          <div class="hero-buttons">
            <a href="#projects" class="btn primary-btn">
              View My Projects
            </a>

            <a href="#contact" class="btn secondary-btn">
              Contact Me
            </a>
          </div>

        </div>


        <div class="hero-image">

          <div class="profile-circle">
            <span>MM</span>
          </div>

        </div>

      </section>


      <!-- ================= ABOUT ================= -->
      <section id="about" class="section">

        <div class="container">

          <p class="section-label">
            Get to know me
          </p>

          <h2 class="section-title">
            About Me
          </h2>

          <div class="about-content">

            <div class="about-text">

              <p>
                Hello! My name is <strong>JRojo</strong>.
                I am currently studying and developing my
                skills in web development and programming.
              </p>

              <p>
                I enjoy learning how websites and applications
                work. I am particularly interested in creating
                clean, responsive, and user-friendly websites.
              </p>

              <p>
                My goal is to continue improving my programming
                skills and eventually become a professional
                web developer.
              </p>

            </div>

            <div class="about-card">

              <div class="info-item">
                <span>👨‍💻</span>
                <div>
                  <h3>Developer</h3>
                  <p>Web Development</p>
                </div>
              </div>

              <div class="info-item">
                <span>🎓</span>
                <div>
                  <h3>Student</h3>
                  <p>Currently Learning</p>
                </div>
              </div>

              <div class="info-item">
                <span>💡</span>
                <div>
                  <h3>Interested In</h3>
                  <p>Technology & Programming</p>
                </div>
              </div>

            </div>

          </div>

        </div>

      </section>


      <!-- ================= SKILLS ================= -->
      <section id="skills" class="section skills-section">

        <div class="container">

          <p class="section-label">
            What I know
          </p>

          <h2 class="section-title">
            My Skills
          </h2>

          <div class="skills-grid">

            <div class="skill-card">
              <div class="skill-icon">HTML</div>
              <h3>HTML</h3>
              <p>
                Creating the structure and content of websites.
              </p>
            </div>

            <div class="skill-card">
              <div class="skill-icon">CSS</div>
              <h3>CSS</h3>
              <p>
                Designing responsive and attractive interfaces.
              </p>
            </div>

            <div class="skill-card">
              <div class="skill-icon">JS</div>
              <h3>JavaScript</h3>
              <p>
                Adding functionality and interactivity to websites.
              </p>
            </div>

            <div class="skill-card">
              <div class="skill-icon">V</div>
              <h3>Vue.js</h3>
              <p>
                Building modern and interactive web applications.
              </p>
            </div>

            <div class="skill-card">
              <div class="skill-icon">GIT</div>
              <h3>Git</h3>
              <p>
                Managing and tracking changes in projects.
              </p>
            </div>

            <div class="skill-card">
              <div class="skill-icon">UI</div>
              <h3>UI Design</h3>
              <p>
                Creating simple and user-friendly interfaces.
              </p>
            </div>

          </div>

        </div>

      </section>


      <!-- ================= PROJECTS ================= -->
      <section id="projects" class="section">

        <div class="container">

          <p class="section-label">
            My work
          </p>

          <h2 class="section-title">
            My Projects
          </h2>

          <div class="projects-grid">

            <article class="project-card">

              <div class="project-image">
                <span>Numero UNO</span>
              </div>

              <div class="project-content">

                <h3>
                  Student Management System
                </h3>

                <p>
                  A web application designed to manage
                  student information and records.
                </p>

                <div class="project-tags">
                  <span>HTML</span>
                  <span>CSS</span>
                  <span>JavaScript</span>
                </div>

              </div>

            </article>


            <article class="project-card">

              <div class="project-image">
                <span>Numero DOS</span>
              </div>

              <div class="project-content">

                <h3>
                  Login & Registration System
                </h3>

                <p>
                  A simple authentication interface with
                  login and registration functionality.
                </p>

                <div class="project-tags">
                  <span>Vue</span>
                  <span>CSS</span>
                  <span>JavaScript</span>
                </div>

              </div>

            </article>


            <article class="project-card">

              <div class="project-image">
                <span>Numero TRES</span>
              </div>

              <div class="project-content">

                <h3>
                  Personal Portfolio
                </h3>

                <p>
                  A responsive personal portfolio created
                  using Vue.js and external CSS.
                </p>

                <div class="project-tags">
                  <span>Vue.js</span>
                  <span>HTML</span>
                  <span>CSS</span>
                </div>

              </div>

            </article>

          </div>

        </div>

      </section>


      <!-- ================= CONTACT ================= -->
      <section id="contact" class="section contact-section">

        <div class="container">

          <p class="section-label">
            Get in touch
          </p>

          <h2 class="section-title">
            Contact Me
          </h2>

          <div class="contact-content">

            <div class="contact-info">

              <h3>
                Let's Work Together
              </h3>

              <p>
                If you would like to get in touch with me,
                feel free to contact me through any of the
                information below.
              </p>

              <div class="contact-item">
                <span>📧</span>
                <div>
                  <strong>Email</strong>
                  <p>JRojo@example.com</p>
                </div>
              </div>

              <div class="contact-item">
                <span>📱</span>
                <div>
                  <strong>Phone</strong>
                  <p>+63 92456864</p>
                </div>
              </div>

              <div class="contact-item">
                <span>📍</span>
                <div>
                  <strong>Location</strong>
                  <p>Philippines</p>
                </div>
              </div>

            </div>


            <form class="contact-form">

              <div class="form-group">
                <label for="name">
                  Name
                </label>

                <input
                  id="name"
                  type="text"
                  placeholder="Your Name"
                >
              </div>


              <div class="form-group">
                <label for="email">
                  Email
                </label>

                <input
                  id="email"
                  type="email"
                  placeholder="your@email.com"
                >
              </div>


              <div class="form-group">
                <label for="message">
                  Message
                </label>

                <textarea
                  id="message"
                  rows="5"
                  placeholder="Write your message..."
                ></textarea>
              </div>


              <button
                type="button"
                class="btn primary-btn"
              >
                Send Message
              </button>

            </form>

          </div>

        </div>

      </section>

    </main>


    <!-- ================= FOOTER ================= -->
    <AppFooter />

  </div>
</template>
