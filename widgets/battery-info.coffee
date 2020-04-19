command: "./battery.pl"

refreshFrequency: 10000

render: -> """
  <link rel='stylesheet' href='./css/style.css'>
  <table id='batteryInfo'></table>
"""

update: (output, domEl) -> 
  data = JSON.parse output

  html = ""

  get_text_color_class_for_status = (battery_status) ->
    if parseFloat(battery_status) <= 20 
      text_color_class = "critical"
    else if parseFloat(battery_status) <= 50 
      text_color_class = "issue"
    else if parseFloat(battery_status) <= 75 
      text_color_class = "elevated"

  percent_battery_capacity = data.remainingPercent
  text_color_class = get_text_color_class_for_status(percent_battery_capacity)

  html += "<tr><td>"
  html += "    <span class=" + text_color_class + ">MAIN: " + percent_battery_capacity + "% (" + data.remaining + "/" + data.capacity + " mAh)</span>" 
  html += "</td></tr>"

  battery_activity = data.activity

  text_color_class = "negligible"
  if battery_activity == "Discharging"
    text_color_class = "issue"
  else if battery_activity == "Charging" 
    text_color_class = "elevated"

  html += "<tr><td>"
  html += "    <span class=" + text_color_class + ">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Currently: " + battery_activity + ", " + data.amps +  " mA</span>" 
  html += "</td></tr>"

  battery_condition = data.condition

  text_color_class = "nominal"

  # Condition: https://support.apple.com/en-us/HT204054
  # Cycles:https://support.apple.com/en-my/HT201585

  if battery_condition == "Replace Soon"
    text_color_class = "elevated"
  else if battery_condition == "Replace Now"
    text_color_class = "issue"
  else if battery_condition == "Service Battery" 
    text_color_class = "critical"

  html += "<tr><td>"
  html += "    <span class=" + text_color_class + ">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Health: " + data.condition + ", " + data.cycles +  " cycles</span>" 
  html += "</td></tr>"

  percent_keyboard_battery_capacity = data.keyboard_remaining_percent

  if data.keyboard_connected == 'Yes'
    keyboard_status = percent_keyboard_battery_capacity + "%"
    text_color_class = get_text_color_class_for_status(percent_keyboard_battery_capacity)
  else
    keyboard_status = "Disconnected"
    text_color_class = "negligible"

  html += "<tr><td>"
  html += "    <span class=" + text_color_class + ">AUX-K: " + keyboard_status + "</span>" 
  html += "</td></tr>"

  percent_mouse_battery_capacity = data.mouse_remaining_percent

  if data.mouse_connected == 'Yes'
    mouse_status = percent_mouse_battery_capacity + "%"
    text_color_class = get_text_color_class_for_status(percent_mouse_battery_capacity)
  else
    mouse_status = "Disconnected"
    text_color_class = "negligible"

  html += "<tr><td>"
  html += "    <span class=" + text_color_class + ">AUX-M: " + mouse_status + "</span>" 
  html += "</td></tr>"

  $(batteryInfo).html(html)

style: """
  left: 840px
  top: 0px
  width: 200px
"""