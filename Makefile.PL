use strict;
use warnings;
use ExtUtils::MakeMaker;

my %params = (
    NAME          => 'Parse::PMFile',
    AUTHOR        => 'Kenichi Ishigaki <ishigaki@cpan.org>',
    VERSION_FROM  => 'lib/Parse/PMFile.pm',
    ABSTRACT_FROM => 'lib/Parse/PMFile.pm',
    LICENSE       => 'perl',
    PREREQ_PM     => {
        'CPAN::Version' => 0,
        'Dumpvalue' => 0,
        'File::Spec' => 0,
        'File::Temp' => 0,
        'JSON::PP' => '2.00',
        'Safe' => 0,
        'version' => '0.79',
    },
    BUILD_REQUIRES => {
        'Test::More'          => '0.88',
    },
    META_MERGE => {
        resources => {
            repository => 'https://github.com/charsbar/Parse-PMFile',
        },
    },
);

my $eumm = $ExtUtils::MakeMaker::VERSION;
delete $params{LICENSE}          if $eumm < 6.31;
delete $params{META_MERGE}       if $eumm < 6.46;

WriteMakefile(%params);
