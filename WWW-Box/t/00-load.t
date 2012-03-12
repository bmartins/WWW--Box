#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'WWW::Box' ) || print "Bail out!\n";
}

diag( "Testing WWW::Box $WWW::Box::VERSION, Perl $], $^X" );
