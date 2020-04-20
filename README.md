# uebersicht-widgets

My personal library of [Übersicht](http://tracesof.net/uebersicht/) widgets, which render output similar to the [LCARS Interface](https://en.wikipedia.org/wiki/LCARS) from Star Trek.

![Screenshot depicting how my Übersicht widgets render an LCARS-like interface](https://raw.githubusercontent.com/syelle/uebersicht-widgets/master/lcars.png)

## How To Use
- Install [Übersicht](http://tracesof.net/uebersicht/).
- Open a terminal window
- Run the following commands:
  - Change to the directory where Übersicht widgets are stored: `cd ~/Library/ApplicationSupport/Übersicht/widgets/`
  - Delete the example widgets that come with Übersicht: `rm ./getting-started.coffee`
  - Install the widgets from this repository: `curl https://codeload.github.com/syelle/uebersicht-widgets/zip/master | tar -xz --strip=2 uebersicht-widgets-master/widgets`
- Edit config variables
  - Note: To make these scripts faster, I don't include logic for things like determining your PCs # of cores for each refresh. Each file includes comments on how you can get the needed info once, then store it in a variable within the script.
  - _cpu-info.pl_ - Edit `$number_of_logical_cpus` with the output of `sysctl -n hw.ncpu`
  - _memory-info.pl_ - Edit `$system_memory_in_gb` with the output of `system_profiler SPHardwareDataType | grep "  Memory:" | awk '{print $2}'`
  - _network-info.pl_ - Edit `$ethernetService` with the name of your preferred ethernet adapter as it appears in the output of `networksetup -listallnetworkservices`
  - _battery-info.pl_ - Edit `$keyboard_name` and `$mouse_name` with the names of your keyboard and mouse as they appear in the output of `system_profiler SPBluetoothDataType 2>&1`
    - Note: Only certain bluetooth devices report their battery status to OSX. This script has only been tested with Apple's Magic Keyboard and Magic Mouse
  - _disk-info.pl_ - Edit `$disk_name` with the name of your preferred disk as it appears in the output of `df -l`

## Dependencies
- [Übersicht](http://tracesof.net/uebersicht/), which renders the UI and continuously runs scripts to fetch updates
- [Okuda](http://www.pixelsagas.com/?download=okuda), a free-for-personal-use font similar to the font used in the LCARS Interface in Star Trek.

## Dev Setup
- Install [Übersicht](http://tracesof.net/uebersicht/).
- Checkout this repo.
- Delete the widgets directory that comes with Übersicht: `rm -rf ~/Library/Application\ Support/Übersicht/widgets/`
- Symlink the widgets directory in Übersicht with the widgets directory in your repo checkout: `ln -s ~/Code/uebersicht-widgets/widgets ~/Library/Application\ Support/Übersicht/widgets`
  - This command assumes you checked this repo out to `~/Code/`
