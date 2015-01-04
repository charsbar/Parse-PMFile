use strict;
use warnings;
use Test::More;
use Parse::PMFile;

use lib 't/lib';
use TempModule;

my $module = <<'MODULE';
package Parse::PMFile::Test;
our $VERSION = sprintf("%d.%02d", q$Revision: 1.12 $=~/(\d+)\.(\d+)/);
MODULE

my $pmfile = temp_module('Test.pm', $module);

for (0..1) {
  no warnings 'once';
  local $Parse::PMFile::FORK = $_;
  my $parser = Parse::PMFile->new;
  my $info = $parser->parse($pmfile);

  is $info->{'Parse::PMFile::Test'}{version} => '1.12';
}

done_testing;
