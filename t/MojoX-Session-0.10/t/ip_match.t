use Test::More tests => 4;

use lib 't/lib';

use_ok('MojoX::Session');

use Mojo::Transaction;
use MojoX::Session::Store::Dummy;

my $tx = Mojo::Transaction->new;

my $session = MojoX::Session->new(
    tx       => $tx,
    store    => MojoX::Session::Store::Dummy->new(),
    ip_match => 1
);

$tx->remote_address('127.0.0.1');
$session->create();
my $sid = $session->sid;
ok($sid);
$session->flush();

$tx->remote_address('127.0.0.2');
ok(not defined $session->load($sid));

$tx->remote_address('127.0.0.1');
ok($session->load($sid));
