use v6.c;

use Method::Also;
use NativeCall;

use AMTK::Raw::Types;
use GLib::Roles::TypedBuffer;

class AMTK::ActionInfoEntryBlock {
  also does GLib::Roles::TypedBuffer[AmtkActionInfoEntry];

  method AMTK::Raw::Types::AmtkActionInfoEntry {
    cast(AmtkActionInfoEntry, $!b);
  }

}

class AMTK::GActionEntryBlock {
  also does GLib::Roles::TypedBuffer[GActionEntry];

  method GTK::Compat::Raw::GActionEntry {
    cast(GActionEntry, $!b);
  }

}
