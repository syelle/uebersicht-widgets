#!/usr/bin/perl

use strict;
use warnings;

use JSON::XS;

# config
my $number_of_logical_cpus = 12;

my ($total_cpu_load) = (0.0);
my (%all_processes, %top_processes);

$_ = `ps -creo "command=, %cpu="`;

open my $process_list, '<', \$_;

while (my $line = <$process_list>) { 
	my ($process_name, $process_cpu_used) = $line =~ /(.{16})\s*(\d+.\d+)/;

	if(exists($all_processes{$process_name})) {
		$all_processes{$process_name} += $process_cpu_used;
	} else {
		$all_processes{$process_name} = $process_cpu_used;
	}

	$total_cpu_load += $process_cpu_used;
}

$top_processes{'total_cpu_load'} = sprintf("%.2f", $total_cpu_load) + 0;
$top_processes{'cpu_cores'} = $number_of_logical_cpus;
$top_processes{'total_cpu_capacity'} = 100 * $number_of_logical_cpus;
$top_processes{'total_cpu_load_as_percent_of_total_cpu_capacity'} = sprintf("%.2f", $total_cpu_load / $number_of_logical_cpus) + 0;

my $top_10_counter = 0;

foreach my $key (sort { $all_processes{$b} <=> $all_processes{$a} } keys %all_processes) {
	if($top_10_counter < 10) {
		#$top_processes{'process'}{$key} = $all_processes{$key};
		my $this_process_cpu_load = $all_processes{$key};

		if($this_process_cpu_load > 0) {
			push (@{$top_processes{'processes'}}, {
				name=>$key, 
				cpu_load => sprintf("%.2f", $this_process_cpu_load) + 0,
				percent_of_total_cpu_capacity => sprintf("%.2f", $this_process_cpu_load / $number_of_logical_cpus) + 0,
			});
			$top_10_counter++;
		} else {
			last;
		}
	} else {
		last;
	}
}

my $json = JSON::XS->new->utf8->pretty->allow_nonref;
my $cpu_info_JSON = $json->encode(\%top_processes);

print $cpu_info_JSON;