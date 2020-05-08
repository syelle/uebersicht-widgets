command: "./disk-info.pl"

refreshFrequency: 60000

render: -> """
  <link rel='stylesheet' href='./css/style.css'>
  <table id='diskInfo'></table>
"""

update: (output, domEl) -> 
  data = JSON.parse output

  html = ""

  disk_used_percent = data.disk_used_percent

  text_color_class = "nominal"
  if parseFloat(disk_used_percent) >= 90 
    text_color_class = "critical"
  else if parseFloat(disk_used_percent) >= 75 
    text_color_class = "issue"
  else if parseFloat(disk_used_percent) >= 50 
    text_color_class = "elevated"

  html += "<tr><td>"
  html += "    <span class=" + text_color_class + ">" + data.disk_name + "</span>" 
  html += "</td></tr>"

  html += "<tr><td>" 
  html += "    <span class=" + text_color_class + ">&nbsp;&nbsp;&nbsp;&nbsp;" + disk_used_percent + "% (" + data.disk_used + "/" + data.disk_size + ")</span>" 
  html += "</td></tr>"


  $(diskInfo).html(html)

style: """
  left: 900px
  top: 60px
  width: 200px
"""