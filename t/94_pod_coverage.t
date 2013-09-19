#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

# Skip if doing a regular install
plan skip_all => "Author tests not required for installation"
    unless $ENV{AUTHOR_TESTING};

eval "use Test::Pod::Coverage 1.04";
plan skip_all => "Test::Pod::Coverage 1.04 required for testing POD coverage" if $@;

# TODO
plan skip_all => 'Now this test so bugged, see RT Bug #34594';

all_pod_coverage_ok();
