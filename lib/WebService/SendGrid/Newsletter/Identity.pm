use strict;
use warnings;
package WebService::SendGrid::Newsletter::Identity;

use parent 'WebService::SendGrid::Newsletter::Base';

=method new

Creates a new instance of WebService::SendGrid::Newsletter::Identity.

    my $recipients = WebService::SendGrid::Newsletter::Identity->new(sgn => $sgn);

Parameters:

=over 4

=item * sgn

An instance of WebService::SendGrid::Identity.

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

Creates a new address

Parameters:

=over 4

=item * identity

B<(Required)> A name to identify an address.

=item * name

B<(Required)> The name of the sender to be used for this address.

=item * email

B<(Required)> The email address of the sender.

=item * address

B<(Required)> The physical street address to be used for this address.

=item * city

B<(Required)> The city name.

=item * zip

B<(Required)> The zip code.

=item * state

B<(Required)> The state of the address.

=item * country

B<(Required)> The country name.

=item * replyto

A specific email to be used in for replying. If not defined,
will default to email parameter.

=back

=cut

sub add {
    my ($self, %args) = @_;

    $self->_check_required_args([ 
        qw( identity name email address city zip state country )
    ], %args);

    $self->{sgn}->_send_request('identity/add', %args);
}


=method edit

Edits an existing address.

Parameters:

=over 4

=item * identity

B<(Required)> The existing identity of the address to be edited.

=item * newidentity

The specific new identity to be used for this address.

=item * name

The new name to be used.

=item * email

<(Required)> The specific email to be used for this address.

=item * replyto

A specific email to be used in for replying. If not defined,
will default to email parameter

=item * address

The new physical address to used for this address.

=back

=cut

sub edit {
    my ($self, %args) = @_;

    $self->_check_required_args([ qw( identity email ) ], %args);

    $self->{sgn}->_send_request('identity/edit', %args);
}

=method get

Retrieves information associated with a particular address.

=item * identity

B<(Required)> The identity of a particular address to retrieve information.

=back

=cut

sub get {
    my ($self, %args) = @_;

    $self->_check_required_args([ qw( identity ) ], %args);

    $self->{sgn}->_send_request('identity/get', %args);
}

=method list

Retrives all address on the account, or check if a specified address exists.

=item * identity

The identity of an existing address to check.

=back

=cut

sub list {
    my ($self, %args) = @_;

    $self->{sgn}->_send_request('identity/list', %args);
}

=method delete

Removes an exsiting address from the account.

=item * identity

B<(Required)> The identity of an existing address to be removed.

=back

=cut

sub delete {
    my ($self, %args) = @_;

    $self->_check_required_args([ qw( identity ) ], %args);

    $self->{sgn}->_send_request('identity/delete', %args);
}

1;
