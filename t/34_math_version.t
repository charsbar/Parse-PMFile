use strict;
use warnings;
use Test::More;
use Parse::PMFile;
use File::Temp;

my $tmpdir = File::Temp->newdir(CLEANUP => 1);
plan skip_all => "tmpdir is not ready" unless -e $tmpdir && -w $tmpdir;

my $pmfile = "$tmpdir/Test.pm";

open my $fh, '>', $pmfile or plan skip_all => "Failed to create a pmfile";
print $fh "package " . "Parse::PMFile::Test;\n";
print $fh 'my $version = atan2(1,1) * 4; $Parse::PMFile::Test::VERSION = "$version";', "\n";  # from Acme-Pi-3
close $fh;

for (0..1) {
  no warnings 'once';
  local $Parse::PMFile::FORK = $_;
  my $parser = Parse::PMFile->new;
  my $info = $parser->parse($pmfile);

  is substr($info->{'Parse::PMFile::Test'}{version} || '', 0, 4) => "3.14";
  #note explain $info;
}

done_testing;

