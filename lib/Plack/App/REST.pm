package Plack::App::REST;

use 5.008_005;
use strict;
use warnings FATAL => 'all';

our $VERSION = '0.01';

use parent qw( Plack::Component );
use Plack::Util;
use HTTP::Exception '4XX';

use Plack::Util::Accessor qw( via class handler );

sub prepare_app {
	my $self = shift;

	die 'You must set "via" parameter.' unless $self->via;

	# Try autoload class
	my $file = $self->via;
    $file =~ s!::!/!g;
    eval{ require "$file.pm"; }; ## no critic

	# Prepare object
	$self->handler( $self->via->new() );
}

sub call {
	my($self, $env) = @_;

	my $method = $env->{REQUEST_METHOD};

	# Throw an exception if method is not defined
	if (!$self->handler->can($method)){
		HTTP::Exception::405->throw(message=>'Method Not Allowed');
	}

	# Set params of path
	my $id = _get_param($env);

	# compatibility with Plack::Middleware::ParseContent
	my $data = $env->{'restapi.parseddata'} if exists $env->{'restapi.parseddata'};

	my $ret = $self->handler->$method($env, $id, $data);
	return $ret;
}

# Get last requested path
sub _get_param {
	my $env = shift;
	my $p = $env->{PATH_INFO};
	return if !$p or $p eq '/';

	# get param of uri
	(my $r = $p) =~ s/\+/ /g;
	$r =~ m!/(?:([^/]*))!g;
	return $1;
}

1;
__END__

=encoding utf-8

=head1 NAME

Plack::App::REST - Perl PSGI App that just call http method from object.

=head1 SYNOPSIS

	use Plack::App::REST;

	builder {
		mount "/api" => builder {
			mount "/" => Plack::App::REST->new(via => 'Test::Root');
		};
	};

	package Test::Root;
	use parent 'Plack::App::REST';

	sub GET {
		return [ 200, [ 'Content-Type' => 'text/plain' ], [ 'app/root' ] ];
	}

=head1 DESCRIPTION

Plack::App::REST is simple plack application that call requested method directly from mounted class.

Method can be GET, PUT, POST, DELETE, HEAD, PATCH. 

Each method is called with three params:

=over 4

=item * Env - Plack Env

=item * Params - resource identifier (usually id). /help/123 => return 123

=item * Data - Compatibility with Plack::Middleware::ParseContent. Return parsed data as perl structure

=back

For complete RestAPI in Perl use: 

=over 4

=item * Plack::Middleware::ParseContent

=item * Plack::Middleware::FormatOutput

=back

=cut

=head1 TUTORIAL

L<http://psgirestapi.dovrtel.cz/>

=head1 AUTHOR

Václav Dovrtěl E<lt>vaclav.dovrtel@gmail.comE<gt>

=head1 BUGS

Please report any bugs or feature requests to github repository.

=head1 ACKNOWLEDGEMENTS

Inspired by L<https://github.com/towhans/hochschober>
Inspired by L<https://github.com/nichtich/Plack-Middleware-REST>

=head1 COPYRIGHT

Copyright 2015- Václav Dovrtěl

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
