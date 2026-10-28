<?php
require_once '../../db_config.php';
$conn = getDBConnection();
$booking_id = isset($_GET['id']) ? intval($_GET['id']) : 0;
if ($booking_id === 0) {
    header('Location: ../Admin_reservation.php');
    exit();
}
$sql = "SELECT 
            b.*,
            u.full_name,
            u.email,
            u.phone,
            u.gender,
            r.room_number
        FROM bookings b
        JOIN users u ON b.user_id = u.user_id
        JOIN rooms r ON b.room_id = r.room_id
        WHERE b.booking_id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $booking_id);
$stmt->execute();
$result = $stmt->get_result();
if ($result->num_rows === 0) {
    header('Location: ../Admin_reservation.php');
    exit();
}
$booking = $result->fetch_assoc();
$name_parts = explode(' ', $booking['full_name'], 2);
$first_name = $name_parts[0];
$last_name = isset($name_parts[1]) ? $name_parts[1] : '';
$roomsQuery = "SELECT room_id, room_number, room_type, price_per_month 
               FROM rooms 
               WHERE status = 'available' OR room_id = ?
               ORDER BY room_number";
$stmt = $conn->prepare($roomsQuery);
$stmt->bind_param("i", $booking['room_id']);
$stmt->execute();
$roomsResult = $stmt->get_result();
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $first_name_new = $_POST['first_name'];
    $last_name_new = $_POST['last_name'];
    $email = $_POST['email'];
    $phone = $_POST['phone'];
    $room_id = $_POST['room_id'];
    $check_in_date = $_POST['check_in_date'];
    $check_out_date = !empty($_POST['check_out_date']) ? $_POST['check_out_date'] : null;
    $status = $_POST['status'];
    $gender = $_POST['gender'];
    $payment_amount = $_POST['payment_amount'];
    $full_name_new = $first_name_new . ' ' . $last_name_new;
    $password = $_POST['password'];
    $conn->begin_transaction();
    try {
        $roomSql = "SELECT price_per_month FROM rooms WHERE room_id = ?";
        $stmt = $conn->prepare($roomSql);
        $stmt->bind_param("i", $room_id);
        $stmt->execute();
        $roomResult = $stmt->get_result();
        $room = $roomResult->fetch_assoc();
        $monthly_amount = $room['price_per_month'];
        if (!empty($password)) {
            $password_hash = password_hash($password, PASSWORD_DEFAULT);
            $updateUserSql = "UPDATE users SET full_name = ?, email = ?, phone = ?, gender = ?, password_hash = ? WHERE user_id = ?";
            $stmt = $conn->prepare($updateUserSql);
            $stmt->bind_param("sssssi", $full_name_new, $email, $phone, $gender, $password_hash, $booking['user_id']);
        } else {
            $updateUserSql = "UPDATE users SET full_name = ?, email = ?, phone = ?, gender = ? WHERE user_id = ?";
            $stmt = $conn->prepare($updateUserSql);
            $stmt->bind_param("ssssi", $full_name_new, $email, $phone, $gender, $booking['user_id']);
        }
        $stmt->execute();
        $updateBookingSql = "UPDATE bookings SET room_id = ?, check_in_date = ?, check_out_date = ?, monthly_amount = ?, status = ? WHERE booking_id = ?";
        $stmt = $conn->prepare($updateBookingSql);
        $stmt->bind_param("issdsi", $room_id, $check_in_date, $check_out_date, $monthly_amount, $status, $booking_id);
        $stmt->execute();
        if ($room_id != $booking['room_id']) {
            $updateOldRoomSql = "UPDATE rooms SET current_occupancy = current_occupancy - 1 WHERE room_id = ?";
            $stmt = $conn->prepare($updateOldRoomSql);
            $stmt->bind_param("i", $booking['room_id']);
            $stmt->execute();
            $checkOldRoomSql = "UPDATE rooms SET status = 'available' WHERE room_id = ? AND current_occupancy = 0";
            $stmt = $conn->prepare($checkOldRoomSql);
            $stmt->bind_param("i", $booking['room_id']);
            $stmt->execute();
            $updateNewRoomSql = "UPDATE rooms SET current_occupancy = current_occupancy + 1, status = 'occupied' WHERE room_id = ?";
            $stmt = $conn->prepare($updateNewRoomSql);
            $stmt->bind_param("i", $room_id);
            $stmt->execute();
        }
        if ($payment_amount > 0) {
            $paymentSql = "INSERT INTO payments (booking_id, amount, payment_date, payment_method) VALUES (?, ?, CURDATE(), 'cash')";
            $stmt = $conn->prepare($paymentSql);
            $stmt->bind_param("id", $booking_id, $payment_amount);
            $stmt->execute();
            $updatePaidSql = "UPDATE bookings SET total_paid = total_paid + ? WHERE booking_id = ?";
            $stmt = $conn->prepare($updatePaidSql);
            $stmt->bind_param("di", $payment_amount, $booking_id);
            $stmt->execute();
        }
        $conn->commit();
        $_SESSION['message'] = 'Reservation updated successfully!';
        $_SESSION['message_type'] = 'success';
        header('Location: ../Admin_reservation.php');
        exit();
    } catch (Exception $e) {
        $conn->rollback();
        $error_message = 'Error updating reservation: ' . $e->getMessage();
    }
}
?>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Edit Reservation</title>
    <link rel="stylesheet" href="../Admin_reservation_style.css"/>
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
          <h2>Edit Reservation - <?php echo htmlspecialchars($booking['reservation_code']); ?></h2>
          <?php if (isset($error_message)): ?>
            <div class="error-message"><?php echo htmlspecialchars($error_message); ?></div>
          <?php endif; ?>
          <form method="POST" action="">
            <div class="naming-container">
              <label>
                <span>First name</span>
                <input type="text" name="first_name" value="<?php echo htmlspecialchars($first_name); ?>" required />
              </label>
              <label>
                <span>Last name</span>
                <input type="text" name="last_name" value="<?php echo htmlspecialchars($last_name); ?>" required />
              </label>
            </div>
            <label>
              <span>Email address</span>
              <input type="email" name="email" value="<?php echo htmlspecialchars($booking['email']); ?>" required />
            </label>
            <label>
              <span>Phone number</span>
              <input type="tel" name="phone" value="<?php echo htmlspecialchars($booking['phone']); ?>" required />
            </label>
            <label>
              <span>Gender</span>
              <select name="gender" required>
                <option value="male" <?php echo $booking['gender'] === 'male' ? 'selected' : ''; ?>>Male</option>
                <option value="female" <?php echo $booking['gender'] === 'female' ? 'selected' : ''; ?>>Female</option>
              </select>
            </label>
            <label>
              <span>Password (leave blank to keep current)</span>
              <input type="password" name="password" />
            </label>
            <label>
              <span>Room</span>
              <select name="room_id" required>
                <?php while ($room = $roomsResult->fetch_assoc()): ?>
                  <option value="<?php echo $room['room_id']; ?>" <?php echo $room['room_id'] == $booking['room_id'] ? 'selected' : ''; ?>>
                    Room <?php echo $room['room_number']; ?> - 
                    <?php echo ucfirst($room['room_type']); ?> - 
                    ₱<?php echo number_format($room['price_per_month'], 2); ?>/month
                  </option>
                <?php endwhile; ?>
              </select>
            </label>
            <label>
              <span>Check-in Date</span>
              <input type="date" name="check_in_date" value="<?php echo $booking['check_in_date']; ?>" required />
            </label>
            <label>
              <span>Check-out Date (optional)</span>
              <input type="date" name="check_out_date" value="<?php echo $booking['check_out_date']; ?>" />
            </label>
            <label>
              <span>Status</span>
              <select name="status" required>
                <option value="pending" <?php echo $booking['status'] === 'pending' ? 'selected' : ''; ?>>Pending</option>
                <option value="confirmed" <?php echo $booking['status'] === 'confirmed' ? 'selected' : ''; ?>>Confirmed</option>
                <option value="canceled" <?php echo $booking['status'] === 'canceled' ? 'selected' : ''; ?>>Canceled</option>
                <option value="completed" <?php echo $booking['status'] === 'completed' ? 'selected' : ''; ?>>Completed</option>
              </select>
            </label>
            <label>
              <span>Additional Payment Amount</span>
              <input type="number" name="payment_amount" step="0.01" min="0" value="0" />
            </label>
            <div class="info-box">
              <p><strong>Current Total Paid:</strong> ₱<?php echo number_format($booking['total_paid'], 2); ?></p>
              <p><strong>Monthly Amount:</strong> ₱<?php echo number_format($booking['monthly_amount'], 2); ?></p>
            </div>
            <button type="submit">Update Reservation</button>
            <a href="../Admin_reservation.php" class="back-link">Back to Reservations</a>
          </form>
        </section>
      </main>
    </div>
  </body>
</html>
<?php
$conn->close();
?>