use v6.c;

use NativeCall;

use GTK::Roles::Pointer;

class AmtkActionInfo             is repr('CPointer') is export does GTK::Roles::Pointers { }
class AmtkActionInfoCentralStore is repr('CPointer') is export does GTK::Roles::Pointers { }
class AmtkActionInfoEntry        is repr('CPointer') is export does GTK::Roles::Pointers { }
class AmtkActionInfoStore        is repr('CPointer') is export does GTK::Roles::Pointers { }
class AmtkApplicationWindow      is repr('CPointer') is export does GTK::Roles::Pointers { }
class AmtkFactory                is repr('CPointer') is export does GTK::Roles::Pointers { }
class AmtkMenuShell              is repr('CPointer') is export does GTK::Roles::Pointers { }

our enum AmtkFactoryFlags is export (
  AMTK_FACTORY_FLAGS_NONE            =>  0,
  AMTK_FACTORY_IGNORE_GACTION        =>  1,
  AMTK_FACTORY_IGNORE_ICON           =>  1 +< 1,
  AMTK_FACTORY_IGNORE_LABEL          =>  1 +< 2,
  AMTK_FACTORY_IGNORE_TOOLTIP        =>  1 +< 3,
  AMTK_FACTORY_IGNORE_ACCELS         =>  1 +< 4,
  AMTK_FACTORY_IGNORE_ACCELS_FOR_DOC =>  1 +< 5,
  AMTK_FACTORY_IGNORE_ACCELS_FOR_APP =>  1 +< 6,
);
