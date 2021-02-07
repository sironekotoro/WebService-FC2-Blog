requires 'File::Slurp', '9999.32';
requires 'FindBin::libs';
requires 'Function::Parameters', '2.001003';
requires 'MIME::Base64';
requires 'Moo', '2.004004';
requires 'Syntax::Keyword::Try', '0.20';
requires 'Time::Piece';
requires 'XMLRPC::Lite', '0.717';
requires 'parent';
requires 'perl', '5.008001';

on configure => sub {
    requires 'Module::Build::Tiny', '0.035';
};

on test => sub {
    requires 'Test::More', '0.98';
};

on develop => sub {
    requires 'Test::Perl::Critic', '1.04';
};
