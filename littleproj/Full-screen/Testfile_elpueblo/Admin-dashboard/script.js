new Chart(document.getElementById("barChart"), {
    type: "bar",
    data: {
        labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
        datasets:[
            {
                label: "Bookings",
                data: [3, 9, 5, 10, 7, 8],
                backgroundColor: "#ff6a00"
            },
            {
              label: "Revenue",
              data: [6, 12, 9, 14, 8, 15],
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
    labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
    datasets: [
      {
        label: "Revenue",
        data: [2000, 9000, 4000, 10000, 3500, 11000],
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