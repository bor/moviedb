#!perl

use lib qw( lib );
use strict;
use warnings;

use App::moviedb;

use Test::More tests => 3;

eval { require DBD::SQLite; };
if ($@) {
    plan skip_all => 'DBD::SQLite required to run these tests';
}

my $class = 'App::moviedb::Command';
use_ok($class);

# TODO init test db
# sqlite3 $test_db < conf/moviedb.schema.sql

# init dbh singleton here
my $app = App::moviedb->new( { conf_file => 't/test.conf' } );

my $obj = $class->new();
isa_ok( $obj, $class );

my @methods = map { 'act_' . $_ } qw( add del display find find_by_star import list list_by_year );
can_ok( $obj, @methods );

