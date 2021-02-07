#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use FindBin;

use WebService::FC2::Blog;

my $fc2blog = WebService::FC2::Blog->new(
    username => $ENV{FC2BLOG_USERNAME},
    password => $ENV{FC2BLOG_PASSWORD},
);

my $file_path = "$FindBin::Bin/internet_heiwa.png";

my $content = $fc2blog->upload_file( file_path => $file_path);

print Dumper $content;
