#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Exception;
use DateTime;

BEGIN {
    use_ok(
        'WebService::SendGrid::Newsletter', 
    );
    plan skip_all => 'SENDGRID_API_USER and SENDGRID_API_KEY are required to run live tests' 
    unless ($ENV{SENDGRID_API_USER} && $ENV{SENDGRID_API_KEY});     
}

my $sgn;

$sgn = WebService::SendGrid::Newsletter->new(
    api_user => $ENV{SENDGRID_API_USER},
    api_key  => $ENV{SENDGRID_API_KEY},
);

# create a new recipients list
my $list_name = 'subscribers_test';

throws_ok { 
    $sgn->lists->add(name => 'name') 
} qr/Required parameter 'list' is not defined/, 
'Get expected exception when a required parameter is missing';


$sgn->lists->add(list => $list_name, name => 'name');
is($sgn->{last_response_code}, 200, 'Can successfully create a new subscribers list');
is($sgn->{last_response}->{message}, 'success', 'Get response message for adding a new list');

$sgn->lists->add(list => $list_name, name => 'name');
is($sgn->{last_response_code}, 200, 'Get OK status from adding an existing list');
is(
    $sgn->{last_response}->{error}, 
    "$list_name already exists", 
    'Get the error response message when the list name already exists'
);

$sgn->lists->get(list => $list_name);
is($sgn->{last_response_code}, 200, 'Can successfully get a new subscribers list');
ok($sgn->{last_response}->[0]->{id}, 'Get the list ID');
is($sgn->{last_response}->[0]->{list}, "$list_name", 'Get the specified list name');

# add recipients to the list 
throws_ok { 
    $sgn->lists->email->add( list => $list_name )
} qr/Required parameter 'data' is not defined/, 
'Get expected exception when a required parameter is missing';


$sgn->lists->email->add(
    list => $list_name,
    data => { 
        name  => 'Customer', 
        email => 'someone@example.com' 
    }
);
is($sgn->{last_response_code}, 200, 'Can successfully add a subscriber to the list');

my $new_list = 'subscribers_new';

throws_ok { 
    $sgn->lists->edit(list => $list_name) 
} qr/Required parameter 'newlist' is not defined/, 
'Get expected exception when a required parameter is missing';


$sgn->lists->edit(list => $list_name, newlist => $new_list);

is($sgn->{last_response}->{message}, 'success', 'Get successful response message after edit a list name');
is($sgn->{last_response_code}, 200, 'Can successfully edit a subscriber list');

my $newsletter_name = 'Test Newsletter';

my %newsletter = (        
    identity => 'This is my test marketing email',
    subject  => 'Your weekly newsletter',
    text     => 'Hello, this is your weekly newsletter',
    html     => '<h1>Hello</h1><p>This is your weekly newsletter</p>'
);

throws_ok { 
    $sgn->add(%newsletter) 
} qr/Required parameter 'name' is not defined/, 
'Get expected exception when a required parameter is missing';

$newsletter{name} = $newsletter_name;

$sgn->add( %newsletter );

is(
    $sgn->{last_response}->{message}, 
    'success', 
    'Get successful response message from adding a new newsletter'
);
is($sgn->{last_response_code}, 200, 'Can successfully create a newsletter');

throws_ok { 
    $sgn->recipients->add(name => $newsletter_name )
} qr/Required parameter 'list' is not defined/, 
'Get expected exception when a required parameter is missing';

#waiting for data updated
sleep(60);

$sgn->recipients->add(name => $newsletter_name, list => $new_list);
is(
    $sgn->{last_response}->{message}, 
    'success', 
    'Get successful response message from assign newsletter to list' 
);
is($sgn->{last_response_code}, 200, 'Can successfully assign a newsletter to a list');

$sgn->recipients->get(name => $newsletter_name);
is(
    $sgn->{last_response}->[0]->{list}, 
    'subscribers_new',
    'Found the expected subscribers list',
);
is($sgn->{last_response_code}, 200, 'Can successfully get a newsletter');

throws_ok {
    $sgn->schedule->add->(list => $new_list);
} qr/Required parameter 'name' is not defined/, 
'Get expected exception when a required parameter is missing';

my $dt = DateTime->now();
$dt->add( minutes => 2 );
$sgn->schedule->add(name => $newsletter_name, at => "$dt");
is(
    $sgn->{last_response}->{message}, 
    'success', 
    'Get successful response message from scheduling sending time'
);
is($sgn->{last_response_code}, 200, 'Can successfully schedule date time to send');

$sgn->schedule->add(name => $newsletter_name, after => 5);
is(
    $sgn->{last_response}->{message}, 
    'success', 
    'Get successful response message from scheduling sending time in 5 minutes'
);
is(
    $sgn->{last_response_code}, 
    200, 
    'Can successfully schedule to send newsletter in 5 minutes'
);

throws_ok {
    $sgn->schedule->add->();
} qr/Required parameter 'name' is not defined/, 
'Get expected exception when a required parameter is missing';

$sgn->schedule->get(name => $newsletter_name);
ok($sgn->{last_response}->{date}, 'Get date time to send a particular newsletter');
is(
    $sgn->{last_response_code}, 
    200, 
    'Can successfully get date time schedule to send a particular newsletter'
);

throws_ok {
    $sgn->schedule->delete->();
} qr/Required parameter 'name' is not defined/, 
'Get expected exception when a required parameter is missing';

$sgn->schedule->delete(name => $newsletter_name);
is($sgn->{last_response}->{message}, 'success', 'Get response message from removing schedule');
is($sgn->{last_response_code}, 200, 'Can successfully remove schedule delivery time');

$sgn->recipients->delete(name => $newsletter_name, list => $new_list);
is(
    $sgn->{last_response}->{message}, 
    'success', 
    'Get successful response message from unassigning a newsletter'
);
is($sgn->{last_response_code}, 200, 'Can successfully cancel assigning a newsletter');

throws_ok { 
    $sgn->delete() 
} qr/Required parameter 'name' is not defined/, 
'Get expected exception when a required parameter is missing';

$sgn->delete(name => $newsletter_name);
is(
    $sgn->{last_response}->{message}, 
    'success', 
    'Get successful response message from removing a newsletter'
);
is($sgn->{last_response_code}, 200, 'Can successfully delete a newsletter');


throws_ok { 
    $sgn->lists->delete() 
} qr/Required parameter 'list' is not defined/, 
'Get expected exception when a required parameter is missing';

$sgn->lists->delete(list => $new_list);
is(
    $sgn->{last_response}->{message}, 
    'success', 
    'Get successful response message from removing a subscribers list'
);
is($sgn->{last_response_code}, 200, 'Can successfully delete a subscriber list');

done_testing();