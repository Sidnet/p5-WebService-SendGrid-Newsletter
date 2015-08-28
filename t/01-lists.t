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

    $self->SUPER::startup();

    $sgn = WebService::SendGrid::Newsletter->new(
        api_user => $self->sendgrid_api_user,
        api_key  => $self->sendgrid_api_key,
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

sub mocked_data {
    my ($self) = @_;

    return [
          {
            'response' => {
                            'success' => 1,
                            'headers' => {
                                           'date' => 'Fri, 28 Aug 2015 01:19:28 GMT',
                                           'set-cookie' => '__cfduid=dc30afc3252a0042aa42f0fde023bdc8b1440724768; expires=Sat, 27-Aug-16 01:19:28 GMT; path=/; domain=.sendgrid.com; HttpOnly',
                                           'cf-ray' => '21cc3027cd492b21-WAW',
                                           'transfer-encoding' => 'chunked',
                                           'connection' => 'keep-alive',
                                           'content-type' => 'text/html',
                                           'server' => 'cloudflare-nginx'
                                         },
                            'protocol' => 'HTTP/1.1',
                            'status' => '200',
                            'reason' => 'OK',
                            'url' => 'https://sendgrid.com/api/newsletter/lists/add.json',
                            'content' => '{"message": "success"}'
                          },
            'args' => {
                        'headers' => {
                                       'content-type' => 'application/x-www-form-urlencoded'
                                     },
                        'content' => 'api_key=sendgrid_api_key&api_user=sendgrid_api_user&list=Test+List&name=Test+List+Name'
                      },
            'url' => 'https://sendgrid.com/api/newsletter/lists/add.json',
            'method' => 'POST'
          },
          {
            'response' => {
                            'content' => '{"error": "Test List already exists"}',
                            'url' => 'https://sendgrid.com/api/newsletter/lists/add.json',
                            'reason' => 'OK',
                            'success' => 1,
                            'protocol' => 'HTTP/1.1',
                            'headers' => {
                                           'server' => 'cloudflare-nginx',
                                           'transfer-encoding' => 'chunked',
                                           'cf-ray' => '21cc30295d4a2b21-WAW',
                                           'connection' => 'keep-alive',
                                           'content-type' => 'text/html',
                                           'date' => 'Fri, 28 Aug 2015 01:19:28 GMT',
                                           'set-cookie' => '__cfduid=dc30afc3252a0042aa42f0fde023bdc8b1440724768; expires=Sat, 27-Aug-16 01:19:28 GMT; path=/; domain=.sendgrid.com; HttpOnly'
                                         },
                            'status' => '200'
                          },
            'args' => {
                        'content' => 'api_key=sendgrid_api_key&api_user=sendgrid_api_user&list=Test+List&name=Test+List+Name',
                        'headers' => {
                                       'content-type' => 'application/x-www-form-urlencoded'
                                     }
                      },
            'url' => 'https://sendgrid.com/api/newsletter/lists/add.json',
            'method' => 'POST'
          },
          {
            'url' => 'https://sendgrid.com/api/newsletter/lists/edit.json',
            'method' => 'POST',
            'args' => {
                        'headers' => {
                                       'content-type' => 'application/x-www-form-urlencoded'
                                     },
                        'content' => 'api_key=sendgrid_api_key&api_user=sendgrid_api_user&list=Test+List&newlist=New+Test+List'
                      },
            'response' => {
                            'reason' => 'OK',
                            'url' => 'https://sendgrid.com/api/newsletter/lists/edit.json',
                            'content' => '{"message": "success"}',
                            'success' => 1,
                            'status' => '200',
                            'protocol' => 'HTTP/1.1',
                            'headers' => {
                                           'server' => 'cloudflare-nginx',
                                           'content-type' => 'text/html',
                                           'connection' => 'keep-alive',
                                           'cf-ray' => '21cc302abd4b2b21-WAW',
                                           'transfer-encoding' => 'chunked',
                                           'set-cookie' => '__cfduid=dc30afc3252a0042aa42f0fde023bdc8b1440724768; expires=Sat, 27-Aug-16 01:19:28 GMT; path=/; domain=.sendgrid.com; HttpOnly',
                                           'date' => 'Fri, 28 Aug 2015 01:19:28 GMT'
                                         }
                          }
          },
          {
            'response' => {
                            'reason' => 'OK',
                            'url' => 'https://sendgrid.com/api/newsletter/lists/get.json',
                            'content' => '[{"list": "New Test List", "id": 43427677},{"list": "subscribers", "id": 38060302},{"list": "Test Category List", "id": 38116483}]',
                            'success' => 1,
                            'protocol' => 'HTTP/1.1',
                            'status' => '200',
                            'headers' => {
                                           'set-cookie' => '__cfduid=dc30afc3252a0042aa42f0fde023bdc8b1440724768; expires=Sat, 27-Aug-16 01:19:28 GMT; path=/; domain=.sendgrid.com; HttpOnly',
                                           'date' => 'Fri, 28 Aug 2015 01:19:28 GMT',
                                           'content-type' => 'text/html',
                                           'cf-ray' => '21cc302c2d4c2b21-WAW',
                                           'connection' => 'keep-alive',
                                           'transfer-encoding' => 'chunked',
                                           'server' => 'cloudflare-nginx'
                                         }
                          },
            'args' => {
                        'headers' => {
                                       'content-type' => 'application/x-www-form-urlencoded'
                                     },
                        'content' => 'api_key=sendgrid_api_key&api_user=sendgrid_api_user'
                      },
            'method' => 'POST',
            'url' => 'https://sendgrid.com/api/newsletter/lists/get.json'
          },
          {
            'response' => {
                            'success' => 1,
                            'protocol' => 'HTTP/1.1',
                            'status' => '200',
                            'headers' => {
                                           'set-cookie' => '__cfduid=dc30afc3252a0042aa42f0fde023bdc8b1440724768; expires=Sat, 27-Aug-16 01:19:28 GMT; path=/; domain=.sendgrid.com; HttpOnly',
                                           'date' => 'Fri, 28 Aug 2015 01:19:29 GMT',
                                           'content-type' => 'text/html',
                                           'transfer-encoding' => 'chunked',
                                           'cf-ray' => '21cc302d8d4d2b21-WAW',
                                           'connection' => 'keep-alive',
                                           'server' => 'cloudflare-nginx'
                                         },
                            'url' => 'https://sendgrid.com/api/newsletter/lists/get.json',
                            'content' => '[{"list": "New Test List", "id": 43427677}]',
                            'reason' => 'OK'
                          },
            'args' => {
                        'headers' => {
                                       'content-type' => 'application/x-www-form-urlencoded'
                                     },
                        'content' => 'api_key=sendgrid_api_key&api_user=sendgrid_api_user&list=New+Test+List'
                      },
            'method' => 'POST',
            'url' => 'https://sendgrid.com/api/newsletter/lists/get.json'
          },
          {
            'url' => 'https://sendgrid.com/api/newsletter/lists/email/add.json',
            'method' => 'POST',
            'args' => {
                        'headers' => {
                                       'content-type' => 'application/x-www-form-urlencoded'
                                     },
                        'content' => 'api_key=sendgrid_api_key&api_user=sendgrid_api_user&data=%7B%22name%22%3A%22Some+One%22%2C%22email%22%3A%22someone%40example.com%22%7D&list=New+Test+List'
                      },
            'response' => {
                            'reason' => 'OK',
                            'url' => 'https://sendgrid.com/api/newsletter/lists/email/add.json',
                            'content' => '{"inserted": 1}',
                            'success' => 1,
                            'headers' => {
                                           'server' => 'cloudflare-nginx',
                                           'date' => 'Fri, 28 Aug 2015 01:19:29 GMT',
                                           'set-cookie' => '__cfduid=d1a232a5c13ca1f4a60d2f76c06d0618e1440724769; expires=Sat, 27-Aug-16 01:19:29 GMT; path=/; domain=.sendgrid.com; HttpOnly',
                                           'cf-ray' => '21cc302edd4e2b21-WAW',
                                           'transfer-encoding' => 'chunked',
                                           'connection' => 'keep-alive',
                                           'content-type' => 'text/html'
                                         },
                            'protocol' => 'HTTP/1.1',
                            'status' => '200'
                          }
          },
          {
            'url' => 'https://sendgrid.com/api/newsletter/lists/delete.json',
            'method' => 'POST',
            'args' => {
                        'content' => 'api_key=sendgrid_api_key&api_user=sendgrid_api_user&list=New+Test+List',
                        'headers' => {
                                       'content-type' => 'application/x-www-form-urlencoded'
                                     }
                      },
            'response' => {
                            'success' => 1,
                            'protocol' => 'HTTP/1.1',
                            'status' => '200',
                            'headers' => {
                                           'server' => 'cloudflare-nginx',
                                           'content-type' => 'text/html',
                                           'cf-ray' => '21cc30304d4f2b21-WAW',
                                           'connection' => 'keep-alive',
                                           'transfer-encoding' => 'chunked',
                                           'set-cookie' => '__cfduid=d1a232a5c13ca1f4a60d2f76c06d0618e1440724769; expires=Sat, 27-Aug-16 01:19:29 GMT; path=/; domain=.sendgrid.com; HttpOnly',
                                           'date' => 'Fri, 28 Aug 2015 01:19:29 GMT'
                                         },
                            'url' => 'https://sendgrid.com/api/newsletter/lists/delete.json',
                            'content' => '{"message": "success"}',
                            'reason' => 'OK'
                          }
          }
        ];
}