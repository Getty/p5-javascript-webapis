package JavaScript::WebAPIs::Console;

use Moo;
use Data::Printer;
use Term::ANSIColor;
use Time::HiRes qw( time );

sub _map_lines { map { defined $_ ? $_ : 'undef' } map { ref $_ ? np($_,
  hash_max => 1000,
  array_max => 1000,
  string_max => 32768,
  show_dualvar => 'off',
) : $_ } @_ }

sub _stdout {
  my $func = shift;
  my $color = shift;
  print(($color ? colored($_, $color) : $_)."\n") for _map_lines(@_);
}

sub _stderr {
  my $func = shift;
  my $color = shift;
  print STDERR colored($_, $color)."\n" for _map_lines(@_);
}

has log => (
  is => 'lazy',
  default => sub {sub { _stdout('log',undef,@_) }},
);

has info => (
  is => 'lazy',
  default => sub {sub { _stdout('info','cyan',@_) }},
);

has warn => (
  is => 'lazy',
  default => sub {sub { _stderr('warn','yellow',@_) }},
);

has error => (
  is => 'lazy',
  default => sub {sub { _stderr('error','red',@_) }},
);

has timers => (
  is => 'lazy',
  default => sub {+{}},
);

has counters => (
  is => 'lazy',
  default => sub {+{}},
);

sub binds {
  my ( $self ) = @_;
  return {
    log => $self->log,
    warn => $self->warn,
    error => $self->error,
    info => $self->info,
    clear => sub {return;},
    time => sub {
      my ( $timer ) = @_;
      $self->timers->{$timer} = ( time * 1000 );
    },
    timeEnd => sub {
      my ( $timer ) = @_;
      return unless $self->timers->{$timer};
      return ( ( time * 1000 ) - ( delete $self->timers->{$timer} ) );
    },
    count => sub {
      my ( $counter ) = @_;
      $self->counters->{$counter} = 0 unless defined $self->counters->{$counter};
      return ++$self->counters->{$counter};
    },
  };
}

1;