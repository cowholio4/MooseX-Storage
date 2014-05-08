use strict;
use warnings;

use Test::More;
use Test::Deep;

use Test::Requires qw(
    JSON::Any
    Test::Deep::JSON
);

BEGIN {
    plan tests => 11;
    use_ok('MooseX::Storage');
}

{

    package Foo;
    use Moose;
    use MooseX::Storage;

    with Storage( 'format' => 'JSON' );

    has 'number' => ( is => 'ro', isa => 'Int' );
    has 'string' => ( is => 'ro', required => 1, isa => 'Str | Undef' );
    has 'float'  => ( is => 'ro', isa => 'Num' );
    has 'array'  => ( is => 'ro', isa => 'ArrayRef' );
    has 'hash'   => ( is => 'ro', isa => 'HashRef' );
    has 'object' => ( is => 'ro', isa => 'Object' );
}

{
    my $foo = Foo->new(
        number => 10,
        string => undef,
        float  => 10.5,
        array  => [ 1 .. 10 ],
        hash   => { map { $_ => undef } ( 1 .. 10 ) },
        object => Foo->new( number => 2, string => "string" ),
    );
    isa_ok( $foo, 'Foo' );

    my $json = $foo->freeze;

    cmp_deeply(
        $json,
        json({
            number => 10,
            string => undef,
            float => 10.5,
            array => [ 1 .. 10 ],
            hash => { map { $_ => undef } (1 .. 10) },
            __CLASS__ => 'Foo',
            object => {
                number => 2,
                string => "string",
                __CLASS__ => 'Foo'
            },
        }),
        'is valid JSON and content matches',
    );
}

{
    my $foo = Foo->new(
        number => 10,
        string => undef,
        float  => 10.5,
        array  => [ 1 .. 10 ],
        hash   => { map { $_ => undef } ( 1 .. 10 ) },
        object => Foo->new( number => 2, string => "string" ),
    );
    isa_ok( $foo, 'Foo' );

    my $json = $foo->freeze;
    
    my $foo2 = Foo->thaw( $json );

}
