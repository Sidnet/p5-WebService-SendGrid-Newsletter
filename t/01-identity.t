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
my $identity = 'Testing Address';
my $email    = 'someone@example.com';
my $new_name = 'The New Commpany Name';

sub startup : Test(startup => no_plan) {
    my ($self) = @_;

    $self->SUPER::startup();

    $sgn = WebService::SendGrid::Newsletter->new(
        api_user     => $self->sendgrid_api_user,
        api_key      => $self->sendgrid_api_key,
        json_options => { canonical => 1 },
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

sub mocked_data {
    my ($self) = @_;

    return [
          {
            'url' => 'https://sendgrid.com/api/newsletter/identity/add.json',
            'args' => {
                        'content' => {
                                       'address' => 'Some+street+123',
                                       'city' => 'Hannover',
                                       'email' => 'commpany@example.com',
                                       'zip' => '10220',
                                       'country' => 'Germany',
                                       'replyto' => 'replythis@example.com',
                                       'state' => 'DEU',
                                       'api_key' => 'sendgrid_api_key',
                                       'identity' => 'Testing+Address',
                                       'name' => 'A+commpany+name',
                                       'api_user' => 'sendgrid_api_user'
                                     },
                        'headers' => {
                                       'content-type' => 'application/x-www-form-urlencoded'
                                     }
                      },
            'response' => {
                            'status' => '200',
                            'success' => 1,
                            'url' => 'https://sendgrid.com/api/newsletter/identity/add.json',
                            'headers' => {
                                           'date' => 'Sun, 13 Sep 2015 17:16:18 GMT',
                                           'content-type' => 'text/html',
                                           'server' => 'cloudflare-nginx',
                                           'transfer-encoding' => 'chunked',
                                           'cf-ray' => '22557fc221802ad3-WAW',
                                           'set-cookie' => '__cfduid=de93053aed42bf1ac3935f6513be26e8f1442164577; expires=Mon, 12-Sep-16 17:16:17 GMT; path=/; domain=.sendgrid.com; HttpOnly',
                                           'connection' => 'keep-alive'
                                         },
                            'reason' => 'OK',
                            'content' => '{"message": "success"}',
                            'protocol' => 'HTTP/1.1'
                          },
            'method' => 'POST'
          },
          {
            'url' => 'https://sendgrid.com/api/newsletter/identity/edit.json',
            'args' => {
                        'content' => {
                                       'email' => 'someone@example.com',
                                       'identity' => 'Testing+Address',
                                       'name' => 'The+New+Commpany+Name',
                                       'api_key' => 'sendgrid_api_key',
                                       'api_user' => 'sendgrid_api_user'
                                     },
                        'headers' => {
                                       'content-type' => 'application/x-www-form-urlencoded'
                                     }
                      },
            'method' => 'POST',
            'response' => {
                            'headers' => {
                                           'connection' => 'keep-alive',
                                           'cf-ray' => '22557fc851862ad3-WAW',
                                           'set-cookie' => '__cfduid=d4820c201d1463ea8ebe276b2798212ac1442164578; expires=Mon, 12-Sep-16 17:16:18 GMT; path=/; domain=.sendgrid.com; HttpOnly',
                                           'transfer-encoding' => 'chunked',
                                           'server' => 'cloudflare-nginx',
                                           'content-type' => 'text/html',
                                           'date' => 'Sun, 13 Sep 2015 17:16:19 GMT'
                                         },
                            'reason' => 'OK',
                            'status' => '200',
                            'success' => 1,
                            'url' => 'https://sendgrid.com/api/newsletter/identity/edit.json',
                            'protocol' => 'HTTP/1.1',
                            'content' => '{"message": "success"}'
                          }
          },
          {
            'response' => {
                            'url' => 'https://sendgrid.com/api/newsletter/identity/get.json',
                            'success' => 1,
                            'status' => '200',
                            'reason' => 'OK',
                            'headers' => {
                                           'transfer-encoding' => 'chunked',
                                           'connection' => 'keep-alive',
                                           'set-cookie' => '__cfduid=d19cada8a76264bcdc2bd062847b4b3261442164579; expires=Mon, 12-Sep-16 17:16:19 GMT; path=/; domain=.sendgrid.com; HttpOnly',
                                           'cf-ray' => '22557fce518a2ad3-WAW',
                                           'date' => 'Sun, 13 Sep 2015 17:16:19 GMT',
                                           'server' => 'cloudflare-nginx',
                                           'content-type' => 'text/html'
                                         },
                            'content' => '{"city": "Hannover", "name": "The New Commpany Name", "zip": "10220", "replyto": "replythis@example.com", "country": "Germany", "state": "DEU", "address": "Some street 123", "email": "someone@example.com", "identity": "Testing Address"}',
                            'protocol' => 'HTTP/1.1'
                          },
            'method' => 'POST',
            'url' => 'https://sendgrid.com/api/newsletter/identity/get.json',
            'args' => {
                        'headers' => {
                                       'content-type' => 'application/x-www-form-urlencoded'
                                     },
                        'content' => {
                                       'api_user' => 'sendgrid_api_user',
                                       'identity' => 'Testing+Address',
                                       'api_key' => 'sendgrid_api_key'
                                     }
                      }
          },
          {
            'url' => 'https://sendgrid.com/api/newsletter/identity/list.json',
            'args' => {
                        'headers' => {
                                       'content-type' => 'application/x-www-form-urlencoded'
                                     },
                        'content' => {
                                       'api_user' => 'sendgrid_api_user',
                                       'api_key' => 'sendgrid_api_key',
                                       'identity' => 'Testing+Address'
                                     }
                      },
            'method' => 'POST',
            'response' => {
                            'success' => 1,
                            'url' => 'https://sendgrid.com/api/newsletter/identity/list.json',
                            'status' => '200',
                            'reason' => 'OK',
                            'headers' => {
                                           'transfer-encoding' => 'chunked',
                                           'connection' => 'keep-alive',
                                           'set-cookie' => '__cfduid=d19cada8a76264bcdc2bd062847b4b3261442164579; expires=Mon, 12-Sep-16 17:16:19 GMT; path=/; domain=.sendgrid.com; HttpOnly',
                                           'cf-ray' => '22557fcfc18c2ad3-WAW',
                                           'date' => 'Sun, 13 Sep 2015 17:16:20 GMT',
                                           'server' => 'cloudflare-nginx',
                                           'content-type' => 'text/html'
                                         },
                            'content' => '[{"identity": "Testing Address"}]',
                            'protocol' => 'HTTP/1.1'
                          }
          },
          {
            'response' => {
                            'content' => '[{"identity": "Testing Address"},{"identity": "This is my test marketing email"}]',
                            'protocol' => 'HTTP/1.1',
                            'status' => '200',
                            'success' => 1,
                            'url' => 'https://sendgrid.com/api/newsletter/identity/list.json',
                            'headers' => {
                                           'transfer-encoding' => 'chunked',
                                           'cf-ray' => '22557fd1318e2ad3-WAW',
                                           'set-cookie' => '__cfduid=dc570e4d330a853f58c7fc12d63171b321442164580; expires=Mon, 12-Sep-16 17:16:20 GMT; path=/; domain=.sendgrid.com; HttpOnly',
                                           'connection' => 'keep-alive',
                                           'date' => 'Sun, 13 Sep 2015 17:16:20 GMT',
                                           'content-type' => 'text/html',
                                           'server' => 'cloudflare-nginx'
                                         },
                            'reason' => 'OK'
                          },
            'method' => 'POST',
            'args' => {
                        'content' => {
                                       'api_key' => 'sendgrid_api_key',
                                       'api_user' => 'sendgrid_api_user'
                                     },
                        'headers' => {
                                       'content-type' => 'application/x-www-form-urlencoded'
                                     }
                      },
            'url' => 'https://sendgrid.com/api/newsletter/identity/list.json'
          },
          {
            'method' => 'POST',
            'response' => {
                            'reason' => 'OK',
                            'headers' => {
                                           'connection' => 'keep-alive',
                                           'set-cookie' => '__cfduid=dc570e4d330a853f58c7fc12d63171b321442164580; expires=Mon, 12-Sep-16 17:16:20 GMT; path=/; domain=.sendgrid.com; HttpOnly',
                                           'cf-ray' => '22557fd2918f2ad3-WAW',
                                           'transfer-encoding' => 'chunked',
                                           'server' => 'cloudflare-nginx',
                                           'content-type' => 'text/html',
                                           'date' => 'Sun, 13 Sep 2015 17:16:20 GMT'
                                         },
                            'url' => 'https://sendgrid.com/api/newsletter/identity/delete.json',
                            'success' => 1,
                            'status' => '200',
                            'protocol' => 'HTTP/1.1',
                            'content' => '{"message": "success"}'
                          },
            'url' => 'https://sendgrid.com/api/newsletter/identity/delete.json',
            'args' => {
                        'headers' => {
                                       'content-type' => 'application/x-www-form-urlencoded'
                                     },
                        'content' => {
                                       'api_key' => 'sendgrid_api_key',
                                       'identity' => 'Testing+Address',
                                       'api_user' => 'sendgrid_api_user'
                                     }
                      }
          }
        ];
}
