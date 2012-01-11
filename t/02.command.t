#!perl

use lib qw( lib );
use strict;
use warnings;

use App::moviedb;

use Test::More;

eval { require DBD::SQLite; };    ## no critic (ErrorHandling::RequireCheckingReturnValueOfEval)
if ($@) {
    plan skip_all => 'DBD::SQLite required to run these tests';
}

my $class = 'App::moviedb::Command';
use_ok($class);

# init dbh singleton here
my $app = App::moviedb->new( { conf_file => 't/test.conf' } );

# init test DB
open( my $fh, '<', 'conf/moviedb.schema.sql' ) or die "Cant open sql schema file: $!\n";
my $sql = do { local $/; <$fh> };
close($fh);
App::moviedb::DB->new()->dbh()->do($_) foreach split( ';', $sql );    # simple sql split by ';'

my $obj = $class->new();
isa_ok( $obj, $class );

my @methods = map { 'act_' . $_ } qw( add del display find find_by_star import list list_by_year );
can_ok( $obj, @methods );

# empty list
my $result = $obj->act_list();
ok( $result eq 'None found', 'empty list');

# import
$result = eval { $obj->act_import( { file_in => 't/test_movies.txt' } ); };
ok( !$@ && $result, 'import from file: ' . ( $result || 'error: ' . $@ ) );

# list
$result = $obj->act_list();
like($result, qr/^\nID:/, 'list');

done_testing();
