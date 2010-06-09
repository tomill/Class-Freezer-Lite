use inc::Module::Install;
all_from 'lib/Class/Freezer/Lite.pm';

requires 'Data::UUID';
requires 'Scalar::Util';
requires 'Data::Serializer';

features(
    'DB::Meta' => [
        'DBIx::Simple' => 1.27,
    ],
);

test_requires 'Test::More' => 0.94; # subtest
test_requires 'Test::Requires';
test_requires 'Test::use::ok';

author_tests 'xt';

readme_from 'lib/Class/Freezer/Lite.pm';
resources(
    repository => 'http://github.com/tomi-ru/Class-Freezer-Lite',
    bugtracker => 'http://github.com/tomi-ru/Class-Freezer-Lite/issues',
);

auto_install;
WriteAll;
