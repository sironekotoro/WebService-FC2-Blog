package WebService::FC2::Blog::Delete;
use 5.008001;
use strict;
use warnings;

use Moo 2.004004;
use XMLRPC::Lite 0.717;
use Syntax::Keyword::Try 0.20;
use Function::Parameters 2.001003;

use Exporter 'import';
our @EXPORT = qw/delete_post/;

method delete_post(:$post_id) {
    try {
        my $post_id
            = XMLRPC::Lite->proxy( $self->END_POINT_URL,
            timeout => $self->timeout )->call(
            'blogger.deletePost',
            $self->blog_id,
            $post_id,
            $self->username,
            $self->password,
            1,    # 0/1 どちらを設定しても削除される
        )->result;

        return $post_id;
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

WebService::FC2::Blog::Delete - Posting or retrieving articles to FC2 blog.

=head2  delete_post

    my $delete_post_id = 6666;    # 1 〜

    my $result = $obj->delete_post( post_id => $delete_post_id );
    print $result;    # 成功すると 1 が返る

FC2 ブログの記事を削除します。


