function openModal(modalId) {
    document.getElementById(modalId).style.display = "flex";
    document.getElementById('overlay').style.display = "block";
}
function closeModal(modalId) {
    document.getElementById(modalId).style.display = "none";
    document.getElementById('overlay').style.display = "none";
}
function openDeleteModal(bookingId) {
    document.getElementById('deleteBookingId').value = bookingId;
    openModal('deleteModal');
}
function openRemove(modalId) {
    openModal(modalId);
}
function closeRemove(modalId) {
    closeModal(modalId);
}
document.addEventListener('DOMContentLoaded', function() {
    const overlay = document.getElementById('overlay');
    if (overlay) {
        overlay.addEventListener('click', function() {
            const modals = document.querySelectorAll('.modal');
            modals.forEach(function(modal) {
                modal.style.display = 'none';
            });
            overlay.style.display = 'none';
        });
    }
    const alertMessage = document.getElementById('alertMessage');
    if (alertMessage) {
        setTimeout(function() {
            alertMessage.style.animation = 'slideOut 0.3s ease';
            setTimeout(function() {
                alertMessage.remove();
            }, 300);
        }, 5000);
    }
});
const style = document.createElement('style');
style.textContent = `
    @keyframes slideOut {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(400px);
            opacity: 0;
        }
    }
`;
document.head.appendChild(style);
function validateForm(formId) {
    const form = document.getElementById(formId);
    if (!form) return true;
    const inputs = form.querySelectorAll('input[required], select[required]');
    let isValid = true;
    inputs.forEach(function(input) {
        if (!input.value.trim()) {
            input.style.borderColor = 'red';
            isValid = false;
        } else {
            input.style.borderColor = '#ccc';
        }
    });
    return isValid;
}
function validateEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
}
function validatePhone(phone) {
    const re = /^[0-9]{10,11}$/;
    return re.test(phone.replace(/\s/g, ''));
}