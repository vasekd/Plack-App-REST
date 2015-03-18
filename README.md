# NAME

Plack::App::REST - Perl PSGI App that just call http method from object.

# SYNOPSIS

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

# DESCRIPTION

Plack::App::REST is simple plack application that call requested method directly from mounted class.

Method can be GET, PUT, POST, DELETE, HEAD, PATCH. 

Each method is called with three params:

- Env - Plack Env
- Params - resource identifier (usually id). /help/123 => return 123
- Data - Compatibility with Plack::Middleware::ParseContent. Return parsed data as perl structure

For complete RestAPI in Perl use: 

- Plack::Middleware::ParseContent
- Plack::Middleware::FormatOutput

# TUTORIAL

[http://psgirestapi.dovrtel.cz/](http://psgirestapi.dovrtel.cz/)

# AUTHOR

Václav Dovrtěl <vaclav.dovrtel@gmail.com>

# BUGS

Please report any bugs or feature requests to github repository.

# ACKNOWLEDGEMENTS

Inspired by [https://github.com/towhans/hochschober](https://github.com/towhans/hochschober)

Inspired by [https://github.com/nichtich/Plack-Middleware-REST](https://github.com/nichtich/Plack-Middleware-REST)

# COPYRIGHT

Copyright 2015- Václav Dovrtěl

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO
