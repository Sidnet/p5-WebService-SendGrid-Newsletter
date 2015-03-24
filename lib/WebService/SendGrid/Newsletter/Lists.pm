use strict;
use warnings;
package WebService::SendGrid::Newsletter::Lists;

use WebService::SendGrid::Newsletter::Lists::Email;
use parent 'WebService::SendGrid::Newsletter::Base';

=method new

Creates a new instance of WebService::SendGrid::Newsletter::Lists.

    my $lists = WebService::SendGrid::Newsletter::Lists->new(sgn => $sgn);

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

Creates a new recipient list.

Parameters:

=over 4

=item * list

B<(Required)> The name of the new recipient list.

=item * name

The name of the column for the name associated with email address.

=back

=cut

sub add {
    my ($self, %args) = @_;

    $self->_check_required_args([ qw( list ) ], %args);

    return $self->{sgn}->_send_request('lists/add', %args);
}

=method get

Retrieves all recipient lists or checks if a specific list exists.

Parameters:

=over 4

=item * list

The name of the list to retrieve.

=back

=cut

sub get {
    my ($self, %args) = @_;

    return $self->{sgn}->_send_request('lists/get', %args);
}

=method edit

Renames a list.

Parameters:

=over 4

=item * list

B<(Required)> The existing name of the list.

=item * newlist

B<(Required)> The new name for the list.

=back

=cut

sub edit {
    my ($self, %args) = @_;

    $self->_check_required_args([ qw( list newlist ) ], %args);

    return $self->{sgn}->_send_request('lists/edit', %args);
}

=method delete

Deletes a list.

Parameters:

=over 4

=item * list

B<(Required)> The name of the list to be deleted.

=back

=cut

sub delete {
    my ($self, %args) = @_;

    $self->_check_required_args([ qw( list ) ], %args);

    return $self->{sgn}->_send_request('lists/delete', %args);
}

=method email

Returns an instance of WebService::SendGrid::Newsletter::Lists::Email.

=cut

sub email {
    my ($self) = @_;
    
    if (!defined $self->{email}) {
        $self->{email} = WebService::SendGrid::Newsletter::Lists::Email->new(
            sgn => $self->{sgn}
        );
    }
    
    return $self->{email};
}

1;
