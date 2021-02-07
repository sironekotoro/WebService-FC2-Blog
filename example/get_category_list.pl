#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

use WebService::FC2::Blog;

my $fc2blog = WebService::FC2::Blog->new(
    username => $ENV{FC2BLOG_USERNAME},
    password => $ENV{FC2BLOG_PASSWORD},
);

my $result = $fc2blog->get_category_list();

print Dumper $result;

