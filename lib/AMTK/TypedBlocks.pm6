use v6.c;

use Method::Also;
use NativeCall;

use GTK::Compat::Types;
use AMTK::Raw::Types;

use GTK::Raw::Utils;

use GTK::Compat::Roles::TypedBuffer;

class AMTK::ActionInfoEntryBlock {
  also does GTK::Compat::Roles::TypedBuffer[AmtkActionInfoEntry];

  method AMTK::Raw::Types::AmtkActionInfoEntry {
    nativecast(AmtkActionInfoEntry, $!b);
  }

}

class AMTK::GActionEntryBlock {
  also does GTK::Compat::Roles::TypedBuffer[GActionEntry];

  method GTK::Compat::Raw::GActionEntry {
    nativecast(GActionEntry, $!b);
  }

}
