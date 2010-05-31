package Mopo;
use Mouse;
use Time::Piece;

has name => (
    is => 'rw',
);

has tags => (
    is => 'rw',
);

has created_at => (
    is => 'ro',
    default => sub { scalar localtime },
);

sub created_datetime {
    shift->created_at->datetime;
}

1;
