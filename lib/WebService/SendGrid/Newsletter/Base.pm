use strict;
use warnings;
package WebService::SendGrid::Newsletter::Base;

use Carp;

# Checks if the required arguments are present

sub _check_required_args {
    my ($self, $required_args, %args) = @_;

    foreach my $arg ( @{$required_args} ) {
        if (!exists $args{$arg}) {
            croak "Required parameter '$arg' is not defined";
        }
    }
}

1;
