use v6.c;

use NativeCall;

use GTK::Roles::Pointers;

unit package AMTK::Raw::Types;

constant amtk is export = 'amtk-5',v0;

class AmtkActionInfo             is repr('CPointer') is export does GTK::Roles::Pointers { }
class AmtkActionInfoCentralStore is repr('CPointer') is export does GTK::Roles::Pointers { }
class AmtkActionInfoStore        is repr('CPointer') is export does GTK::Roles::Pointers { }
class AmtkApplicationWindow      is repr('CPointer') is export does GTK::Roles::Pointers { }
class AmtkFactory                is repr('CPointer') is export does GTK::Roles::Pointers { }
class AmtkMenuShell              is repr('CPointer') is export does GTK::Roles::Pointers { }

class AmtkActionInfoEntry is repr('CStruct') is export {
	use nqp;

	has Str $!action_name;
	has Str $!icon_name;
	has Str $!label;
	has Str $!accel;
	has Str $!tooltip;

	method action_name is rw {
		Proxy.new:
			FETCH => -> $ { $!action_name },
			STORE => -> $, Str() $val {
				nqp::bindattr(
					nqp::decont(self),
					AmtkActionInfoEntry,
					'$!action_name',
					nqp::decont( $val )
				);
			}
	}

	method icon_name is rw {
		Proxy.new:
			FETCH => -> $ { $!icon_name },
			STORE => -> $, Str() $val {
				nqp::bindattr(
					nqp::decont(self),
					AmtkActionInfoEntry,
					'$!icon_name',
					nqp::decont( $val )
				);
			}
	}

	method label is rw {
		Proxy.new:
			FETCH => -> $ { $!label },
			STORE => -> $, Str() $val {
				nqp::bindattr(
					nqp::decont(self),
					AmtkActionInfoEntry,
					'$!label',
					nqp::decont( $val )
				);
			}
	}

	method accel is rw {
		Proxy.new:
			FETCH => -> $ { $!accel },
			STORE => -> $, Str() $val {
				nqp::bindattr(
					nqp::decont(self),
					AmtkActionInfoEntry,
					'$!accel',
					nqp::decont( $val )
				);
			}
	}

	method tooltip is rw {
		Proxy.new:
			FETCH => -> $ { $!tooltip },
			STORE => -> $, Str() $val {
				nqp::bindattr(
					nqp::decont(self),
					AmtkActionInfoEntry,
					'$!tooltip',
					nqp::decont( $val )
				);
			}
	}

  submethod BUILD (
    :$action_name,
    :$icon_name,
    :$label,
    :$accel,
    :$tooltip
  ) {
		say "{ ::?CLASS.^name } BUILD enter";
		self.action_name = $action_name;
		self.icon_name   = $icon_name;
		self.label       = $label;
		self.accel       = $accel;
		self.tooltip     = $tooltip;
		say "{ ::?CLASS.^name } BUILD exit;";
	}

  method new (
    Str() $action_name,
    Str() $icon_name   = Str,
    Str() $label       = Str,
    Str() $accel       = Str,
    Str() $tooltip     = Str
  ) {
    self.bless(
      :$action_name,
      :$icon_name,
      :$label,
      :$accel,
      :$tooltip
    );
  }
}

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
