#!/usr/bin/env perl
# check for test code coverage

use strict;
use warnings;

use File::Glob ':glob';
use Test::More;

plan skip_all => "Author tests not required for installation"
  unless $ENV{AUTHOR_TESTING};

eval "use Test::Strict ();";    ## no critic (BuiltinFunctions::ProhibitStringyEval)
plan skip_all => 'Test::Strict required' if $@;

# tweak this to change coverage acceptance level
my $coverage_threshold = 60;    # 90? / 100??? :)

{
    no warnings 'once';         ## no critic (TestingAndDebugging::ProhibitNoWarnings)
    $Test::Strict::TEST_SKIP = [ glob('t/9?_*.t') ];    # skip some dev. & integration tests
}
$Test::Strict::DEVEL_COVER_OPTIONS .= ',+inc,"t/\b"';    # ignore 't/' dir
$Test::Strict::DEVEL_COVER_OPTIONS .= ',-silent,1';      # shut up warnings from Devel::Cover

Test::Strict::all_cover_ok( $coverage_threshold, 't' );
