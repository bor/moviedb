#!/usr/bin/env perl
# check for spelling errors in POD

use strict;
use warnings;

use Test::More;

plan skip_all => "Author tests not required for installation"
  unless $ENV{AUTHOR_TESTING};

eval "use Test::Spelling 0.11;";    ## no critic (BuiltinFunctions::ProhibitStringyEval)
plan skip_all => 'Test::Spelling (>=0.11) required' if $@;

# set_spell_cmd('aspell -l en list');
Test::Spelling::add_stopwords(<DATA>);
Test::Spelling::all_pod_files_spelling_ok(qw( bin lib t ));

__DATA__
SQLite
Sergiy
Borodych
