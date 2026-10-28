const monthsLabels = window.dashboardData.monthsLabels;
const bookingsData = window.dashboardData.bookingsData;
const revenueData = window.dashboardData.revenueData;
new Chart(document.getElementById("barChart"), {
    type: "bar",
    data: {
        labels: monthsLabels,
        datasets:[
            {
                label: "Bookings",
                data: bookingsData,
                backgroundColor: "#ff6a00"
            },
            {
              label: "Revenue (₱)",
              data: revenueData,
              backgroundColor: "gray"
            },
        ]
    },
    options: {
        responsive: true,
        plugins: {
            legend: { labels: { color: "white" } },
        },
        scales: {
            x: { ticks: {color: "white" } },
            y: { ticks: {color: "white" } },
        }
    }
});
new Chart(document.getElementById("lineChart"), {
  type: "line",
  data: {
    labels: monthsLabels,
    datasets: [
      {
        label: "Revenue (₱)",
        data: revenueData,
        borderColor: "#ff6a00",
        fill: false,
        tension: 0.4
      }
    ]
  },
  options: {
    responsive: true,
    plugins: {
      legend: { labels: { color: "white" } }
    },
    scales: {
      x: { ticks: { color: "white" } },
      y: { ticks: { color: "white" } }
    }
  }
});
function openLogout(modal){
    document.getElementById(modal).style.display = "flex";
    document.getElementById('overlay').style.display = "block";
}
function closeLogout(modal){
    document.getElementById(modal).style.display = "none";
    document.getElementById('overlay').style.display = "none";
}