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
if (!isset($_GET['room_id']) || !is_numeric($_GET['room_id'])) {
    header("Location: ../Room-booking/user_dashboard.php");
    exit();
}
$room_id = (int)$_GET['room_id'];
$conn = getDBConnection();
$stmt = $conn->prepare("SELECT * FROM rooms WHERE room_id = ?");
$stmt->bind_param("i", $room_id);
$stmt->execute();
$result = $stmt->get_result();
if ($result->num_rows === 0) {
    $_SESSION['error'] = "Room not found";
    header("Location: ../Room-booking/user_dashboard.php");
    exit();
}
$room = $result->fetch_assoc();
$available_slots = $room['capacity'] - $room['current_occupancy'];
if ($available_slots <= 0 || $room['status'] !== 'available') {
    $_SESSION['error'] = "This room is no longer available";
    header("Location: ../Room-booking/user_dashboard.php");
    exit();
}
$room_type = $room['capacity'] > 1 ? 'Double Decked' : 'Single Room';
$booking_success = false;
$booking_reference = "";
$error = "";
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['confirm_booking'])) {
    $check_in_date = sanitizeInput($_POST['check_in_date'] ?? '');
    $terms_agreed = isset($_POST['terms']);
    if (!$terms_agreed) {
        $error = "Please agree to dormitory rules and regulations";
    } elseif (empty($check_in_date)) {
        $error = "Please select a check-in date";
    } else {
        $check_stmt = $conn->prepare("SELECT capacity, current_occupancy FROM rooms WHERE room_id = ? FOR UPDATE");
        $check_stmt->bind_param("i", $room_id);
        $check_stmt->execute();
        $check_result = $check_stmt->get_result();
        $current_room = $check_result->fetch_assoc();
        $check_stmt->close();
        $current_available = $current_room['capacity'] - $current_room['current_occupancy'];
        if ($current_available <= 0) {
            $error = "Sorry, this room is now fully booked. Please choose another room.";
        } else {
            $reservation_code = 'R-' . time();
            $stmt = $conn->prepare("INSERT INTO bookings (reservation_code, user_id, room_id, check_in_date, monthly_amount, status) VALUES (?, ?, ?, ?, ?, 'pending')");
            $stmt->bind_param("siisd", $reservation_code, $user_id, $room_id, $check_in_date, $room['price_per_month']);
            if ($stmt->execute()) {
                $new_occupancy = $current_room['current_occupancy'] + 1;
                $new_status = ($new_occupancy >= $current_room['capacity']) ? 'occupied' : 'available';
                $update_stmt = $conn->prepare("UPDATE rooms SET current_occupancy = ?, status = ? WHERE room_id = ?");
                $update_stmt->bind_param("isi", $new_occupancy, $new_status, $room_id);
                $update_stmt->execute();
                $update_stmt->close();
                $booking_success = true;
                $booking_reference = $reservation_code;
            } else {
                $error = "Booking failed. Please try again.";
            }
            $stmt->close();
        }
    }
}
$conn->close();
?>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Room Details - El Pueblo Dormitory</title>
    <link rel="stylesheet" href="booking_details_style.css" />
</head>
<body>
    <header id="site-header">
        <nav>
            <div class="brand-container">
                <div class="black-container">
                    <img src="../Images/elpueblo-removebg-preview1.png" alt="El Pueblo Logo" />
                </div>
            </div>
            <div class="auth-buttons">
                <a href="../Room-booking/user_dashboard.php" class="back-btn">
                    <img src="../Images/left-arrow-1.png" alt="Go back" />
                    Go back
                </a>
            </div>
        </nav>
    </header>
    <main>
        <h1>Booking Details</h1>
        <div class="booking-container">
            <div class="room-details">
                <div class="image-gallery">
                    <div class="main-image">
                        <img id="mainImage" 
                             src="https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"
                             alt="Room" />
                    </div>
                    <div class="thumbnail-container">
                        <img src="https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"
                             onclick="changeImage(this)" alt="Room thumbnail 1" />
                        <img src="../Images/backgrounddorm1.jpg" 
                             onclick="changeImage(this)" alt="Room thumbnail 2" />
                        <img src="../Images/Coffee-High-Definition-Desktop-Wallpaper.jpg" 
                             onclick="changeImage(this)" alt="Room thumbnail 3" />
                    </div>
                </div>
                <div class="room-info">
                    <h2>Room <?php echo htmlspecialchars($room['room_number']); ?></h2>
                    <p class="room-type"><?php echo $room_type; ?> room</p>
                    <p class="description">
                        <?php echo htmlspecialchars($room['description'] ?? 'Spacious room perfect for comfortable living and studying.'); ?>
                    </p>
                    <div class="room-status">
                        <div class="left-status-container">
                            <div class="alignment">
                                <img src="../Images/chekcmark-icon30.png" alt="Availability" />
                                <p>Availability: <strong><?php echo $available_slots; ?> slots left</strong></p>
                            </div>
                            <div class="alignment">
                                <img src="../Images/average-price0-icon30.png" alt="Price" />
                                <p>Price: <strong>₱<?php echo number_format($room['price_per_month'], 2); ?> per month</strong></p>
                            </div>
                        </div>
                        <img id="vertical-line" src="../Images/vertical-line100.png" alt="Divider" />
                        <div class="right-status-container">
                            <div class="alignment">
                                <img src="../Images/bunk-bed-icon30.png" alt="Capacity" />
                                <p>Capacity: <strong><?php echo $room['capacity']; ?> beds</strong></p>
                            </div>
                            <div class="alignment">
                                <img src="../Images/smart-shelf30.png" alt="Facilities" />
                                <p>Facilities:</p>
                                <div class="icons-container">
                                    <img src="../Images/Wi-Fi-icon30.png" alt="WiFi" />
                                    <img src="../Images/vacuum-cleaner-icon30.png" alt="Vacuum" />
                                    <img src="../Images/bureau-icon-30.png" alt="Bureau" />
                                    <img src="../Images/dishwasher-icon30.png" alt="Dishwasher" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- BOOKING PANEL -->
            <div class="booking-summary" id="bookingPanel">
                <!-- STEP 1: Summary -->
                <div id="step1" class="step <?php echo !$booking_success ? 'active' : ''; ?>">
                    <h3>Room Booking Summary</h3>
                    <p>Review your booking before proceeding</p>
                    <div class="divider"></div>
                    <div class="summary-box">
                        <h3>Selected room</h3>
                        <p>Room: <strong>Room <?php echo htmlspecialchars($room['room_number']); ?></strong></p>
                        <p>Room type: <strong><?php echo $room_type; ?></strong></p>
                        <p>Capacity: <strong><?php echo $room['capacity']; ?> beds</strong></p>
                        <p>Available slots: <strong><?php echo $available_slots; ?></strong></p>
                        <p>Monthly fee: <strong>₱<?php echo number_format($room['price_per_month'], 2); ?></strong></p>
                    </div>
                    <div class="divider"></div>
                    <div class="cost-preview">
                        <h4>Cost Review</h4>
                        <div class="info-container">
                            <table>
                                <tr>
                                    <td>Rate:</td>
                                    <td>₱<?php echo number_format($room['price_per_month'], 2); ?>/month</td>
                                </tr>
                            </table>
                            <div class="cost-line"></div>
                            <table>
                                <tr>
                                    <td>Slots Reserved:</td>
                                    <td>1</td>
                                </tr>
                            </table>
                            <div class="cost-line"></div>
                            <table>
                                <tr class="last-tr">
                                    <td>Duration:</td>
                                    <td>Monthly</td>
                                </tr>
                            </table>
                        </div>
                        <div class="button-container">
                            <button onclick="showConfirmation()" class="book-btn">
                                Proceed to confirmation
                            </button>
                        </div>
                    </div>
                </div>
                <!-- STEP 2: Confirmation -->
                <div id="step2" class="booking-confirmation step">
                    <h4 class="panel-title">Booking Confirmation</h4>
                    <?php if (!empty($error)): ?>
                        <div class="error-message"><?php echo $error; ?></div>
                    <?php endif; ?>
                    <div class="inner-box">
                        <p><strong>Room <?php echo htmlspecialchars($room['room_number']); ?> - <?php echo $room_type; ?> Room</strong></p>
                        <div class="inner-context">
                            <table>
                                <tr>
                                    <td>1 Bed Reserved</td>
                                </tr>
                                <tr>
                                    <td>Monthly Fee: </td>
                                    <td><strong>₱<?php echo number_format($room['price_per_month'], 2); ?></strong></td>
                                </tr>
                                <tr>
                                    <td>Available Slots</td>
                                    <td><strong><?php echo $available_slots; ?> Slots Remaining</strong></td>
                                </tr>
                            </table>  
                            <form method="POST" action="">
                                <div class="date-box">
                                    <label>Start Date</label>
                                    <input type="date" name="check_in_date" required min="<?php echo date('Y-m-d'); ?>" />
                                </div>
                                <p class="Agree">Agree to the</p>
                                <label class="agreement-box">
                                    <input type="checkbox" name="terms" required />
                                    <a href="../Dormitory-rules/index.html" class="link-btn">Dormitory rules and Regulations</a>
                                </label>
                                <div class="buttons-container">
                                    <button type="submit" name="confirm_booking" class="confirm-btn">
                                        Confirm Booking
                                    </button>
                                    <button type="button" onclick="showStep(1)" class="btn-gray">
                                        Back to Room Details
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <!-- STEP 3: Success -->
                <div id="step3" class="successful-container step <?php echo $booking_success ? 'active' : ''; ?>">
                    <div class="success-icon">
                        <img src="../Images/check-mark100.png" alt="Success" />
                    </div>
                    <h2 class="success-title">Booking Successful!</h2>
                    <div class="refrerence-box">
                        <div class="detail-row">
                            <table>
                                <tr>
                                    <td>Booking Reference No</td>
                                    <td>Status</td>
                                </tr>
                                <tr>
                                    <td><strong><span class="reference-font"><?php echo htmlspecialchars($booking_reference); ?></span></strong></td>
                                    <td><strong>Pending Approval</strong></td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <div class="success-btn-container">
                        <button class="back-details-btn">
                            <a href="../Room-booking/user_dashboard.php" style="color: white; text-decoration: none;">View All Rooms</a>
                        </button>
                        <button class="back-home-btn">
                            <a href="../Room-booking/user_dashboard.php">Back to Home</a>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <script src="script.js"></script>
</body>
</html>