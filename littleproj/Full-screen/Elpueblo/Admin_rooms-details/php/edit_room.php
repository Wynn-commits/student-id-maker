<?php
require_once '../../db_config.php';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $room_id = intval($_POST['room_id']);
    $room_number = sanitizeInput($_POST['room_number']);
    $room_type = sanitizeInput($_POST['room_type']);
    $capacity = intval($_POST['capacity']);
    $price_per_month = floatval($_POST['price_per_month']);
    $floor = intval($_POST['floor']);
    $status = sanitizeInput($_POST['status']);
    $description = isset($_POST['description']) ? sanitizeInput($_POST['description']) : '';
    $conn = getDBConnection();
    try {
        $checkSql = "SELECT room_id FROM rooms WHERE room_number = ? AND room_id != ?";
        $stmt = $conn->prepare($checkSql);
        $stmt->bind_param("si", $room_number, $room_id);
        $stmt->execute();
        $result = $stmt->get_result();
        if ($result->num_rows > 0) {
            $_SESSION['message'] = 'Room number already exists!';
            $_SESSION['message_type'] = 'error';
            header('Location: ../Admin-rooms/Admin_rooms.php');
            exit();
        }
        $updateSql = "UPDATE rooms 
                      SET room_number = ?, room_type = ?, capacity = ?, price_per_month = ?, 
                          status = ?, floor = ?, description = ?
                      WHERE room_id = ?";
        $stmt = $conn->prepare($updateSql);
        $stmt->bind_param("ssidsisi", $room_number, $room_type, $capacity, $price_per_month, $status, $floor, $description, $room_id);
        if ($stmt->execute()) {
            $_SESSION['message'] = 'Room updated successfully!';
            $_SESSION['message_type'] = 'success';
        } else {
            throw new Exception('Failed to update room');
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