<?php
require_once '../../db_config.php';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $room_number = sanitizeInput($_POST['room_number']);
    $room_type = sanitizeInput($_POST['room_type']);
    $capacity = intval($_POST['capacity']);
    $price_per_month = floatval($_POST['price_per_month']);
    $floor = intval($_POST['floor']);
    $status = sanitizeInput($_POST['status']);
    $description = isset($_POST['description']) ? sanitizeInput($_POST['description']) : '';
    $conn = getDBConnection();
    try {
        $checkSql = "SELECT room_id FROM rooms WHERE room_number = ?";
        $stmt = $conn->prepare($checkSql);
        $stmt->bind_param("s", $room_number);
        $stmt->execute();
        $result = $stmt->get_result();
        if ($result->num_rows > 0) {
            $_SESSION['message'] = 'Room number already exists!';
            $_SESSION['message_type'] = 'error';
            header('Location: ../Admin-rooms/Admin_rooms.php');
            exit();
        }
        $insertSql = "INSERT INTO rooms (room_number, room_type, capacity, price_per_month, status, floor, description) 
                      VALUES (?, ?, ?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($insertSql);
        $stmt->bind_param("ssidsis", $room_number, $room_type, $capacity, $price_per_month, $status, $floor, $description);
        if ($stmt->execute()) {
            $_SESSION['message'] = 'Room added successfully!';
            $_SESSION['message_type'] = 'success';
        } else {
            throw new Exception('Failed to add room');
        }
    } catch (Exception $e) {
        $_SESSION['message'] = 'Error: ' . $e->getMessage();
        $_SESSION['message_type'] = 'error';
    }
    $conn->close();
}
header('Location: ../Admin-rooms/Admin_rooms.php');
exit();
?>