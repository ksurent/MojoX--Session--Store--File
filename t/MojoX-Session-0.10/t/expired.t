use Test::More tests => 5;

use lib 't/lib';

use_ok('MojoX::Session');

use MojoX::Session::Store::Dummy;
use MojoX::Session::Transport::Dummy;

my $session = MojoX::Session->new(
    store     => MojoX::Session::Store::Dummy->new(),
    transport => MojoX::Session::Transport::Dummy->new(),
    expires_delta   => 1
);

my $sid = $session->create();
$session->flush();

diag 'Sleep 2 seconds to expire session';
sleep(2);

$session->transport->get($sid);
ok($session->load());
is($session->is_expired, 1);
$session->extend_expires;
$session->flush;

ok($session->load());
is($session->is_expired, 0);
