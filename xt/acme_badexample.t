use strict;
use warnings;
use Test::More;

plan skip_all => "requires WorePAN" unless eval "use WorePAN 0.03; 1";
my @tests = (
  ['A/AD/ADAMK/Acme-BadExample-1.01.tar.gz', 'lib/Acme/BadExample.pm', 'Acme::BadExample', 'undef'],
);

for my $test (@tests) {
  my ($path, $pmfile, $package, $version) = @$test;
  note "downloading $path...";

  my $worepan = WorePAN->new(
    no_network => 0,
    use_backpan => 1,
    cleanup => 1,
    no_indices => 1,
    files => [$path],
  );

  note "parsing $path...";

  $worepan->walk(callback => sub {
    my $dir = shift;
    my $file = $dir->file($pmfile);
    my $parser = Parse::PMFile->new;

    my $info;
    eval {
      local $SIG{ALRM} = sub { die "timeout\n" };
      alarm 30;
      $info = $parser->parse($file);
      alarm 0;
    };
    ok !$@ && ref $info eq ref {} && !$info->{$package}{version}, "parsed successfully in time";
    note $@ if $@;
    note explain $info;
  });
}

done_testing;
