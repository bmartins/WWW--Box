#!/usr/bin/perl

use strict;
use warnings;
use WWW::Box;
use Data::Dumper;

my $box = WWW::Box->new( { 'auth_token' => $ENV{'box_auth_token'}, 'api_key' => $ENV{'box_api_key'} });
#my $info = $box->get_account_info();


#my $folder_id = $box->get_folder_id('/test/backup');
#print "folder_id: " . $folder_id ."\n";

#$box->build_tree('230490846','/test');
$box->build_tree('0','/');

#my $new_folder = $box->create_folder('backup', '230490846', 0);

#print Dumper $new_folder;

#my $tree = $box->get_tree('0');

#print Dumper $tree;

#my $upload = $box->upload_file(0,'WWW/Box.pm');

#print Dumper $upload;





