package WebService::FC2::Blog::Get;
use 5.008001;
use strict;
use warnings;

use Moo 2.004004;
use XMLRPC::Lite 0.717;
use Syntax::Keyword::Try 0.20;
use Function::Parameters 2.001003;

use Exporter 'import';
our @EXPORT = qw/get_category_list get_post get_post_category get_recent_posts /;


method get_category_list() {

    try {
        my $result = XMLRPC::Lite->proxy( $self->END_POINT_URL,
            timeout => $self->timeout )->call(

            'mt.getCategoryList',    # MovableType API
            $self->blog_id,
            $self->username,
            $self->password,
        )->result;
        return $result;
    }
    catch ($e) {
        warn "It failed - $e";
        return "failure";
    }
}

method get_post(:$post_id) {

    try {
        my $result = XMLRPC::Lite->proxy( $self->END_POINT_URL,
            timeout => $self->timeout )->call(

            'metaWeblog.getPost',    # metaWeblog API
            $post_id,
            $self->username,
            $self->password,
        )->result;
        return $result;
    }
    catch ($e) {
        warn "It failed - $e";
        return "failure";
    }
}

method get_post_category(:$post_id) {

    try{
        my $results = XMLRPC::Lite->proxy( $self->END_POINT_URL,
            timeout => $self->timeout )->call(

            'mt.getPostCategories',
            $post_id,
            $self->username,
            $self->password,

        )->result;

        # FC2ブログは複数カテゴリに対応していない
        return pop @{$results};
    }
    catch($e){
        warn "It failed - $e";
        return "failure";

    }
}


method get_recent_posts(:$number_of_posts = 5) {

    try {
        my $result = XMLRPC::Lite->proxy( $self->END_POINT_URL,
            timeout => $self->timeout )->call(

            'metaWeblog.getRecentPosts',    # metaWeblog API
            $self->blog_id,
            $self->username,
            $self->password,
            $number_of_posts,
        )->result;

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

WebService::FC2::Blog::Get - Posting or retrieving articles to FC2 blog.

=head2  get_category_list

    my $result = $fc2blog->get_category_list();

    print Dumper $result;

ブログに設定しているカテゴリの一覧を取得します。

=head2  get_post

    my $result = $fc2blog->get_post( post_id => 6666 );

    print Dumper $result;

投稿済みの記事を取得します。

=head2  get_post_category

    my $result = $fc2blog->get_post_category( post_id => 6666 );

    print Dumper $result;

投稿済みの記事のカテゴリー番号を取得します。

=head2  get_recent_posts

    my $fc2blog = WebService::FC2::Blog->new(

    my $result = $fc2blog->get_recent_posts( number_of_posts => 5 );

投稿済みの記事を最新の記事からさかのぼって取得します。最大 100 件まで取得できます。

