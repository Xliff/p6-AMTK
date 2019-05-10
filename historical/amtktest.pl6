use v6.c;

use NativeCall;

use GTK::Compat::Types;
use AMTK::Roles::TypedBuffer;

sub printActionEntries(Pointer, uint32)
  is native('./amtktest')
  { * }

sub MAIN {
  my @entries = (
    GActionEntry.new('print'#, -> GSimpleAction, GVariant, gpointer {
    #   say 'Print'
    # }
    ),
    GActionEntry.new(
      'shortcuts-window'#,
      # -> GSimpleAction, GVariant, gpointer {
      #   shortcuts_window_activate_cb ($w);
      # }
    )
  );

  my $gab = AMTK::GActionEntryBlock.new(@entries);

  say "P6 Size = { nativesizeof(GActionEntry) }";
  printActionEntries($gab.p, 2);
}
