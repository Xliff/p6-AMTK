use v6.c;

use NativeCall;

role AMTK::TypedBuffer[::T] does Positional {
  has $!size;

  # Cribbed from MySQL::Native. Thanks, ctilmes!
  method AT-POS(Int $field) {
    nativecast(
      T,
      Pointer.new( self + $field * nativesizeof(T) )
    )
  }

  method setSize(Int() $s) {
    $!size = $s;
  }

  method elems {
    do given self {
      when Buf {
        self.Buf::elems / nativesizeof(T);
      }
      when CArray {
        warn 'Cannot find size of CArray unless specified.'
          unless $!size.defined;
        $!size;
      }
      default {
        die "Can't handle size of base type '{ self.^name }'";
      }
    }
  }

  method allocate (Int() $n, *@fill) {
    self.allocate( $n * nativesizeof(T), @fill // 0 );
  }

}
