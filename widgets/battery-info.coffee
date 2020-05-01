command: "./battery-info.pl"

refreshFrequency: 5000

render: -> """
  <link rel='stylesheet' href='./css/style.css'>
  <table id='batteryInfo'></table>
  <div>
    <div class='battery-gauge'>
      <div class='battery-title'>MAIN</div>
      <div class='battery-bar-container'>
        <div id='main-battery-bar' class='battery-progress-bar'></div>
      </div>
      <div id='main-battery-percent-display' class='battery-percent-display'></div>
    </div>
    <div class='battery-gauge'>
      <div class='battery-title'>AUX-K</div>
      <div class='battery-bar-container'>
        <div id='keyboard-battery-bar' class='battery-progress-bar battery-discharging'></div>
      </div>
      <div id='keyboard-battery-percent-display' class='battery-percent-display'></div>
    </div>
    <div class='battery-gauge'>
      <div class='battery-title'>AUX-M</div>
      <div class='battery-bar-container'>
        <div id='mouse-battery-bar' class='battery-progress-bar battery-discharging'></div>
      </div>
      <div id='mouse-battery-percent-display' class='battery-percent-display'></div>
    </div>
  <div>
"""

update: (output, domEl) -> 
  data = JSON.parse output

  html = ""

  text_color_class = "nominal"

  # Condition: https://support.apple.com/en-us/HT204054
  # Cycles:https://support.apple.com/en-my/HT201585

  battery_condition = data.condition

  if battery_condition == "Replace Soon"
    text_color_class = "elevated"
  else if battery_condition == "Replace Now"
    text_color_class = "issue"
  else if battery_condition == "Service Battery" 
    text_color_class = "critical"

  html += "<tr><td><span class=" + text_color_class + ">Core Health: " + data.condition + "</span></td></tr>" 
  html += "<tr><td><span class=" + text_color_class + ">Age: " + data.cycles +  " cycles</span></td></tr>" 

  get_text_color_class_for_status = (battery_status) ->
    if parseFloat(battery_status) <= 20 
      text_color_class = "critical"
    else if parseFloat(battery_status) <= 50 
      text_color_class = "issue"
    else if parseFloat(battery_status) <= 75 
      text_color_class = "elevated"

  percent_battery_capacity = data.remainingPercent
  text_color_class = get_text_color_class_for_status(percent_battery_capacity)

  html += "<tr><td><span class=" + text_color_class + ">xFer: " + data.amps + "mA (" + data.remaining + "/" + data.capacity + " mAh)</span></td></tr>" 

  battery_activity = data.activity

  text_color_class = get_text_color_class_for_status(percent_battery_capacity)

  $("#main-battery-bar").css('height', percent_battery_capacity + '%')
  $("#main-battery-percent-display").html("<span class=" + text_color_class + ">" + percent_battery_capacity + "%</span>" )
  $("#main-battery-bar").removeClass('battery-idle', 'battery-charging', 'battery-discharging');
  $("#main-battery-bar").addClass('battery-' + battery_activity.toLowerCase());

  # If your keyboard doesn't report its battery status to OSX, delete everything until the 'end keyboard status' comment to remove it from your UI
  percent_keyboard_battery_capacity = data.keyboard_remaining_percent

  if data.keyboard_connected == 'Yes'
    keyboard_status = percent_keyboard_battery_capacity + "%"
    text_color_class = get_text_color_class_for_status(percent_keyboard_battery_capacity)
  else
    keyboard_status = "OFFLINE"
    text_color_class = "negligible"

  $("#keyboard-battery-bar").css('height', percent_keyboard_battery_capacity + '%')
  $("#keyboard-battery-percent-display").html("<span class=" + text_color_class + ">" + keyboard_status + "</span>")

  # end keyboard status

  # If your mouse doesn't report its battery status to OSX, delete everything until the 'end mouse status' comment to remove it from your UI

  percent_mouse_battery_capacity = data.mouse_remaining_percent

  if data.mouse_connected == 'Yes'
    mouse_status = percent_mouse_battery_capacity + "%"
    text_color_class = get_text_color_class_for_status(percent_mouse_battery_capacity)
  else
    mouse_status = "OFFLINE"
    text_color_class = "negligible"

  $("#mouse-battery-bar").css('height', percent_mouse_battery_capacity + '%')
  $("#mouse-battery-percent-display").html("<span class=" + text_color_class + ">" + mouse_status + "</span>")

  # end mouse status

  $(batteryInfo).html(html)

style: """
  left: 890px
  top: 0px
  width: 210px
"""
