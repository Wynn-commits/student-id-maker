<?php
require_once '../db_config.php';
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['booking_id'])) {
    $booking_id = intval($_POST['booking_id']);
    $conn = getDBConnection();
    $conn->begin_transaction();
    try {
        $getBookingSql = "SELECT room_id, status FROM bookings WHERE booking_id = ?";
        $stmt = $conn->prepare($getBookingSql);
        $stmt->bind_param("i", $booking_id);
        $stmt->execute();
        $result = $stmt->get_result();
        if ($result->num_rows === 0) {
            throw new Exception("Booking not found");
        }
        $booking = $result->fetch_assoc();
        $room_id = $booking['room_id'];
        $updateBookingSql = "UPDATE bookings SET status = 'canceled', check_out_date = CURDATE() WHERE booking_id = ?";
        $stmt = $conn->prepare($updateBookingSql);
        $stmt->bind_param("i", $booking_id);
        $stmt->execute();
        $updateRoomSql = "UPDATE rooms SET current_occupancy = current_occupancy - 1 WHERE room_id = ?";
        $stmt = $conn->prepare($updateRoomSql);
        $stmt->bind_param("i", $room_id);
        $stmt->execute();
        $checkRoomSql = "UPDATE rooms SET status = 'available' WHERE room_id = ? AND current_occupancy = 0";
        $stmt = $conn->prepare($checkRoomSql);
        $stmt->bind_param("i", $room_id);
        $stmt->execute();
        $conn->commit();
        $_SESSION['message'] = 'Reservation canceled successfully!';
        $_SESSION['message_type'] = 'success';
    } catch (Exception $e) {
        $conn->rollback();
        $_SESSION['message'] = 'Error canceling reservation: ' . $e->getMessage();
        $_SESSION['message_type'] = 'error';
    }
    $conn->close();
}
header('Location: Admin_reservation.php');
exit();
?>