#!/usr/bin/env perl

use lib 'lib';
use strict;
use warnings;

use App::moviedb;
use Test::More;

eval "use DBD::SQLite;";    ## no critic (BuiltinFunctions::ProhibitStringyEval)
plan skip_all => 'DBD::SQLite required to run these tests' if $@;

use_ok('App::moviedb');
use_ok('App::moviedb::DB');

# init dbh singleton here
my $app = App::moviedb->new( { conf_file => 't/test.conf' } );
isa_ok( $app, 'App::moviedb' );

# init test DB
my $db = eval { App::moviedb::DB->new()->init_db(); };
ok( !$@, 'init test DB' );
isa_ok( $db, 'App::moviedb::DB' );

# tests

my $class = 'App::moviedb::Command';
use_ok($class);

my $obj = $class->new();
isa_ok( $obj, $class );

my @methods = map { 'act_' . $_ } qw( add del display find find_by_star import list list_by_year );
can_ok( $obj, @methods );

## list, empty
my $result = $obj->act_list();
is( $result, 'None found', 'empty list' );

## import
$result = eval { $obj->act_import( { file_in => 't/test_movies.txt' } ); };
ok( !$@, 'import from file, no error' );
like( $result, qr/Import \d+ movies done/, 'import from file, check result' );

## list
$result = $obj->act_list();
like( $result, qr/^\nID:/, 'list()' );

## list_by_year
$result = $obj->act_list_by_year();
like( $result, qr/^\nID:/, 'list_by_year()' );

done_testing();
