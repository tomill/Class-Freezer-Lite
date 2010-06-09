package Class::Freezer::Lite::Backend;
use strict;
use warnings;
use Data::Serializer;

sub new {
    my $self = bless {}, shift;
    $self->init(@_);
    $self;
}

sub auto {
    my ($class, $dsn, @args) = @_;
    
    my $backend = do {
        my $class = $dsn =~ /^dbi:/ ? 'DB::Meta'
                  : $dsn =~ /^files:/ ? 'Files'
                  : undef;
        return unless $class;
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
