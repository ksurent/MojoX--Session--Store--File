package MojoX::Session::Store::File;

use strict;
use warnings;

use base 'MojoX::Session::Store';

use MojoX::Session::Store::File::Serializer;

use File::Spec;

our $VERSION = '0.01';

__PACKAGE__->attr(
    dir => (
        default => File::Spec->tmpdir,
        chained => 1,
    ),
);
__PACKAGE__->attr(
    prefix => (
        default => 'mojoxsess',
        chained => 1,
    ),
);

__PACKAGE__->attr(
    serializer => (
        default => 'Storable',
        chained => 1,
    ),
);

sub create {
    my $self = shift;

    my($sid, $expires, $data) = @_;

    my $file = $self->_get_file_name($sid);
    return if -e $file;

    my $serializer = MojoX::Session::Store::File::Serializer->new(
        driver => $self->serializer,
        file   => $file,
    );
    return $serializer->freeze([$expires, $data])
}

sub update {
    my $self = shift;

    my($sid, $expires, $data) = @_;

    my $file = $self->_get_file_name($sid);
    return if not -e $file or not -w _;

    my $serializer = MojoX::Session::Store::File::Serializer->new(
        driver => $self->serializer,
        file   => $file,
    );
    return $serializer->freeze([$expires, $data])
}

sub load {
    my $self = shift;

    my $sid = shift;

    my $file = $self->_get_file_name($sid);
    return if not -e $file or not -r _;

    my $serializer = MojoX::Session::Store::File::Serializer->new(
        driver => $self->serializer,
        file   => $file,
    );
    return @{$serializer->thaw}
}

sub delete {
    my $self = shift;

    my $sid = shift;

    return unlink $self->_get_file_name($sid)
}

sub _get_file_name {
    my $self = shift;

    my $sid = shift;

    return File::Spec->catfile($self->dir, sprintf('%s_%s', $self->prefix, $sid))
}

1

__END__
