#!/usr/bin/env perl

use Test::More;

# Skip if doing a regular install
plan skip_all => "Author tests not required for installation"
    unless $ENV{AUTHOR_TESTING};

eval "use Test::Pod 1.14";
plan skip_all => "Test::Pod 1.14 required for testing POD" if $@;

all_pod_files_ok();
