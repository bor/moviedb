package App::moviedb::Star;

use 5.010;
use lib qw( lib );
use warnings;
use strict;

our $VERSION = 0.01;

use App::moviedb::DB;

sub new {
    my ( $class, $params ) = @_;
    $params->{dbh} ||= App::moviedb::DB->new();
    my $info =
      $params->{dbh}->selectrow_hashref(
        'SELECT star_id, name FROM star WHERE name = ?',
        undef, $params->{name}
      );
    return unless $info;
    my $self = bless $info, $class;
    $self->{dbh} = delete $params->{dbh};
    return $self;
}

1;

__END__

=head1 NAME

App::moviedb::Star

=head1 SYNOPSIS

    use App::moviedb::Star;
    my $movie = App::moviedb::Star->new({ name => $star_name, dbh => $dbh });
    say $movie->as_string();

=head1 DESCRIPTION

Simple implementation for star object.

=head1 SEE ALSO

App::moviedb

=head1 AUTHOR

Sergiy Borodych  C<< <bor@cpan.org> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2011, Sergiy Borodych C<< <bor@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.
