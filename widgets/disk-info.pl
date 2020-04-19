#!/usr/bin/perl

use strict;
use warnings;

use JSON::XS;

# config: Edit `$disk_name` with the name of your preferred disk as it appears in the output of `df -l`
my $disk_name = '/dev/disk1s1';

my ($disk_size, $disk_available, $disk_used, $disk_used_percent) = (0, 0, 0, 0);

# get disk data in kilobyte-sized blocks
$_ = `df -lk`;

my $disk_name_regex = $disk_name . '\s+(\d+)';

if(/$disk_name_regex/) {
  $disk_size = $1;    
}

$disk_name_regex = $disk_name . '\s+\d+\s+\d+\s+(\d+)';

if(/$disk_name_regex/) {
  $disk_available = $1; 
}

$disk_used = $disk_size - $disk_available;
$disk_used_percent = sprintf("%.2f", $disk_used / $disk_size * 100);

$disk_used = maybe_reformat_kilobytes($disk_used);
$disk_available = maybe_reformat_kilobytes($disk_available);
$disk_size = maybe_reformat_kilobytes($disk_size);

my $disk_info = {
	disk_name => $disk_name,
	disk_used => $disk_used,
	disk_size => $disk_size,
	disk_available => $disk_available,
	disk_used_percent => $disk_used_percent,
};

my $json = JSON::XS->new->ascii->pretty->allow_nonref;
my $disk_info_json = $json->encode($disk_info);

print $disk_info_json;

sub maybe_reformat_kilobytes {
	my ($kilobytes) = @_;

    if ($kilobytes > 1073741824)  #   GB: 1024 MB
    {
        return sprintf("%.2f TB", $kilobytes / 1073741824);
    }
    elsif ($kilobytes > 1048576)     #   MB: 1024 KB
    {
        return sprintf("%.2f GB", $kilobytes / 1048576);
    }
    elsif ($kilobytes > 1024)        #   KB: 1024 B
    {
        return sprintf("%.2f MB", $kilobytes / 1024);
    }
    else                        #   bytes
    {
        return "$kilobytes KB";
    }
}