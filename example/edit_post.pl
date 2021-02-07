#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

use WebService::FC2::Blog;

my $fc2blog = WebService::FC2::Blog->new(
    username => $ENV{FC2BLOG_USERNAME},
    password => $ENV{FC2BLOG_PASSWORD},
);

my $post_id = $fc2blog->edit_post(
    post_id     => 6666,
    title       => "From WebService::FC2::Blog->edit_post(): " . localtime,
    description => "<h1>編集テストEDIT</h1>",
    date_created => '20210206T16:48:06',    # ISO.8601形式
    category_id => 1,
    publish     => 0,
);

print $post_id . "\n";    # 成功すると投稿した post_id が返る
