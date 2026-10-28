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
$user_name = $_SESSION['user_name'];
$user_gender = $_SESSION['user_gender'] ?? '';
$conn = getDBConnection();
$stmt_male = $conn->prepare("SELECT * FROM rooms WHERE room_type = 'male' AND status = 'available' AND current_occupancy < capacity ORDER BY room_number ASC");
$stmt_male->execute();
$male_rooms = $stmt_male->get_result();
$stmt_female = $conn->prepare("SELECT * FROM rooms WHERE room_type = 'female' AND status = 'available' AND current_occupancy < capacity ORDER BY room_number ASC");
$stmt_female->execute();
$female_rooms = $stmt_female->get_result();
$stmt_male->close();
$stmt_female->close();
$conn->close();
?>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Dormitory Rooms - El Pueblo</title>
    <link rel="stylesheet" href="user_dashboard_style.css">
</head>
<body>
    <header id="site-header">
        <nav>
            <div class="brand-container">
                <div class="black-container">
                    <img src="../Images/elpueblo-removebg-preview1.png" alt="El Pueblo Logo"/>
                </div>
            </div>
            <ul>
                <li><a href="#mens-room">Men's Rooms</a></li>
                <li><a href="#womens-room">Women's Rooms</a></li>
                <li><a href="../Profile/user_profile.php">Profile</a></li>
            </ul>
            <div class="auth-buttons">
                <a href="../Profile/logout.php" class="back-btn">
                    <img src="../Images/left-arrow-1.png" alt="Logout"> 
                    Logout
                </a>
            </div>
        </nav>
    </header>
    <main>
        <section id="mens-room">
            <h2>Men's Room</h2>
            <div class="container">
                <?php if ($male_rooms->num_rows > 0): ?>
                    <?php while($room = $male_rooms->fetch_assoc()): ?>
                        <?php 
                        $available_slots = $room['capacity'] - $room['current_occupancy'];
                        $room_type = $room['capacity'] > 1 ? 'Double Decked Room' : 'Single Room';
                        ?>
                        <div class="card">
                            <div class="image-container">
                                <img src="../Images/backgrounddorm1.jpg" 
                                     alt="Room <?php echo htmlspecialchars($room['room_number']); ?>">
                            </div>
                            <div class="text-container">
                                <h3>Room <?php echo htmlspecialchars($room['room_number']); ?></h3>
                                <span><?php echo $room_type; ?></span>
                                <p>Available slot: <?php echo $available_slots; ?></p>
                                <p>₱<?php echo number_format($room['price_per_month'], 2); ?>/month</p>
                            </div>
                            <button>
                                <a href="../Booking-details/booking_details.php?room_id=<?php echo $room['room_id']; ?>">
                                    More Details
                                </a>
                            </button>
                        </div>
                    <?php endwhile; ?>
                <?php else: ?>
                    <div class="no-rooms">No men's rooms available at the moment.</div>
                <?php endif; ?>
            </div>
        </section>
        <section id="womens-room">
            <h2>Women's Room</h2>
            <div class="container">
                <?php if ($female_rooms->num_rows > 0): ?>
                    <?php while($room = $female_rooms->fetch_assoc()): ?>
                        <?php 
                        $available_slots = $room['capacity'] - $room['current_occupancy'];
                        $room_type = $room['capacity'] > 1 ? 'Double Decked Room' : 'Single Room';
                        ?>
                        <div class="card">
                            <div class="image-container">
                                <img src="../Images/backgrounddorm1.jpg" 
                                     alt="Room <?php echo htmlspecialchars($room['room_number']); ?>">
                            </div>
                            <div class="text-container">
                                <h3>Room <?php echo htmlspecialchars($room['room_number']); ?></h3>
                                <span><?php echo $room_type; ?></span>
                                <p>Available slot: <?php echo $available_slots; ?></p>
                                <p>₱<?php echo number_format($room['price_per_month'], 2); ?>/month</p>
                            </div>
                            <button>
                                <a href="../Booking-details/booking_details.php?room_id=<?php echo $room['room_id']; ?>">
                                    More Details
                                </a>
                            </button>
                        </div>
                    <?php endwhile; ?>
                <?php else: ?>
                    <div class="no-rooms">No women's rooms available at the moment.</div>
                <?php endif; ?>
            </div>
        </section>
    </main>
</body>
</html>