#!/usr/bin/env perl

use lib 'lib';
use strict;
use warnings;

use Test::More tests => 1;

BEGIN {
    use_ok('App::moviedb');
}

note 'Testing App::moviedb ' . App::moviedb->VERSION() . ", Perl $], $^X";
