use strict;
use warnings;
package WebService::SendGrid::Newsletter::Identity;

use parent 'WebService::SendGrid::Newsletter::Base';

=method new

Creates a new instance of WebService::SendGrid::Newsletter::Identity.

    my $recipients = WebService::SendGrid::Newsletter::Identity->new(sgn => $sgn);

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

Creates a new identity.

Parameters:

=over 4

=item * C<identity>

B<(Required)> The name of the new identity.

=item * C<name>

B<(Required)> The name of the sender.

=item * C<email>

B<(Required)> The email address of the sender.

=item * C<address>

B<(Required)> The physical address.

=item * C<city>

B<(Required)> The city name.

=item * C<zip>

B<(Required)> The zip code.

=item * C<state>

B<(Required)> The state.

=item * C<country>

B<(Required)> The country name.

=item * C<replyto>

The email address to be used in the Reply-To field. If not defined, will default
to the C<email> parameter.

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

Edits an existing identity.

Parameters:

=over 4

=item * C<identity>

B<(Required)> The identity to be edited.

=item * C<newidentity>

The new name to be used for this identity.

=item * C<name>

The new name of the sender.

=item * C<email>

<(Required)> The email address of the sender.

=item * C<replyto>

The email address to be used in the Reply-To field. If not defined, will default
to the C<email> parameter.

=item * C<address>

The new physical address.

=back

=cut

sub edit {
    my ($self, %args) = @_;

    $self->_check_required_args([ qw( identity email ) ], %args);

    $self->{sgn}->_send_request('identity/edit', %args);
}

=method get

Retrieves information associated with an identity.

=over 4

=item * C<identity>

B<(Required)> The name of the identity to retrieve information for.

=back

=cut

sub get {
    my ($self, %args) = @_;

    $self->_check_required_args([ qw( identity ) ], %args);

    $self->{sgn}->_send_request('identity/get', %args);
}

=method list

Retrieves all identities on the account, or checks if a specified identity exists.

=over 4

=item * C<identity>

The name of the identity to check.

=back

=cut

sub list {
    my ($self, %args) = @_;

    $self->{sgn}->_send_request('identity/list', %args);
}

=method delete

Removes the specified identity.

=over 4

=item * C<identity>

B<(Required)> The name of the identity to remove.

=back

=cut

sub delete {
    my ($self, %args) = @_;

    $self->_check_required_args([ qw( identity ) ], %args);

    $self->{sgn}->_send_request('identity/delete', %args);
}

1;
