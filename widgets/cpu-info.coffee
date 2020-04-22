command: "./cpu-info.pl"

refreshFrequency: 5000

render: -> """
  <link rel='stylesheet' href='./css/style.css'>
  <div id='cpuInfo'></div>
"""

update: (output, domEl) -> 
  data = JSON.parse output

  html = ""

  html += "<table>"

  percent_cpu_capacity = data.total_cpu_load_as_percent_of_total_cpu_capacity

  text_color_class = "nominal"
  if parseFloat(percent_cpu_capacity) >= 60 
    text_color_class = "critical"
  else if parseFloat(percent_cpu_capacity) >= 40 
    text_color_class = "issue"
  else if parseFloat(percent_cpu_capacity) >= 20 
    text_color_class = "elevated"
  else if parseFloat(percent_cpu_capacity) >= 1 
    text_color_class = "nominal"
  else if parseFloat(percent_cpu_capacity) < 1 
    text_color_class = "negligible"

  html += "<tr><td><span class=" + text_color_class + ">Total Load</span></td>"
  html += "<td><span class=" + text_color_class + ">&nbsp;- " + data.total_cpu_load + "</span></td>"
  html += "<td><span class=" + text_color_class + ">" + percent_cpu_capacity + "%</span></td></tr>" 

  for process in data.processes
    process_cpu_capacity_use = process.percent_of_total_cpu_capacity

    text_color_class = "nominal"
    if parseFloat(process_cpu_capacity_use) >= 30 
      text_color_class = "critical"
    else if parseFloat(process_cpu_capacity_use) >= 20 
      text_color_class = "issue"
    else if parseFloat(process_cpu_capacity_use) >= 10 
      text_color_class = "elevated"
    else if parseFloat(process_cpu_capacity_use) >= 1 
      text_color_class = "nominal"
    else if parseFloat(process_cpu_capacity_use) < 1 
      text_color_class = "negligible"

    html += "<tr><td class='header'><span class=" + text_color_class + ">" + process.name + "</span></td>"
    html += "<td class='measure'><span class=" + text_color_class + ">&nbsp;- " + process.cpu_load + "</span></td>"
    html += "<td class='percent'><span class=" + text_color_class + ">"+ process_cpu_capacity_use + "%</span></td></tr>" 
  
  html += "</table>"

  $(cpuInfo).html(html)

style: """
  left 190px
  top 0px
"""