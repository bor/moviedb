package App::moviedb::Movies;

use lib 'lib';
use warnings;
use strict;

our $VERSION = 0.002;

# input: expect $list as arrayref of hashrefs
sub new {
    my ( $class, $list ) = @_;
    my $self = bless $list, $class;
    return $self;
}

# return: string with movie's info
sub as_string {
    my $self = shift;
    my $result;
    foreach my $movie ( @{$self} ) {
        $result .= "ID: $movie->{movie_id}\tTitle: $movie->{title}\n";
    }
    $result = "\n" . $result if $result;
    return $result;
}

1;

__END__

=for stopwords hashrefs

=head1 NAME

App::moviedb::Movies

=head1 SYNOPSIS

    use App::moviedb::Movies;
    my $movies = App::moviedb::Movies->new(\@movies);
    say $movies->as_string();

=head1 DESCRIPTION

Simple implementation for display result for collection of movies.

=head1 METHODS

=head2 new($list)

Create a object.
Expect C<$list> as arrayref of hashrefs.

=head2 as_string()

Return movies list as string (multiple line).

=head1 SEE ALSO

L<App::moviedb>, L<App::moviedb::Movie>

=head1 AUTHOR

Sergiy Borodych  C<< <bor@cpan.org> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2011-2013, Sergiy Borodych C<< <bor@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.
