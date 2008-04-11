# BEGIN BPS TAGGED BLOCK {{{
# 
# COPYRIGHT:
#  
# This software is Copyright (c) 1996-2008 Best Practical Solutions, LLC 
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
# Autogenerated by DBIx::SearchBuilder factory (by <jesse@bestpractical.com>)
# WARNING: THIS FILE IS AUTOGENERATED. ALL CHANGES TO THIS FILE WILL BE LOST.  
# 
# !! DO NOT EDIT THIS FILE !!
#

use strict;


=head1 NAME

RT::GroupMember


=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=cut

package RT::GroupMember;
use RT::Record; 


use vars qw( @ISA );
@ISA= qw( RT::Record );

sub _Init {
  my $self = shift; 

  $self->Table('GroupMembers');
  $self->SUPER::_Init(@_);
}





=head2 Create PARAMHASH

Create takes a hash of values and creates a row in the database:

  int(11) 'GroupId'.
  int(11) 'MemberId'.

=cut




sub Create {
    my $self = shift;
    my %args = ( 
                GroupId => '0',
                MemberId => '0',

		  @_);
    $self->SUPER::Create(
                         GroupId => $args{'GroupId'},
                         MemberId => $args{'MemberId'},
);

}



=head2 id

Returns the current value of id. 
(In the database, id is stored as int(11).)


=cut


=head2 GroupId

Returns the current value of GroupId. 
(In the database, GroupId is stored as int(11).)



=head2 SetGroupId VALUE


Set GroupId to VALUE. 
Returns (1, 'Status message') on success and (0, 'Error Message') on failure.
(In the database, GroupId will be stored as a int(11).)


=cut


=head2 MemberId

Returns the current value of MemberId. 
(In the database, MemberId is stored as int(11).)



=head2 SetMemberId VALUE


Set MemberId to VALUE. 
Returns (1, 'Status message') on success and (0, 'Error Message') on failure.
(In the database, MemberId will be stored as a int(11).)


=cut



sub _CoreAccessible {
    {
     
        id =>
		{read => 1, sql_type => 4, length => 11,  is_blob => 0,  is_numeric => 1,  type => 'int(11)', default => ''},
        GroupId => 
		{read => 1, write => 1, sql_type => 4, length => 11,  is_blob => 0,  is_numeric => 1,  type => 'int(11)', default => '0'},
        MemberId => 
		{read => 1, write => 1, sql_type => 4, length => 11,  is_blob => 0,  is_numeric => 1,  type => 'int(11)', default => '0'},

 }
};


        eval "require RT::GroupMember_Overlay";
        if ($@ && $@ !~ qr{^Can't locate RT/GroupMember_Overlay.pm}) {
            die $@;
        };

        eval "require RT::GroupMember_Vendor";
        if ($@ && $@ !~ qr{^Can't locate RT/GroupMember_Vendor.pm}) {
            die $@;
        };

        eval "require RT::GroupMember_Local";
        if ($@ && $@ !~ qr{^Can't locate RT/GroupMember_Local.pm}) {
            die $@;
        };




=head1 SEE ALSO

This class allows "overlay" methods to be placed
into the following files _Overlay is for a System overlay by the original author,
_Vendor is for 3rd-party vendor add-ons, while _Local is for site-local customizations.  

These overlay files can contain new subs or subs to replace existing subs in this module.

Each of these files should begin with the line 

   no warnings qw(redefine);

so that perl does not kick and scream when you redefine a subroutine or variable in your overlay.

RT::GroupMember_Overlay, RT::GroupMember_Vendor, RT::GroupMember_Local

=cut


1;
