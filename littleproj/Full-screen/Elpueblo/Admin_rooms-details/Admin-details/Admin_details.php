<?php
require_once '../../db_config.php';
$conn = getDBConnection();
$room_id = isset($_GET['room_id']) ? intval($_GET['room_id']) : 0;
if ($room_id === 0) {
    header('Location: ../Admin-rooms/Admin_rooms.php');
    exit();
}
$roomQuery = "SELECT * FROM rooms WHERE room_id = ?";
$stmt = $conn->prepare($roomQuery);
$stmt->bind_param("i", $room_id);
$stmt->execute();
$result = $stmt->get_result();
if ($result->num_rows === 0) {
    header('Location: ../Admin-rooms/Admin_rooms.php');
    exit();
}
$room = $result->fetch_assoc();
$available_slots = $room['capacity'] - $room['current_occupancy'];
$occupantsQuery = "SELECT u.full_name, u.email, u.phone, b.check_in_date, b.status 
                   FROM bookings b
                   JOIN users u ON b.user_id = u.user_id
                   WHERE b.room_id = ? AND b.status IN ('confirmed', 'pending')
                   ORDER BY b.check_in_date DESC";
$stmt = $conn->prepare($occupantsQuery);
$stmt->bind_param("i", $room_id);
$stmt->execute();
$occupants = $stmt->get_result();
?>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Room Details - Room <?php echo htmlspecialchars($room['room_number']); ?></title>
    <link rel="stylesheet" href="../css/Admin_rooms-details_style.css" />
  </head>
  <body>
    <header id="site-header">
      <nav>
        <div class="auth-buttons">
          <a href="../Admin-rooms/Admin_rooms.php" class="back-btn">
            <img src="../../Images/left-arrow-1.png" alt="left-arrow" />
            Go back
          </a>
        </div>
        <div class="brand-container">
          <div class="black-container">
            <img src="../../Images/elpueblo-removebg-preview1.png" alt="logo" />
          </div>
        </div>
      </nav>
    </header>
    <main>
      <h1>Room Details</h1>
      <div class="booking-container">
        <div class="room-details">
          <div class="image-gallery">
            <div class="main-image">
              <img
                id="mainImage"
                src="https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"
                alt="Room"
              />
            </div>
            <div class="thumbnail-container">
              <img
                src="https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"
                onclick="changeImage(this)"
              />
              <img
                src="../../Images/backgrounddorm1.jpg"
                onclick="changeImage(this)"
              />
              <img
                src="../../Images/Coffee-High-Definition-Desktop-Wallpaper.jpg"
                onclick="changeImage(this)"
              />
            </div>
          </div>
          <div class="room-info">
            <h2>Room <?php echo htmlspecialchars($room['room_number']); ?></h2>
            <p class="room-type"><?php echo ucfirst($room['room_type']); ?> Room - Floor <?php echo $room['floor']; ?></p>
            <p class="description">
              <?php echo $room['description'] ? htmlspecialchars($room['description']) : 'Spacious room perfect for comfortable living and study space.'; ?>
            </p>
            <div class="room-status">
              <div class="left-status-container">
                <div class="alignment">
                  <img src="../../Images/chekcmark-icon30.png" />
                  <p>Availability: <strong><?php echo $available_slots; ?> slot<?php echo $available_slots != 1 ? 's' : ''; ?> left</strong></p>
                </div>
                <div class="alignment">
                  <img src="../../Images/average-price0-icon30.png" />
                  <p>Price: <strong>₱<?php echo number_format($room['price_per_month'], 2); ?> per month</strong></p>
                </div>
              </div>
              <img id="vertical-line" src="../../Images/vertical-line100.png" />
              <div class="right-status-container">
                <div class="alignment">
                  <img src="../../Images/bunk-bed-icon30.png" />
                  <p>Beds: <strong><?php echo $room['capacity']; ?> bed<?php echo $room['capacity'] != 1 ? 's' : ''; ?></strong></p>
                </div>
                <div class="alignment">
                  <img src="../../Images/smart-shelf30.png" />
                  <p>Facilities:</p>
                  <div class="icons-container">
                    <img src="../../Images/Wi-Fi-icon30.png" />
                    <img src="../../Images/vacuum-cleaner-icon30.png" />
                    <img src="../../Images/bureau-icon-30.png" />
                    <img src="../../Images/dishwasher-icon30.png" />
                  </div>
                </div>
              </div>
            </div>
            <!-- Current Occupants Section -->
            <?php if ($occupants->num_rows > 0): ?>
            <div class="occupants-section">
              <h3>Current Occupants</h3>
              <div class="occupants-list">
                <?php while ($occupant = $occupants->fetch_assoc()): ?>
                <div class="occupant-card">
                  <p class="occupant-name">Name: <?php echo htmlspecialchars($occupant['full_name']); ?></p>
                  <p class="occupant-info">Email: <?php echo htmlspecialchars($occupant['email']); ?></p>
                  <p class="occupant-info">Phone: <?php echo htmlspecialchars($occupant['phone']); ?></p>
                  <p class="occupant-info">Check-in: <?php echo date('M d, Y', strtotime($occupant['check_in_date'])); ?></p>
                  <span class="status-badge <?php echo strtolower($occupant['status']); ?>">
                    <?php echo ucfirst($occupant['status']); ?>
                  </span>
                </div>
                <?php endwhile; ?>
              </div>
            </div>
            <?php endif; ?>
          </div>
        </div>
        <div class="booking-summary" id="bookingPanel">
          <div class="step">
            <h3>Room Summary</h3>
            <p>Room information overview</p>
            <div class="divider"></div>
            <div class="summary-box">
              <h3>Room Information</h3>
              <p>Room: <strong>Room <?php echo htmlspecialchars($room['room_number']); ?></strong></p>
              <p>Type: <strong><?php echo ucfirst($room['room_type']); ?></strong></p>
              <p>Floor: <strong><?php echo $room['floor']; ?></strong></p>
              <p>Beds: <strong><?php echo $room['capacity']; ?></strong></p>
              <p>Occupied: <strong><?php echo $room['current_occupancy']; ?></strong></p>
              <p>Available slots: <strong><?php echo $available_slots; ?></strong></p>
              <p>Status: <strong class="status-<?php echo $room['status']; ?>"><?php echo ucfirst($room['status']); ?></strong></p>
            </div>
            <div class="divider"></div>
            <div class="cost-preview">
              <h4>Pricing Details</h4>
              <div class="info-container">
                <table>
                  <tr>
                    <td>Monthly Rate:</td>
                    <td>₱<?php echo number_format($room['price_per_month'], 2); ?></td>
                  </tr>
                </table>
                <div class="cost-line"></div>
                <table>
                  <tr>
                    <td>Room Type:</td>
                    <td><?php echo ucfirst($room['room_type']); ?></td>
                  </tr>
                </table>
                <div class="cost-line"></div>
                <table>
                  <tr class="last-tr">
                    <td>Capacity:</td>
                    <td><?php echo $room['capacity']; ?> <?php echo $room['capacity'] > 1 ? 'beds' : 'bed'; ?></td>
                  </tr>
                </table>
              </div>
            </div>
            <div class="divider"></div>
            <button class="action-btn" onclick="window.location.href='../../Admin-reservation/Admin_reservation.php'">
              View All Reservations
            </button>
          </div>
        </div>
      </div>
    </main>
    <script src="../js/Rooms-details.js"></script>
  </body>
</html>
<?php
$conn->close();
?>