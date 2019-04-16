use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GTK::Raw::Types;
use AMTK::Raw::Types;

role AMTK::Roles::Signals::MenuShell {
  has %!signals-ams;
  
  # AmtkMenuShell, GtkMenuItem, gpointer
  method connect-menu-item-deselected (
    $obj,
    $signal = 'menu-item-deselected',
    &handler?
  ) {
    my $hid;
    %!signals-ams{$signal} //= do {
      my $s = Supplier.new;
      $hid = g-connect-menu-item-deselected($obj, $signal,
        -> $, $gmim, $ud {
          CATCH {
            default { $s.quit($_) }
          }

          $s.emit( [self, $gmim, $ud] );
        },
        Pointer, 0
      );
      [ $s.Supply, $obj, $hid ];
    };
    %!signals-ams{$signal}[0].tap(&handler) with &handler;
    %!signals-ams{$signal}[0];
  }

  # AmtkMenuShell, GtkMenuItem, gpointer
  method connect-menu-item-selected (
    $obj,
    $signal = 'menu-item-selected',
    &handler?
  ) {
    my $hid;
    %!signals-ams{$signal} //= do {
      my $s = Supplier.new;
      $hid = g-connect-menu-item-selected($obj, $signal,
        -> $, $gmim, $ud {
          CATCH {
            default { $s.quit($_) }
          }

          $s.emit( [self, $gmim, $ud] );
        },
        Pointer, 0
      );
      [ $s.Supply, $obj, $hid ];
    };
    %!signals-ams{$signal}[0].tap(&handler) with &handler;
    %!signals-ams{$signal}[0];
  }
}

# AmtkMenuShell, GtkMenuItem, gpointer
sub g-connect-menu-item-deselected(
  Pointer $app,
  Str $name,
  &handler (Pointer, GtkMenuItem, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native('gobject-2.0')
  is symbol('g_signal_connect_object')
  { * }

# AmtkMenuShell, GtkMenuItem, gpointer
sub g-connect-menu-item-selected(
  Pointer $app,
  Str $name,
  &handler (Pointer, GtkMenuItem, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native('gobject-2.0')
  is symbol('g_signal_connect_object')
  { * }
