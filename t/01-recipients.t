#!/usr/bin/env perl

package WebService::SendGrid::Newsletter::Test::Recipients;

use strict;
use warnings;

use lib 't/lib';

use Test::More;
use Test::Exception;

use WebService::SendGrid::Newsletter;

use parent 'WebService::SendGrid::Newsletter::Test::Base';

my $sgn;
my $list_name       = 'Test List';
my $newsletter_name = 'Test Newsletter';

sub startup : Test(startup => no_plan) {
    my ($self) = @_;

    $self->SKIP_ALL('SENDGRID_API_USER and SENDGRID_API_KEY are ' .
        'required to run live tests')
        unless $ENV{SENDGRID_API_USER} && $ENV{SENDGRID_API_KEY};

    $sgn = WebService::SendGrid::Newsletter->new(
        api_user => $ENV{SENDGRID_API_USER},
        api_key  => $ENV{SENDGRID_API_KEY},
    );

    # Requires an existing newsletter in order to assign recipient to
    $sgn->add(
        identity => 'This is my test marketing email',
        name     => $newsletter_name,
        subject  => 'Your weekly newsletter',
        text     => 'Hello, this is your weekly newsletter',
        html     => '<h1>Hello</h1><p>This is your weekly newsletter</p>'
    );

    # Give SendGrid some time for the changes to become effective
    sleep(60);
}

sub lists : Tests {
    my ($self) = @_;

    throws_ok
        {
            $sgn->recipients->add->();
        }
        qr/Required parameter 'name' is not defined/,
        'An exception is thrown when a required parameter is missing';

    $sgn->recipients->add(list => $list_name, name => $newsletter_name);
    $self->expect_success($sgn, 'Adding a new list');

    throws_ok
        {
            $sgn->recipients->get->();
        }
        qr/Required parameter 'name' is not defined/,
        'An exception is thrown when a required parameter is missing';

    $sgn->recipients->get(name => $newsletter_name);
    $self->expect_success($sgn, "Getting recipients of specific newsletter");

    throws_ok
        {
            $sgn->recipients->delete->();
        }
        qr/Required parameter 'name' is not defined/, 
        'An exception is thrown when a required parameter is missing';

    $sgn->recipients->delete(list => $list_name, name => $newsletter_name);
    $self->expect_success($sgn, 'Deleting a list');
}

Test::Class->runtests;
