package Class::Freezer::Lite::Backend::DB::Meta;
use strict;
use warnings;
use base 'Class::Freezer::Lite::Backend';
use DBIx::Simple;

sub init {
    my ($self, $dsn, $user, $pass, $attr) = @_;
    $attr = {
        %{ $attr || {} },
        AutoCommit => 1,
        RaiseError => 1,
    };
    $self->{db} = DBIx::Simple->connect($dsn, $user, $pass, $attr);
    $self->{db}->query(q{
        create table if not exists freezer (
            id,
            namespace,
            key,
            value,
            is_raw,
            primary key( id, key )
        )
    });
}

sub store {
    my ($self, $id, $obj) = @_;
    my $namespace = ref $obj;
    $self->{db}->begin_work;
    for my $key (keys %$obj) {
        my $value  = $obj->{$key};
        my $is_raw = 1;
        if (ref $value) {
            $value  = $self->serializer->freeze($obj->{$key});
            $is_raw = 0;
        }
        $self->{db}->query(
            'insert or replace into freezer (id, namespace, key, value, is_raw) values (??)',
            $id, $namespace, $key, $value, $is_raw,
        );
    }
    
    my @keys = keys %$obj;
    my $sql = sprintf 'delete from freezer where id = ? and namespace = ? and key not in (%s)',
                      join(', ', ('?') x @keys);
    $self->{db}->query($sql, $id, $namespace, @keys);
    $self->{db}->commit;
}

sub load {
    my ($self, $id) = @_;
    my $res = $self->{db}->query(
        'select namespace, key, value, is_raw from freezer where id = ?',
        $id,
    );
    my $obj = {};
    my $namespace;
    while (my $row = $res->hash) {
        $obj->{ $row->{key} } = $row->{is_raw} ? $row->{value}
                              : $self->serializer->thaw($row->{value});
        $namespace ||= $row->{namespace};
    }
    if (keys %$obj) {
        return bless $obj, $namespace;
    } else {
        return;
    }
}

sub delete {
    my ($self, $id) = @_;
    $self->{db}->query('delete from freezer where id = ?', $id);
}

sub search {
    my ($self, %args) = @_;
    $self->{db}->select('freezer', 'distinct id', { %args })->flat;
}

1;
