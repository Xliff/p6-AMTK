use v6.c;

use Method::Also;
use NativeCall;

use GTK::Compat::Types;
use AMTK::Raw::Types;

use GTK::Raw::Utils;

role AMTK::Roles::TypedBuffer[::T] does Positional {
  has $!size;
  has Pointer $!b;

  submethod BUILD (:$!size) {
    my uint64 $s1 = resolve-uint64($!size );
    $!b = calloc( $s1, nativesizeof(T) );
  }

  submethod DESTROY {
    # Free individual elements, as well!
    #if $!size.defined {
    #  free(self[$_]) for ^$!size;
    #}
    #free( $!b // nativecast(Pointer, self) );
  }

  method NativeCall::Types::Pointer
    is also<
      Pointer
      p
    >
  { $!b }

  # Cribbed from MySQL::Native. Thanks, ctilmes!
  method AT-POS(Int $field) {
    # warn 'Must call .setSize before attempting to use as a positional!'
    #   unless $!size.defined;
    # unless $!b.defined {
    #   $!b = nativecast(
    #     Pointer,
    #     Buf.allocate( $!size * nativesizeof(T) )
    #   );
    # }s
    nativecast(
      T,
      Pointer.new( $!b + $field * nativesizeof(T) )
    )
  }

  # For use on externally retrieved data.
  method setSize(Int() $s) {
    warn 'Cannot reset size!' if $!size.defined;
    $!size = $s unless $!size.defined;
  }

  method bind (Int() $pos, T $elem) {
    my uint64 $p = resolve-uint($pos);
    memcpy(
      Pointer.new( $!b + $p * nativesizeof(T) ),
      nativecast(Pointer, $elem),
      nativesizeof(T)
    );
  }

  method elems {
    $!size;
  }

  method new (@entries) {
    die qq:to/D/.chomp unless @entries.all ~~ T;
    { ::?CLASS.^name } can only be initialized if all entries are an { T.^name }
    D

    my $o = self.bless( size => @entries.elems );
    for ^@entries.elems {
      $o.bind( $_, @entries[$_] );
    }
    $o;
  }

  # Infinite loop, dummy!
  #method allocate (Int() $n, *@fill) {
  # method allocate (Int() $n) {
  #   # Implement fill pattern, later.
  #   my $p = Pointer.new( calloc($n * nativesizeof(T)) );
  #   memcpy($p, $n * nativesizeof(T), 0);

}

class AMTK::ActionInfoEntryBlock {
  also does AMTK::Roles::TypedBuffer[AmtkActionInfoEntry];

  method AMTK::Raw::Types::AmtkActionInfoEntry {
    nativecast(AmtkActionInfoEntry, $!b);
  }

}

class AMTK::GActionEntryBlock {
  also does AMTK::Roles::TypedBuffer[GActionEntry];

  method GTK::Compat::Raw::GActionEntry {
    nativecast(GActionEntry, $!b);
  }

}
