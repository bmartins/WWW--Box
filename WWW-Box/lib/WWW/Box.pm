package WWW::Box;

use 5.006;
use strict;
use warnings;
use LWP::UserAgent;
use XML::Simple;
use HTTP::Request::Common;

=head1 NAME

WWW::Box - The great new WWW::Box!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use WWW::Box;

    my $foo = WWW::Box->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 function1

=cut

sub new {
    my ( $this, @args ) = @_;

    my $class = ( ref($this) or $this );
    my $self = {};
    bless $self, $class;

	$self->{'api_key'}    = $args[0]->{'api_key'} or die "no api_key provided";
	$self->{'auth_token'} = $args[0]->{'auth_token'} or die "no auth_token provided";
	$self->{'tree'}->{'/'}->{'id'} = 0;
	$self->{'tree'}->{'/'}->{'type'} = 'd';
    return $self;
}



sub get_account_info {
	my ($self) = @_;
	my $url = 'https://www.box.net/api/1.0/rest?action=get_account_info&api_key=' . $self->{'api_key'} . '&auth_token=' . $self->{'auth_token'};
	my $response = $self->get_it($url);
	if ($response) {
		return $response->{'user'};
	} else {
		return $response;
	}
	
}
=head
sub get_folder_id {
	my ($self, $folder) = @_;
	$folder .='/' if ($folder !~/\/$/);
	my @folders = ();

	#print $folder ."\n";

	my @tok = split(/\//,$folder);
	use Data::Dumper;
	#print Dumper \@tok;
	for my $i (0..(scalar(@tok)-1)) {
		my @tmptok =();
		for my $j (0..$i) {
			push @tmptok , $tok[$j];
		}
#		print Dumper \@tmptok;
		my $f = join('/', @tmptok);
		$f ='/' if ($f eq '');
#		print $f ."\n";
		push @folders, $f;



	}
	print Dumper \@folders;
	

}
=cut
sub get_tree {
	my ($self, $folder_id) = @_;
	$folder_id ||= 0;

	my $url = 'https://www.box.net/api/1.0/rest?action=get_account_tree' 
		. '&api_key=' . $self->{'api_key'} 
		. '&auth_token=' . $self->{'auth_token'} 
		. '&folder_id=' . $folder_id 
		. '&params%5B%5D=onelevel&params%5B%5D=nozip';

	my $response = $self->get_it($url);
	return $response;


}

sub create_folder {
	my ($self, $folder_name, $parent_id, $share) = @_;
	$parent_id  ||= 0;
	$share ||= 0;

	my $url = 'https://www.box.net/api/1.0/rest?action=create_folder'
		. '&api_key=' . $self->{'api_key'} 
		. '&auth_token=' . $self->{'auth_token'} 
		. '&parent_id=' . $parent_id 
		.'&name=' . $folder_name 
		.'&share=' . $share;

	my $response = $self->get_it($url);
	return $response;
	

}

sub upload_file {
	my ($self, $folder_id, $file) = @_;
	my $url = 'https://upload.box.net/api/1.0/upload/'. $self->{'auth_token'} . '/' . $folder_id;

	my $ua = LWP::UserAgent->new;

	my $response = $ua->request(POST  $url , Content_Type => 'form-data' , Content => [  file => [$file]]);

	if ($response->is_success) {
		my $xml = $response->content;
		my $ref = XMLin($xml);
		return $ref;
#		return $ref->{'response'};
	} else {
		$self->{'error'} = 'THERE WAS A PROBLEM UPLOADING THE FILE ' . $response->status_line;
		return undef;
	}


	

}

sub get_it {
	my ($self, $url) = @_;
	my $ua = LWP::UserAgent->new();
	my $response = $ua->get($url);
	if ($response->is_success) {
		my $xml = $response->content;
		my $ref = XMLin($xml);
		return $ref;
	} else {
		$self->{'error'} = 'There was a problem with the request . ' . $response->status_line;
		return undef;
	}
}

sub function1 {
}

=head2 function2

=cut

sub function2 {
}

=head1 AUTHOR

Bruno Martins, C<< <bscmartins at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-www-box at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-Box>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::Box


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-Box>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-Box>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-Box>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-Box/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2012 Bruno Martins.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of WWW::Box
