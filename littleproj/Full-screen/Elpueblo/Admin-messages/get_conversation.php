<?php
require_once '../db_config.php';
header('Content-Type: application/json');
$message_id = isset($_GET['message_id']) ? intval($_GET['message_id']) : 0;
if ($message_id <= 0) {
    echo json_encode(array(
        'success' => false,
        'error' => 'Invalid message ID'
    ));
    exit();
}
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
            m.booking_id
        FROM messages m
        WHERE m.message_id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $message_id);
$stmt->execute();
$result = $stmt->get_result();
if ($result->num_rows === 0) {
    echo json_encode(array(
        'success' => false,
        'error' => 'Message not found'
    ));
    $stmt->close();
    $conn->close();
    exit();
}
$message = $result->fetch_assoc();
$stmt->close();
if (!$message['is_read']) {
    $update_sql = "UPDATE messages SET is_read = 1 WHERE message_id = ?";
    $update_stmt = $conn->prepare($update_sql);
    $update_stmt->bind_param("i", $message_id);
    $update_stmt->execute();
    $update_stmt->close();
}
$conversation = array(
    array(
        'message_id' => $message['message_id'],
        'sender_type' => $message['sender_type'],
        'sender_name' => $message['sender_name'],
        'message_text' => $message['message_text'],
        'created_at' => $message['created_at'],
        'time' => date('g:i A', strtotime($message['created_at']))
    )
);
$conn->close();
echo json_encode(array(
    'success' => true,
    'sender_name' => $message['sender_name'],
    'sender_email' => $message['sender_email'],
    'sender_phone' => $message['sender_phone'],
    'conversation' => $conversation
));
?>