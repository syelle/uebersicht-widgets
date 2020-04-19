#!/usr/bin/perl

use strict;
use warnings;

use JSON::XS;

# config
my $system_memory_in_gb = 16;

$_ = `ps -cmeo "command=, rss="`;

my ($total_memory_used) = (0);
my (%all_processes, %top_processes);

open my $process_list, '<', \$_;

while (my $line = <$process_list>) { 
	my ($process_name, $process_memory_used) = $line =~ /(.{16})\s*(\d+)/;

	if(exists($all_processes{$process_name})) {
		$all_processes{$process_name} += $process_memory_used;
	} else {
		$all_processes{$process_name} = ($process_memory_used + 0);
	}

	$total_memory_used += $process_memory_used;
}

$top_processes{'total_memory_used'} = maybe_reformat_kilobytes($total_memory_used);
$top_processes{'percent_of_total_memory_used'} = sprintf("%.2f", ($total_memory_used * 1024) / ($system_memory_in_gb * 1073741824) * 100) + 0;

my $top_10_counter = 0;

foreach my $key (sort { $all_processes{$b} <=> $all_processes{$a} } keys %all_processes) {

	my $this_process_memory_use = $all_processes{$key};

	if($top_10_counter < 10) {
		push (@{$top_processes{'processes'}}, {
			name=>$key, 
			memory_used=>maybe_reformat_kilobytes($this_process_memory_use),
			percent_memory_used=>sprintf("%.2f", ($this_process_memory_use * 1024) / ($system_memory_in_gb * 1073741824) * 100) + 0,
		});
		$top_10_counter++;
	} else {
		last;
	}
}

my $json = JSON::XS->new->ascii->pretty->allow_nonref;
my $memory_info_JSON = $json->encode(\%top_processes);

print $memory_info_JSON;

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