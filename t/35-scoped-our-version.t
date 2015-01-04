use strict;
use warnings;
use Test::More;
use Parse::PMFile;

use lib 't/lib';
use TempModule;

my $module = <<'MODULE';
package Parse::PMFile::Test;
{ our $VERSION = '0.01'; }
MODULE

my $pmfile = temp_module('Test.pm', $module);

local $TODO = 'this syntax is not yet supported';

for (0..1) {
  no warnings 'once';
  local $Parse::PMFile::FORK = $_;
  local $Parse::PMFile::ALLOW_DEV_VERSION = 0;
  my $parser = Parse::PMFile->new;
  my $info = $parser->parse($pmfile);

  ok $info->{'Parse::PMFile::Test'}{version};
  note explain $info;
}

done_testing;
