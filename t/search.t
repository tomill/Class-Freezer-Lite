use strict;
use warnings;
use Test::Most;

use ok 'Class::Freezer::Lite';

use lib 't/lib';
use Popo;

my $freezer = Class::Freezer::Lite->connect(
    "dbi:SQLite:dbname=:memory:", "", "", {
        sqlite_unicode => 1,
    }
);

my %id_table;
for (qw/ apple banana grape melon orange /) {
    my $id = $freezer->store(Popo->new(name => $_));
    $id_table{$_} = $id;
}

my @ids = $freezer->search(
    key   => 'name',
    value => { 'like', '%e' },
);

is_deeply(
    [ sort(@ids) ],
    [ sort($id_table{apple}, $id_table{grape}, $id_table{orange}) ],
);

done_testing;
