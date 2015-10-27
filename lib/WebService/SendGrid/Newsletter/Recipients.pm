use strict;
use warnings;
package WebService::SendGrid::Newsletter::Recipients;

use parent 'WebService::SendGrid::Newsletter::Base';

=method new

Creates a new instance of WebService::SendGrid::Newsletter::Recipients.

    my $recipients = WebService::SendGrid::Newsletter::Recipients->new(sgn => $sgn);

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

Assigns a recipients list to a newsletter.

Parameters:

=over 4

=item * C<name>

B<(Required)> The name of the newsletter.

=item * C<list>

B<(Required)> The name of the recipients list.

=back

=cut

sub add {
    my ($self, %args) = @_;

    $self->_check_required_args([ qw( name list ) ], %args);

    $self->{sgn}->_send_request('recipients/add', %args);
}

=method get

Retrieves all recipient lists assigned to the specified newsletter.

Parameters:

=over 4

=item * C<name>

B<(Required)> The name of the newsletter for which to retrieve lists.

=back

=cut

sub get {
    my ($self, %args) = @_;

    $self->_check_required_args([ qw( name ) ], %args);
    
    $self->{sgn}->_send_request('recipients/get', %args);
}

=method delete

Removes a recipient list from the specified newsletter.

Parameters:

=over 4

=item * C<name>

B<(Required)> The name of the newsletter from which to remove the list.

=item * C<list>

B<(Required)> The name of the list to be removed.

=back

=cut

sub delete {
    my ($self, %args) = @_;

    $self->_check_required_args([ qw( name list ) ], %args);
    
    $self->{sgn}->_send_request('recipients/delete', %args);
}

1;
