<template>
  <header class="header">
    <div class="container">
      <h1>Ycon Samson</h1>

      <nav>
        <a href="#">Home</a>
        <a href="#">About</a>
        <a href="#">Projects</a>
        <a href="#">Contact</a>
      </nav>
    </div>
  </header>
</template>

<style scoped>
.header {
  background: #0acdeb;
  color: rgb(4, 78, 158);
  padding: 15px;
}

h1{
    padding: 8px;
}

.container {
  width: 100%;
  margin: auto;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

nav a {
  color: rgb(6, 84, 32);
  text-decoration: none;
  margin-left: 20px;
  transition:all 0.3s;
}                                     

nav a:hover {
  color: #033f88;
  text-decoration: underline;
  border-radius: 30px;
}
</style>