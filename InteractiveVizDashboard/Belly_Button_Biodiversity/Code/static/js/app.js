function buildMetadata(sample) {
  let url = "/metadata/" + sample;
  d3.json(url).then(function(response){
    
    // Use `d3.json` to fetch the metadata for a sample
    // Use d3 to select the panel with id of `#sample-metadata`
    // Use `.html("") to clear any existing metadata
    let panel = d3.select("#sample-metadata").html("");

    // Use `Object.entries` to add each key and value pair to the panel
    Object.entries(response).forEach(function([key, value]) {
      panel.append("li").text(`${key}: ${value}`);
    })
  })
}

//builds pie and bubble charts for sample data
function buildCharts(sample) {

  let url = "/samples/" + sample
  d3.json(url).then(function(response) {
    console.log(response)


    //order and slice data based on top ten sample_values
    let data = [];
    for (i = 0; i < response.sample_values.length; i++){
      data.push({
        otu_id: response.otu_ids[i],
        species: response.otu_labels[i],
        value: response.sample_values[i]
      })
    
    }
    let sorted = data.sort(function(a, b) {
       return b.value-a.value;
    });
    sorted = sorted.slice(0, 10);
    console.log(sorted)

    let sorted_ids = [];
    let sorted_values = [];
    let sorted_labels = [];

    for (i = 0; i < sorted.length; i++) {
      sorted_ids.push(sorted[i].otu_id)
      sorted_values.push(sorted[i].value)
      sorted_labels.push(sorted[i].species)
    }
    
    //get most specific classication of bacteria
    let specie_labels = sorted_labels.map(element => element.split(';').slice(-1)[0])

    //create pie chart
    let trace1 = {
      labels: sorted_ids,
      values: sorted_values,
      hovertext: specie_labels,
      type: "pie",
    };
    
    let pieData = [trace1];
    
    let layout = {
      title: `Top Ten Belly Button Bacteria from Sample ${sample}`,
    };
    
    Plotly.newPlot("pie", pieData, layout);

    //create bubble chart
    let traceBubble = {
      x: sorted_ids,
      y: sorted_values,
      mode: "markers",
      marker: {
        size: sorted_values.map(element => element/1.5),
        color: ["#9b59b6", "#3498db", "#95a5a6", "#e74c3c", "#34495e", "#2ecc71", "#B2D732", "#FE2712", "#347B98"],
      },
      hoverinfo: "x+y+text",
      hovertext: specie_labels
    };
    console.log(traceBubble)
    let bubbleData = [traceBubble];
      
    let layoutBubble = {
      hovermode:'closest',
      title: "Bacteria Species Distribution",
      xaxis: {
        zeroline: false,
        title: 'OTU ID',
      },
      
    };

      
    Plotly.newPlot("bubble", bubbleData, layoutBubble)
    
  })
}


function init() {
  // Grab a reference to the dropdown select element
  var selector = d3.select("#selDataset");

  // Use the list of sample names to populate the select options
  d3.json("/names").then((sampleNames) => {
    sampleNames.forEach((sample) => {
      selector
        .append("option")
        .text(sample)
        .property("value", sample);
    });

    // Use the first sample from the list to build the initial plots
    const firstSample = sampleNames[0];
    buildCharts(firstSample);
    buildMetadata(firstSample);
  });
}

function optionChanged(newSample) {
  // Fetch new data each time a new sample is selected
  buildCharts(newSample);
  buildMetadata(newSample);
}

// Initialize the dashboard
init();
