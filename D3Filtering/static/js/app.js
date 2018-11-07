// from data.js
var tableData = data;

 let tbody = d3.select("tbody");

 tableData.forEach(element => {
    let row = tbody.append("tr");
    Object.entries(element).forEach(function([key, value]) {
     // Append a cell to the row for each value in the UFO-sighting object
        var cell = row.append("td");
        cell.text(value);
        });
        
});

// Select the submit button
var submit = d3.select("#filter-btn");

submit.on("click", function() {
  
  // Prevent the page from refreshing
  d3.event.preventDefault();
  
  //Remove intial table rows
  d3.selectAll('tbody tr').remove();
  // Select the input element and get the raw HTML node
  var inputElement = d3.select("#datetime");

  // Get the value property of the input element
  var inputValue = inputElement.property("value");
  var filteredData = tableData.filter(tableRow => {
        return tableRow.datetime === inputValue
    });
  console.log(inputValue);
  console.log(filteredData);
  
  filteredData.forEach(element => {
    let row = tbody.append("tr");
    Object.entries(element).forEach(function([key, value]) {
    // Append a cell to the row for each value in the UFO-sighting object
        var cell = row.append("td");
        cell.text(value);
        });
    });
    
});
