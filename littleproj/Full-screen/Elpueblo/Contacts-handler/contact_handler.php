<?php
require_once '../db_config.php';
$success = "";
$error = "";
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $sender_name   = sanitizeInput($_POST['name'] ?? '');
    $sender_email  = sanitizeInput($_POST['email'] ?? '');
    $sender_phone  = sanitizeInput($_POST['phone'] ?? '');
    $message_text  = sanitizeInput($_POST['message'] ?? '');
    if (empty($sender_name) || empty($sender_email) || empty($message_text)) {
        $error = "Please fill in all required fields";
    } elseif (!filter_var($sender_email, FILTER_VALIDATE_EMAIL)) {
        $error = "Invalid email format";
    } else {
        $conn = getDBConnection();
        $stmt = $conn->prepare("INSERT INTO messages (sender_type, sender_name, sender_email, sender_phone, message_text) VALUES ('guest', ?, ?, ?, ?)");
        $stmt->bind_param("ssss", $sender_name, $sender_email, $sender_phone, $message_text);
        if ($stmt->execute()) {
            $success = "Thank you for your message! We'll get back to you soon.";
        } else {
            $error = "Failed to send message. Please try again.";
        }
        $stmt->close();
        $conn->close();
    }
} else {
    $error = "Invalid request. Please submit the contact form.";
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Message Sent - El Pueblo Dormitory</title>
    <link rel="stylesheet" href="contacts_handler_style.css">
</head>
<body>
    <div class="container">
        <?php if (!empty($success)): ?>
            <div class="success-icon">✓</div>
            <h2>Message Sent!</h2>
            <p><?php echo $success; ?></p>
        <?php else: ?>
            <div class="error-icon">✕</div>
            <h2>Oops!</h2>
            <p><?php echo $error; ?></p>
        <?php endif; ?>
        <a href="../Main-interface/index.html" class="btn">Back to Home</a>
    </div>
</body>
</html>