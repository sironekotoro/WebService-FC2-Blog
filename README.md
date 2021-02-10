# NAME

WebService::FC2::Blog - Posting or retrieving articles to FC2 blog.

# SYNOPSIS

    use WebService::FC2::Blog;

    use utf8;

    my $fc2blog = WebService::FC2::Blog->new(
        username => $YOUR_FC2BLOG_USERNAME,
        password => $YOUR_FC2BLOG_PASSWORD,
    );

    my $post_id = $fc2blog->new_post(
        title       => "From WebService::FC2::Blog->create_post(): " . localtime,
        description => "<h1>日本語</h1>",
        category_id => 0,   # カテゴリの作成は FC2 Blog の管理画面で行う
        publish     => 0,   # 0:下書き 1:公開
    );

    print $post_id . "\n";    # 成功すると投稿した post_id が返る

# DESCRIPTION

WebService::FC2::Blog は XML-RPC を利用して FC2 ブログに記事を投稿・取得するモジュールです。

# METHOD

## new

    $fc2blog = WebService::FC2::Blog->new(
        username => $ENV{FC2BLOG_USERNAME},
        password => $ENV{FC2BLOG_PASSWORD},
    );

このコンストラクタは新しい WebService::FC2::Blog オブジェクトを返します。

## new\_post

    $fc2blog->new_post(
        title       => "タイトル" . localtime,
        description => "本文",
        category_id => 0,   # カテゴリの作成は FC2 Blog の管理画面で行う
        publish     => 0,   # 0:下書き 1:公開
    );

FC2 ブログに新規記事を投稿します。

## delete\_post

    my $delete_post_id = 6666;    # 1 〜

    my $result = $obj->delete_post( post_id => $delete_post_id );
    print $result;    # 成功すると 1 が返る

FC2 ブログの記事を削除します。

## edit\_post

    my $post_id = $fc2blog->edit_post(
        post_id     => 6666,
        title       => "From WebService::FC2::Blog->edit_post(): " . localtime,
        description => "<h1>編集テストEDIT</h1>",
        date_created => '20210206T16:48:06',    # ISO.8601形式
        category_id => 1,
        publish     => 0,
    );

投稿した記事を編集します。

## get\_post

    my $result = $fc2blog->get_post( post_id => 6666 );

    print Dumper $result;

投稿済みの記事を取得します。

## get\_recent\_posts

    my $result = $fc2blog->get_recent_posts( number_of_posts => 5 );

投稿済みの記事を最新の記事からさかのぼって取得します。最大 100 件まで取得できます。

## set\_post\_category

    my $result = $fc2blog->set_post_category( post_id => 6666, category_id => 1 );

    print Dumper $result;

投稿済みの記事にカテゴリー番号を設定します。

## get\_post\_category

    my $result = $fc2blog->get_post_category( post_id => 6666 );

    print Dumper $result;

投稿済みの記事のカテゴリー番号を取得します。

## get\_category\_list

    my $result = $fc2blog->get_category_list();

    print Dumper $result;

ブログに設定しているカテゴリの一覧を取得します。

## upload\_file

    my $content = $fc2blog->upload_file( file_path => $file_path);

ブログにファイルをアップロードします。アップロード可能なファイルの拡張子は以下です。

    jpg gif png mid swf ico mp3 html txt css js rdf xml xsl

# LICENSE

Copyright (C) sironekotoro

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

sironekotoro <develop@sironekotoro.com>
