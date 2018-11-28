// Define SVG area dimensions
var svgWidth = 960;
var svgHeight = 500;

// Define the chart's margins as an object
var margin = {
  top: 60,
  right: 60,
  bottom: 60,
  left: 60
};

var chartWidth = svgWidth - margin.left - margin.right;
var chartHeight = svgHeight - margin.top - margin.bottom;

// Select body, append SVG area to it, and set its dimensions
var svg = d3.select("#scatter")
  .append("svg")
  .attr("width", svgWidth)
  .attr("height", svgHeight);

let chartGroup = svg.append("g")
  .attr("transform", `translate(${margin.left}, ${margin.top})`);


d3.csv("assets/data/data.csv").then(function(data) {
    data.forEach(element => {
        element.poverty = +element.poverty,
        element.smokes = +element.smokes
        
    })

    //create linear scale for data points
    var xLinearScale = d3.scaleLinear()
        .domain(d3.extent(data, element => element.poverty))
        .range([0, chartWidth]);

     var yLinearScale = d3.scaleLinear()
        .domain([7, d3.max(data, element => element.smokes)])
        .range([chartHeight, 0]);
        //.range([0, chartHeight]);

    //create axes and append to chart
    const xAxis =d3.axisBottom(xLinearScale);
    const yAxis = d3.axisLeft(yLinearScale);

    chartGroup.append("g")
    .attr("transform", `translate(0, ${chartHeight})`)
    .call(xAxis);

    chartGroup.append("g")
    .call(yAxis);
    
    //add markers
    //add state name labels to markers
    const points = chartGroup.selectAll("circle")
        .data(data)
        .enter()
        .append("circle")
        .attr("cx", element => xLinearScale(element.poverty))
        .attr("cy", element => yLinearScale(element.smokes))
        .attr("r", "5")
        .attr("fill", "blue")
        ;

    const labels = chartGroup.selectAll("text")
        .data(data)
        .enter()
        .append("text")
        .text(element => element.abbr)
        .attr("x", element => xLinearScale(element.poverty))
        .attr("y", element => yLinearScale(element.smokes))
            
    chartGroup.append("text")
        .text("Smoking Population (%) vs Poverty (%)")
})

