use strict;
use warnings;
package WebService::SendGrid::Newsletter::Categories;

use parent 'WebService::SendGrid::Newsletter::Base';

=method new

Creates a new instance of WebService::SendGrid::Newsletter::Categories.

    my $lists = WebService::SendGrid::Newsletter::Categories->new(sgn => $sgn);

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

=method create

Creates a new category.

Parameters:

=over 4

=item * C<category>

B<(Required)> The name of the new category.

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

=item * C<category>

B<(Required)> The name of the category to be added to the newsletter.

=item * C<name>

B<(Required)> The name of the newsletter to add the category to.

=back

=cut

sub add {
    my ($self, %args) = @_;

    $self->_check_required_args([ qw( category name ) ], %args);

    return $self->{sgn}->_send_request('category/add', %args);
}

=method list

Lists all categories or check if a specific category exists.

Parameters:

=over 4

=item * C<category>

The name of the category to check.

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

=item * C<name>

B<(Required)> The name of the newsletter to remove categories from.

=item * C<category>

The name of the category to be removed. If not specified, all categories will be
removed.

=back

=cut

sub remove {
    my ($self, %args) = @_;

    $self->_check_required_args([ qw( name ) ], %args);

    return $self->{sgn}->_send_request('category/remove', %args);
}

1;
