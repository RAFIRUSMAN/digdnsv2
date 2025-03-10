document.addEventListener("DOMContentLoaded", function () {
    document.getElementById("dnsLookupForm").addEventListener("submit", function (event) {
      event.preventDefault();
      
      const domain = document.getElementById("domain").value.trim();
      if (!domain) {
        alert("Please enter a valid domain!");
        return;
      }
  
      fetch(`/lookup?domain=${encodeURIComponent(domain)}`)
        .then(response => response.json())
        .then(data => {
          document.getElementById("results").textContent = data.result.join("\n");
        })
        .catch(error => {
          console.error("Error:", error);
          document.getElementById("results").textContent = "Failed to fetch DNS data.";
        });
    });
  });
  