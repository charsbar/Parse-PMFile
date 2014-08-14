use strict;
use warnings;
use Test::More;

plan skip_all => "requires WorePAN" unless eval "use WorePAN 0.09; 1";
my @tests = (
  ['JHTHORSEN/App-git-ship-0.07.tar.gz', 'lib/App/git/ship/perl.pm', 'App::git::ship::perl', 'undef'],
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

    for (0..1) {
      no warnings 'once';
      local $Parse::PMFile::FORK = $_;
      my $info;
      eval {
        local $SIG{ALRM} = sub { die "timeout\n" };
        alarm 30;
        $info = $parser->parse($file);
        alarm 0;
      };
      ok !$@ && ref $info eq ref {} && $info->{$package}{version} eq $version, "parsed successfully in time";
      note $@ if $@;
      note explain $info;
    }
  });
}

done_testing;
