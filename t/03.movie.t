#!perl

use lib qw( lib );
use strict;
use warnings;

use Test::More tests => 1;

my $class = 'App::moviedb::Movie';
use_ok($class);

# TODO
#my $obj = $class->new();
#isa_ok( $obj, $class );

#my $obj = $class->add({});

#can_ok( $obj, qw( add del as_string stars ) );

