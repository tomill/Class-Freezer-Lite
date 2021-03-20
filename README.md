# NAME

Class::Freezer::Lite - Simple perl object persistence tool

# SYNOPSIS

    use Class::Freezer::Lite;

# DESCRIPTION

Class::Freezer::Lite is a super lite module to make perl object persistence,
and it is similar in [KiokuDB](https://metacpan.org/pod/KiokuDB).

\* Not support scope, transparent systems.

\* This will be able to store only simple blessed hash object (like Mouse or Class::Accessor).

# METHODS

- connect

        my $freezer = Class::Freezer::Lite->connect(
            "dbi:SQLite:dbname=:memory:", "", "", {
                sqlite_unicode => 1,
            }
        );

- store

        my $id = $freezer->store($obj);

- load

        my $obj = $freezer->load($id);

- delete

        $freezer->delete($id);

- search

        my @ids = $freezer->search(
            key   => 'name',
            value => { 'like', '%e' },
        );

# SEE ALSO

[KiokuDB](https://metacpan.org/pod/KiokuDB), [Data::Serializer](https://metacpan.org/pod/Data%3A%3ASerializer)

# AUTHOR

Naoki Tomita <tomita@cpan.org>

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
