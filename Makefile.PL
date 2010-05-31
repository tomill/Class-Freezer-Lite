use inc::Module::Install;
name 'Class-Freezer-Lite';
all_from 'lib/Class/Freezer/Lite.pm';
readme_from 'lib/Class/Freezer/Lite.pm';
repository 'http://github.com/tomi-ru/Class-Freezer-Lite';
bugtracker 'http://github.com/tomi-ru/Class-Freezer-Lite/issues';

requires_any_moose;
requires '';
test_requires '';
test_requires 'Test::More' => 0.94; # subtest
test_requires 'Test::use::ok';
use_test_base;
author_tests 'xt';

# install_share;
# bundle_local_lib;

auto_install;
auto_include_deps;
WriteAll;
