function changeImage(element) {
    const mainImage = document.getElementById("mainImage");
    mainImage.classList.add("slide");
    setTimeout(() => {
        mainImage.src = element.src;
        mainImage.classList.remove("slide");
    }, 200);
}
function openRoomModal(modalId) {
    document.getElementById(modalId).style.display = "flex";
    document.getElementById('overlay').style.display = "block";
}
function closeRoomModal(modalId) {
    document.getElementById(modalId).style.display = "none";
    document.getElementById('overlay').style.display = "none";
}
function openAddRoomModal(roomType) {
    document.getElementById('addRoomType').value = roomType;
    openRoomModal('addRoomModal');
}
function openEditRoomModal(roomId) {
    fetch(`../php/get_room.php?room_id=${roomId}`)
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                const room = data.room;
                document.getElementById('editRoomId').value = room.room_id;
                document.getElementById('editRoomNumber').value = room.room_number;
                document.getElementById('editRoomTypeSelect').value = room.room_type;
                document.getElementById('editCapacity').value = room.capacity;
                document.getElementById('editOccupancy').value = room.current_occupancy;
                document.getElementById('editPrice').value = room.price_per_month;
                document.getElementById('editFloor').value = room.floor;
                document.getElementById('editStatus').value = room.status;
                document.getElementById('editDescription').value = room.description || '';
                openRoomModal('editRoomModal');
            } else {
                alert('Error loading room data: ' + data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Failed to load room data');
        });
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
function validateRoomForm(formId) {
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
document.addEventListener('DOMContentLoaded', function() {
    const capacityInput = document.getElementById('editCapacity');
    const occupancyInput = document.getElementById('editOccupancy');
    if (capacityInput && occupancyInput) {
        capacityInput.addEventListener('input', function() {
            const capacity = parseInt(this.value);
            const occupancy = parseInt(occupancyInput.value);
            if (capacity < occupancy) {
                alert(`Capacity cannot be less than current occupancy (${occupancy})`);
                this.value = occupancy;
            }
        });
    }
});