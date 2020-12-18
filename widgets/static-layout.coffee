# refreshFrequency default is 1000 ms (1 s), so we set it to false on purpose
# Reference: https://github.com/felixhageloh/uebersicht/blob/master/README.md
refreshFrequency: false

render: -> """

  <div id='system-status-section'>
		<div id='system-status-title' class='bottom-spacer'>SYSTEM STATUS</div>
		<div class='sidebar-filler'></div>
  </div>
	<div class='metrics-titles-section bottom-spacer'>
		<div class='system-status-title-filler title-row'></div>
		<div id='resc-main' class='metric-title title-row'>RESC-MAIN</div>
    <div id='reactor' class='metric-title title-row'>REACTOR</div>
		<div id='comm-array' class='metric-title title-row'>DATA COMMS & STORAGE</div>
		<div class='system-status-titles-end-filler title-row'></div>
 	</div>
  <div class='metrics-titles-section'>
    <div class='ops-metrics-title-filler title-row'></div>
    <div id='missions' class='metric-title title-row'>MISSIONS</div>
    <div class='ops-status-titles-end-filler title-row'></div>
  </div>
  <div id='ops-status-section'>
    <div class='sidebar-filler bottom-spacer'></div>
    <div id='ops-status-title'>OPERATIONS STATUS</div>
  </div>
"""

style: """
  left 0px
  top 0px
  width 2000px

  border none
  box-sizing border-box

  color rgba(255,255,255,.8)
  font-family Okuda
  font-size 20px

  #system-status-section
    height 300px

  #system-status-title
    width 124px
    height 244px
    padding 8px
    color #000
    background-color #5a92b7

  .sidebar-filler
    background-color #666666
    height 34px
    width 140px

  .metrics-titles-section
    height 38px

  .bottom-spacer
    margin-bottom 6px

  .title-row
    float left
    height 28px
    margin-right 5px

  .system-status-title-filler
    width 178px
    background-color #666666
    height 38px
    border-bottom-left-radius 35px

  .system-status-title-filler::before
    content: "";
    position: relative;
    display: block;

    background-color: transparent;
    left: 140px
    bottom: 100px;
    height: 100px;
    width: 38px;
    border-bottom-left-radius: 50px;
    box-shadow: 0 35px 0 0 #666666;

  .system-status-titles-end-filler
    background-color #666666
    height 38px
    width 475px
    border-bottom-right-radius 35px
    border-top-right-radius 35px

  .metric-title
    padding 5px 8px
    color #000
    background-color #b99609

  #resc-main
    width 460px

  #comm-array
  	width 200px

  #reactor
  	width 420px

  .ops-metrics-title-filler
    width 178px
    background-color #666666
    height 38px
    border-top-left-radius 35px

  .ops-metrics-title-filler::before
    content: "";
    position: relative;
    display: block;

    background-color: transparent;
    left: 140px;
    top: 38px;
    height: 100px;
    width: 38px;
    border-top-left-radius: 50px;
    box-shadow: 0 -35px 0 0 #666666;

  .ops-status-titles-end-filler
    background-color #666666
    height 38px
    width 1208px
    border-bottom-right-radius 35px
    border-top-right-radius 35px

  #ops-status-section
    height 300px

  #ops-status-title
    width 124px
    height 640px
    padding 8px
    color #000
    background-color #5a92b7

  #missions
    width 380px

"""