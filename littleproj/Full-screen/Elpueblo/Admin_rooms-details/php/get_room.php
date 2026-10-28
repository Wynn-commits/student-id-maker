<?php
require_once '../../db_config.php';
header('Content-Type: application/json');
if (isset($_GET['room_id'])) {
    $room_id = intval($_GET['room_id']);
    $conn = getDBConnection();
    $sql = "SELECT * FROM rooms WHERE room_id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $room_id);
    $stmt->execute();
    $result = $stmt->get_result();
    if ($result->num_rows > 0) {
        $room = $result->fetch_assoc();
        echo json_encode(['success' => true, 'room' => $room]);
    } else {
        echo json_encode(['success' => false, 'message' => 'Room not found']);
    }
    $conn->close();
} else {
    echo json_encode(['success' => false, 'message' => 'No room ID provided']);
}
?>