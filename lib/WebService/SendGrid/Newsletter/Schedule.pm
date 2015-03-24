use strict;
use warnings;
package WebService::SendGrid::Newsletter::Schedule;

use parent 'WebService::SendGrid::Newsletter::Base';

=method new

Creates a new instance of WebService::SendGrid::Newsletter::Schedule.

    my $schedule = WebService::SendGrid::Newsletter::Schedule->new(sgn => $sgn);

Parameters:

=over 4

=item * sgn

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

=item * name

B<(Required)> Existing newsletter to schedule delivery for.

=item * at

Date/Time to schedule newsletter must be provided
in format (YYYY-MM-DDTHH:MM:SS+-HH:MM).

=item * after

Positive number of minutes until devivery should occur.

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

=item * name

B<(Required)> Specific existing newsletter to be retrieved
the delivery time schedule.

=back

=cut

sub get {
    my ($self, %args) = @_;

    $self->_check_required_args([ qw( name ) ], %args);

    $self->{sgn}->_send_request('schedule/get', %args);
}

=method delete

Removes a schedule send for a newsletter

Parameters:

=over 4

=item * name

B<(Required)> Existing newsletter to be removed schedule delivery time

=back

=cut

sub delete {
    my ($self, %args) = @_;
    
    $self->_check_required_args([ qw( name ) ], %args);

    $self->{sgn}->_send_request('schedule/delete', %args);
}

1;
