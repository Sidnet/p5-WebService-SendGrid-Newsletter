#!/usr/bin/env perl

package WebService::SendGrid::Newsletter::Test::Lists;

use strict;
use warnings;

use lib 't/lib';

use Test::More;
use Test::Exception;

use WebService::SendGrid::Newsletter;

use parent 'WebService::SendGrid::Newsletter::Test::Base';

my $sgn;
my $list_name       = 'Test List';
my $new_list_name   = 'New Test List';
my $name            = 'Test List Name';

sub startup : Test(startup => no_plan) {
    my ($self) = @_;

    $self->SKIP_ALL('SENDGRID_API_USER and SENDGRID_API_KEY are ' .
        'required to run live tests')
        unless $ENV{SENDGRID_API_USER} && $ENV{SENDGRID_API_KEY};

    $sgn = WebService::SendGrid::Newsletter->new(
        api_user => $ENV{SENDGRID_API_USER},
        api_key  => $ENV{SENDGRID_API_KEY},
    );
}

sub list : Tests {
    my ($self) = @_;

    throws_ok
        {
            $sgn->lists->add->();
        }
        qr/Required parameter 'list' is not defined/,
        'An exception is thrown when a required parameter is missing';

    $sgn->lists->add(list => $list_name, name => $name);
    $self->expect_success($sgn, 'Adding a new list');

    $sgn->lists->add(list => $list_name, name => $name);
    $self->expect_success($sgn, 'Adding a duplicate new list');
    is(
        $sgn->{last_response}->{error}, 
        "$list_name already exists",
        'An error response message is returned when the list name already exists'
    );

    $sgn->lists->edit(list => $list_name, newlist => $new_list_name);
    $self->expect_success($sgn, 'Editing list name');
    
    $sgn->lists->get();
    ok($sgn->{last_response}->[0]->{list}, 'List is found');
    $self->expect_success($sgn, 'Getting lists');

    $sgn->lists->get(list => $new_list_name);
    $self->expect_success($sgn, "$list_name already exists");

    throws_ok
        {
            $sgn->lists->email->add(list => $new_list_name)
        }
        qr/Required parameter 'data' is not defined/, 
        'An exception is thrown when a required parameter is missing';
    
    $sgn->lists->email->add(
        list => $new_list_name,
        data => { 
            name  => 'Some One', 
            email => 'someone@example.com' 
        }
    );
    $self->expect_success($sgn, 'Adding a new email');

    throws_ok
        {
            $sgn->lists->delete->();
        }
        qr/Required parameter 'list' is not defined/, 
        'An exception is thrown when a required parameter is missing';

    $sgn->lists->delete(list => $new_list_name);
    $self->expect_success($sgn, 'Deleting a list');
}



Test::Class->runtests;
