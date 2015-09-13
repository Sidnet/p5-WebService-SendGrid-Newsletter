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
        api_user     => $self->sendgrid_api_user,
        api_key      => $self->sendgrid_api_key,
        json_options => { canonical => 1 },
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
                            'url' => 'https://sendgrid.com/api/newsletter/lists/add.json',
                            'protocol' => 'HTTP/1.1',
                            'content' => '{"message": "success"}',
                            'reason' => 'OK',
                            'headers' => {
                                           'server' => 'cloudflare-nginx',
                                           'transfer-encoding' => 'chunked',
                                           'cf-ray' => '21d2222191262af1-WAW',
                                           'content-type' => 'text/html',
                                           'connection' => 'keep-alive',
                                           'date' => 'Fri, 28 Aug 2015 18:38:28 GMT',
                                           'set-cookie' => '__cfduid=d4c8b42a54244e86e868b6a52fa57bcf81440787108; expires=Sat, 27-Aug-16 18:38:28 GMT; path=/; domain=.sendgrid.com; HttpOnly'
                                         },
                            'status' => '200'
                          },
            'method' => 'POST',
            'args' => {
                        'content' => {
                                       'api_key' => 'sendgrid_api_key',
                                       'list' => 'Test+List',
                                       'name' => 'Test+List+Name',
                                       'api_user' => 'sendgrid_api_user'
                                     },
                        'headers' => {
                                       'content-type' => 'application/x-www-form-urlencoded'
                                     }
                      },
            'url' => 'https://sendgrid.com/api/newsletter/lists/add.json'
          },
          {
            'url' => 'https://sendgrid.com/api/newsletter/lists/add.json',
            'args' => {
                        'content' => {
                                       'api_key' => 'sendgrid_api_key',
                                       'api_user' => 'sendgrid_api_user',
                                       'name' => 'Test+List+Name',
                                       'list' => 'Test+List'
                                     },
                        'headers' => {
                                       'content-type' => 'application/x-www-form-urlencoded'
                                     }
                      },
            'method' => 'POST',
            'response' => {
                            'protocol' => 'HTTP/1.1',
                            'content' => '{"error": "Test List already exists"}',
                            'success' => 1,
                            'url' => 'https://sendgrid.com/api/newsletter/lists/add.json',
                            'status' => '200',
                            'reason' => 'OK',
                            'headers' => {
                                           'transfer-encoding' => 'chunked',
                                           'cf-ray' => '21d2222321292af1-WAW',
                                           'server' => 'cloudflare-nginx',
                                           'date' => 'Fri, 28 Aug 2015 18:38:28 GMT',
                                           'set-cookie' => '__cfduid=d4c8b42a54244e86e868b6a52fa57bcf81440787108; expires=Sat, 27-Aug-16 18:38:28 GMT; path=/; domain=.sendgrid.com; HttpOnly',
                                           'content-type' => 'text/html',
                                           'connection' => 'keep-alive'
                                         }
                          }
          },
          {
            'url' => 'https://sendgrid.com/api/newsletter/lists/edit.json',
            'args' => {
                        'content' => {
                                       'newlist' => 'New+Test+List',
                                       'api_user' => 'sendgrid_api_user',
                                       'list' => 'Test+List',
                                       'api_key' => 'sendgrid_api_key'
                                     },
                        'headers' => {
                                       'content-type' => 'application/x-www-form-urlencoded'
                                     }
                      },
            'method' => 'POST',
            'response' => {
                            'success' => 1,
                            'url' => 'https://sendgrid.com/api/newsletter/lists/edit.json',
                            'content' => '{"message": "success"}',
                            'protocol' => 'HTTP/1.1',
                            'headers' => {
                                           'transfer-encoding' => 'chunked',
                                           'cf-ray' => '21d22224712b2af1-WAW',
                                           'server' => 'cloudflare-nginx',
                                           'set-cookie' => '__cfduid=d4c8b42a54244e86e868b6a52fa57bcf81440787108; expires=Sat, 27-Aug-16 18:38:28 GMT; path=/; domain=.sendgrid.com; HttpOnly',
                                           'date' => 'Fri, 28 Aug 2015 18:38:28 GMT',
                                           'content-type' => 'text/html',
                                           'connection' => 'keep-alive'
                                         },
                            'reason' => 'OK',
                            'status' => '200'
                          }
          },
          {
            'response' => {
                            'content' => '[{"list": "New Test List", "id": 43450780},{"list": "subscribers", "id": 38060302},{"list": "Test Category List", "id": 38116483}]',
                            'protocol' => 'HTTP/1.1',
                            'url' => 'https://sendgrid.com/api/newsletter/lists/get.json',
                            'success' => 1,
                            'status' => '200',
                            'headers' => {
                                           'server' => 'cloudflare-nginx',
                                           'cf-ray' => '21d22225e12c2af1-WAW',
                                           'transfer-encoding' => 'chunked',
                                           'connection' => 'keep-alive',
                                           'content-type' => 'text/html',
                                           'set-cookie' => '__cfduid=d4c8b42a54244e86e868b6a52fa57bcf81440787108; expires=Sat, 27-Aug-16 18:38:28 GMT; path=/; domain=.sendgrid.com; HttpOnly',
                                           'date' => 'Fri, 28 Aug 2015 18:38:28 GMT'
                                         },
                            'reason' => 'OK'
                          },
            'method' => 'POST',
            'args' => {
                        'headers' => {
                                       'content-type' => 'application/x-www-form-urlencoded'
                                     },
                        'content' => {
                                       'api_user' => 'sendgrid_api_user',
                                       'api_key' => 'sendgrid_api_key'
                                     }
                      },
            'url' => 'https://sendgrid.com/api/newsletter/lists/get.json'
          },
          {
            'response' => {
                            'status' => '200',
                            'reason' => 'OK',
                            'headers' => {
                                           'server' => 'cloudflare-nginx',
                                           'cf-ray' => '21d22227412f2af1-WAW',
                                           'transfer-encoding' => 'chunked',
                                           'connection' => 'keep-alive',
                                           'content-type' => 'text/html',
                                           'set-cookie' => '__cfduid=d8c7b31ebacd55c3636822e86f665cb591440787109; expires=Sat, 27-Aug-16 18:38:29 GMT; path=/; domain=.sendgrid.com; HttpOnly',
                                           'date' => 'Fri, 28 Aug 2015 18:38:29 GMT'
                                         },
                            'protocol' => 'HTTP/1.1',
                            'content' => '[{"list": "New Test List", "id": 43450780}]',
                            'url' => 'https://sendgrid.com/api/newsletter/lists/get.json',
                            'success' => 1
                          },
            'method' => 'POST',
            'args' => {
                        'headers' => {
                                       'content-type' => 'application/x-www-form-urlencoded'
                                     },
                        'content' => {
                                       'api_key' => 'sendgrid_api_key',
                                       'list' => 'New+Test+List',
                                       'api_user' => 'sendgrid_api_user'
                                     }
                      },
            'url' => 'https://sendgrid.com/api/newsletter/lists/get.json'
          },
          {
            'response' => {
                            'url' => 'https://sendgrid.com/api/newsletter/lists/email/add.json',
                            'success' => 1,
                            'content' => '{"inserted": 1}',
                            'protocol' => 'HTTP/1.1',
                            'headers' => {
                                           'content-type' => 'text/html',
                                           'connection' => 'keep-alive',
                                           'set-cookie' => '__cfduid=d8c7b31ebacd55c3636822e86f665cb591440787109; expires=Sat, 27-Aug-16 18:38:29 GMT; path=/; domain=.sendgrid.com; HttpOnly',
                                           'date' => 'Fri, 28 Aug 2015 18:38:29 GMT',
                                           'server' => 'cloudflare-nginx',
                                           'transfer-encoding' => 'chunked',
                                           'cf-ray' => '21d22228b1312af1-WAW'
                                         },
                            'reason' => 'OK',
                            'status' => '200'
                          },
            'method' => 'POST',
            'args' => {
                        'headers' => {
                                       'content-type' => 'application/x-www-form-urlencoded'
                                     },
                        'content' => {
                                       'api_user' => 'sendgrid_api_user',
                                       'list' => 'New+Test+List',
                                       'data' => '{"email":"someone@example.com","name":"Some+One"}',
                                       'api_key' => 'sendgrid_api_key'
                                     }
                      },
            'url' => 'https://sendgrid.com/api/newsletter/lists/email/add.json'
          },
          {
            'url' => 'https://sendgrid.com/api/newsletter/lists/delete.json',
            'args' => {
                        'content' => {
                                       'list' => 'New+Test+List',
                                       'api_user' => 'sendgrid_api_user',
                                       'api_key' => 'sendgrid_api_key'
                                     },
                        'headers' => {
                                       'content-type' => 'application/x-www-form-urlencoded'
                                     }
                      },
            'method' => 'POST',
            'response' => {
                            'status' => '200',
                            'reason' => 'OK',
                            'headers' => {
                                           'server' => 'cloudflare-nginx',
                                           'transfer-encoding' => 'chunked',
                                           'cf-ray' => '21d2222b71352af1-WAW',
                                           'content-type' => 'text/html',
                                           'connection' => 'keep-alive',
                                           'set-cookie' => '__cfduid=d8c7b31ebacd55c3636822e86f665cb591440787109; expires=Sat, 27-Aug-16 18:38:29 GMT; path=/; domain=.sendgrid.com; HttpOnly',
                                           'date' => 'Fri, 28 Aug 2015 18:38:29 GMT'
                                         },
                            'protocol' => 'HTTP/1.1',
                            'content' => '{"message": "success"}',
                            'success' => 1,
                            'url' => 'https://sendgrid.com/api/newsletter/lists/delete.json'
                          }
          }
        ];
}