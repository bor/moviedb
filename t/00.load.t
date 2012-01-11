#!perl

use lib 'lib';
use strict;
use warnings;

use Test::More tests => 1;

BEGIN {
    use_ok('App::moviedb');
}

diag("Testing App::moviedb $App::moviedb::VERSION");
