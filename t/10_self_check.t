use strict;
use warnings;
use Test::More tests => 1;
use FindBin;
use Parse::PMFile;

my $p = Parse::PMFile->new;
my $pkg = $p->parse("$FindBin::Bin/../lib/Parse/PMFile.pm");

is $pkg->{'Parse::PMFile'}{version} => $Parse::PMFile::VERSION, "version of Parse::PMFile matches \$Parse::PMFile::VERSION";
