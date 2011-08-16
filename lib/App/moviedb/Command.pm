package App::moviedb::Command;

use 5.010;
use lib qw( lib );
use warnings;
use strict;

our $VERSION = 0.01;

use IO::Prompt;

use App::moviedb::DB;
use App::moviedb::Movie;
use App::moviedb::Movies;

sub new {
    my ( $class, $params ) = @_;
    $params //= {};
    my $self = bless $params, $class;
    $self->{db} ||= App::moviedb::DB->new();
    return $self;
}

# actions methods
#   with 'act_' prefix

# add movie to DB
sub act_add {
    my $self = shift;
    my %info;
    foreach my $field (qw( title year format stars )) {
        prompt(
            "$App::moviedb::Movie::fields{$field}{title}: ",
            -require => {
                "(bad value)\n$App::moviedb::Movie::fields{$field}{title}: " =>
                  $App::moviedb::Movie::fields{$field}{re}
            }
        );
        $info{$field} = $_;
    }
    my $movie = App::moviedb::Movie->add( \%info );
    return $movie ? 'Added successfully' : 'Cant add: something wrong';
}

# delete movie from DB
sub act_del {
    my $self = shift;
    prompt( 'ID: ', '-integer' );
    my $result = App::moviedb::Movie::del({ movie_id => $_ });
    return $result ? 'Deleted successfully' : 'Cant delete: something wrong';
}

# display movie (show properties)
sub act_display {
    my $self = shift;
    prompt( 'ID: ', '-integer' );
    my $movie = App::moviedb::Movie->new({ movie_id => $_ });
    return $movie ? $movie->as_string() : 'None found';
}

# find movies by title
sub act_find {
    my $self = shift;
    while ( ! prompt( 'Title: ', -while => $App::moviedb::Movie::fields{title}{re} ) ) {
        say 'Bad value';
    }
    my $movies = $self->{db}->get_movies({ where => { 'movie.title' => $_ } });
    return App::moviedb::Movies->new($movies)->as_string() || 'None found';
}

# find movies by star
sub act_find_by_star {
    my $self = shift;
    while ( ! prompt( 'Star: ', -while => $App::moviedb::Movie::fields{stars}{re} ) ) {
        say 'Bad value';
    }
    my $movies = $self->{db}->get_movies({ where => { 'star.name' => $_ } });
    return App::moviedb::Movies->new($movies)->as_string() || 'None found';
}

# import movies from text file and add to DB
sub act_import {
    my ( $self, $params ) = @_;
    die "Need input file\n" unless $params->{file_in};
    # import movies from text file
    my $movies = $self->_import_txt_file($params->{file_in});
    # add movies to DB
    $self->{db}->add_movies($movies);
    return 'Import '. scalar(@$movies) .' movies done';
}

# list movies by title
sub act_list {
    my $self = shift;
    my $movies = $self->{db}->get_movie_list({ order_by => 'title' });
    return App::moviedb::Movies->new($movies)->as_string() || 'None found';
}

# list movies by year
sub act_list_by_year {
    my $self = shift;
    my $movies = $self->{db}->get_movie_list({ order_by => 'year' });
    return App::moviedb::Movies->new($movies)->as_string() || 'None found';
}

#
# private methods
#

# import movies from text file
# return: arrayref of hashrefs with movie's info
# TODO : create App::moviedb::Import(::Text)
sub _import_txt_file {
    my ( $self, $filename ) = @_;
    use autodie qw( :file );
    # parse file
    my @movies;
    my %fields = (
        'Title'        => 'title',
        'Release Year' => 'year',
        'Format'       => 'format',
        'Stars'        => 'stars',
    );
    my $field_re = qr/[\w\s\-:,]+/;
    open( my $fh, '<', $filename );
    while (<$fh>) {
        chomp();
        next unless $_;
        my $movie;
        if (/^Title:\s*($field_re)$/) {
            $movie->{title} = $1;
            foreach my $field ( ( 'Release Year', 'Format', 'Stars' ) ) {
                my $_ = <$fh>;
                chomp();
                if (/^$field:\s*($field_re)$/) {
                    $movie->{ $fields{$field} } = $1;
                }
                else {
                    die "Bad file format. Expect '$field:' in '$_'\n";
                }
            }
            $movie->{stars} = [ split( /,\s*/, $movie->{stars} ) ];
            push @movies, $movie;
        }
        else {
            die "Bad file format. Expect 'Title:' in '$_'\n";
        }
    }
    close($fh);
    return \@movies;
}

1;

__END__

=head1 NAME

App::moviedb::Command

=head1 SYNOPSIS

	# using inside App::moviedb
    use App::moviedb::Command;
    my $command = App::moviedb::Command->new();
	my $command_method = 'add';
    $command->$command_method(@ARGV) if $command->can($command_method);

=head1 DESCRIPTION

Collection of command/action methods for App::moviedb.

=head1 SEE ALSO

App::moviedb

=head1 AUTHOR

Sergiy Borodych  C<< <bor@cpan.org> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2011, Sergiy Borodych C<< <bor@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.
