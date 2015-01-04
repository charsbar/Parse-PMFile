use strict;
use warnings;
use Test::More;
use Parse::PMFile;

use lib 't/lib';
use TempModule;

my $module = <<'MODULE';
package Parse::PMFile::Test;
$Parse::PMFile::Test::VERSION = version->declare("v0.0.1");
MODULE

my $pmfile = temp_module('Test.pm', $module);

for (0..1) {
  no warnings 'once';
  local $Parse::PMFile::FORK = $_;
  my $parser = Parse::PMFile->new;
  my $info = $parser->parse($pmfile);

  ok $info->{'Parse::PMFile::Test'}{version} eq '0.000001';
  note explain $info;
}

done_testing;
