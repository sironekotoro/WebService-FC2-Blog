#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

use WebService::FC2::Blog;

my $fc2blog = WebService::FC2::Blog->new(
    username => $ENV{FC2BLOG_USERNAME},
    password => $ENV{FC2BLOG_PASSWORD},
);

my $post_id = $fc2blog->new_post(
    title       => "タイトル" . localtime,
    description => "本文",
    category_id => 0,                    # カテゴリの作成は FC2 Blog の管理画面で行う
    publish     => 0,                    # 0:下書き 1:公開
);

print $post_id . "\n";                   # 成功すると投稿した post_id が返る
