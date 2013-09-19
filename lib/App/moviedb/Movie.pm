package App::moviedb::Movie;

use 5.010;
use lib qw( lib );
use warnings;
use strict;

our $VERSION = 0.01;
our @EXPORT_OK = qw( %fields %field_titles );

use App::moviedb::DB;
use App::moviedb::Star;

our %fields = (
    # re - is like 'require' flag for IO::Prompt
    title  => { title => 'Title',        re => qr/^[\w\s\-:,]{1,255}$/ },
    year   => { title => 'Release Year', re => qr/^\d{4}$/ },
    format => { title => 'Format',       re => [qw( VHS DVD Blu-Ray )] },
    stars  => { title => 'Stars',        re => qr/^(?:[\w\s]+,?)+$/ },
);
our %field_titles = ( map { $fields{$_} => $_ } keys %fields );

sub new {
    my ( $class, $params ) = @_;
    die "Require movie id\n" unless $params->{movie_id};
    $params->{dbh} ||= App::moviedb::DB->new()->dbh();
    my $movie_info =
      $params->{dbh}->selectrow_hashref(
        'SELECT movie_id, title, year, format FROM movie WHERE movie_id = ?',
        undef, $params->{movie_id}
      );
    return unless $movie_info;
    my $self = bless $movie_info, $class;
    $self->{dbh} = delete $params->{dbh};
    return $self;
}

# TODO : move all DB related stuff to ::DB module
# add movie to DB, class method
# return: self (movie object)
sub add {
    my ( $class, $params ) = @_;
    my $self = bless $params, $class;
    $self->{dbh} ||= App::moviedb::DB->new()->dbh();
    # TODO : check if movie (title&year) already in DB
    # add movie info to DB
    $self->{dbh}->do(
        'INSERT INTO movie (title, year, format) VALUES (?,?,?)',
        undef, @{$self}{qw(title year format)}
    );
    $self->{movie_id} = $self->{dbh}->last_insert_id( undef, undef, 'movie', 'movie_id' );
    # add stars & movie_stars to DB
    my $sth = $self->{dbh}->prepare('INSERT INTO star (name) VALUES (?)');
    my $sth_ms = $self->{dbh}->prepare('INSERT INTO movie_star (movie_id, star_id) VALUES (?,?)');
    foreach my $name ( split(/,\s*/,$params->{stars}) ) {
        # check if already star exists
        my $star = App::moviedb::Star->new({ name => $name });
        unless ( $star ) {
            $sth->execute($name);
            $star->{id} = $self->{dbh}->last_insert_id( undef, undef, 'star', 'star_id' );
        }
        $sth_ms->execute($self->{movie_id},$star->{star_id});
    }
    $sth->finish();
    $sth_ms->finish();
    return $self;
}


# return: string with movie details
sub as_string {
    my $self = shift;
    my $stars = join( ', ', @{ $self->stars() } );
    return <<"MOVIE_INFO";

ID:     $self->{movie_id}
Title:  $self->{title}
Year:   $self->{year}
Format: $self->{format}
Stars:  $stars
MOVIE_INFO
}

# return: arrayref with star's names
sub stars {
    my $self = shift;
    unless ($self->{_stars}) {
        $self->{_stars} = $self->{dbh}->selectcol_arrayref(
            q/  SELECT star.name
                FROM star
                JOIN movie_star USING (star_id)
                WHERE movie_id = ?
            /,
            undef, $self->{movie_id}
        );
    }
    return $self->{_stars};
}

1;

__END__

=head1 NAME

App::moviedb::Movie

=head1 SYNOPSIS

    use App::moviedb::Movie;
    my $movie = App::moviedb::Movie->new({ id => $movie_id });
    say $movie->as_string();

=head1 DESCRIPTION

Simple implementation for movie object.

=head1 SEE ALSO

App::moviedb

=head1 AUTHOR

Sergiy Borodych  C<< <bor@cpan.org> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2011-2013, Sergiy Borodych C<< <bor@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.
