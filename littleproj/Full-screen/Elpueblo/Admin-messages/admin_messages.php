<?php
require_once '../db_config.php';
if (!isset($_SESSION['admin_id']) || ($_SESSION['user_type'] !== 'admin' && $_SESSION['role'] !== 'admin')) {
    header("Location: ../Sign-in-admin/admin_login.php");
    exit();
}
$admin_name = $_SESSION['admin_name'] ?? 'Administrator';
?>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Messages - Admin</title>
    <link rel="stylesheet" href="Admin_messages_style.css"/>
  </head>
  <body>
    <header id="site-header">
      <nav>
        <div class="brand-container">
          <div class="black-container">
            <img src="../Images/elpueblo-removebg-preview1.png" alt="logo"/>
          </div>
        </div>
        <h1>Messages</h1>
        <div class="empty-container"></div>
      </nav>
    </header>
    <div class="container">
      <aside class="sidebar">
        <ul>
          <li><a href="../Admin-dashboard/admin_dashboard.php"><img src="../Images/orange-foursquares-icon50.png" alt="icon"> Dashboard</a></li>
          <li><a href="../Admin-reservation/Admin_reservation.php"><img src="../Images/orange-reserve-icon50.png" alt="icon"> Reservation</a></li>
          <li><a href="../Admin_rooms-details/Admin-rooms/Admin_rooms.php"><img src="../Images/orange-home-icon50.png" alt="icon"> Rooms</a></li>
          <li class="active"><img src="../Images/black-typing-icon50.png" alt="icon"> Messages</li>
        </ul>
      </aside>
      <main>
        <div class="messages-container">
          <!-- Chat List - Will be populated dynamically -->
          <div class="chat-list" id="chatList">
            <div style="text-align: center; padding: 20px; color: white;">
              Loading messages...
            </div>
          </div>
          <!-- Chat Window -->
          <div class="chat-window">
            <div class="chat-header" id="chatHeader">
              <div class="user-info">
                <img src="../Images/Coffee-High-Definition-Desktop-Wallpaper.jpg" alt="User" class="avatar">
                <div>
                  <div class="user-name">Select a message</div>
                  <div class="user-status">
                    <span class="online-dot" style="display: none;"></span>
                    <span id="userStatus">No message selected</span>
                  </div>
                </div>
              </div>
            </div>
            <div class="messages-area" id="messagesArea">
              <div style="text-align: center; padding: 40px; color: white;">
                <p>Select a message from the list to view the conversation</p>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
    <script src="messages.js"></script>
  </body>
</html>