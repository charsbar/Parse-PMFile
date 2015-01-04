use strict;
use warnings;
package TempModule;

use Test::More;
use Test::TempDir::Tiny;

use Exporter 5.57 'import';
our @EXPORT = qw(temp_module);

# prepares a tempdir with a Test.pm containing specified content
sub temp_module {
    my ($filename, $content) = @_;

    my $tmpdir = eval { tempdir() };
    plan skip_all => "tmpdir is not ready: $@" unless !$@ && -e $tmpdir && -w $tmpdir;

    my $pmfile = "$tmpdir/$filename";
    {
        open my $fh, '>', $pmfile or plan skip_all => "Failed to create a pmfile";
        print $fh $content;
        close $fh;
    }

    return $pmfile;
}

1;
