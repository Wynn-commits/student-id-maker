function goBack() {
  const params = new URLSearchParams(window.location.search); 
  const from = params.get('from'); 
  if (from === 'signup-page') { 
    window.location.href = '../Sign-up/register.php'; 
  } else if (from === 'booking-page') { 
    window.location.href = '../Room-booking/booking_details.php'; 
  } else {
    history.back(); 
  }
}