package Class::Freezer::Lite::Backend;
use strict;
use warnings;
use Carp;
use Data::Serializer;

sub auto {
    my ($class, $dsn, @args) = @_;
    
    my $backend = do {
        my $class = $dsn =~ /^dbi:/ ? 'DB::Meta'
                  : '';
        croak "Cannot offer backend for $dsn" unless $class;
        __PACKAGE__ . "::$class";
    };
    
    my $file = $backend;
       $file =~ s!::!/!g;
    require "$file.pm"; ## no critic
    
    $backend->new($dsn, @args);
}

sub serializer {
    my ($self) = @_;
    $self->{serializer} ||= new Data::Serializer;
}

1;
