use Test::More tests => 6;

use MojoX::Session;
use MojoX::Session::Store::File;

my $session = MojoX::Session->new(store => MojoX::Session::Store::File->new);

my $sid = $session->create;
ok $sid, 'create';
$session->flush;

ok $session->load($sid), 'load';
is $session->sid(), $sid, 'sid';

$session->data->{foo} = 'bar';
$session->flush;
ok $session->load($sid), 'load';
is $session->data('foo'), 'bar', 'data';

$session->expire;
$session->flush;
is $session->load($sid), undef, 'delete';
