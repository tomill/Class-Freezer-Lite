use strict;
use warnings;
use Test::Most tests => 2;

use Class::Freezer::Lite;

use utf8;
use lib 't/lib';
use Popo;
use Mopo;

my $freezer = Class::Freezer::Lite->connect(
    "dbi:SQLite:dbname=:memory:", "", "", {
        sqlite_unicode => 1,
    }
);

test_class_freezser(
    Popo->new(
        name => "こんにちは",
        tags => [ "foo", "bar" ],
    ),
    'plain old perl object',
);

test_class_freezser(
    Mopo->new(
        name => "こんにちは",
        tags => [ "foo", "bar" ],
    ),
    'modern perl object by Mouse',
);

sub test_class_freezser {
    my ($obj, $testname) = @_;
    
    subtest $testname => sub {
        my $id;
        
        subtest 'store' => sub {
            plan 'no_plan';
            $id = $freezer->store($obj);
            ok $id;
            ok $freezer->exists($id);
            
            is($obj->{$Class::Freezer::Lite::ID}, $id);
            # diag("id: $id");
            
            throws_ok { $freezer->store($obj) } qr/^Object already exists: id => $id/;
        };

        subtest 'load' => sub {
            plan 'no_plan';
            my $obj = $freezer->load($id);
            ok $obj;

            is($obj->name, 'こんにちは');
            is_deeply($obj->tags, [ "foo", "bar" ]);
            isa_ok($obj->{created_at}, 'Time::Piece');
            like($obj->created_datetime, qr/^\d{4}-\d\d-\d\dT\d\d:\d\d:\d\d$/);
            
            $obj->{name} = 'hello!!!';
            delete $obj->{tags};
            ok $freezer->update($obj);
        };

        subtest 'update' => sub {
            plan 'no_plan';
            my $obj = $freezer->load($id);
            is($obj->name, 'hello!!!');
            ok not defined $obj->{tags};
            
            $obj->{$Class::Freezer::Lite::ID} = 'xxx';
            throws_ok { $freezer->update($obj) } qr/^Object does not exist: id => xxx/;
        };

        subtest 'delete' => sub {
            plan 'no_plan';
            ok $freezer->delete($id);
            throws_ok { $freezer->load($id) } qr/^Cannot find object: id => $id/;
        };
    };
}