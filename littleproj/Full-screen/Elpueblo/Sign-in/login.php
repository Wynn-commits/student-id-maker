<?php
require_once '../db_config.php';
$error = "";
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = sanitizeInput($_POST['email'] ?? '');
    $password = $_POST['password'] ?? '';
    $remember = isset($_POST['remember']);
    if (empty($email) || empty($password)) {
        $error = "Please enter both email and password";
    } else {
        $conn = getDBConnection();
        $stmt = $conn->prepare("SELECT user_id, email, password_hash, full_name, gender FROM users WHERE email = ? AND is_active = 1");
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $result = $stmt->get_result();
        if ($result->num_rows === 1) {
            $user = $result->fetch_assoc();
            if (verifyPassword($password, $user['password_hash'])) {
                $_SESSION['user_id'] = $user['user_id'];
                $_SESSION['user_email'] = $user['email'];
                $_SESSION['user_name'] = $user['full_name'];
                $_SESSION['user_gender'] = $user['gender'];
                $_SESSION['user_type'] = 'user';
                if ($remember) {
                    setcookie('user_email', $email, time() + (86400 * 30), "/", "", false, true);
                }
                header("Location: ../Room-booking/user_dashboard.php");
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
$saved_email = isset($_COOKIE['user_email']) ? htmlspecialchars($_COOKIE['user_email']) : '';
?>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login - El Pueblo Dormitory</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <header id="site-header">
        <nav>
            <div class="brand-container">
                <div class="black-container">
                    <img src="../Images/elpueblo-removebg-preview1.png" alt="El Pueblo Logo"/>
                </div>
            </div>
            <div class="auth-buttons">
                <a href="../Main-interface/index.html" class="back-btn">
                    <img src="../Images/left-arrow-1.png" alt="Go back"> 
                    Go back
                </a>
            </div>
        </nav>
    </header>
    <main>
        <section class="form-container">
            <h2>Welcome to <br><span class="orange-col">Our Dormitory!</span></h2>
            <p>Log in to access your account</p>
            <?php if (!empty($error)): ?>
                <div class="error-message"><?php echo $error; ?></div>
            <?php endif; ?>
            <form method="POST" action="">
                <div class="input-container">
                    <img src="../Images/letter32.png" alt="Email icon">
                    <input type="email" 
                           name="email" 
                           placeholder="Email address" 
                           value="<?php echo $saved_email; ?>" 
                           required />
                </div>
                <div class="input-container">
                    <img src="../Images/lock-50.png" alt="Password icon">
                    <input type="password" 
                           name="password" 
                           placeholder="Password" 
                           required />
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
                <p class="login-link">
                    Don't have an account? 
                    <a href="../Sign-up/register.php">Sign up</a>
                </p>
            </form>
        </section>
    </main>
</body>
</html>