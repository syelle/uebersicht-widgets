# refreshFrequency default is 1000 ms (1 s), so we set it to false on purpose
# Reference: https://github.com/felixhageloh/uebersicht/blob/master/README.md
refreshFrequency: false

render: -> """

    <div id="top-section">
		<div id='system-status'>SYSTEM STATUS</div>
		<div class='sidebar-filler'></div>
    </div>
	<div id="top-section-metrics-titles">
		<div class='top-title-filler title-row'> </div>
		<div id='resc-main' class='metric-title title-row'>RESC-MAIN</div>
		<div id='comm-array' class='metric-title title-row'>COMMS ARRAY</div>
		<div id='reactor' class='metric-title title-row'>REACTOR</div>
		<div class='top-title-end-filler title-row'></div>
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

  #top-section
    height 270px

  #system-status
    width 130px
    height 200px
    padding 5px
    color #000
    background-color #5a92b7

  .sidebar-filler
    background-color #666666
    margin-top 7px
    height 60px
    width 140px

  #top-section-metrics-titles
    height 100px

  .title-row
    float left
    height 25px
    margin-right 5px

  .top-title-filler
    width 178px
    background-color #666666
    height 35px
    border-bottom-left-radius 35px

  .top-title-filler::before
    content: "";
    position: absolute;

    background-color: transparent;
    left: 140px
    bottom: 100px;
    height: 100px;
    width: 38px;
    border-bottom-left-radius: 50px;
    box-shadow: 0 35px 0 0 #666666;

  .top-title-end-filler
    background-color #666666
    height 35px
    width 742px
    border-bottom-right-radius 35px
    border-top-right-radius 35px

  .bottom-title-filler::before
    content: "";
    position: absolute;

    background-color: transparent;
    bottom: -50px;
    height: 50px;
    width: 25px;
    border-top-left-radius: 25px;
    box-shadow: 0 -25px 0 0 #666666;

  .metric-title
    padding 5px
    color #000
    background-color #b99609

  #resc-main
    width 420px

  #comm-array
  	width 200px

  #reactor
  	width 200px

"""