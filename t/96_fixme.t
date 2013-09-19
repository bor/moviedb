#!/usr/bin/env perl
# check code for FIXME/BUG/XXX/TODO labels

use strict;
use warnings;

use Test::More;

plan skip_all => "Author tests not required for installation"
  unless $ENV{AUTHOR_TESTING};

eval "use Test::Fixme ();";    ## no critic (BuiltinFunctions::ProhibitStringyEval)
plan skip_all => 'Test::Fixme required' if $@;

# test files in t/ and xt/ could have FIXME and other words, so not test it
Test::Fixme::run_tests(
    filename_match => qr/\/\w+\.?\w+$/,
    match          => qr/FIXME|\bBUG\b|XXX/,
    where          => [qw/ bin lib /],
);
