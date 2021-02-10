package WebService::FC2::Blog;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";

use FindBin::libs 'v2.20.2';
use Function::Parameters 2.001003;
use Moo 2.004004;
use Syntax::Keyword::Try 0.20;
use Time::Piece;
use XMLRPC::Lite 0.717;

use parent qw/
    WebService::FC2::Blog::New
    WebService::FC2::Blog::Edit
    WebService::FC2::Blog::Get
    WebService::FC2::Blog::Media
    WebService::FC2::Blog::Delete
    /;

has username => (
    is       => 'ro',
    required => 1,
);

has password => (
    is       => 'ro',
    required => 1,
);

has blog_id => (
    is      => 'ro',
    default => sub {
        my $self = shift;
        return $self->username;
    },
    required => 0,
    lazy     => 1,
);

has timeout => (
    is       => 'ro',
    default  => 5,
    required => 0,
);

has END_POINT_URL => (
    is      => 'ro',
    default => sub {'http://blog.fc2.com/xmlrpc.php'},
);

has create_time => (
    is      => 'ro',
    default => sub {
        my $t = localtime();
        return $t->datetime;
    },
);

has upload_file_extention_regex => (
    is      => 'ro',
    builder => sub {

        my @exts
            = qw(jpg gif png mid swf ico mp3 html txt css js rdf xml xsl);
        my @qr_exts = map { '\A.+\.' . $_ . '\z' } @exts;
        my $qr_str  = join '|', @qr_exts;

        return qr/$qr_str/;
    }
);

1;
__END__

=encoding utf-8

=head1 NAME

WebService::FC2::Blog - Posting or retrieving articles to FC2 blog.

=head1 SYNOPSIS

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

=head1 DESCRIPTION

WebService::FC2::Blog は XML-RPC を利用して FC2 ブログに記事を投稿・取得するモジュールです。

=head1 METHOD

=head2 new

    $fc2blog = WebService::FC2::Blog->new(
        username => $ENV{FC2BLOG_USERNAME},
        password => $ENV{FC2BLOG_PASSWORD},
    );

このコンストラクタは新しい WebService::FC2::Blog オブジェクトを返します。

=head2  new_post

    $fc2blog->new_post(
        title       => "タイトル" . localtime,
        description => "本文",
        category_id => 0,   # カテゴリの作成は FC2 Blog の管理画面で行う
        publish     => 0,   # 0:下書き 1:公開
    );

FC2 ブログに新規記事を投稿します。

=head2  delete_post

    my $delete_post_id = 6666;    # 1 〜

    my $result = $obj->delete_post( post_id => $delete_post_id );
    print $result;    # 成功すると 1 が返る

FC2 ブログの記事を削除します。

=head2  edit_post

    my $post_id = $fc2blog->edit_post(
        post_id     => 6666,
        title       => "From WebService::FC2::Blog->edit_post(): " . localtime,
        description => "<h1>編集テストEDIT</h1>",
        date_created => '20210206T16:48:06',    # ISO.8601形式
        category_id => 1,
        publish     => 0,
    );

投稿した記事を編集します。

=head2  get_post

    my $result = $fc2blog->get_post( post_id => 6666 );

    print Dumper $result;

投稿済みの記事を取得します。

=head2  get_recent_posts

    my $result = $fc2blog->get_recent_posts( number_of_posts => 5 );

投稿済みの記事を最新の記事からさかのぼって取得します。最大 100 件まで取得できます。


=head2  set_post_category

    my $result = $fc2blog->set_post_category( post_id => 6666, category_id => 1 );

    print Dumper $result;

投稿済みの記事にカテゴリー番号を設定します。


=head2  get_post_category

    my $result = $fc2blog->get_post_category( post_id => 6666 );

    print Dumper $result;

投稿済みの記事のカテゴリー番号を取得します。

=head2  get_category_list

    my $result = $fc2blog->get_category_list();

    print Dumper $result;

ブログに設定しているカテゴリの一覧を取得します。

=head2  upload_file

    my $content = $fc2blog->upload_file( file_path => $file_path);

ブログにファイルをアップロードします。アップロード可能なファイルの拡張子は以下です。

    jpg gif png mid swf ico mp3 html txt css js rdf xml xsl

=head1 LICENSE

Copyright (C) sironekotoro

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

sironekotoro E<lt>develop@sironekotoro.comE<gt>

=cut

