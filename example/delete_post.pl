#!/usr/bin/env perl
use strict;
use warnings;

use WebService::FC2::Blog;

my $fc2blog = WebService::FC2::Blog->new(
    username => $ENV{FC2BLOG_USERNAME},
    password => $ENV{FC2BLOG_PASSWORD},
);

my $delete_post_id = '';    # 1 〜

my $result = $fc2blog->delete_post( post_id => $delete_post_id );

print $result;
