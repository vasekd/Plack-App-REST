#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Plack::Builder;
use Plack::Test;
use HTTP::Request::Common;
use Plack::App::URLMap;
use Plack::App::REST;

BEGIN {
	use_ok( 'Plack::App::REST' ) || print "Bail out!\n";
}

my $make_app = sub {
    my $name = shift;
    sub {
        my $env = shift;
        my $body = join "|", $name, $env->{SCRIPT_NAME}, $env->{PATH_INFO};
        return [ 200, [ 'Content-Type' => 'text/plain' ], [ $body ] ];
    };
};

my $app1 = $make_app->("app1");

my $urlmap = Plack::App::URLMap->new;

my $app = builder {
		mount "/api" => builder {
			mount '/' => Test::Root->new();
		};
};

test_psgi app => $app, client => sub {
	my $cb = shift;

	my $res ;

	$res = $cb->(GET "http://localhost/api");
	is $res->content, 'app/root';

	$res = $cb->(GET "http://localhost/api/");
	is $res->content, 'app/root';

	$res = $cb->(GET "http://localhost/api/123");
	is $res->content, 'app/root1';

	$res = $cb->(GET "http://localhost/api1/test");
	is $res->content, 'Not Found';

	$res = $cb->(POST "http://localhost/api");
	is $res->content, 'Method Not Allowed';

};

done_testing;

package Test::Root;
use parent qw(Plack::App::REST);

sub GET {
	my ($self, $env, $param, $data) = @_;

	if ($param){
		return [ 200, [ 'Content-Type' => 'text/plain' ], [ 'app/root1' ] ];
	}else{
		return [ 200, [ 'Content-Type' => 'text/plain' ], [ 'app/root' ] ];
	}		
}
