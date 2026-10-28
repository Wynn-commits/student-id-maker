function goBack() {
  const params = new URLSearchParams(window.location.search); //search niya ang url page
  const from = params.get('from'); // Kuhaon(get) niya ang page location ug asa('from')

  if (from === 'signup-page') { //kung nag pindot user sa page na sign-up,
    window.location.href = '../Testfile_elpueblo/Sign-up/signup-page.html'; // sa sign up siya e padulong.
  } else if (from === 'booking-page') { //if ang pindot naman sa booking details,
    window.location.href = '../Testfile_elpueblo/Room-booking/booking-page.html'; // sa booking details siya mo balik.
  } else {
    history.back(); // balik siya
  }
}