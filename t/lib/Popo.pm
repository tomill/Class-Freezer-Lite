package Popo;
use strict;
use warnings;
use Time::Piece;

sub new {
    my $class = shift;
    bless {
        @_,
        created_at => scalar localtime,
    }, $class;
}

sub name {
    shift->{name};
}

sub tags {
    shift->{tags};
}

sub created_datetime {
    shift->{created_at}->datetime;
}

1;
