use strict;
use warnings;
use Test::More;
use Parse::PMFile;

use lib 't/lib';
use TempModule;

test('package '.'Parse::PMFile::Test', <<'TEST');
{
  $Parse::PMFile::Test::VERSION = "0.01";
}
TEST

test('package '.'Parse::PMFile::Test', <<'TEST');
{
  $VERSION = "0.01";
}
TEST

test('package '.'Parse::PMFile::Test {', <<'TEST');
  $Parse::PMFile::Test::VERSION = "0.01";
};
TEST

test('package '.'Parse::PMFile::Test {', <<'TEST');
  $VERSION = "0.01";
};
TEST

test('package '.'Parse::PMFile::Test 0.01 {', <<'TEST');
};
TEST

sub test {
  my @lines = @_;

  my $pmfile = temp_module('Test.pm', join "\n", @lines);

  for (0..1) {
    no warnings 'once';
    local $Parse::PMFile::FORK = $_;
    my $parser = Parse::PMFile->new;
    my $info = $parser->parse($pmfile);

    is $info->{'Parse::PMFile::Test'}{version} => '0.01';
    # note explain $info;
  }
}

done_testing;
