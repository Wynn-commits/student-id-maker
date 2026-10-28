<?php
require_once '../../db_config.php';
$conn = getDBConnection();
$mensRoomsQuery = "SELECT * FROM rooms WHERE room_type = 'male' ORDER BY room_number";
$womensRoomsQuery = "SELECT * FROM rooms WHERE room_type = 'female' ORDER BY room_number";
$mensRooms = $conn->query($mensRoomsQuery);
$womensRooms = $conn->query($womensRoomsQuery);
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
    <title>Dormitory Rooms</title>
    <link rel="stylesheet" href="../css/Admin_rooms-details_style.css" />
  </head>
  <body>
    <?php if ($message): ?>
    <div class="alert alert-<?php echo $messageType; ?>" id="alertMessage">
      <?php echo htmlspecialchars($message); ?>
    </div>
    <?php endif; ?>
    <header id="site-header">
      <nav>
        <div class="auth-buttons">
          <a href="../../Admin-dashboard/admin_dashboard.php" class="back-btn">
            <img src="../../Images/left-arrow-1.png" alt="left-arrow"> Go back
          </a>
        </div>
        <ul>
          <li><a href="#mens-room">Men's Rooms</a></li>
          <li><a href="#womens-room">Women's Rooms</a></li>
          <li><a href="../../Admin-dashboard/admin_dashboard.php">Dashboard</a></li>
        </ul>
        <div class="brand-container">
          <div class="black-container">
            <img src="../../Images/elpueblo-removebg-preview1.png" alt="logo"/>
          </div>
        </div>
      </nav>
    </header>
    <main>

      <section id="mens-room">
        <div class="section-header">
          <h2>Men's Room</h2>
          <button class="add-room-btn" onclick="openAddRoomModal('male')">
            <span>+</span> Add Room
          </button>
        </div>
        <div class="container">
          <?php if ($mensRooms && $mensRooms->num_rows > 0): ?>
            <?php while ($room = $mensRooms->fetch_assoc()): ?>
              <?php 
                $available_slots = $room['capacity'] - $room['current_occupancy'];
                $isAvailable = $room['status'] === 'available' && $available_slots > 0;
              ?>
              <div class="card <?php echo !$isAvailable ? 'unavailable' : ''; ?>">
                <div class="room-actions">
                  <button class="edit-room-btn" onclick="openEditRoomModal(<?php echo $room['room_id']; ?>)" title="Edit Room">
                    ✏️
                  </button>
                </div>
                <div class="image-container">
                  <img src="../../Images/backgrounddorm1.jpg" alt="room-<?php echo $room['room_number']; ?>">
                  <?php if (!$isAvailable): ?>
                    <div class="room-overlay">
                      <span><?php echo ucfirst($room['status']); ?></span>
                    </div>
                  <?php endif; ?>
                </div>
                <div class="text-container">
                  <h3>Room <?php echo htmlspecialchars($room['room_number']); ?></h3>
                  <span>Capacity: <?php echo $room['capacity']; ?> <?php echo $room['capacity'] > 1 ? 'beds' : 'bed'; ?></span>
                  <p>Available slot: <?php echo $available_slots; ?></p>
                  <p class="room-price">₱<?php echo number_format($room['price_per_month'], 2); ?>/month</p>
                </div>
                <button>
                  <a href="../Admin-details/Admin_details.php?room_id=<?php echo $room['room_id']; ?>">More Details</a>
                </button>
              </div>
            <?php endwhile; ?>
          <?php else: ?>
            <p class="no-rooms">No men's rooms available</p>
          <?php endif; ?>
        </div>
      </section>

      <section id="womens-room">
        <div class="section-header">
          <h2>Women's Room</h2>
          <button class="add-room-btn" onclick="openAddRoomModal('female')">
            <span>+</span> Add Room
          </button>
        </div>
        <div class="container">
          <?php if ($womensRooms && $womensRooms->num_rows > 0): ?>
            <?php while ($room = $womensRooms->fetch_assoc()): ?>
              <?php 
                $available_slots = $room['capacity'] - $room['current_occupancy'];
                $isAvailable = $room['status'] === 'available' && $available_slots > 0;
              ?>
              <div class="card <?php echo !$isAvailable ? 'unavailable' : ''; ?>">
                <div class="room-actions">
                  <button class="edit-room-btn" onclick="openEditRoomModal(<?php echo $room['room_id']; ?>)" title="Edit Room">
                    ✏️
                  </button>
                </div>
                <div class="image-container">
                  <img src="../../Images/backgrounddorm1.jpg" alt="room-<?php echo $room['room_number']; ?>">
                  <?php if (!$isAvailable): ?>
                    <div class="room-overlay">
                      <span><?php echo ucfirst($room['status']); ?></span>
                    </div>
                  <?php endif; ?>
                </div>
                <div class="text-container">
                  <h3>Room <?php echo htmlspecialchars($room['room_number']); ?></h3>
                  <span>Capacity: <?php echo $room['capacity']; ?> <?php echo $room['capacity'] > 1 ? 'beds' : 'bed'; ?></span>
                  <p>Available slot: <?php echo $available_slots; ?></p>
                  <p class="room-price">₱<?php echo number_format($room['price_per_month'], 2); ?>/month</p>
                </div>
                <button>
                  <a href=".../Admin-details/Admin_details.php?room_id=<?php echo $room['room_id']; ?>">More Details</a>
                </button>
              </div>
            <?php endwhile; ?>
          <?php else: ?>
            <p class="no-rooms">No women's rooms available</p>
          <?php endif; ?>
        </div>
      </section>
    </main>
    <!-- Add Room Modal -->
    <div class="overlay" id="overlay"></div>
    <div class="modal room-modal" id="addRoomModal">
      <div class="modal-content">
        <span class="close-modal" onclick="closeRoomModal('addRoomModal')">&times;</span>
        <h2>Add New Room</h2>
        <form method="POST" action="../php/add_room.php">
          <input type="hidden" name="room_type" id="addRoomType">
          <label>
            <span>Room Number</span>
            <input type="text" name="room_number" required>
          </label>
          <label>
            <span>Capacity (number of beds)</span>
            <input type="number" name="capacity" min="1" max="10" value="2" required>
          </label>
          <label>
            <span>Price per Month (₱)</span>
            <input type="number" name="price_per_month" step="0.01" min="0" value="850" required>
          </label>
          <label>
            <span>Floor</span>
            <input type="number" name="floor" min="1" max="10" value="1" required>
          </label>
          <label>
            <span>Status</span>
            <select name="status" required>
              <option value="available">Available</option>
              <option value="occupied">Occupied</option>
              <option value="maintenance">Maintenance</option>
            </select>
          </label>
          <label>
            <span>Description (optional)</span>
            <textarea name="description" rows="3"></textarea>
          </label>
          <button type="submit" class="submit-btn">Add Room</button>
        </form>
      </div>
    </div>
    <!-- Edit Room Modal -->
    <div class="modal room-modal" id="editRoomModal">
      <div class="modal-content">
        <span class="close-modal" onclick="closeRoomModal('editRoomModal')">&times;</span>
        <h2>Edit Room</h2>
        <form method="POST" action="../php/edit_room.php" id="editRoomForm">
          <input type="hidden" name="room_id" id="editRoomId">
          <label>
            <span>Room Number</span>
            <input type="text" name="room_number" id="editRoomNumber" required>
          </label>
          <label>
            <span>Room Type</span>
            <select name="room_type" id="editRoomTypeSelect" required>
              <option value="male">Male</option>
              <option value="female">Female</option>
            </select>
          </label>
          <label>
            <span>Capacity (number of beds)</span>
            <input type="number" name="capacity" id="editCapacity" min="1" max="10" required>
          </label>
          <label>
            <span>Current Occupancy</span>
            <input type="number" name="current_occupancy" id="editOccupancy" min="0" readonly>
          </label>
          <label>
            <span>Price per Month (₱)</span>
            <input type="number" name="price_per_month" id="editPrice" step="0.01" min="0" required>
          </label>
          <label>
            <span>Floor</span>
            <input type="number" name="floor" id="editFloor" min="1" max="10" required>
          </label>
          <label>
            <span>Status</span>
            <select name="status" id="editStatus" required>
              <option value="available">Available</option>
              <option value="occupied">Occupied</option>
              <option value="maintenance">Maintenance</option>
            </select>
          </label>
          <label>
            <span>Description (optional)</span>
            <textarea name="description" id="editDescription" rows="3"></textarea>
          </label>
          <button type="submit" class="submit-btn">Update Room</button>
        </form>
      </div>
    </div>
    <script src="../js/Rooms-details.js"></script>
  </body>
</html>
<?php
$conn->close();
?>