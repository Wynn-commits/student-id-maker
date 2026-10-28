<?php
require_once '../db_config.php';
$errors = [];
$success = "";
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $firstname = sanitizeInput($_POST['firstname'] ?? '');
    $lastname  = sanitizeInput($_POST['lastname'] ?? '');
    $full_name = $firstname . " " . $lastname;
    $email     = sanitizeInput($_POST['email'] ?? '');
    $phone     = sanitizeInput($_POST['phone'] ?? '');
    $password  = $_POST['password'] ?? '';
    $gender    = isset($_POST['gender']) ? sanitizeInput($_POST['gender']) : '';
    if (empty($firstname) || empty($lastname)) {
        $errors[] = "First name and last name are required";
    }
    if (empty($email)) {
        $errors[] = "Email is required";
    } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $errors[] = "Invalid email format";
    }
    if (empty($phone)) {
        $errors[] = "Phone number is required";
    }
    if (empty($password)) {
        $errors[] = "Password is required";
    } elseif (strlen($password) < 6) {
        $errors[] = "Password must be at least 6 characters";
    }
    if (empty($gender) || !in_array($gender, ['male', 'female'])) {
        $errors[] = "Please select your gender";
    }
    if (!isset($_POST['terms'])) {
        $errors[] = "Please agree to the dormitory rules and regulations";
    }
    if (empty($errors)) {
        $conn = getDBConnection();
        $stmt = $conn->prepare("SELECT user_id FROM users WHERE email = ?");
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $result = $stmt->get_result();
        if ($result->num_rows > 0) {
            $errors[] = "Email already registered. Please login instead.";
        } else {
            $password_hash = hashPassword($password);
            $stmt = $conn->prepare("INSERT INTO users (email, password_hash, full_name, phone, gender) VALUES (?, ?, ?, ?, ?)");
            $stmt->bind_param("sssss", $email, $password_hash, $full_name, $phone, $gender);
            if ($stmt->execute()) {
                $success = "Registration successful! Redirecting to login...";
                header("refresh:2;url=../Sign-in/login.php");
                exit();
            } else {
                $errors[] = "Registration failed. Please try again.";
            }
        }
        $stmt->close();
        $conn->close();
    }
}
?>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Register - El Pueblo Dormitory</title>
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
                <a href="../Sign-in-as/index.html" class="back-btn">
                    <img src="../Images/left-arrow-1.png" alt="Go back"> 
                    Go back
                </a>
            </div>
        </nav>
    </header>
    <main>
        <section class="form-container">
            <h2>Join our <span class="orange-col">Dormitory!</span></h2>
            <?php if (!empty($errors)): ?>
                <div class="error-message">
                    <ul>
                        <?php foreach ($errors as $error): ?>
                            <li><?php echo $error; ?></li>
                        <?php endforeach; ?>
                    </ul>
                </div>
            <?php endif; ?>
            <?php if (!empty($success)): ?>
                <div class="success-message"><?php echo $success; ?></div>
            <?php endif; ?>
            <form method="POST" action="">
                <div class="naming-container">
                    <label class="text" for="firstname">
                        <span>First name</span><br />
                        <input type="text" name="firstname" id="firstname" required />
                    </label>
                    <label class="text" for="lastname">
                        <span>Last name</span><br />
                        <input type="text" name="lastname" id="lastname" required />
                    </label>
                </div>
                <div class="input-container">
                    <label for="email">
                        <span>Email address</span><br />
                        <input type="email" name="email" id="email" required />
                    </label>
                </div>
                <div class="input-container">
                    <label for="phone">
                        <span>Phone number</span><br />
                        <input type="tel" name="phone" id="phone" placeholder="09XXXXXXXXX" required />
                    </label>
                </div>
                <div class="input-container">
                    <label for="password">
                        <span>Password (minimum 6 characters)</span><br />
                        <input type="password" name="password" id="password" required />
                    </label>
                </div>
                <div class="gender-container">
                    <p>Gender</p>
                    <div class="gender-options">
                        <label>
                            <input type="radio" name="gender" value="male" required> Male
                        </label>
                        <label>
                            <input type="radio" name="gender" value="female" required> Female
                        </label>
                    </div>
                </div>
                <label class="checkbox">
                    <input type="checkbox" name="terms" required />
                    <span>
                        By creating an account, I agree to our 
                        <a href="../Dormitory-rules/index.html" class="link-btn">Dormitory rules and Regulations</a>
                    </span>
                </label>
                <label class="checkbox">
                    <input type="checkbox" name="marketing" />
                    <span>
                        By creating an account, I am also consenting to receive SMS 
                        messages and emails, including product updates, events, and 
                        marketing promotions.
                    </span>
                </label>
                <div class="sign-up-container">
                    <button type="submit">Sign up</button>
                    <p class="login-link">
                        Already have an account? 
                        <a href="../Sign-in/login.php">Sign in</a>
                    </p>
                </div>
            </form>
        </section>
    </main>
</body>
</html>