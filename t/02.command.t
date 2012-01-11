#!perl

use lib 'lib';
use strict;
use warnings;

use App::moviedb;

use Test::More;

eval { require DBD::SQLite; };    ## no critic (ErrorHandling::RequireCheckingReturnValueOfEval)
if ($@) {
    plan skip_all => 'DBD::SQLite required to run these tests';
}

use_ok('App::moviedb::DB');

my $class = 'App::moviedb::Command';
use_ok($class);

# init dbh singleton here
my $app = App::moviedb->new( { conf_file => 't/test.conf' } );

# init test DB
eval { App::moviedb::DB->new()->init_db(); };    ## no critic (ErrorHandling::RequireCheckingReturnValueOfEval)
ok( !$@, 'init test DB' );

my $obj = $class->new();
isa_ok( $obj, $class );

my @methods = map { 'act_' . $_ } qw( add del display find find_by_star import list list_by_year );
can_ok( $obj, @methods );

# empty list
my $result = $obj->act_list();
ok( $result eq 'None found', 'empty list' );

# import
$result = eval { $obj->act_import( { file_in => 't/test_movies.txt' } ); };
ok( !$@ && $result, 'import from file: ' . ( $result || 'error: ' . $@ ) );

# list
$result = $obj->act_list();
like( $result, qr/^\nID:/, 'list' );

done_testing();
