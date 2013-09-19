#!/usr/bin/env perl
# check syntax, presence of use strict & warnings

use strict;
use warnings;

use Test::More;

plan skip_all => "Author tests not required for installation"
  unless $ENV{AUTHOR_TESTING};

eval "use Test::Strict ();";    ## no critic (BuiltinFunctions::ProhibitStringyEval)
plan skip_all => 'Test::Strict required' if $@;

{
    no warnings 'once';         ## no critic (TestingAndDebugging::ProhibitNoWarnings)
    $Test::Strict::TEST_WARNINGS = 1;
}

Test::Strict::all_perl_files_ok(qw( bin lib t ));
