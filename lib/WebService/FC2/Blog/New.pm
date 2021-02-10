package WebService::FC2::Blog::New;
use 5.008001;
use strict;
use warnings;

use Moo 2.004004;
use XMLRPC::Lite 0.717;
use Syntax::Keyword::Try 0.20;
use Function::Parameters 2.001003;

use Exporter 'import';
our @EXPORT = qw/new_post/;

method new_post (:$title, :$description, :$date_created = undef, :$category_id = undef, :$publish = 0 ) {

    try {
        my $post_id = XMLRPC::Lite->proxy( $self->END_POINT_URL,
            timeout => $self->timeout )->call(

            'metaWeblog.newPost',    # metaWeblog API
            $self->blog_id,
            $self->username,
            $self->password,

            # content構造体
            {   title       => XMLRPC::Data->type( 'string', $title ),
                description => XMLRPC::Data->type(
                    'string', $description || $self->create_time
                ),
                dateCreated =>
                    XMLRPC::Data->type( "dateTime", $date_created ),
            },
            $publish
        )->result;

        if ($category_id) {
            $self->set_post_category(
                post_id     => $post_id,
                category_id => $category_id
            );
        }

        return $post_id;
    }
    catch ($e) {
        warn "It failed - $e";
        return "failure";
    }
};

1;
__END__

=encoding utf-8

=head1 NAME

WebService::FC2::Blog::New - Posting or retrieving articles to FC2 blog.

=head2  new_post

    $fc2blog->new_post(
        title       => "タイトル" . localtime,
        description => "本文",
        category_id => 0,   # カテゴリの作成は FC2 Blog の管理画面で行う
        publish     => 0,   # 0:下書き 1:公開
    );

FC2 ブログに新規記事を投稿します。
