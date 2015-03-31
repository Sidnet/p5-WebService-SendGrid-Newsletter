use strict;
use warnings;
package WebService::SendGrid::Newsletter::Categories;

use parent 'WebService::SendGrid::Newsletter::Base';

=method new

Creates a new instance of WebService::SendGrid::Newsletter::Categories.

    my $lists = WebService::SendGrid::Newsletter::Categories->new(sgn => $sgn);

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

=method create

Creates a new category.

Parameters:

=over 4

=item * category

B<(Required)> The name of new category.

=back

=cut

sub create {
    my ($self, %args) = @_;

    $self->_check_required_args([ qw( category ) ], %args);

    return $self->{sgn}->_send_request('category/create', %args);
}

=method add

Assigns a category to an existing newsletter.

Parameters:

=over 4

=item * category

B<(Required)> The existing category to be added to newsletter.

=item * name

B<(Required)> The existing newsletter to which the categories will be added to.

=back

=cut

sub add {
    my ($self, %args) = @_;

    $self->_check_required_args([ qw( category name ) ], %args);

    return $self->{sgn}->_send_request('category/add', %args);
}

=method list

Lists all categories or check whether the specific category exists.

Parameters:

=over 4

=item * category

B<(Required)> The existing category to check.

=back

=cut

sub list {
    my ($self, %args) = @_;

    return $self->{sgn}->_send_request('category/list', %args);
}

=method remove

Removes a specific category, or all categories from a newsletter.

Parameters:

=over 4

=item * name

B<(Required)> The existing that will have category(ies) unassigned from it.

=item * category

B<(Required)> The specific category to be unassigned from the news letter.
If the category is no specified all categories will be removed.

=back

=cut

sub remove {
    my ($self, %args) = @_;

    $self->_check_required_args([ qw( name ) ], %args);

    return $self->{sgn}->_send_request('category/remove', %args);
}

1;
