use Mojo::Base -strict;

use Test::More;
use Mojolicious::Controller;

# Partial rendering
my $c = Mojolicious::Controller->new;
$c->app->log->level('fatal');
is $c->render(text => 'works', partial => 1), 'works', 'renderer is working';

# Normal rendering with default format
my $r = $c->app->renderer->default_format('test');
$r->add_handler(
  debug => sub {
    my ($self, $c, $output) = @_;
    $$output .= 'Hello Mojo!';
  }
);
$c->stash->{template} = 'something';
$c->stash->{handler}  = 'debug';
is_deeply [$r->render($c)], ['Hello Mojo!', 'test'], 'normal rendering';

# Normal rendering with custom format
$c->stash->{format}   = 'something';
$c->stash->{template} = 'something';
$c->stash->{handler}  = 'debug';
is_deeply [$r->render($c)], ['Hello Mojo!', 'something'], 'normal rendering';

# Normal rendering with layout
delete $c->stash->{format};
$c->stash->{template} = 'something';
$c->stash->{layout}   = 'something';
$c->stash->{handler}  = 'debug';
is_deeply [$r->render($c)], ['Hello Mojo!Hello Mojo!', 'test'],
  'normal rendering with layout';
is delete $c->stash->{layout}, 'something';

# Rendering a path with dots
$c->stash->{template} = 'some.path.with.dots/template';
$c->stash->{handler}  = 'debug';
is_deeply [$r->render($c)], ['Hello Mojo!', 'test'],
  'rendering a path with dots';

# Unrecognized handler
$c->stash->{handler} = 'not_defined';
is $r->render($c), undef, 'return undef for unrecognized handler';

done_testing();
