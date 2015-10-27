use strict;
use warnings;
package WebService::SendGrid::Newsletter::Schedule;

use parent 'WebService::SendGrid::Newsletter::Base';

=method new

Creates a new instance of WebService::SendGrid::Newsletter::Schedule.

    my $schedule = WebService::SendGrid::Newsletter::Schedule->new(sgn => $sgn);

Parameters:

=over 4

=item * C<sgn>

An instance of WebService::SendGrid::Newsletter.

=back

=cut

sub new {
    my ($class, %args) = @_;

    my $self = {};
    bless($self, $class);
    
    $self->{sgn} = $args{sgn};
    
    return $self;
}

=method add

Schedules a delivery time for an existing newsletter.

Parameters:

=over 4

=item * C<name>

B<(Required)> The name of the newsletter to schedule delivery for.

=item * C<at>

Date/time of the scheduled delivery (must be provided in the
C<YYYY-MM-DDTHH:MM:SS+-HH:MM> format).

=item * C<after>

The number of minutes until delivery time (must be positive).

=back

=cut

sub add {
    my ($self, %args) = @_;

    $self->_check_required_args([ qw( name ) ], %args);

    $self->{sgn}->_send_request('schedule/add', %args);
}

=method get

Retrieves the scheduled delivery time for an existing newsletter.

Parameters:

=over 4

=item * C<name>

B<(Required)> The name of the newsletter for which to retrieve the scheduled
delivery time.

=back

=cut

sub get {
    my ($self, %args) = @_;

    $self->_check_required_args([ qw( name ) ], %args);

    $self->{sgn}->_send_request('schedule/get', %args);
}

=method delete

Removes a scheduled send for a newsletter.

Parameters:

=over 4

=item * C<name>

B<(Required)> The name of the newsletter for which to remove the scheduled
delivery time.

=back

=cut

sub delete {
    my ($self, %args) = @_;
    
    $self->_check_required_args([ qw( name ) ], %args);

    $self->{sgn}->_send_request('schedule/delete', %args);
}

1;
