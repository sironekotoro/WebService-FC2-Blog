#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

use WebService::FC2::Blog;

my $fc2blog = WebService::FC2::Blog->new(
    username => $ENV{FC2BLOG_USERNAME},
    password => $ENV{FC2BLOG_PASSWORD},
);

# max 100
my $result = $fc2blog->get_recent_posts( number_of_posts => 5 );

print Dumper $result;
