#!/usr/bin/perl

use strict;
use warnings;

use JSON::XS;

my %config = do './config/circle-ci.config';

my $circleci_api_token = $config{circleci_api_token};
my $vcs_service = $config{vcs_service};
my $org_name = $config{org_name};
my $workflows_to_fetch = $config{workflows_to_fetch};

my $max_workflow_executions_to_show = 10;

my @workflow_results;

foreach (@$workflows_to_fetch) {
	my $workflow_to_fetch = $_;

	my $repo_name = $workflow_to_fetch->{'repo_name'};
	my $workflow_name = $workflow_to_fetch->{'workflow_name'};
	my $branch_name = $workflow_to_fetch->{'branch_name'};

	my $workflow_results_json = `curl -sS -H 'Accept: application/json' 'https://circleci.com/api/v2/insights/$vcs_service/$org_name/$repo_name/workflows/$workflow_name?branch=$branch_name&circle-token=$circleci_api_token&limit=$max_workflow_executions_to_show'`;

	my $workflow_result_hash_ref = JSON::XS->new->utf8->decode($workflow_results_json);

	my $lastest_workflow_result = $workflow_result_hash_ref->{'items'}[0];

	$lastest_workflow_result->{'repo_name'} = $repo_name;
	$lastest_workflow_result->{'workflow_name'} = $workflow_name;
	$lastest_workflow_result->{'branch_name'} = $branch_name;

	push @workflow_results, $lastest_workflow_result;
}

my $json = JSON::XS->new->utf8->pretty->allow_nonref;
my $workflow_info_JSON = $json->encode(\@workflow_results);

print $workflow_info_JSON;