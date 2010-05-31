use Test::More;
plan skip_all => "Test::Dependencies is not installed." unless eval { require Test::Dependencies; 1 };
Test::Dependencies->import(
    exclude => [qw( Test::Dependencies Class::Freezer::Lite )],
    style => 'light',
);
ok_dependencies();
