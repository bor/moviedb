#!/usr/bin/env perl
# check the correct line endings

use strict;
use warnings;

use Test::More;

plan skip_all => "Author tests not required for installation"
  unless $ENV{AUTHOR_TESTING};

eval "use Test::EOL ();";    ## no critic (BuiltinFunctions::ProhibitStringyEval)
plan skip_all => 'Test::EOL required' if $@;

Test::EOL::all_perl_files_ok( { trailing_whitespace => 1 }, qw( bin lib t ) );
