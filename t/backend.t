use strict;
use warnings;
use Test::Most;

use ok 'Class::Freezer::Lite';

ok( Class::Freezer::Lite->connect("dbi:SQLite:dbname=:memory:") );

ok(
    Class::Freezer::Lite->new( backend => do {
        Class::Freezer::Lite::Backend::DB::Meta->new("dbi:SQLite:dbname=:memory:")
    })
);

throws_ok {
    my $freezer = Class::Freezer::Lite->connect("");
} qr/^Cannot offer backend for/;

throws_ok {
    my $freezer = Class::Freezer::Lite->new( backend => "" );
} qr/^Invalid backend./;

done_testing;
