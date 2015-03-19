use strict;
use warnings;
package WebService::SendGrid::Newsletter::Lists;

use WebService::SendGrid::Newsletter::Lists::Email;

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

B<(Required)> Create a recipient list with this name.

=item * name

Specify column name for the name associated with email addresses.

=back

=cut

sub add {
    my ($self, %args) = @_;


    return $self->{sgn}->_send_request('lists/add', %args);
}

=method get

Retreive all recipient lists or check if specific list exists

Parameters:

=over 4

=item * list

Check whether this specific list exists on the account

=back

=cut

sub get {
    my ($self, %args) = @_;

    return $self->{sgn}->_send_request('lists/get', %args);
}

=method edit

Rename a list.

Parameters:

=over 4

=item * list

B<(Required)> Existing list to be renamed.

=item * newlist

B<(Required)> New name for the specific list.

=back

=cut

sub edit {
    my ($self, %args) = @_;

    return $self->{sgn}->_send_request('lists/edit', %args);
}

=method delete

Delete a list.

Parameters:

=over 4

=item * list

B<(Required)> Existing list to be removed.

=back

=cut

sub delete {
    my ($self, %args) = @_;

    return $self->{sgn}->_send_request('lists/delete', %args);
}

=method email

Create instance of Lists::Email

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
