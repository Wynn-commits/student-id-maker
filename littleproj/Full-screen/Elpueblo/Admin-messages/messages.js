let allMessages = [];
let currentMessageId = null;
function openLogout(modal){
    document.getElementById(modal).style.display = "flex";
    document.getElementById('overlay').style.display = "block";
}
function closeLogout(modal){
    document.getElementById(modal).style.display = "none";
    document.getElementById('overlay').style.display = "none";
}
document.addEventListener('DOMContentLoaded', function() {
    loadMessages();
    setInterval(loadMessages, 30000);
});
function loadMessages() {
    fetch('get_messages.php')
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                allMessages = data.messages;
                displayMessageList(allMessages);
                if (currentMessageId) {
                    loadConversation(currentMessageId);
                }
            } else {
                console.error('Failed to load messages');
            }
        })
        .catch(error => {
            console.error('Error loading messages:', error);
            document.getElementById('chatList').innerHTML = 
                '<div style="text-align: center; padding: 20px; color: #ff4e4e;">Error loading messages. Please refresh the page.</div>';
        });
}
function displayMessageList(messages) {
    const chatList = document.getElementById('chatList');
    if (messages.length === 0) {
        chatList.innerHTML = 
            '<div style="text-align: center; padding: 20px; color: #94a3b8;">No messages yet</div>';
        return;
    }
    chatList.innerHTML = '';
    messages.forEach(message => {
        const chatItem = document.createElement('div');
        chatItem.className = 'chat-item';
        if (currentMessageId === message.message_id) {
            chatItem.classList.add('active');
        }
        const preview = message.message_text.length > 40 
            ? message.message_text.substring(0, 40) + '...'
            : message.message_text;
        chatItem.innerHTML = `
            <img src="../Images/Coffee-High-Definition-Desktop-Wallpaper.jpg" alt="${message.sender_name}" class="avatar">
            <div class="chat-info">
                <div class="chat-name">${message.sender_name}${!message.is_read ? ' <span style="color: #ff6a00;">●</span>' : ''}</div>
                <div class="chat-preview">${preview}</div>
            </div>
            <div class="chat-time">${message.time_ago}</div>
        `;
        chatItem.addEventListener('click', function() {
            selectMessage(message.message_id);
        });
        chatList.appendChild(chatItem);
    });
}
function selectMessage(messageId) {
    currentMessageId = messageId;
    const allChatItems = document.querySelectorAll('.chat-item');
    allChatItems.forEach(item => item.classList.remove('active'));
    event.currentTarget.classList.add('active');
    loadConversation(messageId);
}
function loadConversation(messageId) {
    fetch(`get_conversation.php?message_id=${messageId}`)
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                displayConversation(data);
            } else {
                console.error('Failed to load conversation:', data.error);
            }
        })
        .catch(error => {
            console.error('Error loading conversation:', error);
        });
}
function displayConversation(data) {
    const chatHeader = document.getElementById('chatHeader');
    chatHeader.innerHTML = `
        <div class="user-info">
            <img src="../Images/Coffee-High-Definition-Desktop-Wallpaper.jpg" alt="${data.sender_name}" class="avatar">
            <div>
                <div class="user-name">${data.sender_name}</div>
                <div class="user-status">
                    <span class="online-dot" style="display: none;"></span>
                    ${data.sender_email}${data.sender_phone ? ' • ' + data.sender_phone : ''}
                </div>
            </div>
        </div>
    `;
    const messagesArea = document.getElementById('messagesArea');
    messagesArea.innerHTML = '';
    data.conversation.forEach(msg => {
        const messageDiv = document.createElement('div');
        messageDiv.className = msg.sender_type === 'admin' ? 'message sent' : 'message received';
        messageDiv.innerHTML = `
            <div class="message-bubble">
                ${msg.message_text}
            </div>
            <div class="message-time">${msg.time}</div>
        `;
        messagesArea.appendChild(messageDiv);
    });
    messagesArea.scrollTop = messagesArea.scrollHeight;
}
document.getElementById('sendBtn').addEventListener('click', function() {
    sendMessage();
});
document.getElementById('messageInput').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        sendMessage();
    }
});
function sendMessage() {
    const messageInput = document.getElementById('messageInput');
    const messageText = messageInput.value.trim();
    if (messageText === '') {
        return;
    }
    if (!currentMessageId) {
        alert('Please select a message first');
        return;
    }
    alert('Reply functionality will be implemented soon!\n\nYou wrote: ' + messageText);
    messageInput.value = '';
}