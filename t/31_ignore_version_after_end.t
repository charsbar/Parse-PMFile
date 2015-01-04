use strict;
use warnings;
use Test::More;
use Parse::PMFile;

use lib 't/lib';
use TempModule;

my $module = <<'MODULE';
package Parse::PMFile::Test;

__END__
our $VERSION = "0.01";
MODULE

my $pmfile = temp_module('Test.pm', $module);

for (0..1) {
  no warnings 'once';
  local $Parse::PMFile::FORK = $_;
  my $parser = Parse::PMFile->new;
  my $info = $parser->parse($pmfile);

  ok $info->{'Parse::PMFile::Test'}{version} eq 'undef';
  note explain $info;
}

done_testing;
