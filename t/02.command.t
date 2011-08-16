#!perl

use lib qw( lib );
use strict;
use warnings;

use App::moviedb;

use Test::More tests => 3;

my $class = 'App::moviedb::Command';
use_ok($class);

# init dbh singleton here
my $app = App::moviedb->new();

my $obj = $class->new();
isa_ok( $obj, $class );

my @methods = map { 'act_'.$_ } qw( add del display find find_by_star import list list_by_year );
can_ok( $obj, @methods );

