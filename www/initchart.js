$(document).ready(function() {
  Highcharts.setOptions({
    global: {
      useUTC: true
    }
  });

  $("#resultsChart").highcharts({
    chart: {
      marginRight: 0,
      borderWidth: 0,
      height: 350,
      animation: {
        duration: 600
      }
    },
    title: {
      text: null
    },
    xAxis: {
      categories: ["Chirag", "Nakul", "Aaras", "Shrinidhi", "Anuj", "Mihir", "Reena", "Ruchi", "Ankit", "Elina"]
    },
    yAxis: {
      title: {
        text: "Probability"
      },
      min: 0,
      max: 1.05,
      tickInterval: .2,
      endOnTick: false
    },
    legend: {
      enabled: false,
      floating: false
    },
    plotOptions: {
      series: {
        colorByPoint: true,
        dataLabels: {
          enabled: true,
          format: '{point.y:.3f}',
        }
      }
    },
    series: [{
      name: 'Probability',
      type: 'column',
      data: [.1, .1, .1, .1, .1, .1, .1, .1, .1, .1],
      tooltip: {
        pointFormat: '{point.y:.3f}',
        followPointer: true
      }
    }]
  });


  // Handle messages from server - update graph
  Shiny.addCustomMessageHandler("updateChart",
    function(message) {
      var chart = $("#resultsChart").highcharts();
      var data = chart.series[0].data;

      data[0].update(Number(message.chirag));
      data[1].update(Number(message.nakul));
      data[2].update(Number(message.aaras));
      data[3].update(Number(message.shrinidhi));
      data[4].update(Number(message.anuj));
      data[5].update(Number(message.mihir));
      data[6].update(Number(message.reena));
      data[7].update(Number(message.ruchi));
      data[8].update(Number(message.ankit));
      data[9].update(Number(message.elina));
    }
  );
});