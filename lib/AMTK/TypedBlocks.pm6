use v6.c;

use Method::Also;
use NativeCall;

use GTK::Compat::Types;
use AMTK::Raw::Types;

use GTK::Raw::Utils;

use GLib::Roles::TypedBuffer;

class AMTK::ActionInfoEntryBlock {
  also does GLib::Roles::TypedBuffer[AmtkActionInfoEntry];

  method AMTK::Raw::Types::AmtkActionInfoEntry {
    nativecast(AmtkActionInfoEntry, $!b);
  }

}

class AMTK::GActionEntryBlock {
  also does GLib::Roles::TypedBuffer[GActionEntry];

  method GTK::Compat::Raw::GActionEntry {
    nativecast(GActionEntry, $!b);
  }

}
