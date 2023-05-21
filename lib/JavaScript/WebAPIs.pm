package JavaScript::WebAPIs;
# ABSTRACT: Add Web APIs and polyfills to your Perl V8 environment

use Moo;
use File::ShareDir::ProjectDistDir;
use Path::Tiny;
use Module::Runtime qw( use_module );
use Carp qw( confess croak );

# class functions
sub share_path { path(dist_dir('JavaScript-WebAPIs'), @_) }
sub main_js { share_path('main.js')->slurp_utf8 }
sub main_min_js { share_path('main.min.js')->slurp_utf8 }

has source_supported => (
  is => 'lazy',
  default => sub { 1 },
);

has init_global => (
  is => 'lazy',
  default => sub { 1 },
);

has minified => (
  is => 'lazy',
  default => sub { 0 },
);

has console_class => (
  is => 'lazy',
  default => sub { 'JavaScript::WebAPIs::Console' },
);

has console_args => (
  is => 'lazy',
  default => sub {+{}},
);

has console => (
  is => 'lazy',
  default => sub {
    my ( $self ) = @_;
    return use_module($self->console_class)->new($self->console_args) if $self->console_class;
    return undef;
  },
);

has console_binds => (
  is => 'lazy',
  default => sub {
    my ( $self ) = @_;
    return undef unless $self->console;
    return $self->console->binds;
  },
);

sub _eval {
  my ( $self, $engine, $js, $source) = @_;
  return $self->source_supported
    ? $engine->eval($js, $source)
    : $engine->eval($js);
}

sub _bind {
  my ( $self, $engine, $key, $bind ) = @_;
  return $engine->eval($key, $bind);
}

sub fill {
  my ( $self, $engine ) = @_;

  for (qw( bind eval )) {
    confess __PACKAGE__." js engine requires a ".$_." function" unless $engine->can($_);
  }

  $self->_eval($engine, "var global = this;", __FILE__);
  $self->_bind($engine, console => $self->console_binds ) if $self->console_binds;

}

1;
