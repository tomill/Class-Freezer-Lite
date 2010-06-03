package Class::Freezer::Lite;
use 5.008000;
use strict;
use warnings;
our $VERSION = '0.01';
use Carp; $Carp::Internal{ (__PACKAGE__) }++;
use Data::UUID;
use Scalar::Util qw/blessed/;

use Class::Freezer::Lite::Backend;

our $ID = __PACKAGE__ . '::ID';

sub new {
    my ($class, %arg) = @_;
    my $self = bless { %arg }, $class;
    
    unless (blessed($self->{backend}) &&
        $self->{backend}->isa('Class::Freezer::Lite::Backend')) {
        croak "Invalid backend.";
    }
    
    $self;
}

sub connect {
    my ($class, $dsn, @args) = @_;
    my $self = $class->new(
        backend => Class::Freezer::Lite::Backend->auto($dsn, @args),
    );
}

sub store {
    my ($self, $obj) = @_;
    my $id = $self->_check_obj($obj);
    $self->{backend}->store($id, $obj);
    $id;
}

sub load {
    my ($self, $id) = @_;
    $self->{backend}->load($id);
    my $obj = $self->{backend}->load($id);
    croak "Cannot find object: id => $id" unless keys %$obj;
    $obj;
}

sub delete {
    my ($self, $obj_or_id) = @_;
    my $id = ref($obj_or_id) ? $self->_check_obj($obj_or_id) : $obj_or_id;
    $self->{backend}->delete($id) ? 1 : 0;
}

sub search {
    my ($self, %arg) = @_;
    my @list = $self->{backend}->search(%arg);
    wantarray ? @list : \@list;
}

sub _check_obj {
    my ($self, $obj) = @_;
    
    unless (blessed($obj) && $obj->isa('HASH')) {
        croak "Cannot freeze: $obj";
    }
    
    $obj->{$ID} ||= do {
        $self->{uuid} ||= new Data::UUID;
        $self->{uuid}->create_str;
    };
}

1;
__END__

=encoding utf-8

=head1 NAME

Class::Freezer::Lite -

=head1 SYNOPSIS

  use Class::Freezer::Lite;

=head1 DESCRIPTION

Class::Freezer::Lite is

=head1 METHODS

=over 4

=item new

=item foo

=back

=head1 SEE ALSO



=head1 AUTHOR

Naoki Tomita E<lt>tomita@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
