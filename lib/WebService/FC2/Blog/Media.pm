package WebService::FC2::Blog::Media;
use 5.008001;
use strict;
use warnings;

use Moo 2.004004;
use XMLRPC::Lite 0.717;
use Syntax::Keyword::Try 0.20;
use Function::Parameters 2.001003;
use Carp qw/croak/;
use File::Basename qw/basename/;
use File::Slurp 9999.32 qw/read_file/;
use MIME::Base64 qw/encode_base64/;
use Exporter 'import';
our @EXPORT = qw/upload_file/;

method upload_file( :$file_path, :$name = basename($file_path) ) {

    my $bin_data = read_file( $file_path, binmode => ':raw' );
    my $base64   = encode_base64( $bin_data, '' );

    my $regex = $self->upload_file_extention_regex;
    croak
        "Only the following extensions can be uploaded.\njpg/gif/png/mid/swf/ico/mp3/html/txt/css/js/rdf/xml/xsl"
        if ( $name !~ /$regex/ );

    try {
        my $content = XMLRPC::Lite->proxy( $self->END_POINT_URL,
            timeout => $self->timeout )->call(

            'metaWeblog.newMediaObject',    # metaWeblog API
            $self->blog_id,
            $self->username,
            $self->password,

            # file構造体
            {   bits => XMLRPC::Data->type( "base64", $bin_data ),
                name => XMLRPC::Data->type( "string", $name ),
            },
        )->result;

        return $content;
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

WebService::FC2::Blog - Posting or retrieving articles to FC2 blog.

=head2  upload_file

    my $content = $fc2blog->upload_file( file_path => $file_path);

ブログにファイルをアップロードします。アップロード可能なファイルの拡張子は以下です。

    jpg gif png mid swf ico mp3 html txt css js rdf xml xsl)
