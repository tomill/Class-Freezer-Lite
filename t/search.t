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

my %ids;
for (qw/ apple banana grape melon orange /) {
    my $id = $freezer->store(Popo->new(name => $_));
    $ids{$_} = $id;
}

my @res = $freezer->search(
    key   => 'name',
    value => { 'like', '%e' },
);

is_deeply(
    [ sort(@res) ],
    [ sort($ids{apple}, $ids{grape}, $ids{orange}) ],
);

done_testing;
