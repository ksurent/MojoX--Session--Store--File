package MojoX::Session::Store::Dummy;

use strict;
use warnings;

use base 'MojoX::Session::Store';

use File::Spec;
use File::Slurp;
use Storable qw(freeze thaw);

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
    sessions => (
        default => sub { {} },
    ),
);

sub create {
    my $self = shift;

    my($sid, $expires, $data) = @_;

    my $file = $self->_get_file_name($sid);
    return if -e $file;

    return write_file($file, {binmode => ':raw', atomic => 1}, $expires, $/, freeze($data))
}

sub update {
    my $self = shift;

    my($sid, $expires, $data) = @_;

    my $file = $self->_get_file_name($sid);
    return if not -e $file or not -w _;

    return overwrite_file($file, {binmode => ':raw', atomic => 1}, $expires, $/, freeze($data))
}

sub load {
    my $self = shift;

    my $sid = shift;

    my $file = $self->_get_file_name($sid);
    return if not -e $file or not -r _;

    my $slurp = read_file($file, binmode => ':raw');
    
    return split $/, $slurp
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
