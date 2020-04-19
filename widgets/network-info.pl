#!/usr/bin/perl

use strict;
use warnings;

use JSON::XS;

my $ipRegex = qr"\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b";
my $macRegex = qr"[a-fA-F0-9:]{17}|[a-fA-F0-9]{12}$";

my ($ethernetService, $ethernetIP, $ethernetMAC, $wifiIP, $wifiMAC) = ("Ethernet", "Disconnected", "", "Disconnected", "");

# config: Run `networksetup -listallnetworkservices` to find the name of your Ethernet network adapter
# $ethernetService = "Ethernet";
# $ethernetService = "Display Ethernet";
# $ethernetService = "Thunderbolt Ethernet";
$ethernetService = "USB 10/100/1000 LAN";

$_ = `networksetup -getinfo "$ethernetService"`;

if(/IP\s+address:\s+($ipRegex)/) {
	$ethernetIP = $1; 
}

if(/Ethernet\s+Address:\s+($macRegex)/) {
	$ethernetMAC = $1; 
}

$_ = `networksetup -getinfo wi-fi`;

if(/IP\s+address:\s+($ipRegex)/) {
	$wifiIP = $1; 
}

if(/Wi\-Fi\s+ID:\s+($macRegex)/) {
	$wifiMAC = $1; 
}

my $networkInfo = {
	services => {
		ethernet => {
			name => "Ethernet",
			ip => $ethernetIP,
			mac => $ethernetMAC,
		},
		wifi => {
			name => "Wi-Fi",
			ip => $wifiIP,
			mac => $wifiMAC,
		},
	}
};

my $json = JSON::XS->new->ascii->pretty->allow_nonref;
my $networkInfoJSON = $json->encode($networkInfo);

print $networkInfoJSON;