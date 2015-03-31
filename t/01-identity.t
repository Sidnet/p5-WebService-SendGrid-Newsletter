#!/usr/bin/env perl

package WebService::SendGrid::Newsletter::Test::Identity;

use strict;
use warnings;

use lib 't/lib';

use Test::More;
use Test::Exception;

use WebService::SendGrid::Newsletter;

use parent 'WebService::SendGrid::Newsletter::Test::Base';

my $sgn;
my $identity     = 'Testing Address';
my $email        = 'someone@example.com';
my $new_name     = 'The New Commpany Name';

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

sub identity : Tests {
    my ($self) = @_;

    throws_ok 
        {
            $sgn->identity->add(name => 'name') 
        }
        qr/Required parameter 'identity' is not defined/, 
        'An exception is thrown when a required parameter is missing';


    $sgn->identity->add(
        identity => $identity,
        name     => 'A commpany name',
        email    => 'commpany@example.com',
        address  => 'Some street 123',
        city     => 'Hannover',
        zip      => '10220',
        state    => 'DEU',
        country  => 'Germany',
        replyto  => 'replythis@example.com',
    );
    $self->expect_success($sgn, 'Creating a new sender address');

    $sgn->identity->edit(
        identity    => $identity,
        name        => $new_name,
        email       => $email,
    );
    $self->expect_success($sgn, 'Editing a sender address');

    throws_ok 
        {
            $sgn->identity->get() 
        }
        qr/Required parameter 'identity' is not defined/, 
        'An exception is thrown when a required parameter is missing';

    $sgn->identity->get(identity => $identity);
    is(
        $sgn->{last_response}->{name}, 
        $new_name, 
        'An expected name of sender is found'
    );
    $self->expect_success($sgn, 'Getting sender address');

    $sgn->identity->list(identity => $identity);
    is($sgn->{last_response}->[0]->{identity}, $identity, "$identity exists on the account");
    $self->expect_success($sgn, 'Checking if specific sender address exists');

    $sgn->identity->list();
    ok($sgn->{last_response}->[0]->{identity}, 'Get list of sender address');
    $self->expect_success($sgn, 'Listing sender addresses');

    throws_ok
        {
            $sgn->identity->delete() 
        }
        qr/Required parameter 'identity' is not defined/, 
        'An exception is thrown when a required parameter is missing';

    $sgn->identity->delete(identity => $identity);
    $self->expect_success($sgn, 'Deleting sender address');
}

Test::Class->runtests;
