<?php
require_once '../db_config.php';
if (isset($_GET['logout'])) {
    session_unset();
    session_destroy();
    header("Location: ../Sign-in-admin/admin_login.php");
    exit();
}
$error = "";
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = sanitizeInput($_POST['email']);
    $password = $_POST['password'];
    $remember = isset($_POST['remember']);
    if (empty($email) || empty($password)) {
        $error = "Please enter both email and password";
    } else {
        $conn = getDBConnection();
        $stmt = $conn->prepare("SELECT admin_id, username, password_hash, full_name, email FROM admins WHERE email = ?");
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $result = $stmt->get_result();
        if ($result->num_rows === 1) {
            $admin = $result->fetch_assoc();
            if (verifyPassword($password, $admin['password_hash'])) {
                $_SESSION['admin_id'] = $admin['admin_id'];
                $_SESSION['admin_username'] = $admin['username'];
                $_SESSION['admin_name'] = $admin['full_name'];
                $_SESSION['admin_email'] = $admin['email'];
                $_SESSION['user_type'] = 'admin';  
                $_SESSION['role'] = 'admin';       
                if ($remember) {
                    setcookie('admin_email', $email, time() + (86400 * 30), "/"); 
                }
                header("Location: ../Admin-dashboard/admin_dashboard.php");
                exit();
            } else {
                $error = "Invalid email or password";
            }
        } else {
            $error = "Invalid email or password";
        }
        $stmt->close();
        $conn->close();
    }
}
$saved_email = isset($_COOKIE['admin_email']) ? $_COOKIE['admin_email'] : '';
?>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Admin Login - El Pueblo</title>
    <link rel="stylesheet" href="admin_login_style.css"/>
  </head>
  <body style="background-image: url('../Images/backgrounddorm1.jpg');">
    <header id="site-header">
      <nav>
        <div class="brand-container">
          <div class="black-container">
            <img src="../Images/elpueblo-removebg-preview1.png" alt="logo"/>
          </div>
        </div>
        <div class="auth-buttons">
          <a href="../Sign-in-as/index.html" class="back-btn"><img src="../Images/left-arrow-1.png" alt="left-arrow"> Go back</a>
        </div>
      </nav>
    </header>
    <main>
      <section class="form-container">
        <h2>Sign In as <span class="orange-col">Admin</span></h2>
        <p>Log in to access to your admin account</p>
        <?php if (!empty($error)): ?>
          <div class="error-message">
            <?php echo htmlspecialchars($error); ?>
          </div>
        <?php endif; ?>
        <form method="POST" action="">
          <div class="input-container">
            <img src="../Images/letter32.png" alt="Email">
            <input type="email" name="email" placeholder="Email address" value="<?php echo htmlspecialchars($saved_email); ?>" required />
          </div>
          <div class="input-container">
            <img src="../Images/lock-50.png" alt="Password">
            <input type="password" name="password" placeholder="Password" required />
          </div>
          <div class="check-frgt-container">
            <div class="checkbox-container">
              <label class="checkbox">
                <input type="checkbox" name="remember" />
                <span>Remember me</span>
              </label>
            </div>
          </div>
          <div class="sign-up-container">
            <button type="submit">Log in</button>
          </div>
        </form>
      </section>
    </main>
  </body>
</html>