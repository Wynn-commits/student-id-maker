<?php
require_once '../../db_config.php';
$conn = getDBConnection();
$roomsQuery = "SELECT room_id, room_number, room_type, price_per_month 
               FROM rooms 
               WHERE status = 'available' 
               ORDER BY room_number";
$roomsResult = $conn->query($roomsQuery);
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $first_name = $_POST['first_name'];
    $last_name = $_POST['last_name'];
    $email = $_POST['email'];
    $phone = $_POST['phone'];
    $password = $_POST['password'];
    $room_id = $_POST['room_id'];
    $check_in_date = $_POST['check_in_date'];
    $gender = $_POST['gender'];
    $payment_amount = $_POST['payment_amount'];
    $full_name = $first_name . ' ' . $last_name;
    $password_hash = password_hash($password, PASSWORD_DEFAULT);
    $conn->begin_transaction();
    try {
        $checkUserSql = "SELECT user_id FROM users WHERE email = ?";
        $stmt = $conn->prepare($checkUserSql);
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $result = $stmt->get_result();
        if ($result->num_rows > 0) {
            $user = $result->fetch_assoc();
            $user_id = $user['user_id'];
        } else {
            $insertUserSql = "INSERT INTO users (email, password_hash, full_name, phone, gender) VALUES (?, ?, ?, ?, ?)";
            $stmt = $conn->prepare($insertUserSql);
            $stmt->bind_param("sssss", $email, $password_hash, $full_name, $phone, $gender);
            $stmt->execute();
            $user_id = $conn->insert_id;
        }
        $roomSql = "SELECT price_per_month FROM rooms WHERE room_id = ?";
        $stmt = $conn->prepare($roomSql);
        $stmt->bind_param("i", $room_id);
        $stmt->execute();
        $roomResult = $stmt->get_result();
        $room = $roomResult->fetch_assoc();
        $monthly_amount = $room['price_per_month'];
        $reservation_code = 'R-' . str_pad(rand(1000, 9999), 4, '0', STR_PAD_LEFT);
        $insertBookingSql = "INSERT INTO bookings (reservation_code, user_id, room_id, check_in_date, monthly_amount, total_paid, status) 
                            VALUES (?, ?, ?, ?, ?, ?, 'confirmed')";
        $stmt = $conn->prepare($insertBookingSql);
        $stmt->bind_param("siisdd", $reservation_code, $user_id, $room_id, $check_in_date, $monthly_amount, $payment_amount);
        $stmt->execute();
        $booking_id = $conn->insert_id;
        if ($payment_amount > 0) {
            $paymentSql = "INSERT INTO payments (booking_id, amount, payment_date, payment_method) VALUES (?, ?, CURDATE(), 'cash')";
            $stmt = $conn->prepare($paymentSql);
            $stmt->bind_param("id", $booking_id, $payment_amount);
            $stmt->execute();
        }
        $updateRoomSql = "UPDATE rooms SET status = 'occupied', current_occupancy = current_occupancy + 1 WHERE room_id = ?";
        $stmt = $conn->prepare($updateRoomSql);
        $stmt->bind_param("i", $room_id);
        $stmt->execute();
        $conn->commit();
        $_SESSION['message'] = 'Reservation added successfully!';
        $_SESSION['message_type'] = 'success';
        header('Location: ../Admin_reservation.php');
        exit();
    } catch (Exception $e) {
        $conn->rollback();
        $error_message = 'Error adding reservation: ' . $e->getMessage();
    }
}
?>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Add Reservation</title>
    <link rel="stylesheet" href="../Admin_reservation_style.css" />
  </head>
  <body>
    <header>
      <nav>
        <div class="brand-container">
          <div class="black-container">
            <img src="../../Images/elpueblo-removebg-preview.png" alt="logo" />
          </div>
        </div>
      </nav>
    </header>
    <div class="container">
      <aside class="sidebar">
        <ul>
          <li>
            <a href="../../Admin-dashboard/admin_dashboard.php"
              ><img
                src="../../Images/orange-foursquares-icon50.png"
                alt="icon"
              />
              Dashboard</a
            >
          </li>
          <li class="active">
            <img
              src="../../Images/black-reserve-icon50.png"
              alt="icon"
            />
            Reservation
          </li>
          <li>
            <a
              href="../../Admin_rooms-details/Admin-rooms/Admin_rooms.php"
              ><img
                src="../../Images/orange-home-icon50.png"
                alt="icon"
              />
              Rooms</a
            >
          </li>
          <li>
            <a href="../../Admin-messages/admin_messages.php"
              ><img
                src="../../Images/orange-typing-icon50.png"
                alt="icon"
              />
              Messages</a
            >
          </li>
        </ul>
      </aside>
      <main>
        <section class="form-container">
          <h2>Add Reservation</h2>
          <?php if (isset($error_message)): ?>
            <div class="error-message"><?php echo htmlspecialchars($error_message); ?></div>
          <?php endif; ?>
          <form method="POST" action="">
            <div class="naming-container">
              <label>
                <span>First name</span>
                <input type="text" name="first_name" required />
              </label>
              <label>
                <span>Last name</span>
                <input type="text" name="last_name" required />
              </label>
            </div>
            <label>
              <span>Email address</span>
              <input type="email" name="email" required />
            </label>
            <label>
              <span>Phone number</span>
              <input type="tel" name="phone" required />
            </label>
            <label>
              <span>Gender</span>
              <select name="gender" required>
                <option value="">Select Gender</option>
                <option value="male">Male</option>
                <option value="female">Female</option>
              </select>
            </label>
            <label>
              <span>Password</span>
              <input type="password" name="password" required />
            </label>
            <label>
              <span>Room</span>
              <select name="room_id" required>
                <option value="">Select Room</option>
                <?php while ($room = $roomsResult->fetch_assoc()): ?>
                  <option value="<?php echo $room['room_id']; ?>">
                    Room <?php echo $room['room_number']; ?> - 
                    <?php echo ucfirst($room['room_type']); ?> - 
                    ₱<?php echo number_format($room['price_per_month'], 2); ?>/month
                  </option>
                <?php endwhile; ?>
              </select>
            </label>
            <label>
              <span>Check-in Date</span>
              <input type="date" name="check_in_date" required />
            </label>
            <label>
              <span>Initial Payment Amount</span>
              <input type="number" name="payment_amount" step="0.01" min="0" required />
            </label>
            <button type="submit">Add Reservation</button>
            <a href="../../Admin-reservation/Admin_reservation.php" class="back-link">Back to Reservations</a>
          </form>
        </section>
      </main>
    </div>
  </body>
</html>
<?php
$conn->close();
?>