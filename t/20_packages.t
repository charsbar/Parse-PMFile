use strict;
use warnings;
use Test::More;
use Parse::PMFile;
use File::Temp;

my $tmpdir = File::Temp->newdir(CLEANUP => 1);
plan skip_all => "tmpdir is not ready" unless -e $tmpdir && -w $tmpdir;

my $class   = "\x63\x6c\x61\x73\x73";
my $package = "\x70\x61\x63\x6b\x61\x67\x65";
my $role    = "\x72\x6f\x6c\x65";

# plain packages
test('undef', <<TEST);
$package Parse::PMFile::Test;
TEST
test('1.23', <<TEST);
$package Parse::PMFile::Test 1.23;
TEST
test('1.002003', <<TEST);
$package Parse::PMFile::Test v1.2.3;
TEST

# packages with blocks
test('undef', <<TEST);
$package Parse::PMFile::Test { };
TEST
test('1.23', <<TEST);
$package Parse::PMFile::Test 1.23 { };
TEST
test('1.002003', <<TEST);
$package Parse::PMFile::Test v1.2.3 { };
TEST

# scoped plain packages
test('undef', <<TEST);
{ $package Parse::PMFile::Test; }
TEST
test('1.23', <<TEST);
{ $package Parse::PMFile::Test 1.23; }
TEST
test('1.002003', <<TEST);
{ $package Parse::PMFile::Test v1.2.3; }
TEST

# scoped packages with blocks
test('undef', <<TEST);
{ $package Parse::PMFile::Test { } };
TEST
test('1.23', <<TEST);
{ $package Parse::PMFile::Test 1.23 { } };
TEST
test('1.002003', <<TEST);
{ $package Parse::PMFile::Test v1.2.3 { } };
TEST

# plain classes
test('undef', <<TEST);
use experimental 'class';
$class Parse::PMFile::Test;
TEST
test('1.23', <<TEST);
use experimental 'class';
$class Parse::PMFile::Test 1.23;
TEST
test('1.002003', <<TEST);
use experimental 'class';
$class Parse::PMFile::Test v1.2.3;
TEST

# classes with blocks
test('undef', <<TEST);
use experimental 'class';
$class Parse::PMFile::Test { };
TEST
test('1.23', <<TEST);
use experimental 'class';
$class Parse::PMFile::Test 1.23 { };
TEST
test('1.002003', <<TEST);
use experimental 'class';
$class Parse::PMFile::Test v1.2.3 { };
TEST

# scoped plain classes
test('undef', <<TEST);
{ use experimental 'class';
$class Parse::PMFile::Test; }
TEST
test('1.23', <<TEST);
{ use experimental 'class';
$class Parse::PMFile::Test 1.23; }
TEST
test('1.002003', <<TEST);
{ use experimental 'class';
$class Parse::PMFile::Test v1.2.3; }
TEST

# scoped classes with blocks
test('undef', <<TEST);
{ use experimental 'class';
$class Parse::PMFile::Test { } };
TEST
test('1.23', <<TEST);
{ use experimental 'class';
$class Parse::PMFile::Test 1.23 { } };
TEST
test('1.002003', <<TEST);
{ use experimental 'class';
$class Parse::PMFile::Test v1.2.3 { } };
TEST

# plain classes with attributes
test('undef', <<TEST);
use experimental 'class';
$class Parse::PMFile::Test :isa(Simple);
TEST
test('1.23', <<TEST);
use experimental 'class';
$class Parse::PMFile::Test 1.23 :isa(Simple);
TEST
test('1.002003', <<TEST);
use experimental 'class';
$class Parse::PMFile::Test v1.2.3 :isa(Simple);
TEST

# classes with attributes with blocks
test('undef', <<TEST);
use experimental 'class';
$class Parse::PMFile::Test :isa(Simple) { };
TEST
test('1.23', <<TEST);
use experimental 'class';
$class Parse::PMFile::Test 1.23 :isa(Simple) { };
TEST
test('1.002003', <<TEST);
use experimental 'class';
$class Parse::PMFile::Test v1.2.3 :isa(Simple) { };
TEST

# scoped classes with attributes
test('undef', <<TEST);
{ use experimental 'class';
$class Parse::PMFile::Test :isa(Simple); }
TEST
test('1.23', <<TEST);
{ use experimental 'class';
$class Parse::PMFile::Test 1.23 :isa(Simple); }
TEST
test('1.002003', <<TEST);
{ use experimental 'class';
$class Parse::PMFile::Test v1.2.3 :isa(Simple); }
TEST

# scoped classes with attributes with blocks
test('undef', <<TEST);
{ use experimental 'class';
$class Parse::PMFile::Test :isa(Simple) { } };
TEST
test('1.23', <<TEST);
{ use experimental 'class';
$class Parse::PMFile::Test 1.23 :isa(Simple) { } };
TEST
test('1.002003', <<TEST);
{ use experimental 'class';
$class Parse::PMFile::Test v1.2.3 :isa(Simple) { } };
TEST


# plain roles
test('undef', <<TEST);
use Object::Pad;
$role Parse::PMFile::Test;
TEST
test('1.23', <<TEST);
use Object::Pad;
$role Parse::PMFile::Test 1.23;
TEST
test('1.002003', <<TEST);
use Object::Pad;
$role Parse::PMFile::Test v1.2.3;
TEST

# roles with blocks
test('undef', <<TEST);
use Object::Pad;
$role Parse::PMFile::Test { };
TEST
test('1.23', <<TEST);
use Object::Pad;
$role Parse::PMFile::Test 1.23 { };
TEST
test('1.002003', <<TEST);
use Object::Pad;
$role Parse::PMFile::Test v1.2.3 { };
TEST

# plain roles
test('undef', <<TEST);
{ use Object::Pad;
$role Parse::PMFile::Test; };
TEST
test('1.23', <<TEST);
{ use Object::Pad;
$role Parse::PMFile::Test 1.23; };
TEST
test('1.002003', <<TEST);
{ use Object::Pad;
$role Parse::PMFile::Test v1.2.3; };
TEST

# scoped roles with blocks
test('undef', <<TEST);
{ use Object::Pad;
$role Parse::PMFile::Test { } };
TEST
test('1.23', <<TEST);
{ use Object::Pad;
$role Parse::PMFile::Test 1.23 { } };
TEST
test('1.002003', <<TEST);
{ use Object::Pad;
$role Parse::PMFile::Test v1.2.3 { } };
TEST

# roles with attributes
test('undef', <<TEST);
use Object::Pad;
$role Parse::PMFile::Test :does(Simple);
TEST
test('1.23', <<TEST);
use Object::Pad;
$role Parse::PMFile::Test 1.23 :does(Simple);
TEST
test('1.002003', <<TEST);
use Object::Pad;
$role Parse::PMFile::Test v1.2.3 :does(Simple);
TEST

# roles with attributes with blocks
test('undef', <<TEST);
use Object::Pad;
$role Parse::PMFile::Test :does(Simple) { };
TEST
test('1.23', <<TEST);
use Object::Pad;
$role Parse::PMFile::Test 1.23 :does(Simple) { };
TEST
test('1.002003', <<TEST);
use Object::Pad;
$role Parse::PMFile::Test v1.2.3 :does(Simple) { };
TEST

# scoped roles with attributes with blocks
test('undef', <<TEST);
{ use Object::Pad;
$role Parse::PMFile::Test :does(Simple); };
TEST
test('1.23', <<TEST);
{ use Object::Pad;
$role Parse::PMFile::Test 1.23 :does(Simple); };
TEST
test('1.002003', <<TEST);
{ use Object::Pad;
$role Parse::PMFile::Test v1.2.3 :does(Simple); };
TEST

# scoped roles with attributes with blocks
test('undef',  <<TEST);
{ use Object::Pad;
$role Parse::PMFile::Test :does(Simple) { } };
TEST
test('1.23', <<TEST);
{ use Object::Pad;
$role Parse::PMFile::Test 1.23 :does(Simple) { } };
TEST
test('1.002003', <<TEST);
{ use Object::Pad;
$role Parse::PMFile::Test v1.2.3 :does(Simple) { } };
TEST



sub test {
  my ($version, @lines) = @_;

  my $pmfile = "$tmpdir/Test.pm";

  open my $fh, '>', $pmfile or plan skip_all => "Failed to create a pmfile";
  print $fh join "\n", @lines, "";
  close $fh;

  for (0..1) {
    no warnings 'once';
    local $Parse::PMFile::FORK = $_;
    my $parser = Parse::PMFile->new;
    my $info = $parser->parse($pmfile);

    is_deeply( [ keys %{ $info } ], [ qw/ Parse::PMFile::Test / ] )
        or diag( join "\n", @lines );
    is( $parser->{VERSION} => $version )
        or diag( 'VERSION ' . join "\n", @lines );
    # note explain $info;
  }
}

done_testing;

