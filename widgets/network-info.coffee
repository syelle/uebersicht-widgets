# Run the command to get network info
command: "./network-info.pl"

# Set the refresh frequency (milliseconds).
refreshFrequency: 10000

# Render the output.
render: (output) -> """
  <link rel='stylesheet' href='./css/style.css'>
  <table id='networkInfo'></table>
"""

# Update the rendered output.
update: (output, domEl) -> 
  # Parse the JSON created by the shell script.
  data = JSON.parse output
  
  get_text_color_class_for_status = (ip) ->
    if ip == "Disconnected" 
      return "critical"
    else if ip.match(/(169\.\d+\.\d+\.\d+)/)
      return "issue"
    else
      return "nominal" 

  html = ""
  
  text_color_class = get_text_color_class_for_status(data.services.ethernet.ip)

  html += "<tr><td><span class=" + text_color_class + ">" + data.services.ethernet.name + "</span></td>" 
  html += "<td><span class=" + text_color_class + ">: " + data.services.ethernet.ip + "</span></td>" 
  # html += "<td><span class=" + text_color_class + ">&nbsp;@ " + data.services.ethernet.mac + "</span></td></tr>"

  text_color_class = get_text_color_class_for_status(data.services.wifi.ip)

  html += "<tr><td><span class=" + text_color_class + ">" + data.services.wifi.name + "</span></td>" 
  html += "<td><span class=" + text_color_class + ">: " + data.services.wifi.ip + "</span></td>" 
  # html += "<td><span class=" + text_color_class + ">&nbsp;@ " + data.services.wifi.mac + "</span></td></tr>"

  $(networkInfo).html(html)

# CSS Style
style: """
  left: 675px
  top: 0px
"""
