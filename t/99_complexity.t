#!/usr/bin/env perl
# test sources for cyclomatic (mccabe) complexity
#   see also https://en.wikipedia.org/wiki/Cyclomatic_complexity

use strict;
use warnings;

use Test::More;

plan skip_all => "Author tests not required for installation"
  unless $ENV{AUTHOR_TESTING};

eval "use Test::Perl::Metrics::Lite ();";    ## no critic (BuiltinFunctions::ProhibitStringyEval)
plan skip_all => 'Test::Perl::Metrics::Lite required' if $@;

Test::Perl::Metrics::Lite->import(
    -mccabe_complexity => 10,                # default 10
    -loc               => 50,                # default 60
);

Test::Perl::Metrics::Lite::all_metrics_ok(qw( bin lib t ));
