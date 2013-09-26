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

my $eumm = eval $ExtUtils::MakeMaker::VERSION;
delete $params{LICENSE}          if $eumm < 6.31;
delete $params{META_MERGE}       if $eumm < 6.46;

if ($eumm < 6.5503 && $params{BUILD_REQUIRES}) {
    $params{PREREQ_PM} = {
        %{ $params{PREREQ_PM}      || {} },
        %{ $params{BUILD_REQUIRES} },
    };
    delete $params{BUILD_REQUIRES};
}

WriteMakefile(%params);
