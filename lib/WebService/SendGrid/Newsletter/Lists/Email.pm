use strict;
use warnings;
package WebService::SendGrid::Newsletter::Lists::Email;

use JSON;
use parent 'WebService::SendGrid::Newsletter::Base';

=method new

Creates a new instance of WebService::SendGrid::Newsletter::Lists::Email.

    my $email = WebService::SendGrid::Newsletter::Lists::Email->new(
        sgn => $sgn
    );

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

Adds one or more emails to a recipient list.

Parameters:

=over 4

=item * list

B<(Required)> Existing list to be added email address to.

=item * data

B<(Required)> A reference to an array or a hash that specifies the name,
email address, and additional fields to add to the specified recipient list.

=back

=cut

sub add {
    my ($self, %args) = @_;
    
    $self->_check_required_args([ qw( list data ) ], %args);

    if (ref $args{data} eq 'HASH') {
        # Data is a hashref -- turn it into JSON
        $args{data} = encode_json $args{data};
    }
    elsif (ref $args{data} eq 'ARRAY') {
        # Data is an arrayref of hashrefs -- turn each item into JSON
        $args{data} = [ map { encode_json $_; } @{$args{data}} ];
    }
    
    return $self->{sgn}->_send_request('lists/email/add', %args);
}

1;
