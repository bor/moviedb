package App::moviedb::DB;

use 5.010;
use lib qw( lib );
use warnings;
use strict;

our $VERSION = 0.01;

use DBI;
use DBD::SQLite;

my $db;

sub new {
    my ( $class, $conf ) = @_;
    unless ( $db ) {
        die "Need db driver setup\n" unless $conf->{driver};
        my $self = bless {}, $class;
        $self->{dbh} = DBI->connect(
            'DBI:' . $conf->{driver}
              . ':dbname='
              . ( $conf->{dir} ? "$conf->{dir}/" : '' )
              . $conf->{name}
              . ( $conf->{host} ? ';host=' . $conf->{host} : '' ),
            $conf->{user}, $conf->{password},
            { RaiseError => 1 }
        ) or die "Can't connect to database\nError: $DBI::errstr\n";
        $db = $self;
    }
    return $db;
}

sub dbh {
    my $self = shift;
    return $self->{dbh};
}

# add movies & stars to DB
# return: hashref of araryrefs { star_name => [movie_id,...] }
sub add_movies {
    my ( $self, $movies ) = @_;
    my %stars;
    my $sth = $self->{dbh}->prepare('INSERT INTO movie (title, year, format) VALUES (?,?,?)');
    foreach my $movie (@$movies) {
        $sth->execute( @$movie{qw(title year format)} );
        my $movie_id = $self->{dbh}->last_insert_id( undef, undef, 'movie', 'movie_id' );
        push @{ $stars{$_} }, $movie_id foreach @{ $movie->{stars} };
    }
    $sth->finish();

    # add stars & movie_stars to DB
    $sth = $self->{dbh}->prepare('INSERT INTO star (name) VALUES (?)');
    my $sth_ms = $self->{dbh}->prepare('INSERT INTO movie_star (movie_id, star_id) VALUES (?,?)');
    foreach my $name ( keys %stars ) {
        $sth->execute($name);
        my $star_id = $self->{dbh}->last_insert_id( undef, undef, 'star', 'star_id' );
        foreach my $movie_id (@{$stars{$name}}) {
            $sth_ms->execute($movie_id,$star_id);
        }
    }
    $sth->finish();
    $sth_ms->finish();
    return 1;
}

# return: 
sub get_movies {
    my ( $self, $params ) = @_;
    my $query = q/
        SELECT DISTINCT movie.movie_id, movie.title
        FROM movie
        JOIN movie_star USING (movie_id)
        JOIN star USING (star_id)
        WHERE 1
    /;
    my @binds;
    foreach ( keys %{ $params->{where} } ) {
        $query .= " AND $_ LIKE ?";
        push @binds, "%$params->{where}{$_}%";
    }
    return $self->{dbh}->selectall_arrayref(
        $query, { Slice => {} }, @binds
    );
}

sub get_movie_list {
    my ( $self, $params ) = @_;
    my $query = 'SELECT movie_id, title FROM movie';
    $query .= " ORDER BY $params->{order_by}" if $params->{order_by};
    return $self->{dbh}->selectall_arrayref( $query, { Slice => {} } );
}

sub get_star {
    my ( $self, $name ) = @_;
    my $star = $self->{dbh}->selectrow_hashref(
        'SELECT star_id, name FROM star WHERE name = ?',
        undef, $name
    );
    return $star;
}

# create db file and connect to it
# return: dbh
sub init_db {
    my $self = shift;
	# TODO
	die "Not implemented yet!\n";
    #my $schema_file = $self->{_conf_dir} . '/moviedb.schema.sql';
    #return $self;
}

1;

__END__

=head1 NAME

App::moviedb::DB

=head1 SYNOPSIS

    use App::moviedb::DB;
    my $dbh = App::moviedb::DB->new();

=head1 DESCRIPTION

This class create dbh singleton.

=head1 AUTHOR

Sergiy Borodych  C<< <bor@cpan.org> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2011, Sergiy Borodych C<< <bor@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.
