#!/usr/bin/env perl

package WebService::SendGrid::Newsletter::Test::Categories;

use strict;
use warnings;

use lib 't/lib';

use Test::More;
use Test::Exception;
use String::Random qw(random_regex);

use WebService::SendGrid::Newsletter;

use parent 'WebService::SendGrid::Newsletter::Test::Base';

my $category_name;
my $newsletter_name = 'Test Newsletter';

sub startup : Test(startup => no_plan) {
    my ($self) = @_;

    $self->SKIP_ALL('SENDGRID_API_USER and SENDGRID_API_KEY are ' .
        'required to run live tests')
        unless $ENV{SENDGRID_API_USER} && $ENV{SENDGRID_API_KEY};

    # Requires an existing newsletter in order to assign recipient to
    $self->sgn->add(
        identity => 'This is my test marketing email',
        name     => $newsletter_name,
        subject  => 'Your weekly newsletter',
        text     => 'Hello, this is your weekly newsletter',
        html     => '<h1>Hello</h1><p>This is your weekly newsletter</p>'
    );

    sleep(60);

    $category_name = random_regex('[A-Z]{5}[a-z]{5}');
}

sub shutdown : Test(shutdown) {
    my ($self) = @_;

    $self->sgn->delete(name => $newsletter_name);
}

sub categories : Tests {
    my ($self) = @_;

    throws_ok 
        { 
            $self->sgn->categories->create() 
        } 
        qr/Required parameter 'category' is not defined/, 
        'An exception is thrown when a required parameter is missing';

    $self->sgn->categories->create(category => $category_name);
    $self->expect_success($self->sgn, 'Creating a new category');
  
    throws_ok 
        { 
            $self->sgn->categories->add(category => $category_name);
        } 
        qr/Required parameter 'name' is not defined/, 
        'An exception is thrown when a required parameter is missing';

    $self->sgn->categories->add(category => $category_name, name => $newsletter_name);
    $self->expect_success($self->sgn, 'Assigning category to a newletter');

    $self->sgn->categories->list();
    $self->expect_success($self->sgn, 'Listing category');

    throws_ok
        {
            $self->sgn->categories->remove->();
        }
        qr/Required parameter 'name' is not defined/, 
        'An exception is thrown when a required parameter is missing';

    $self->sgn->categories->remove(category => $category_name, name => $newsletter_name);
    $self->expect_success($self->sgn, 'Removing a category');

}

Test::Class->runtests;
