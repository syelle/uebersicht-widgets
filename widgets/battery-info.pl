#!/usr/bin/perl

use strict;
use warnings;

use JSON::XS;

# config: Update these variables with the names of your keyboard and mouse as they appear in the output of `system_profiler SPBluetoothDataType 2>&1`
# Note: Only certain bluetooth devices report their battery status to OSX. This script has only been tested with Apple's Magic Keyboard and Magic Mouse
my $keyboard_name = "Shaun Yelle’s Keyboard";
my $mouse_name = "Shaun Yelle’s Mouse";
my $airpods_name = "Shaun Yelle's AirPods Pro";

$_ = `system_profiler SPPowerDataType 2>&1`;

my ($remaining, $capacity, $charging, $cycles, $condition, $amps, $volts, $connected) = (0, 0, 'No', 0, 'Unknown', 0, 0, 'No');

if(/\bState\s+of\s+Charge\s+\(%\):\s+(\w+)/) {
  $remaining = $1;	
}

if(/\bFull\s+Charge\s+Capacity\s+\(mAh\):\s+(\w+)/) {
  $capacity = $1;	
}

if(/\bCharging:\s+(\w+)/) {
  $charging = $1;	
}

if(/\bCycle\s+Count:\s+(\w+)/) {
  $cycles = $1;	
}

if(/\bCondition:\s+(\w+)/) {
  $condition = $1;	
}

if(/\bAmperage\s+\(mA\):\s+(-*\w+)/) {
  $amps = $1;
}

if(/\bVoltage\s+\(mV\):\s+(\w+)/) {
  $volts = $1;	
}

if(/\bConnected:\s+(\w+)/) {
  $connected = $1;	
}

my $activity = "Discharging";

if($connected eq 'Yes') {
  if($charging eq 'Yes') {
    $activity = "Charging";
  }
  else {
    $activity = "Idle";    
  } 
}

$_ = `system_profiler SPBluetoothDataType 2>&1`;

my ($keyboard_connected, $keyboard_remaining_percent, $mouse_connected, $mouse_remaining_percent) = ('No', 0, 'No', 0);
my ($airpod_left_remaining_percent, $airpod_right_remaining_percent, $airpod_case_remaining_percent, $airpods_connected) = (0, 0, 0, 'No');


my $device_name_regex = '(?:' . $keyboard_name . ':).*\n.*\n.*\n.*\n.*\n.*(?:Battery Level: )(\d+)';

if(/$device_name_regex/) {
  $keyboard_remaining_percent = $1;
  $keyboard_connected = 'Yes';
}

$device_name_regex = '(?:' . $mouse_name . ':).*\n.*\n.*\n.*\n.*\n.*(?:Battery Level: )(\d+)';

if(/$device_name_regex/) {
  $mouse_remaining_percent = $1;
  $mouse_connected = 'Yes';  
}

$device_name_regex = '(?:' . $airpods_name . ':).*\n.*\n.*\n.*\n.*\n.*\n.*\n.*(?:Connected: )(\w+)';

if(/$device_name_regex/) {
  $airpods_connected = $1;  
}

$_ = `defaults read /Library/Preferences/com.apple.Bluetooth | grep BatteryPercent`;

$device_name_regex = 'BatteryPercentLeft = (\d+);';

if(/$device_name_regex/) {
  $airpod_left_remaining_percent = $1;
}

$device_name_regex = 'BatteryPercentRight = (\d+);';

if(/$device_name_regex/) {
  $airpod_right_remaining_percent = $1;
}

$device_name_regex = 'BatteryPercentCase = (\d+);';

if(/$device_name_regex/) {
  $airpod_case_remaining_percent = $1;
}

my $batteryInfo = {
  activity => $activity,
  amps => $amps,
  capacity => $capacity,
  condition => $condition,
  cycles => $cycles,
  remaining => sprintf("%.2f", $capacity * ($remaining / 100)),
  remainingPercent => $remaining,
  volts => $volts,
  keyboard_remaining_percent => $keyboard_remaining_percent,
  keyboard_connected => $keyboard_connected,
  mouse_remaining_percent => $mouse_remaining_percent,
  mouse_connected => $mouse_connected,
  airpods_connected => $airpods_connected,
  airpod_left_remaining_percent => $airpod_left_remaining_percent,
  airpod_right_remaining_percent => $airpod_right_remaining_percent,
  airpod_case_remaining_percent => $airpod_case_remaining_percent,
};

my $json = JSON::XS->new->ascii->pretty->allow_nonref;
my $batteryInfoJSON = $json->encode($batteryInfo);

print $batteryInfoJSON;
