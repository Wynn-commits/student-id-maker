<?php
require_once '../db_config.php';
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}
if (!isset($_SESSION['user_id']) || $_SESSION['user_type'] !== 'user') {
    header("Location: ../Sign-in/login.php");
    exit();
}
$user_id = $_SESSION['user_id'];
$conn = getDBConnection();
$stmt = $conn->prepare("SELECT * FROM users WHERE user_id = ?");
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();
if ($result->num_rows === 0) {
    header("Location: ../Sign-in/login.php");
    exit();
}
$user = $result->fetch_assoc();
$stmt->close();
$conn->close();
$name_parts = explode(" ", $user['full_name'], 2);
$first_name = $name_parts[0];
$last_name  = isset($name_parts[1]) ? $name_parts[1] : '';
?>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>User Profile - El Pueblo Dormitory</title>
    <link rel="stylesheet" href="user_profile_style.css">
</head>
<body>
    <div class="overlay" id="overlay"></div>
    <!-- Logout Confirmation Modal -->
    <div class="modal" id="modal">
        <img class="shut-down" src="../Images/shutdown-red-96.png" alt="Logout icon">
        <div class="logout-container">
            <h2>Log Out Account</h2>
            <p>Are you sure you want to log out? Once you logout you need to login again.</p>
            <div class="logout-btn-container">
                <button class="cancel-btn" onclick="closeLogout('modal')">Cancel</button>
                <button class="logout-btn">
                    <a href="../Profile/logout.php">Yes, Log out</a>
                </button>
            </div>  
        </div>
    </div>
    <header id="site-header">
        <nav>
            <div class="brand-container">
                <div class="black-container">
                    <img src="../Images/elpueblo-removebg-preview1.png" alt="El Pueblo Logo"/>
                </div>
            </div>
            <ul>
                <li><a href="../Room-booking/user_dashboard.php
                <li><a href="../Room-booking/user_dashboard.php
                <li><a href="user_profile.php">Profile</a></li>
            </ul>
            <div class="auth-buttons">
                <a href="../Room-booking/user_dashboard.php" class="back-btn">
                    <img src="../Images/left-arrow-1.png" alt="Go back"> 
                    Go back
                </a>
            </div>
        </nav>
    </header>
    <main>
        <div class="profile-container">
            <h2>User Profile</h2>
            <img src="../Images/Coffee-High-Definition-Desktop-Wallpaper.jpg" 
                 alt="User Profile Picture">
            <h2><?php echo htmlspecialchars($user['full_name']); ?></h2>
            <div class="info-container">
                <table>
                    <tr>
                        <th>First Name:</th>
                        <td><?php echo htmlspecialchars($first_name); ?></td>
                    </tr>
                    <tr>
                        <th>Last Name:</th>
                        <td><?php echo htmlspecialchars($last_name); ?></td>
                    </tr>
                    <tr>
                        <th>Email Address:</th>
                        <td><?php echo htmlspecialchars($user['email']); ?></td>
                    </tr>
                    <tr>
                        <th>Phone Number:</th>
                        <td><?php echo htmlspecialchars($user['phone'] ?? 'Not provided'); ?></td>
                    </tr>
                    <tr>
                        <th>Gender:</th>
                        <td><?php echo ucfirst(htmlspecialchars($user['gender'] ?? '')); ?></td>
                    </tr>
                    <tr>
                        <th>Member Since:</th>
                        <td><?php echo isset($user['created_at']) ? date('F Y', strtotime($user['created_at'])) : 'Unknown'; ?></td>
                    </tr>
                </table>
            </div>
            <button onclick="openLogout('modal')">Log Out</button>
        </div>
    </main>
    <script src="script.js"></script>
</body>
</html>