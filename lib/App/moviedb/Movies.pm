package App::moviedb::Movies;

use lib qw( lib );
use warnings;
use strict;

our $VERSION = 0.01;

# input: expect arrayref as $params
sub new {
    my ( $class, $params ) = @_;
    my $self = bless $params, $class;
    return $self;
}

# return: string with movie's info
sub as_string {
    my $self = shift;
    my $result;
    foreach my $movie ( @{ $self } ) {
        $result .= "ID: $movie->{movie_id}\tTitle: $movie->{title}\n";
    }
    $result = "\n" . $result if $result;
    return $result;
}

1;

__END__

=head1 NAME

App::moviedb::Movies

=head1 SYNOPSIS

    use App::moviedb::Movies;
    my $movies = App::moviedb::Movies->new(\@movies);
    say $movies->as_string();

=head1 DESCRIPTION

Simple implementation for display result for collection of movies.

=head1 SEE ALSO

App::moviedb

=head1 AUTHOR

Sergiy Borodych  C<< <bor@cpan.org> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2011, Sergiy Borodych C<< <bor@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.
