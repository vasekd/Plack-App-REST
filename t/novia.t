#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Exception;
use Plack::Builder;
use Plack::Test;
use Plack::App::URLMap;

BEGIN {
	use_ok( 'Plack::App::REST' ) || print "Bail out!\n";
}

throws_ok ( sub{ Plack::App::REST->new()->prepare_app() }, qr/You must set "via" parameter./ );

done_testing();