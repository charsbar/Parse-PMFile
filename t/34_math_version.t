use strict;
use warnings;
use Test::More;
use Parse::PMFile;

use lib 't/lib';
use TempModule;

my $module = <<'MODULE';
package Parse::PMFile::Test;
# from Acme-Pi-3
my $version = atan2(1,1) * 4; $Parse::PMFile::Test::VERSION = "$version";
MODULE

my $pmfile = temp_module('Test.pm', $module);

for (0..1) {
  no warnings 'once';
  local $Parse::PMFile::FORK = $_;
  my $parser = Parse::PMFile->new;
  my $info = $parser->parse($pmfile);

  is substr($info->{'Parse::PMFile::Test'}{version} || '', 0, 4) => "3.14";
  #note explain $info;
}

done_testing;
