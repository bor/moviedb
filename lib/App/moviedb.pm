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
    my $class = shift;
    my $self = bless {}, $class;
	# be sure to load config first
    try { $self->conf() } catch { die "ERROR: $_\n" };
    $self->{_dbh} = try { App::moviedb::DB->new( $self->conf('db') ); }
    				catch { die "ERROR: $_\n" };
    return $self;
}

sub run {
    my $self = shift;

    # process args
    GetOptions(
        'action|a=s' => \$self->{opt}{act},
        'config|c=s' => \$self->{opt}{conf_file},
        'file|f=s'   => \$self->{opt}{file_in},
    ) or die $self->usage();
    $self->{opt}{act} ||= 'help';
    die $self->usage() if $self->{opt}{act} eq 'help';

    # call command
    my $command = App::moviedb::Command->new();
    my $method = 'act_' . delete $self->{opt}{act};
    if ( $command->can($method) ) {
        my $result =
          try { $command->$method( $self->{opt} ); }
          catch { die "ERROR: $_\n" . $self->usage(); };
        say $result if $result;
    }
	else {
		die "ERROR: Bad action name\n" . $self->usage();
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
    	      or die "Cant load config file $conf_file: " . Config::Tiny->errstr;
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

=for author to fill in:
    Write a full description of the module and its features here.
    Use subsections (=head2, =head3) as appropriate.

=head1 CONFIGURATION AND ENVIRONMENT

=for author to fill in:
    A full explanation of any configuration system(s) used by the
    module, including the names and locations of any configuration
    files, and the meaning of any environment variables or properties
    that can be set. These descriptions must also include details of any
    configuration language used.
  
App::moviedb requires no configuration files or environment variables.

=head1 DEPENDENCIES

=for author to fill in:
    A list of all the other modules that this module relies upon,
    including any restrictions on versions, and an indication whether
    the module is part of the standard Perl distribution, part of the
    module's distribution, or must be installed separately. ]

None.

=head1 AUTHOR

Sergiy Borodych  C<< <bor@cpan.org> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2011, Sergiy Borodych C<< <bor@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.
