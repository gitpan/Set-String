##################################################################
# Set::String
#
# See POD
##################################################################
package Set::String;
use strict;
use Carp;
use Want;
use Set::Array;
use attributes qw(reftype);

use subs qw(chop chomp defined eval lc lcfirst ord);
use subs qw(uc ucfirst);

# Subclass of Set::Array
BEGIN{
   use vars qw(@ISA $VERSION);
   @ISA = qw(Set::Array);
   $VERSION = '0.01';
}

sub new{
   my($class,$string) = @_;
   $string = @$class if !$string && ref($class);
   my @array = CORE::split('',$string);
   undef $string;
   return bless \@array, ref($class) || $class;
}

sub chop{
   my($self,$num) = @_;

   $num ||= 1;

   if(want('OBJECT') or !(CORE::defined wantarray)){
      for(1..$num){ $self->SUPER::pop }
      return $self;
   }

   my $copy = CORE::join('',@$self);
   my @chopped;
   for(1..$num){
      push(@chopped,CORE::chop $copy);
   }

   return reverse @chopped if wantarray;
   return scalar @chopped if defined wantarray;
}

sub chomp{
   my($self,$num) = @_;

   $num ||= 1;

   if(want('OBJECT') or !(CORE::defined wantarray)){
      my $string = join '',@$self;
      for(1..$num){
         CORE::chomp $string;
      }
      @$self = split '',$string;
      undef $string;
      return $self;
   }

   my $copy = CORE::join('',@$self);
   my @chomped;
   for(1..$num){
      push(@chomped,CORE::chop $copy);
   }

   return reverse @chomped if wantarray;
   return scalar @chomped if defined wantarray;
}

# Returns 1 or 0
sub defined{
   my($self) = @_;
   return 0 unless CORE::defined($self->[0]);
   return 1;
}

############################################################################
# Eval the string as is.  The object becomes the eval'd string, replacing
# the original content (or assigning them to an lvalue).
#
# I'm considering allowing an alternate string to be eval'd, but how do I
# handle it exactly?
############################################################################
sub eval{
   my($self) = @_;
   my $result = CORE::eval CORE::join('',@$self);
   if(want('OBJECT') or !(CORE::defined wantarray)){
      @$self = CORE::split('',$result);
      undef $result;
      return $self;
   }
   return $result;
}

###############################################################
# Slightly different from standard lc in that you can specify
# the number of characters you want to lc (left to right).
###############################################################
sub lc{
  my($self,$n) = @_;

  if( (CORE::defined $n) && ($n > scalar(@$self)) ){
     croak("Argument to method 'lc()' exceeds length of string");
  }

  $n ||= scalar(@$self);
  $n -= 1;
  if($n < 0){ $n = 0 }

  if($n !~ /\d+/){
     croak("Invalid argument to 'lc()' method");
  }

  if(want('OBJECT') || !(CORE::defined wantarray)){
     for(my $m = 0; $m <= $n; $m++){
        $self->[$m] = CORE::lc($self->[$m]);
     }
     undef $n;
     return $self;
  }

  my $copy = CORE::join('',@$self);
  return CORE::lc($copy);
}

sub lcfirst{
   my($self) = @_;

   if(want('OBJECT') || !(CORE::defined wantarray)){
      $self->[0] = CORE::lc($self->[0]);
      return $self;
   }

  my $copy = CORE::join('',@$self);
  return CORE::lcfirst($copy);
}

###############################################################################
# Slightly different than standard 'ord' in that the programmer may
# specify a range of characters to get ord vals on.  Alternatively, a single
# index may be specified.
#
# By default, this method will return all ord values unless an
# index is specified.  Returns a list or list ref.
###############################################################################
sub ord{
   my($self,$num) = @_;

   cluck("Calling 'ord()' on empty array") if scalar(@$self) == 0;

   $num = scalar(@$self) unless CORE::defined $num;

   $num--;

   if(want('OBJECT') or !(defined wantarray)){
      for(0..$num){ $self->[$_] = CORE::ord($self->[$_]) }
      return $self;
   }

   my @copy = @$self;
   for(0..$num){ $copy[$_] = CORE::ord($copy[$_]) }

   return @copy if wantarray;
   return \@copy if defined wantarray;
}

# Not yet implemented
# sub pack{}

# Not yet implemented
# sub unpack{}

# Not yet implemented
# sub substr{}

# Not yet implemented
#sub pos{}

# Not yet implemented
#sub quotemeta{}

# Not yet implemented
#sub split{}

# May not be implemented
#sub study{}

###############################################################
# Slightly different from standard uc in that you can specify
# the number of characters you want to uc (left to right).
###############################################################
sub uc{
  my($self,$n) = @_;

  if( (CORE::defined $n) && ($n > scalar(@$self)) ){
     croak("Argument to method 'uc()' exceeds length of string");
  }

  $n ||= scalar(@$self);
  $n -= 1;
  if($n < 0){ $n = 0 }

  if($n !~ /\d+/){
     croak("Invalid argument to 'uc()' method");
  }

  if(want('OBJECT') || !(CORE::defined wantarray)){
     for(my $m = 0; $m <= $n; $m++){
        $self->[$m] = CORE::uc($self->[$m]);
     }
     undef $n;
     return $self;
  }

  my $copy = CORE::join('',@$self);
  return CORE::uc($copy);
}

sub ucfirst{
   my($self) = @_;

   if(want('OBJECT') || !(CORE::defined wantarray)){
      $self->[0] = CORE::uc($self->[0]);
      return $self;
   }

  my $copy = CORE::join('',@$self);
  return CORE::ucfirst($copy);
}

# Not yet implemented
#sub vec {}
1;
__END__

=head1 NAME

Set::String - Strings as objects with lots of handy methods (including set
comparisons) and support for method chaining.

=head1 SYNOPSIS

C<< my $s1 = Set::String->new("Hello"); >>

C<< my $s2 = Set::String->new("World!\n"); >>

C<< $s1->length->print; # prints 5 >>

C<< $s1->ord->join->print; # prints 72,101,108,108,111 >>

C<< $s2->chop(3)->print; # prints 'Worl' >>


=head1 PREREQUISITES

Perl 5.6 or later

Set::Array (also by me).  Available on CPAN.

The 'Want' module by Robin Houston.  Available on CPAN.

=head1 DESCRIPTION

Set::String allows you to create strings as objects and use OO-style methods
on them.  Many convenient methods are provided here that appear in the
FAQ's,
the Perl Cookbook or posts from comp.lang.perl.misc.
In addition, there are Set methods with corresponding (overloaded)
operators for the purpose of Set comparison, i.e. B<+>, B<==>, etc.

The purpose is to provide built-in methods for operations that people are
always asking how to do, and which already exist in languages like Ruby.
This
should (hopefully) improve code readability and/or maintainability.  The
other advantage to this module is method-chaining by which any number of
methods may be called on a single object in a single statement.

Note that Set::String is a subclass of Set::Array, and your string objects
are really just treated as an array of characters, ala C.  All methods
available
in Set::Array are available to you.

=head1 OBJECT BEHAVIOR

The exact behavior of the methods depends largely on the calling context.

B<Here are the rules>:

* If a method is called in void context, the object itself is modified.

* If the method called is not the last method in a chain (i.e. it's called
  in object context), the object itself is modified by that method
regardless
  of the 'final' context or method call.

* If a method is called in list or scalar context, a list or list
refererence
  is returned, respectively. The object itself is B<NOT> modified.

Here is a quick example:

C<< my $so = Set::String->new("Hello"); >>

C<< my @uniq = $so->unique(); # Object unmodified. >>

C<< $so->unique(); # Object modified, now contains 'Helo' >>

B<Here are the exceptions>:

* Methods that report a value, such as boolean methods like I<defined()> or
  other methods such as I<at()> or I<as_hash()>, never modify the object.

=head1 BOOLEAN METHODS

B<defined()> - Returns 1 if the string is defined.  Otherwise a 0 is
returned.

=head1 STANDARD METHODS

B<chomp(>I<?int?>B<)> - Deletes the last character of the string that
corresponds to $/, or the newline by default.  Optionally you may pass an
integer to this method to indicate the number of times you want the string
chomped.  In list context, a list of chomped values is returned.  In scalar
context, the number of chomped values is returned.

B<chop(>I<?int?>B<)> - Deletes the last character of the string.  Optionally
you
may pass an integer to this method to indicate the number of times you want
the
string chopped.  In list context, a list of chopped values is returned.  In
scalar context, the number of chopped values is returned.

B<eval> - Evaluates the string and returns the result.

B<lc(>I<?int?>B<)> - Lower case the string.  Optionally, you may pass an
integer
value to this method, in which case only that number of characters will be
lower cased (left to right), instead of the entire string.

B<lcfirst> - Lower case the first character of the string.

B<ord(>I<?int?>B<)> - Converts the string to a list of ord values, one per
character.  Alternatively, you may provide an optional integer argument, in
which case only that number of characters will be converted to ord values.
An array or array ref of ord values is returned in list or scalar context,
respectively.

B<uc(>I<?int?>B<)> - Upper case the string.  Otherwise identical to the
'lc()'
method, above.

=head1 KNOWN BUGS

None.  Please let me know if you find any.

=head1 FUTURE PLANS

Add the 'pack', 'unpack', 'substr' and 'vec' methods.

Allow arguments to be passed to the 'eval()' method.  I am not sure what the
behavior should be at that point, however.  Should it replace the string
object?
Should the results of that evaluation be appended to the original string?
Ideas welcome.

Add character ranges to some of the methods

=head1 AUTHOR

Daniel Berger

djberg96@hotmail.com
