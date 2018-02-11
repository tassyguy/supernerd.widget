#
# ──────────────────────────────────────────────── I ───────
#   :::::: S U P E R N E R D – BOTTOM
# ──────────────────────────────────────────────────────────
#

  #
  # ─── ALL COMMANDS ───────────────────────────────────────────────────────────
  #

  commands =
    battery: "pmset -g batt | egrep '([0-9]+\%).*' -o --colour=auto " +
             "| cut -f1 -d';'"
    time   : "date +\"%H:%M\""
    wifi   : "/System/Library/PrivateFrameworks/Apple80211.framework/" +
             "Versions/Current/Resources/airport -I | " +
             "sed -e \"s/^ *SSID: //p\" -e d"
    volume : "osascript -e 'output volume of (get volume settings)'"
    cpu : "ps -A -o %cpu | awk '{s+=$1} END {printf(\"%.2f\",s/8);}'"
    mem : "ps -A -o %mem | awk '{s+=$1} END {print s \"%\"}' "
    hdd : "df -hl | awk '{s+=$5} END {print s \"%\"}'"
    date  : "date +\"%a %d %b\""

  #
  # ─── COLORS ─────────────────────────────────────────────────────────────────
  #

  colors =
    black:   "#282a36"
    red:     "#ff5c57"
    green:   "#5af78e"
    yellow:  "#f3f99d"
    blue:    "#57c7ff"
    magenta: "#ff6ac1"
    cyan:    "#9aedfe"
    white:   "#eff0eb"

  #
  # ─── COMMAND ────────────────────────────────────────────────────────────────
  #

  command: "echo " +
           "$(#{ commands.battery }):::" +
           "$(#{ commands.time }):::" +
           "$(#{ commands.wifi }):::" +
           "$(#{ commands.volume }):::" +
           "$(#{ commands.cpu }):::" +
           "$(#{ commands.mem }):::" +
           "$(#{ commands.hdd }):::" +
           "$(#{ commands.date }):::"



  #
  # ─── REFRESH ────────────────────────────────────────────────────────────────
  #

  refreshFrequency:5012

  #
  # ─── RENDER ─────────────────────────────────────────────────────────────────
  #

  render: ( ) ->
    """
    <link rel="stylesheet" href="./font-awesome/font-awesome.min.css" />
    <div class="container" id="main">
      <div class="container" id="left">
      <div class="home">
        <i class="fas fa-home"></i>
        ~/
      </div>
        <div class="browser">
          <i class="far fa-compass"></i>
          Browser
        </div>
        <div class="mail">
          <i class="far fa-envelope"></i>
          Mail
        </div>
        <div class="messages">
          <i class="far fa-comments"></i>
          Messages
        </div>
      </div>

      <div class="container" id="center">
      </div>

      <div class="container" id="right">
        <div class="cpu">
          <i class="fa fa-spinner"></i>
          <span class="cpu-output"></span>
        </div>
        <div class="mem">
          <i class="fas fa-server"></i>
          <span class="mem-output"></span>
        </div>
        <div class="hdd">
          <i class="fas fa-hdd"></i>
            <span class="hdd-output"></span>
        </div>
        </div>

      </div>

    </div>
    """

  #
  # ─── RENDER ─────────────────────────────────────────────────────────────────
  #

  update: ( output ) ->
    output = output.split( /:::/g )

    battery = output[ 0 ]
    time   = output[ 1 ]
    wifi = output[ 2 ]
    volume = output[ 3 ]
    cpu = output[ 4 ]
    mem = output[ 5 ]
    hdd = output[ 6 ]
    date = output[ 7 ]


    $( ".time-output" )    .text( "#{ time }" )
    $( ".date-output" )    .text( "#{ date }" )
    $( ".battery-output") .text("#{ battery }")
    $( ".wifi-output") .text("#{ wifi }")
    $( ".volume-output") .text("#{ volume }")
    $( ".cpu-output") .text("#{ cpu }")
    $( ".mem-output") .text("#{ mem }")
    $( ".hdd-output") .text("#{ hdd }")


    @handleBattery( Number( battery.replace( /%/g, "" ) ) )
    @handleVolume( Number( volume ) )

  #
  # ─── HANDLE BATTERY ─────────────────────────────────────────────────────────
  #

  handleBattery: ( percentage ) ->
    batteryIcon = switch
      when percentage <=  12 then "fa-battery-empty"
      when percentage <=  25 then "fa-battery-quarter"
      when percentage <=  50 then "fa-battery-half"
      when percentage <=  75 then "fa-battery-three-quarters"
      when percentage <= 100 then "fa-battery-full"
    $( ".battery-icon" ).html( "<i class=\"fa #{ batteryIcon }\"></i>" )

  #
  # ─── HANDLE VOLUME ──────────────────────────────────────────────────────────
  #

  handleVolume: ( volume ) ->
    volumeIcon = switch
      when volume ==   0 then "fa-volume-off"
      when volume <=  50 then "fa-volume-down"
      when volume <= 100 then "fa-volume-up"
    $( ".volume-icon" ).html( "<i class=\"fa #{ volumeIcon }\"></i>" )

  #
  # ─── STYLE ──────────────────────────────────────────────────────────────────
  #

  style: """
    .battery
      color: #{ colors.green }
    .time
      color: #{ colors.white }
    .wifi
      color: #{ colors.white }
    .volume
      color: #{ colors.cyan }
    .cpu
      color: #{ colors.white }
    .mem
      color: #{ colors.red }
    .hdd
      color: #{ colors.magenta}
    .date
      color: #{ colors.green }
    .up
      color: #{ colors.green }
    .down
      color: #{ colors.red }
    .window
      color: #{ colors.white }
    .messages
      color: #{ colors.green }
    .mail
      color: #{ colors.cyan }
    .browser
      color: #{ colors.blue }
    .home
      color: #{ colors.white }


    bottom: 4px
    left: 16px

    font-family: 'Menlo'
    font-size: 12px
    font-smoothing: antialiasing
    z-index: 0
    display: flex

    i
      margin-left:16px

    .container
      display: flex;
      flex-direction: row;
      justify-content: space-between;
      border-radius:4px
      padding:3px
      background-color: #{ colors.black }


    #main
      padding:4px
      width:1640px

    #left
      width:50%
      justify-content: flex-start

    #center
      width:50%
      display:block
      text-align:center

    #right
      width:50%
      justify-content:flex-end

  """
  #
  # ─── HANDLE CLICKS ──────────────────────────────────────────────────────────
  #
  afterRender: (domEl) ->
    $(domEl).on 'click', '.home', => @run "open ~"
    $(domEl).on 'click', '.browser', => @run "open /Applications/Safari.app"
    $(domEl).on 'click', '.mail', => @run "open /Applications/Mail.app"
    $(domEl).on 'click', '.messages', => @run "open /Applications/WhatsApp.app"

# ──────────────────────────────────────────────────────────────────────────────