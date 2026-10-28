<?php
require_once '../db_config.php';
header('Content-Type: application/json');
$conn = getDBConnection();
$sql = "SELECT 
            m.message_id,
            m.sender_type,
            m.sender_name,
            m.sender_email,
            m.sender_phone,
            m.message_text,
            m.is_read,
            m.created_at,
            m.booking_id,
            b.reservation_code
        FROM messages m
        LEFT JOIN bookings b ON m.booking_id = b.booking_id
        ORDER BY m.created_at DESC";
$result = $conn->query($sql);
$messages = array();
if ($result && $result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $messages[] = array(
            'message_id' => $row['message_id'],
            'sender_type' => $row['sender_type'],
            'sender_name' => $row['sender_name'],
            'sender_email' => $row['sender_email'],
            'sender_phone' => $row['sender_phone'],
            'message_text' => $row['message_text'],
            'is_read' => (bool)$row['is_read'],
            'created_at' => $row['created_at'],
            'booking_id' => $row['booking_id'],
            'reservation_code' => $row['reservation_code'],
            'time_ago' => getTimeAgo($row['created_at'])
        );
    }
}
$conn->close();
echo json_encode(array(
    'success' => true,
    'messages' => $messages,
    'total' => count($messages)
));
function getTimeAgo($datetime) {
    $time = strtotime($datetime);
    $current = time();
    $seconds = $current - $time;
    if ($seconds < 60) {
        return 'Just now';
    } elseif ($seconds < 3600) {
        $minutes = floor($seconds / 60);
        return $minutes . ' minute' . ($minutes > 1 ? 's' : '') . ' ago';
    } elseif ($seconds < 86400) {
        $hours = floor($seconds / 3600);
        return $hours . ' hour' . ($hours > 1 ? 's' : '') . ' ago';
    } elseif ($seconds < 172800) {
        return 'Yesterday';
    } elseif ($seconds < 604800) {
        $days = floor($seconds / 86400);
        return $days . ' day' . ($days > 1 ? 's' : '') . ' ago';
    } else {
        return date('M d, Y', $time);
    }
}
?>