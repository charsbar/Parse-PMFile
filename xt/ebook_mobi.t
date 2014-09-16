use strict;
use warnings;
use Test::More;

plan skip_all => "requires WorePAN" unless eval "use WorePAN 0.03; 1";
my @tests = (

  ['BORISD/EBook-MOBI-0.69.tar.gz', 'lib/EBook/MOBI/MobiPerl/MobiHeader.pm', 'EBook::MOBI::Palm::Doc', 'undef'],
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

    my @errs;
    for my $fork (0..1) {
      no warnings 'once';
      local $Parse::PMFile::FORK = $fork;
      my ($info, $err);
      eval {
        local $SIG{ALRM} = sub { die "timeout\n" };
        alarm 30;
        ($info, $err) = $parser->parse($file);
        alarm 0;
      };
      ok !$@ && ref $info eq ref {} && $info->{$package}{version} eq 'undef', "parsed successfully in time";
      $errs[$fork] = $err->{"EBook::MOBI::Palm::Doc"}{normalize};
      note $@ if $@;
#      note explain $info;
#      note explain $err;
    }
    is $errs[0] => $errs[1];
  });
}

done_testing;
