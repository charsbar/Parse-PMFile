use strict;
use warnings;
use Test::More;
use Parse::PMFile;
use File::Temp;
use Test::Deep;

plan skip_all => "requires WorePAN" unless eval "use WorePAN 0.09; 1";

my @tests = (
  ['MAUKE/Acme-Lvalue-0.03.tar.gz', 'lib/Acme/Lvalue.pm', 'Acme::Lvalue', '0.03'],
  ['JHTHORSEN/App-git-ship-0.07.tar.gz', 'lib/App/git/ship/perl.pm', 'App::git::ship::perl', 'undef'],
  ['MLEHMANN/common-sense-3.72.tar.gz', 'sense.pm.PL', 'common::sense', '3.72'],
  ['DOY/KiokuDB-0.54.tar.gz', 'lib/KiokuDB/Util.pm', 'KiokuDB::Util', 'undef'],
  ['LBROCARD/Module-CPANTS-0.005.tar.gz', 'lib/Module/CPANTS.pm', 'Module::CPANTS', '0.005'],
  ['SRI/Mojolicious-4.23.tar.gz', 'lib/Mojolicious/Command/generate/plugin.pm', 'Mojolicious::Command::generate::plugin', 'undef'],
  ['JTBRAUN/Parse-RecDescent-1.967009.tar.gz', 'lib/Parse/RecDescent.pm', 'Parse::RecDescent', '1.967009'],
  ['HAYASHI/Win32API-MIDI-0.05.tar.gz', 'MIDI/Out.pm', 'Win32API::MIDI::Out', 'undef'],
  ['CJFIELDS/BioPerl-1.6.923.tar.gz', 'Bio/Root/RootI.pm', 'Bio::Root::RootI', 'undef'], # version comparison
  ['FAYLAND/Dist-Zilla-Plugin-ReadmeFromPod-0.30.tar.gz', 'lib/Dist/Zilla/Plugin/ReadmeFromPod.pm', 'Dist::Zilla::Plugin::ReadmeFromPod', '0.30'],
  ['RRWO/Pod-Readme-v1.1.2.tar.gz', 'lib/Pod/Readme.pm', 'Pod::Readme', '1.001002'],

  # our $VERSION in a block
  ['ETHER/Test-Warnings-0.019.tar.gz', 'lib/Test/Warnings.pm', 'Test::Warnings', '0.019'],

  # normalize
  ['BORISD/EBook-MOBI-0.69.tar.gz', 'lib/EBook/MOBI/MobiPerl/MobiHeader.pm', 'EBook::MOBI::Palm::Doc', 'undef', 'normalize'],
  ['PIP/Games-Cards-Poker-1.2.4CCJ12M.tgz', 'Poker.pm', 'Games::Cards::Poker', 'undef', 'normalize'],
  ['PIP/XML-Tidy-1.12.B55J2qn.tgz', 'Tidy.pm', 'XML::Tidy', 'undef', 'normalize'], # 1.12.B55J2qn

  # parse_version
  ['SEANO/sepia-0.61.tgz', 'Xref.pm', 'Sepia::Xref', 'undef', 'parse_version'],

  # too long version
  ['REEDFISH/Net-FullAuto-0.9999999999999928.tar.gz', 'lib/Net/FullAuto.pm', 'Net::FullAuto', undef, 'long_version'],

  # version.pm
  ['MIYAGAWA/CPAN-Test-Dummy-Perl5-VersionDeclare-v0.0.1.tar.gz', 'lib/CPAN/Test/Dummy/Perl5/VersionDeclare.pm', 'CPAN::Test::Dummy::Perl5::VersionDeclare', '0.000001'],
  ['MIYAGAWA/CPAN-Test-Dummy-Perl5-VersionQV-v0.1.0.tar.gz', 'lib/CPAN/Test/Dummy/Perl5/VersionQV.pm', 'CPAN::Test::Dummy::Perl5::VersionQV', '0.001000'],

  # from cpanminus/xt/meta.t
  ['MIYAGAWA/Hash-MultiValue-0.10.tar.gz', 'lib/Hash/MultiValue.pm', 'Hash::MultiValue', '0.10'],
  ['MIYAGAWA/Module-CPANfile-0.9035.tar.gz', 'lib/Module/CPANfile.pm', 'Module::CPANfile', '0.9035'],
  ['TYEMQ/Algorithm-Diff-1.1902.tar.gz', 'lib/Algorithm/Diff.pm', 'Algorithm::Diff', '1.1902'],
  ['ADAMK/Test-Object-0.07.tar.gz', 'lib/Test/Object.pm', 'Test::Object', '0.07'],
  ['GAAS/IO-String-1.08.tar.gz', 'String.pm', 'IO::String', '1.08'],
  ['RCLAMP/Class-Accessor-Chained-0.01.tar.gz', 'lib/Class/Accessor/Chained.pm', 'Class::Accessor::Chained', '0.01'],
  ['ROODE/Readonly-1.03.tar.gz', 'Readonly.pm', 'Readonly', '1.03'],
  ['ACG/Scrabble-Dict-0.01.tar.gz', 'lib/Scrabble/Dict.pm', 'Scrabble::Dict', '0.01'],

  # BOM
  ['DANKOGAI/Lingua-JA-Numbers-0.05.tar.gz', 'lib/Lingua/JA/Numbers.pm', 'Lingua::JA::Numbers', '0.05'],

  # experimental class
  ['RWP/App-APA-0.230470.tar.gz', 'lib/App/APA.pm', 'App::APA', 'undef'],

  # Feature::Compat::Class class
  ['DAVECROSS/Amazon-Sites-0.1.6.tar.gz', 'lib/Amazon/Sites.pm', 'Amazon::Sites', '0.001006'],

  # Object::Pad class
  ['DRCLAW/File-Meta-Cache-v0.3.0.tar.gz', 'lib/File/Meta/Cache.pm', 'File::Meta::Cache', '0.003000'],

  # XXX: Inline::Python class (from Python)
  ['BSHANKS/Wiki-Gateway-0.001991.tar.gz', 'lib/Wiki/Gateway.pm', 'Wiki::Gateway', '0.001991', undef, []],

  # XXX: class (and package) in a heredoc (std should be ignored...)
  ['MSILVA/Language-Tea-0.03.tar.gz', 'lib/Language/Tea/JavaEmitter.pm', 'Language::Tea::JavaEmitter', 'undef', undef, []],
  ['WSNYDER/Verilog-Perl-3.482.tar.gz', 'Std.pm', 'Verilog::Std', '3.482', undef, [qw(std)]],

  # XXX: Class::HPLOO class
  ['GMPASSOS/Class-HPLOO-0.23.tar.gz', 'test/testsuper.pm', undef],

  # XXX: MooseX::Declare class
  ['RGE/App-Syndicator-0.0061.tar.gz', 'lib/App/Syndicator.pm', 'App::Syndicator', '0.0061', undef, []],

  # XXX: Ambrosia::Meta
  ['KNM/Ambrosia-0.010.tar.gz', 'lib/Ambrosia/Addons/Accessor.pm', 'Ambrosia::Addons::Accessor', '0.01', undef, [qw(Ambrosia::Addons::Accessor::Result)]],

  # XXX: Moops
  ['PERLANCAR/Perl-Examples-Accessors-0.132.tar.gz', 'lib/Perl/Examples/Accessors/Moops.pm', 'Perl::Examples::Accessors::Moops', '0.132', undef, []],

  # XXX: Zydeco
  ['LNATION/Mxpress-PDF-Mechanize-0.04.tar.gz', 'lib/Mxpress/PDF/Mechanize.pm', 'Mxpress::PDF::Mechanize', '0.04', undef, []],

  # XXX: multi-lined @EXPORT?
  ['INGY/Lingy-0.1.19.tar.gz', 'lib/Lingy/Common.pm', 'Lingy::Common', 'undef', undef, []],
);

push @tests, (
  ['A/AD/ADAMK/Acme-BadExample-1.01.tar.gz', 'lib/Acme/BadExample.pm', 'Acme::BadExample', 'undef'],
) unless $] < 5.010000;

push @tests, (
  ['KITOMER/App-XUL-0.07.tar.gz', 'lib/App/XUL.pm', 'Eventhandlers', undef],
);

my $root = File::Temp::tempdir(CLEANUP => 1);

for my $test (@tests) {
  my ($path, $pmfile, $package, $version, $error_name, $extra_packages) = @$test;
  note "downloading $path...";

  my $worepan = WorePAN->new(
    no_network => 0,
    use_backpan => 1,
    cleanup => 1,
    no_indices => 1,
    files => [$path],
    root => $root,
  );

  note "parsing $path...";

  $worepan->walk(callback => sub {
    my $dir = shift;
    my $file = $dir->file($pmfile);
    my $parser = Parse::PMFile->new;

    my @errors;
    for my $fork (0..1) {
      no warnings 'once';
      local $Parse::PMFile::FORK = $fork;
      my ($info, $error);
      eval {
        local $SIG{ALRM} = sub { die "timeout\n" };
        alarm 30;
        ($info, $error) = $parser->parse($file);
        alarm 0;
      };
      my $exception = $@;
      if (!defined $package) {
        ok !$exception && ref $info eq ref {} && %$info == 0, "empty" or note explain $info;
        next;
      }
      if (defined $version) {
        ok !$exception && ref $info eq ref {} && $info->{$package}{version} eq $version, "parsed successfully in time";
      } else {
        ok !$exception && ref $info eq ref {} && !$info->{$package}{version}, "parsed successfully in time";
      }
      if ($error_name) {
        ok !$exception && ref $error eq ref {} && $error->{$package}{$error_name}, "returned error";
      }
      if ($extra_packages) {
        my @expected = ($package, @$extra_packages);
        my @packages = keys %$info;
        cmp_bag \@packages => \@expected, "no other packages found" or note explain [grep {$_ ne $package} @packages];
      }
      push @errors, $error if $error;
      note $exception if $exception;
      note explain $error if $error;
      note explain $info;
    }
    if (@errors) {
      is_deeply $errors[0] => $errors[1];
    }
  });
}

done_testing;

