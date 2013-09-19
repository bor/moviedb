
use 5.010;
use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME            => 'App::moviedb',
    AUTHOR          => 'Sergiy Borodych <bor@cpan.org>',
    VERSION_FROM    => 'lib/App/moviedb.pm',
    ABSTRACT_FROM   => 'lib/App/moviedb.pm',
    EXE_FILES       => [ 'bin/moviedb' ],
    PREREQ_PM       => {
        'Config::Tiny'  => 0,
        'DBI'           => 0,
        'DBD::SQLite'   => 0,
        'IO::Prompt'    => 0,
        'Try::Tiny'     => 0,
    },
    dist            => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean           => { FILES => 'App-moviedb-*' },
);


# using perl v5.10 is a bad idea though (it not supported and now we have v5.18+ already)
warn <<'EOF' if $] <= 5.012;

*******************************************************************************
You are using Perl 5.10, a version that has reached the end of its life
and which is no longer getting updated by the community.

Therefore we highly recommend that you upgrade as soon as possible!
*******************************************************************************

EOF


#sub MY::postamble {
#    my $self = shift;
#    return <<"TEXT"
#TEXT
#}

