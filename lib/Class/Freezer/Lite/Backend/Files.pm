package Class::Freezer::Lite::Backend::Files;
use strict;
use warnings;
use base 'Class::Freezer::Lite::Backend';
use Fcntl ':flock';
use Path::Class;

sub init {
    my ($self, $dsn) = @_;
    ($self->{dir}) = $dsn =~ /^files:dir=(.+);?/i;
    $self->serializer->raw(1);
}

sub store {
    my ($self, $id, $obj) = @_;
    my $file = file($self->{dir}, "$id.pl");
    my $fh = $file->open('w') or die "Can't write $file: $!";
    flock($fh, LOCK_SH) or die "Can't lock $file";;
    print $fh $self->serializer->freeze($obj);
    undef $fh;
}

sub load {
    my ($self, $id) = @_;
    my $file = file($self->{dir}, "$id.pl");
    my $fh = $file->open('r') or die "Can't read $file: $!";
    flock($fh, LOCK_SH) or die "Can't lock $file";;
    my $obj = $self->serializer->thaw(do{ local $/; <$fh> });
    undef $fh;
}

sub delete {
    my ($self, $id) = @_;
    my $file = file($self->{dir}, "$id.pl");
    file($self->{dir}, $file)->remove;
}

sub search {
    my ($self, %args) = @_;
    die "not implemented";
}

1;
