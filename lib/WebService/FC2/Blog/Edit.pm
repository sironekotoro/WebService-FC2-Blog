package WebService::FC2::Blog::Edit;
use 5.008001;
use strict;
use warnings;

use Moo 2.004004;
use XMLRPC::Lite 0.717;
use Syntax::Keyword::Try 0.20;
use Function::Parameters 2.001003;

use Exporter 'import';
our @EXPORT = qw/edit_post set_post_category/;

method edit_post(:$post_id, :$title = undef, :$description = undef, :$date_created = undef, :$category_id = undef, :$publish = 0 ){

    # タイトル、内容、投稿日時、カテゴリの変更をしない場合には、元のpostから持ってくる
    my $target_post = $self->get_post(post_id => $post_id);

    $title        = $title ? $title : $target_post->{title};
    $description  = $description ? $description : $target_post->{description};
    $date_created = $date_created ? $date_created : $target_post->{dateCreated};

    try {
         my $result = eval {

                my $hoge = XMLRPC::Lite->proxy( $self->END_POINT_URL,
                timeout => $self->timeout )->call(

                'metaWeblog.editPost',    # MovableType API
                $post_id,
                $self->username,
                $self->password,

                # content構造体
                {   title       => XMLRPC::Data->type( 'string', $title ),
                    description => XMLRPC::Data->type(
                        "string", $description || $self->create_time
                    ),
                    dateCreated =>
                        XMLRPC::Data->type( 'dateTime', $date_created ),
                },
                $publish
            )->result;
        };

        if ($category_id){
            $self->set_post_category(post_id => $post_id, category_id => $category_id)
        }

        return $result;
    }
    catch ($e) {
        warn "It failed - $e";
        return "failure";
    }
}


method set_post_category(:$post_id, :$category_id) {

    try {
        my $result = eval {
            my $post_id
                = XMLRPC::Lite->proxy( $self->END_POINT_URL,
                timeout => $self->timeout )->call(

                'mt.setPostCategories',               # MovableType API
                $post_id,
                $self->username,
                $self->password,
                [ { categoryId => $category_id } ],   # FC2 Blogは複数カテゴリを設定できない
            )->result;
        };
        return $result;
    }
    catch ($e) {
        warn "It failed - $e";
        return "failure";
    }
}

1;
__END__

=encoding utf-8

=head1 NAME

WebService::FC2::Blog::Edit - Posting or retrieving articles to FC2 blog.

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

=head2  set_post_category

    my $result = $fc2blog->set_post_category( post_id => 6666, category_id => 1 );

    print Dumper $result;

投稿済みの記事にカテゴリー番号を設定します。


