#!/usr/bin/perl

use strict;
use warnings;

use JSON::XS;

$_ = `system_profiler SPPowerDataType 2>&1`;

my ($remaining, $capacity, $charging, $cycles, $condition, $amps, $volts, $connected) = (0, 0, 'No', 0, 'Unknown', 0, 0, 'No');

if(/\bCharge\s+Remaining\s+\(mAh\):\s+(\w+)/) {
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

if(/(?:Shaun Yelle’s Keyboard:).*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*(?:Battery Level: )(\d+)/) {
  $keyboard_remaining_percent = $1;
  $keyboard_connected = 'Yes';
}

if(/(?:Shaun Yelle’s Mouse:).*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*\n.*(?:Battery Level: )(\d+)/) {
  $mouse_remaining_percent = $1;
  $mouse_connected = 'Yes';  
}

my $batteryInfo = {
  activity => $activity,
  amps => $amps,
  capacity => $capacity,
  condition => $condition,
  cycles => $cycles,
  remaining => $remaining,
  remainingPercent => sprintf("%.2f", $remaining/$capacity * 100),
  volts => $volts,
  keyboard_remaining_percent => $keyboard_remaining_percent,
  keyboard_connected => $keyboard_connected,
  mouse_remaining_percent => $mouse_remaining_percent,
  mouse_connected => $mouse_connected,
};

my $json = JSON::XS->new->ascii->pretty->allow_nonref;
my $batteryInfoJSON = $json->encode($batteryInfo);

print $batteryInfoJSON;