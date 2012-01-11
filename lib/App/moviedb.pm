package App::moviedb;

use 5.010;
use lib qw( lib );
use warnings;
use strict;

our $VERSION = 0.01;

use Carp;
use Config::Tiny;
use DBI;
use DBD::SQLite;
use FindBin;
use Getopt::Long;
use Try::Tiny;

use App::moviedb::Command;

sub new {
    my ( $class, $params ) = @_;
    my $self = bless {}, $class;
    $self->{opt} = $params;
    # be sure to load config first
    try { $self->conf() } catch { die "ERROR: $_\n" };
    $self->{_dbh} = try { App::moviedb::DB->new( $self->conf('db') ); } catch { die "ERROR: $_\n" };
    return $self;
}

sub run {
    my $self = shift;

    # process args
    GetOptions(
        'action|a=s' => \$self->{opt}{act},
        'config|c=s' => \$self->{opt}{conf_file},
        'file|f=s'   => \$self->{opt}{file_in},
        'help|h'     => \$self->{opt}{help},
    ) or die $self->usage() . "\n";
    die $self->usage() . "\n" if $self->{opt}{help};
    die die "ERROR: Require some args\n" . $self->usage() . "\n"
      unless $self->{opt}{act};

    # call command
    my $command = App::moviedb::Command->new();
    my $method  = 'act_' . delete $self->{opt}{act};
    if ( $command->can($method) ) {
        my $result = try { $command->$method( $self->{opt} ); } catch { die "ERROR: $_\n" . $self->usage() . "\n"; };
        say $result if $result;
    }
    else {
        die "ERROR: Bad action name\n" . $self->usage() . "\n";
    }
    return 1;
}

sub usage {
    return <<"USAGE";
Usage:
 $0 [-c path/to/config ] -a action_name [-f filename]
    -a      - do this action_name (some actions need additional params)
    -c      - using alternative config, default: conf/moviedb.conf
    -f      - use this file (for import ex.)
    -h      - show this screen
  where action_name:
    add             - add movie
    del             - delete movie
    display         - display movie (show properties)
    find            - find movies by title
    find_by_star    - find movies by star
    import          - import movies from text file
    list            - list movies by title
    list_by_year    - list movies by year
USAGE
}

# return: all config hashref or some part of config
sub conf {
    my ( $self, $what ) = @_;
    # load config if need
    unless ( $self->{_conf} ) {
        $self->{_conf_dir} ||= "$FindBin::Bin/../conf";
        my $conf_file = $self->{opt}{conf_file}
          || $self->{_conf_dir} . '/moviedb.conf';
        if ( -e $conf_file ) {
            $self->{_conf} = Config::Tiny->read($conf_file)
              or die "Cant load config file $conf_file: " . Config::Tiny->errstr . "\n";
        }
        else {
            die "Cant find config file $conf_file\n";
        }
    }
    return $what ? $self->{_conf}{$what} : $self->{_conf};
}

1;

__END__

=head1 NAME

App::moviedb - simple movie database

=head1 SYNOPSIS

    use App::moviedb;
    my $app = App::moviedb->new();
    $app->run();

=head1 DESCRIPTION

This simple app that implement a storage system for movies.
The interface is command line.
Movie information stored persistently in database(like SQLite, MySQL, etc).

=head1 CONFIGURATION AND ENVIRONMENT

App::moviedb requires configuration file for working.
Usually it placed in conf/moviedb.conf.

=head1 DEPENDENCIES

perl v5.10+,
Config::Tiny,
DBI,
DBD::SQLite / maybe another in future,
IO::Prompt,
Try::Tiny

=head1 AUTHOR

Sergiy Borodych  C<< <bor@cpan.org> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2011, Sergiy Borodych C<< <bor@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.
