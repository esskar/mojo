use Mojo::Base -strict;

# Disable IPv6 and libev
BEGIN {
  $ENV{MOJO_MODE}    = 'testing';
  $ENV{MOJO_NO_IPV6} = 1;
  $ENV{MOJO_REACTOR} = 'Mojo::Reactor::Poll';
}

use Test::More;

use FindBin;
require "$FindBin::Bin/external/myapp.pl";

use Test::Mojo;

my $t = Test::Mojo->new;

# GET /
$t->get_ok('/')->status_is(200)->content_is(<<'EOF');
works ♥!Insecure!Insecure!

too!works!!!Mojolicious::Plugin::Config::Sandbox
<form action="/%E2%98%83">
  <input type="submit" value="☃" />
</form>
EOF

# GET /index.html
$t->get_ok('/index.html')->status_is(200)
  ->content_is("External static file!\n");

# GET /echo
$t->get_ok('/echo')->status_is(200)->content_is('echo: nothing!');

# GET /stream
$t->get_ok('/stream')->status_is(200)->content_is('hello!');

# GET /url/☃
$t->get_ok('/url/☃')->status_is(200)
  ->content_is('/url/%E2%98%83 -> /%E2%98%83/stream!');

done_testing();
