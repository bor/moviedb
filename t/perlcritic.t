#!perl

use strict;
use warnings;

use Test::More;

# Skip if doing a regular install
plan skip_all => "Author tests not required for installation"
  unless $ENV{AUTHOR_TESTING};

eval { require Test::Perl::Critic; };
plan skip_all => "Test::Perl::Critic required for testing PBP compliance" if $@;

Test::Perl::Critic::all_critic_ok();
