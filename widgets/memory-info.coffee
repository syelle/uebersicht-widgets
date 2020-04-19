command: "./memory-info.pl"

refreshFrequency: 5000

render: -> """
  <link rel='stylesheet' href='./css/style.css'>
  <table id='memoryInfo'></table>
"""

update: (output, domEl) -> 
  data = JSON.parse output

  html = ""

  percent_memory_capacity = data.percent_of_total_memory_used

  text_color_class = "nominal"
  if parseFloat(percent_memory_capacity) > 80 
    text_color_class = "critical"
  else if parseFloat(percent_memory_capacity) > 55 
    text_color_class = "issue"
  else if parseFloat(percent_memory_capacity) > 30 
    text_color_class = "elevated"
  else if parseFloat(percent_memory_capacity) >= 10 
    text_color_class = "nominal"
  else if parseFloat(percent_memory_capacity) < 10 
    text_color_class = "negligible"

  html += "<tr><td width='100px'><span class=" + text_color_class + ">Total Memory Used</span></td>"
  html += "<td width='75px'><span class=" + text_color_class + ">&nbsp;- " + data.total_memory_used + "</span></td>"
  html += "<td width='50px'><span class=" + text_color_class + ">" + percent_memory_capacity + "%</td></span></tr>" 

  for process in data.processes
    process_memory_capacity_use = process.percent_memory_used

    text_color_class = "nominal"
    if parseFloat(process_memory_capacity_use) > 30 
      text_color_class = "critical"
    else if parseFloat(process_memory_capacity_use) > 20 
      text_color_class = "issue"
    else if parseFloat(process_memory_capacity_use) > 10 
      text_color_class = "elevated"
    else if parseFloat(process_memory_capacity_use) >= 1 
      text_color_class = "nominal"
    else if parseFloat(process_memory_capacity_use) < 1 
      text_color_class = "negligible"

    html += "<tr><td><span class=" + text_color_class + ">" + process.name + "</span></td>"
    html += "<td><span class=" + text_color_class + ">&nbsp;- " + process.memory_used + "</span></td>"
    html += "<td><span class=" + text_color_class + ">" + process_memory_capacity_use + "%</span></td></tr>" 

  $(memoryInfo).html(html)

style: """
  border none
  left 400px
  top 0px
  width:225px
"""