use strict;
use warnings;
use Test::More;
use Parse::PMFile;

use lib 't/lib';
use TempModule;

my $module = <<'MODULE';
package Parse::PMFile::Test;
our $VERSION = "0.01_01";
MODULE

my $pmfile = temp_module('Test.pm', $module);

for (0..1) {
  no warnings 'once';
  local $Parse::PMFile::FORK = $_;
  local $Parse::PMFile::ALLOW_DEV_VERSION = 0;
  my $parser = Parse::PMFile->new;
  my $info = $parser->parse($pmfile);

  ok !$info->{'Parse::PMFile::Test'}{version};
  note explain $info;
}

for (0..1) {
  no warnings 'once';
  local $Parse::PMFile::FORK = $_;
  local $Parse::PMFile::ALLOW_DEV_VERSION = 0;
  my $parser = Parse::PMFile->new({
    provides => {
      'Parse::PMFile::Test' => {
        version => '0.01_01',
      },
    },
  });
  my $info = $parser->parse($pmfile);

  ok !$info->{'Parse::PMFile::Test'}{version};
  note explain $info;
}

for (0..1) {
  no warnings 'once';
  local $Parse::PMFile::FORK = $_;
  local $Parse::PMFile::ALLOW_DEV_VERSION = 1;
  my $parser = Parse::PMFile->new;
  my $info = $parser->parse($pmfile);

  ok $info->{'Parse::PMFile::Test'}{version} eq '0.01_01';
  note explain $info;
}

for (0..1) {
  no warnings 'once';
  local $Parse::PMFile::FORK = $_;
  local $Parse::PMFile::ALLOW_DEV_VERSION = 1;
  my $parser = Parse::PMFile->new({
    provides => {
      'Parse::PMFile::Test' => {
        version => '0.01_01',
      },
    },
  });
  my $info = $parser->parse($pmfile);

  ok $info->{'Parse::PMFile::Test'}{version} eq '0.01_01';
  note explain $info;
}

done_testing;
