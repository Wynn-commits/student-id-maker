<?php
require_once '../db_config.php';
if (!isset($_SESSION['admin_id']) || $_SESSION['user_type'] !== 'admin') {
    header("Location: ../Sign-in-admin/admin_login.php");
    exit();
}
$admin_name = $_SESSION['admin_name'];
$admin_email = $_SESSION['admin_email'];
$conn = getDBConnection();
$bookings_query = "SELECT COUNT(*) as total FROM bookings";
$bookings_result = $conn->query($bookings_query);
$total_bookings = $bookings_result->fetch_assoc()['total'];
$revenue_query = "SELECT SUM(monthly_amount) as total FROM bookings WHERE status IN ('confirmed', 'pending')";
$revenue_result = $conn->query($revenue_query);
$total_revenue = $revenue_result->fetch_assoc()['total'] ?? 0;
$occupancy_query = "SELECT 
    SUM(capacity) as total_capacity,
    SUM(current_occupancy) as total_occupied
FROM rooms";
$occupancy_result = $conn->query($occupancy_query);
$occupancy_data = $occupancy_result->fetch_assoc();
$occupancy_rate = ($occupancy_data['total_capacity'] > 0) 
    ? round(($occupancy_data['total_occupied'] / $occupancy_data['total_capacity']) * 100) 
    : 0;
$monthly_bookings = [];
$monthly_revenue = [];
$months_labels = [];
for ($i = 5; $i >= 0; $i--) {
    $month_start = date('Y-m-01', strtotime("-$i months"));
    $month_end = date('Y-m-t', strtotime("-$i months"));
    $month_label = date('M', strtotime("-$i months"));
    $stmt = $conn->prepare("SELECT COUNT(*) as count FROM bookings WHERE created_at BETWEEN ? AND ?");
    $stmt->bind_param("ss", $month_start, $month_end);
    $stmt->execute();
    $monthly_bookings[] = $stmt->get_result()->fetch_assoc()['count'];
    $stmt->close();
    $stmt = $conn->prepare("SELECT SUM(monthly_amount) as total FROM bookings WHERE created_at BETWEEN ? AND ? AND status IN ('confirmed', 'pending')");
    $stmt->bind_param("ss", $month_start, $month_end);
    $stmt->execute();
    $monthly_revenue[] = $stmt->get_result()->fetch_assoc()['total'] ?? 0;
    $stmt->close();
    $months_labels[] = $month_label;
}
$conn->close();
?>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Dashboard - Admin</title>
    <link rel="stylesheet" href="admin_dashboard_style.css"/>
  </head>
  <body>
    <div class="overlay" id="overlay"></div>
    <div class="modal" id="modal">
      <img class="shut-down" src="../Images/shutdown-red-96.png" alt="shut-down">
      <div class="logout-container">
        <h2>Log Out Account</h2>
        <p>Are you sure you want to log out? Once you logout you need to login again.</p>
        <div class="logout-btn-container">
          <button class="cancel-btn" onclick="closeLogout('modal')">Cancel</button>
          <button class="logout-btn" onclick="window.location.href='../Sign-in-admin/admin_login.php?logout=1'">Yes, Log out</button>
        </div>  
      </div>
    </div>
    <header id="site-header">
      <nav>
        <div class="brand-container">
          <div class="black-container">
            <img src="../Images/elpueblo-removebg-preview1.png" alt="logo"/>
          </div>
        </div>
        <h1>Dormitory Management Dashboard</h1>
        <div class="profile-container">
        <img src="../Images/Coffee-High-Definition-Desktop-Wallpaper.jpg" alt="profile">
        <div class="profile-info">
            <p><strong><?php echo htmlspecialchars($admin_name); ?></strong></p>
            <div class="button-admin-container">
                <span>Admin</span>
                <button onclick="openLogout('modal')">Log out</button>
            </div>
        </div>     
        </div>
      </nav>
    </header>
    <div class="container">
      <aside class="sidebar">
        <ul>
          <li class="active"><img src="../Images/black-foursquares-icon48.png" alt="icon"> Dashboard</li>
          <li><a href="../Admin-reservation/Admin_reservation.php"><img src="../Images/orange-reserve-icon50.png" alt="icon"> Reservation</a></li>
          <li><a href="../Admin_rooms-details/Admin-rooms/Admin_rooms.php"><img src="../Images/orange-home-icon50.png" alt="icon"> Rooms</a></li>
          <li><a href="../Admin-messages/admin_messages.php"><img src="../Images/orange-typing-icon50.png" alt="icon"> Messages</a></li>
        </ul>
      </aside>
      <main>
        <div class="cards">
          <div class="card">
            <h3>Bookings</h3>
            <p class="value"><?php echo $total_bookings; ?></p>
            <span class="badge">Total</span>
          </div>
          <div class="card">
            <h3>Revenue</h3>
            <p class="value">₱<?php echo number_format($total_revenue, 0); ?></p>
            <span class="badge">Monthly</span>
          </div>
          <div class="card">
            <h3>Occupancy Rate</h3>
            <p class="value"><?php echo $occupancy_rate; ?>%</p>
            <span class="badge"><?php echo $occupancy_data['total_occupied']; ?>/<?php echo $occupancy_data['total_capacity']; ?> beds</span>
          </div>
        </div>
        <div class="charts">
          <div class="chart-box">
            <h3>Performance Overview</h3>
            <canvas id="barChart"></canvas>
          </div>
          <div class="chart-box">
            <h3>Revenue Overview</h3>
            <canvas id="lineChart"></canvas>
          </div>
        </div>
      </main>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
      window.dashboardData = {
        monthsLabels: <?php echo json_encode($months_labels); ?>,
        bookingsData: <?php echo json_encode($monthly_bookings); ?>,
        revenueData: <?php echo json_encode($monthly_revenue); ?>
      };
    </script>
    <script src="dashboard.js"></script>
  </body>
</html>