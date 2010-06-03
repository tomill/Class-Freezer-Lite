package Class::Freezer::Lite::Backend::Role;
use Mouse::Role;

requires qw(
    store load delete search
);

1;
