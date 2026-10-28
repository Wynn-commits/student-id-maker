<?php
require_once '../db_config.php';
$conn = getDBConnection();
$sql = "SELECT 
            b.booking_id,
            b.reservation_code,
            u.full_name AS guest_name,
            r.room_number,
            b.check_in_date,
            b.check_out_date,
            b.monthly_amount,
            b.status,
            b.created_at
        FROM bookings b
        JOIN users u ON b.user_id = u.user_id
        JOIN rooms r ON b.room_id = r.room_id
        ORDER BY b.created_at DESC";
$result = $conn->query($sql);
$message = '';
$messageType = '';
if (isset($_SESSION['message'])) {
    $message = $_SESSION['message'];
    $messageType = $_SESSION['message_type'];
    unset($_SESSION['message']);
    unset($_SESSION['message_type']);
}
?>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Reservation Management</title>
    <link rel="stylesheet" href="Admin_reservation_style.css" />
  </head>
  <body>
    <div class="overlay" id="overlay"></div>
    <div class="modal" id="deleteModal">
      <img
        class="shut-down"
        src="../Images/shutdown-red-96.png"
        alt="shut-down"
      />
      <div class="logout-container">
        <h2>Cancel Reservation</h2>
        <p>Are you sure you want to cancel this reservation?</p>
        <div class="logout-btn-container">
          <button class="cancel-btn" onclick="closeModal('deleteModal')">
            No, Go Back
          </button>
          <form id="deleteForm" method="POST" action="../Admin-reservation/delete_reservation.php" style="display: inline;">
            <input type="hidden" name="booking_id" id="deleteBookingId">
            <button type="submit" class="logout-btn">
              Yes, Cancel Reservation
            </button>
          </form>
        </div>
      </div>
    </div>
    <?php if ($message): ?>
    <div class="alert alert-<?php echo $messageType; ?>" id="alertMessage">
      <?php echo htmlspecialchars($message); ?>
    </div>
    <?php endif; ?>
    <header id="site-header">
      <nav>
        <div class="brand-container">
          <div class="black-container">
            <img src="../Images/elpueblo-removebg-preview1.png" alt="logo" />
          </div>
        </div>
        <h1>Reservation Management</h1>
        <div class="empty-container"></div>
      </nav>
    </header>
    <div class="container">
      <aside class="sidebar">
        <ul>
          <li>
            <a href="../Admin-dashboard/admin_dashboard.php"
              ><img src="../Images/orange-foursquares-icon50.png" alt="icon" />
              Dashboard</a
            >
          </li>
          <li class="active">
            <img src="../Images/black-reserve-icon50.png" alt="icon" />
            Reservation
          </li>
          <li>
            <a href="../Admin_rooms-details/Admin-rooms/Admin_rooms.php"
              ><img src="../Images/orange-home-icon50.png" alt="icon" /> Rooms</a
            >
          </li>
          <li>
            <a href="../Admin-messages/admin_messages.php"
              ><img src="../Images/orange-typing-icon50.png" alt="icon" />
              Messages</a
            >
          </li>
        </ul>
      </aside>
      <div class="main-content">
        <div class="controls">
          <button class="add-btn">
            <a href="../Admin-reservation/Add-reservation/Add_reservation.php"
              ><span class="plus">+</span> Add Reservation</a
            >
          </button>
        </div>
        <div class="table-wrapper">
          <table>
            <thead>
              <tr>
                <th>Reservation ID</th>
                <th>Guest Name</th>
                <th>Room</th>
                <th>Check-in</th>
                <th>Check-out</th>
                <th>Amount</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <?php if ($result && $result->num_rows > 0): ?>
                <?php while ($row = $result->fetch_assoc()): ?>
                <tr>
                  <td><strong><?php echo htmlspecialchars($row['reservation_code']); ?></strong></td>
                  <td><?php echo htmlspecialchars($row['guest_name']); ?></td>
                  <td><?php echo htmlspecialchars($row['room_number']); ?></td>
                  <td><?php echo date('M d, Y', strtotime($row['check_in_date'])); ?></td>
                  <td><?php echo $row['check_out_date'] ? date('M d, Y', strtotime($row['check_out_date'])) : 'Ongoing'; ?></td>
                  <td class="amount">₱<?php echo number_format($row['monthly_amount'], 2); ?></td>
                  <td>
                    <span class="status <?php echo strtolower($row['status']); ?>">
                      <?php echo ucfirst($row['status']); ?>
                    </span>
                  </td>
                  <td class="actions">
                    <button class="btn edit">
                      <a href="../Admin-reservation/Edit-reservation/Edit_reservation.php?id=<?php echo $row['booking_id']; ?>">✏️ Edit</a>
                    </button>
                    <button class="btn cancel" onclick="openDeleteModal(<?php echo $row['booking_id']; ?>)">
                      🗑 Cancel
                    </button>
                  </td>
                </tr>
                <?php endwhile; ?>
              <?php else: ?>
                <tr>
                  <td colspan="8" style="text-align: center; padding: 40px;">No reservations found</td>
                </tr>
              <?php endif; ?>
            </tbody>
          </table>
          <div class="divider"></div>
        </div>
      </div>
    </div>
    <script src="reservation.js"></script>
  </body>
</html>
<?php
$conn->close();
?>