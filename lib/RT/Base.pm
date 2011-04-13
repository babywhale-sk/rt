# BEGIN BPS TAGGED BLOCK {{{
# 
# COPYRIGHT:
#  
# This software is Copyright (c) 1996-2011 Best Practical Solutions, LLC
#                                          <jesse@bestpractical.com>
# 
# (Except where explicitly superseded by other copyright notices)
# 
# 
# LICENSE:
# 
# This work is made available to you under the terms of Version 2 of
# the GNU General Public License. A copy of that license should have
# been provided with this software, but in any event can be snarfed
# from www.gnu.org.
# 
# This work is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301 or visit their web page on the internet at
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.html.
# 
# 
# CONTRIBUTION SUBMISSION POLICY:
# 
# (The following paragraph is not intended to limit the rights granted
# to you to modify and distribute this software under the terms of
# the GNU General Public License and is only of importance to you if
# you choose to contribute your changes and enhancements to the
# community by submitting them to Best Practical Solutions, LLC.)
# 
# By intentionally submitting any modifications, corrections or
# derivatives to this work, or any other work intended for use with
# Request Tracker, to Best Practical Solutions, LLC, you confirm that
# you are the copyright holder for those contributions and you grant
# Best Practical Solutions,  LLC a nonexclusive, worldwide, irrevocable,
# royalty-free, perpetual, license to use, copy, create derivative
# works based on those contributions, and sublicense and distribute
# those contributions and any derivatives thereof.
# 
# END BPS TAGGED BLOCK }}}
package RT::Base;
use Carp;
use Scalar::Util;

use strict;
use vars qw(@EXPORT);

@EXPORT=qw(loc CurrentUser);

=head1 NAME

RT::Base


=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 FUNCTIONS

=cut

# {{{ sub CurrentUser 

=head2 CurrentUser

If called with an argument, sets the current user to that user object.
This will affect ACL decisions, etc. The argument can be either
L<RT::CurrentUser> or L<RT::User> object.

Returns the current user object of L<RT::CurrentUser> class.

=cut

sub CurrentUser {
    my $self = shift;

    if (@_) {
        $self->{'original_user'} = $self->{'user'};
        my $current_user = $_[0];
        if ( ref $current_user eq 'RT::User' ) {
            $self->{'user'} = new RT::CurrentUser;
            $self->{'user'}->Load( $current_user->id );
        } else {
            $self->{'user'} = $current_user;
        }
        # We need to weaken the CurrentUser ($self->{'user'}) reference
        # if the object in question is the currentuser object.
        # This avoids memory leaks.
        Scalar::Util::weaken($self->{'user'})
            if ref $self->{'user'} && $self->{'user'} == $self;
    }

    unless ( ref $self->{'user'} && $self->{'user'}->isa('RT::CurrentUser') ) {
        my $msg = "$self was created without a CurrentUser."
            ." Any RT object which is subclass of RT::Base must be created"
            ." with a RT::CurrentUser or a RT::User obejct as the first argument.";
        $msg .= "\n". Carp::cluck() if @_;

        $RT::Logger->error( $msg );
        return $self->{'user'} = undef;
    }

    return ( $self->{'user'} );
}

# }}}

sub OriginalUser {
    my $self = shift;

    if (@_) {
        $self->{'original_user'} = shift;
        Scalar::Util::weaken($self->{'original_user'})
            if (ref($self->{'original_user'}) && $self->{'original_user'} == $self );
    }
    return ( $self->{'original_user'} || $self->{'user'} );
}


=head2 loc LOC_STRING

l is a method which takes a loc string
to this object's CurrentUser->LanguageHandle for localization. 

you call it like this:

    $self->loc("I have [quant,_1,concrete mixer].", 6);

In english, this would return:
    I have 6 concrete mixers.


=cut

sub loc {
    my $self = shift;
    if (my $user = $self->OriginalUser) {
        return $user->loc(@_);
    }
    else {
        use Carp;
        Carp::confess("No currentuser");
        return ("Critical error:$self has no CurrentUser", $self);
    }
}

sub loc_fuzzy {
    my $self = shift;
    if (my $user = $self->OriginalUser) {
        return $user->loc_fuzzy(@_);
    }
    else {
        use Carp;
        Carp::confess("No currentuser");
        return ("Critical error:$self has no CurrentUser", $self);
    }
}

eval "require RT::Base_Vendor";
die $@ if ($@ && $@ !~ qr{^Can't locate RT/Base_Vendor.pm});
eval "require RT::Base_Local";
die $@ if ($@ && $@ !~ qr{^Can't locate RT/Base_Local.pm});


1;
