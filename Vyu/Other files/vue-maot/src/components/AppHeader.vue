<template>
  <header class="header">
    <div class="container">
      <div>
        <h1>Gavin Calumba</h1>
        <p>Aspiring Developer</p>
      </div>

      <nav>
        <a href="#about">About</a>
        <a href="#skills">Skills</a>
        <a href="#projects">Projects</a>
        <a href="#contact">Contact</a>
      </nav>
    </div>
  </header>
</template>

<style scoped>
.header {
  background: #2563eb;
  color: white;
  padding: 20px 0;
  position: sticky;
  top: 0;
}

.container {
  width: 90%;
  max-width: 1100px;
  margin: auto;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

nav a {
  color: white;
  text-decoration: none;
  margin-left: 20px;
}

nav a:hover {
  color: #ffd166;
}
</style>