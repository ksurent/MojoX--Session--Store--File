package MojoX::Session::Store::File::Serializer;

use strict;
use warnings;

sub new {
    my $class = shift;

    my $self = {@_};
    foreach(qw(driver file)) {
        Carp::croak "Argument '$_' not specified" unless $self->{$_}
    }

    eval "require $self->{driver}";
    if($@) {
    }

    bless $self, $class
}

1

__END__
