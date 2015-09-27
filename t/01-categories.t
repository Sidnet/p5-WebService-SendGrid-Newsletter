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

my $sgn;
my $category_name;
my $newsletter_name = 'Test Newsletter';

sub startup : Test(startup => no_plan) {
    my ($self) = @_;

    $self->SUPER::startup();

    $sgn = WebService::SendGrid::Newsletter->new(
        api_user => $self->sendgrid_api_user,
        api_key  => $self->sendgrid_api_key,
    );

    # Requires an existing newsletter in order to assign recipient to
    $sgn->add(
        identity => 'This is my test marketing email',
        name     => $newsletter_name,
        subject  => 'Your weekly newsletter',
        text     => 'Hello, this is your weekly newsletter',
        html     => '<h1>Hello</h1><p>This is your weekly newsletter</p>'
    );

    if ($ENV{CAPTURE_DATA}) {
        # Sleep for a minute to allow the changes to become effective
        sleep(60);

        # Generate a new random category name
        $category_name = random_regex('[A-Z]{5}[a-z]{5}')
    }
    else {
        $category_name = 'AWCCSbuzcs';
    }
}

sub shutdown : Test(shutdown) {
    my ($self) = @_;

    $sgn->delete(name => $newsletter_name);

    $self->SUPER::shutdown();

    if ($ENV{CAPTURE_DATA}) {
        print STDERR "Category name: $category_name\n";
    }
}

sub categories : Tests {
    my ($self) = @_;

    throws_ok 
        { 
            $sgn->categories->create() 
        } 
        qr/Required parameter 'category' is not defined/, 
        'An exception is thrown when a required parameter is missing';

    $sgn->categories->create(category => $category_name);
    $self->expect_success($sgn, 'Creating a new category');
  
    throws_ok 
        { 
            $sgn->categories->add(category => $category_name); 
        } 
        qr/Required parameter 'name' is not defined/, 
        'An exception is thrown when a required parameter is missing';

    $sgn->categories->add(category => $category_name, name => $newsletter_name);
    $self->expect_success($sgn, 'Assigning category to a newletter');

    $sgn->categories->list();
    $self->expect_success($sgn, 'Listing category');

    throws_ok
        {
            $sgn->categories->remove->();
        }
        qr/Required parameter 'name' is not defined/, 
        'An exception is thrown when a required parameter is missing';

    $sgn->categories->remove(category => $category_name, name => $newsletter_name);
    $self->expect_success($sgn, 'Removing a category');

}

Test::Class->runtests;
