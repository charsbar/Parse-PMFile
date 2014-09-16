use strict;
use warnings;
use Test::More;

plan skip_all => "requires WorePAN" unless eval "use WorePAN 0.03; 1";
my @tests = (
  ['D/DO/DOY/KiokuDB-0.54.tar.gz', 'lib/KiokuDB/Util.pm', 'KiokuDB::Util', 'undef'],
);

require Parse::PMFile;
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
      my ($info, $errs);
      eval {
        local $SIG{ALRM} = sub { die "timeout\n" };
        alarm 30;
        ($info, $errs) = $parser->parse($file);
        alarm 0;
      };
      ok !$@ && ref $info eq ref {} && $info->{$package}{version} eq $version, "parsed successfully in time";
      ok !$@ && !$errs, "no errors";
      note $@ if $@;
      note explain $info;
      note explain $errs;
    }
  });
}

done_testing;
