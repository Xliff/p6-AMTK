use v6.c;

use Method::Also;
use NativeCall;

use GTK::Compat::Types;
use GTK::Raw::Types;
use AMTK::Raw::Types;

use GTK::Raw::Utils;

use AMTK::Raw::Subs;

use GLib::Roles::StaticClass;

use GTK::Compat::Roles::Object;
use AMTK::Roles::Signals;
use AMTK::Roles::TypedBuffer;

#----- RE-REFINE!!! ----

# CLASS OBJECT
class AMTK::Main {
  also does GLib::Roles::StaticClass;

  method finalize {
    amtk_finalize;
  }

  method init {
    amtk_init;
  }
}

# BOXED TYPE

class AMTK::ActionInfo {
  has AmtkActionInfo $!i;

  submethod BUILD (:$info) {
    $!i = $info;
  }

  method AMTK::Raw::Types::AmtkActionInfo
    #is also<ActionInfo>
  { $!i }

  multi method new (AmtkActionInfo $info) {
    self.bless(:$info);
  }
  multi method new {
    self.bless( info => amtk_action_info_new() );
  }

  method new_from_entry (
    AmtkActionInfoEntry $info_entry,
    Str() $translation_domain = Str
  )
    is also<new-from-entry>
  {
    self.bless(
      info => amtk_action_info_new_from_entry(
        $info_entry,
        $translation_domain
      )
    );
  }

  method accels is rw {
    Proxy.new:
      FETCH => -> $,          { self.get_accels     },
      STORE => -> $, @a       { self.set_accels(@a) };
  }

  method action_name is rw is also<action-name> {
    Proxy.new:
      FETCH => -> $           { self.get_action_name     },
      STORE => -> $, Str() $v { self.set_action_name($v) };
  }

  method icon_name is rw is also<icon-name> {
    Proxy.new:
      FETCH => -> $           { self.get_icon_name     },
      STORE => -> $, Str() $v { self.set_icon_name($v) };
  }

  method label is rw {
    Proxy.new:
      FETCH => -> $           { self.get_label     },
      STORE => -> $, Str() $v { self.set_label($v) };
  }

  method tooltip is rw {
    Proxy.new:
      FETCH => -> $           { self.get_tooltip     },
      STORE => -> $, Str() $v { self.set_tooltip($v) };
  }

  method copy {
    self.bless( info => amtk_action_info_copy($!i) );
  }

  method get_accels is also<get-accels> {
    my ($i, @a) = ( 0 );
    my CArray[Str] $a = amtk_action_info_get_accels($!i);
    @a[$i] = $a[$i++] while $a[$i].defined;
    @a;
  }

  method get_action_name is also<get-action-name> {
    amtk_action_info_get_action_name($!i);
  }

  method get_icon_name is also<get-icon-name> {
    amtk_action_info_get_icon_name($!i);
  }

  method get_label is also<get-label> {
    amtk_action_info_get_label($!i);
  }

  method get_tooltip is also<get-tooltip> {
    amtk_action_info_get_tooltip($!i);
  }

  method get_type is also<get-type> {
    amtk_action_info_get_type();
  }

  method has_been_used is also<has-been-used> {
    so amtk_action_info_has_been_used($!i);
  }

  method mark_as_used is also<mark-as-used> {
    amtk_action_info_mark_as_used($!i);
  }

  method ref {
    amtk_action_info_ref($!i);
  }

  proto method set_accels (|)
    is also<set-accels>
  { * }

  multi method set_accels (@accels) {
    die 'Must be an array of string compatible objects.'
      unless @accels.grep({ $_.^can('Str').elems }).elems == @accels.elems;
    my $a = CArray[Str].new;
    $a[$_] = @accels[$_] for ^@accels;
    $a[@accels.elems] = Str;
    samewith($a);
  }
  multi method set_accels (CArray[Str] $accels) {
    amtk_action_info_set_accels($!i, $accels);
  }

  method set_action_name (Str() $action_name) is also<set-action-name> {
    amtk_action_info_set_action_name($!i, $action_name);
  }

  method set_icon_name (Str() $icon_name) is also<set-icon-name> {
    amtk_action_info_set_icon_name($!i, $icon_name);
  }

  method set_label (Str() $label) is also<set-label> {
    amtk_action_info_set_label($!i, $label);
  }

  method set_tooltip (Str() $tooltip) is also<set-tooltip> {
    amtk_action_info_set_tooltip($!i, $tooltip);
  }

  method unref {
    amtk_action_info_unref($!i);
  }
}

# GObject

class AMTK::ActionInfoCentralStore {
  my AmtkActionInfoCentralStore $singleton;

  submethod BUILD (:$store) {
    $singleton //= $store;
  }

  method AMTK::Raw::Types::ActionInfoCentralStore
    is also<AmtkActionInfoCentralStore>
  { $singleton }

  method get_singleton (AMTK::ActionInfoCentralStore:U: )
    is also<get-singleton>
  {
    self.bless(
      store => $singleton // amtk_action_info_central_store_get_singleton()
    );
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &amtk_action_info_central_store_get_type,
      $t,
      $n
    );
  }

  method lookup (AMTK::ActionInfoCentralStore:D: Str() $action_name) {
    say "{ ::?CLASS.^name }: Looking up action { $action_name }..." if $DEBUG;
    my $l = amtk_action_info_central_store_lookup(
      $singleton,
      $action_name
    );
    my $lo = $l.defined ?? AMTK::ActionInfo.new($l) !! Nil;
    say "{ ::?CLASS.^name }: Result: $l" if $DEBUG;
    $lo
  }

}

# CLASS OBJECT
class AMTK::ActionMap {
  also does GLib::Roles::StaticClass;

  proto method acc_action_entries_check_dups
    is also<add-action-entries-check-dups>
  { * }

  multi method add_action_entries_check_dups(
    GActionMap() $action_map,
    @entries,
    gpointer $user_data = gpointer
  ) {
    my $e = AMTK::GActionEntryBlock.new(@entries);

    samewith($action_map, $e.p, $e.elems, $user_data)
  }
  multi method add_action_entries_check_dups (
    GActionMap() $action_map,
    Pointer $entries,                       # BLOCK of GActionEntry
    Int() $n_entries,
    gpointer $user_data = gpointer
  ) {
    my gint $ne = $n_entries;

    amtk_action_map_add_action_entries_check_dups(
      $action_map,
      $entries,
      $ne,
      $user_data
    );
  }

}

# GObject

our subset AmtkApplicationWindowAncestry is export of Mu
  where AmtkApplicationWindow | GActionMap | GObject;

class AMTK::ApplicationWindow {
  use GTK::Application;
  use GTK::MenuItem;
  use GTK::RecentChooserMenu;
  use GTK::MenuItem;
  use GTK::Statusbar;

  use GIO::Roles::ActionMap;

  also does GIO::Roles::ActionMap;
  also does GTK::Compat::Roles::Object;

  has AmtkApplicationWindow $!aaw is implementor;

  # Should have ancestry logic to account for GObject and GActionMap
  submethod BUILD (:$window) {
    given $window {
      when AmtkApplicationWindowAncestry {
        self.setAmtkApplicationWindow($window);
      }

      when AMTK::ApplicationWindow {
      }

      default {
      }
    }
  }

  method setAmtkApplicationWindow (AmtkApplicationWindowAncestry $_) {
    my $to-parent;

    $!aaw = do {
      when AmtkApplicationWindow {
        $_;
      }

      when GActionMap {
        $!actmap = $_;
        cast(AmtkApplicationWindow, $_);
      }

      default {
        cast(AmtkApplicationWindow, $_);
      }
    };

    self.roleInit-Object
    self.roleInit-ActionMap unless $!actmap;
  }

  method AMTK::Raw::Types::AmtkApplicationWindow
    is also<AmtkApplicationWindow>
  { $!aaw }

  multi method new (AmtkApplicationWindow $window) {
    return unless $window;

    self.bless(:$window);
  }

  method get_from_gtk_application_window (
    GtkApplicationWindow $gtk_window
  )
    is also<get-from-gtk-application-window>
  {
    my $aw =
      amtk_application_window_get_from_gtk_application_window($gtk_window);

    $aw ?? self.bless( window => $aw ) !! Nil;
  }

  method statusbar is rw {
    Proxy.new:
      FETCH => -> $                    { self.get_statusbar     },
      STORE => -> $, GtkStatusbar() $v { self.set_statusbar($v) };
  }

  method connect_menu_to_statusbar (
    GtkMenuShell() $menu_shell
  )
    is also<connect-menu-to-statusbar>
  {
    amtk_application_window_connect_menu_to_statusbar($!aaw, $menu_shell);
  }

  method connect_recent_chooser_menu_to_statusbar (
    GtkRecentChooserMenu() $menu
  )
    is also<connect-recent-chooser-menu-to-statusbar>
  {
    amtk_application_window_connect_recent_chooser_menu_to_statusbar(
      $!aaw,
      $menu
    );
  }

  method create_open_recent_menu is also<create-open-recent-menu> {
    GTK::RecentChooserMenu.new(
      amtk_application_window_create_open_recent_menu($!aaw)
    );
  }

  method create_open_recent_menu_item is also<create-open-recent-menu-item> {
    GTK::MenuItem.new(
      amtk_application_window_create_open_recent_menu_item($!aaw)
    );
  }

  method get_application_window is also<get-application-window> {
    GTK::MenuItem.new(
      amtk_application_window_get_application_window($!aaw)
    );
  }

  method get_statusbar is also<get-statusbar> {
    GTK::Statusbar.new(
      amtk_application_window_get_statusbar($!aaw)
    );
  }

  method get_type is also<get-type> {
    state ($n, $t);
    unstable_get_type(
      self.^name,
      &amtk_application_window_get_type,
      $n,
      $t
    );
  }

  method set_statusbar (GtkStatusbar() $statusbar) is also<set-statusbar> {
    amtk_application_window_set_statusbar($!aaw, $statusbar);
  }

}

# GObject

class AMTK::Factory {
  use GTK::Compat::MenuItem;
  use GTK::Application;
  use GTK::CheckMenuItem;
  use GTK::Menu;
  use GTK::MenuItem;
  use GTK::MenuToolButton;
  use GTK::ToolItem;
  use GTK::ShortcutsShortcut;

  also does GTK::Compat::Roles::Object;

  has AmtkFactory $!af;

  submethod BUILD (:$factory) {
    self!setObject($!af = $factory);
  }

  method AMTK::Raw::Types::AmtkFactory
    #is also<AmtkFactory>
  { $!af }

  multi method new (AmtkFactory $factory) {
    self.bless(:$factory);
  }
  multi method new (GtkApplication() $application) {
    self.bless( factory => amtk_factory_new($application) );
  }
  multi method new {
    my $factory = amtk_factory_new_with_default_application;
    self.bless(:$factory);
  }

  method default_flags is rw is also<default-flags> {
    Proxy.new:
      FETCH => -> $           { self.get_default_flags },
      STORE => -> $, Int() $f { self.set_default_flags($f) };
  }

  # ↓↓↓↓ Return objects here!
  method create_check_menu_item (Str() $action_name)
    is also<create-check-menu-item>
  {
    GTK::CheckMenuItem.new(
      amtk_factory_create_check_menu_item($!af, $action_name)
    );
  }

  method create_check_menu_item_full (
   Str() $action_name,
   Int() $flags
  )
    is also<create-check-menu-item-full>
  {
    my guint $f = $flags;
    GTK::CheckMenuItem.new(
      amtk_factory_create_check_menu_item_full($!af, $action_name, $f)
    );
  }

  method create_gmenu_item (Str() $action_name) is also<create-gmenu-item> {
    GTK::Compat::MenuItem.new(
      amtk_factory_create_gmenu_item($!af, $action_name)
    );
  }

  method create_gmenu_item_full (
    Str() $action_name,
    Int() $flags
  )
    is also<create-gmenu-item-full>
  {
    my guint $f = $flags;
    GTK::Compat::MenuItem.new(
      amtk_factory_create_gmenu_item_full($!af, $action_name, $f)
    );
  }

  method create_menu_item (Str() $action_name) is also<create-menu-item> {
    GTK::MenuItem.new(
      amtk_factory_create_menu_item($!af, $action_name)
    );
  }

  method create_menu_item_full (Str() $action_name, Int() $flags)
    is also<create-menu-item-full>
  {
    my guint $f = $flags;
    GTK::MenuItem.new(
      amtk_factory_create_menu_item_full($!af, $action_name, $f)
    );
  }

  method create_menu_tool_button (Str() $action_name)
    is also<create-menu-tool-button>
  {
    GTK::MenuToolButton.new(
      amtk_factory_create_menu_tool_button($!af, $action_name)
    );
  }

  method create_menu_tool_button_full (Str() $action_name, Int() $flags)
    is also<create-menu-tool-button-full>
  {
    my guint $f = $flags;
    GTK::MenuToolButton.new(
      amtk_factory_create_menu_tool_button_full($!af, $action_name, $f)
    );
  }

  method create_shortcut (Str() $action_name) is also<create-shortcut> {
    GTK::ShortcutsShortcut.new(
      amtk_factory_create_shortcut($!af, $action_name)
    );
  }

  method create_shortcut_full (Str() $action_name, Int() $flags)
    is also<create-shortcut-full>
  {
    my guint $f = $flags;
    GTK::ShortcutsShortcut.new(
      amtk_factory_create_shortcut_full($!af, $action_name, $f)
    );
  }

  proto method create_simple_menu (|)
    is also<create-simple-menu>
  { * }

  multi method create_simple_menu (@entries)  {
    my $e = AMTK::ActionInfoEntryBlock.new(@entries);
    samewith($e, $e.elems);
  }
  multi method create_simple_menu (
    AmtkActionInfoEntry() $entries,             # BLOCK of AmtkActionInfoEntry
    Int() $n_entries
  ) {
    my gint $n = $n_entries;
    GTK::Menu.new(
      amtk_factory_create_simple_menu($!af, $entries, $n)
    );
  }

  method create_simple_menu_full (
    AmtkActionInfoEntry $entries,
    Int() $n_entries,
    Int() $flags
  )
    is also<create-simple-menu-full>
  {
    my guint $f = $flags;
    my gint $n = $n_entries;
    GTK::Menu.new(
      amtk_factory_create_simple_menu_full($!af, $entries, $n, $f)
    );
  }

  method create_tool_button (Str() $action_name) is also<create-tool-button> {
    GTK::ToolButton.new(
      amtk_factory_create_tool_button($!af, $action_name)
    );
  }

  method create_tool_button_full (Str() $action_name, Int() $flags)
    is also<create-tool-button-full>
  {
    my guint $f = $flags;
    GTK::ToolButton.new(
      amtk_factory_create_tool_button_full($!af, $action_name, $f)
    );
  }
  # ↑↑↑↑ Return objects here!

  method get_application is also<get-application> {
    my $a = amtk_factory_get_application($!af);
    $a.defined ?? GTK::Application.new($a) !! Nil;
  }

  method get_default_flags is also<get-default-flags> {
    AmtkFactoryFlags( amtk_factory_get_default_flags($!af) );
  }

  method get_type is also<get-type> {
    state ($n, $t);
    unstable_get_type( self.^name, &amtk_factory_get_type, $n, $t );
  }

  method set_default_flags (Int() $default_flags) is also<set-default-flags> {
    my guint $d = $default_flags;
    amtk_factory_set_default_flags($!af, $d);
  }

}

# CLASS OBJECT
class AMTK::MenuItem {

  method new(|) {
    warn "{ ::?CLASS.^name } cannot be instantiated!";
    AMTK::MenuItem;
  }

  method get_long_description (GtkMenuItem() $menu_item)
    is also<get-long-description>
  {
    amtk_menu_item_get_long_description($menu_item);
  }

  method set_icon_name (GtkMenuItem() $item, Str() $icon_name)
    is also<set-icon-name>
  {
    amtk_menu_item_set_icon_name($item, $icon_name);
  }

  method set_long_description (
    GtkMenuItem() $menu_item,
    Str() $long_description
  )
    is also<set-long-description>
  {
    amtk_menu_item_set_long_description($menu_item, $long_description);
  }

}


# GObject

class AMTK::MenuShell {
  also does GTK::Compat::Roles::Object;
  also does AMTK::Roles::Signals::MenuShell;

  has AmtkMenuShell $!ams;

  submethod BUILD (:$shell) {
    self!setObject($!ams = $shell);
  }

  method new (AmtkMenuShell $shell) {
    self.bless(:$shell);
  }

  method get_from_gtk_menu_shell (GtkMenuShell() $gtk_menu_shell)
    is also<get-from-gtk-menu-shell>
  {
    self.bless(
      shell => amtk_menu_shell_get_from_gtk_menu_shell($gtk_menu_shell)
    );
  }

  # Potential Conflict allowed due to compatibility.
  method AMTK::Raw::Types::AmtkMenuShell
    is also<MenuShell>
  { * }

  # Is originally:
  # AmtkMenuShell, GtkMenuItem, gpointer --> void
  method menu-item-deselected is also<menu_item_deselected> {
    self.connect-menu-item-deselected($!ams);
  }

  # Is originally:
  # AmtkMenuShell, GtkMenuItem, gpointer --> void
  method menu-item-selected is also<menu_item_selected> {
    self.connect-menu-item-selected($!ams);
  }

  method get_menu_shell is also<get-menu-shell> {
    GTK::MenuShell.new(
      amtk_menu_shell_get_menu_shell($!ams)
    );
  }

  method get_type is also<get-type> {
    state ($n, $t);
    unstable_get_type( self.^name, &amtk_menu_shell_get_type, $n, $t );
  }

}

# CLASS OBJECT

class AMTK::GMenu {

  method new(|) {
    warn "{ ::?CLASS.^name } cannot be instantiated!";
    AMTK::GMenu;
  }

  method append_item (GMenu() $menu, GMenuItem() $item) is also<append-item> {
    amtk_gmenu_append_item($menu, $item);
  }

  method append_section (GMenu() $menu, Str() $label, GMenu() $section)
    is also<append-section>
  {
    amtk_gmenu_append_section($menu, $label, $section);
  }

}

# CLASS OBJECT

class AMTK::ShortcutsGroup {
  use GTK::ShortcutsGroup;

  proto method new (|) { * }

  multi method new (Str() $title) {
    GTK::ShortcutsGroup.new(
      amtk_shortcuts_group_new($title)
    )
  }
}

# CLASS OBJECT

class AMTK::ShortcutsSection {
  use GTK::ShortcutsSection;

  proto method new (|) { * }

  multi method new (Str() $title) {
    GTK::ShortcutsSection.new(
      amtk_shortcuts_section_new($title)
    )
  }
}

# CLASS OBJECT

class AMTK::ShortcutsWindow {
  use GTK::ShortcutsWindow;

  proto method new (|) { * }

  multi method new (GtkWindow() $parent) {
    GTK::ShortcutsWindow.new(
      amtk_shortcuts_window_new($parent)
    );
  }
}

# CLASS OBJECT

class AMTK::Shortcuts {
  method new_group (Str() $g) is also<new-group> {
    AMTK::ShortcutsGroup.new($g);
  }

  method new_section (Str() $t) is also<new-section> {
    AMTK::ShortcutsSection.new($t);
  }

  method new_window (GtkWindow() $p) is also<new-window> {
    AMTK::ShortcutsWindow.new($p);
  }

  method new(|) {
    warn "{ ::?CLASS.^name } cannot be instantiated!";
    AMTK::Shortcuts;
  }
}


# CLASS OBJECT
class AMTK::Utils {
  also does GLib::Roles::StaticClass;

  method bind_g_action_to_gtk_action (|)
    is DEPRECATED
    is also<bind-g-action-to-gtk-action>
  {
    die 'This methd is not implemented due to the deprecation of GTK::Action';
  }

  # method bind_g_action_to_gtk_action (
  #   GActionMap() $g_action_map,
  #   Str() $detailed_g_action_name_without_prefix,
  #   GtkActionGroup() $gtk_action_group,
  #   Str() $gtk_action_name
  # ) {
  #   amtk_utils_bind_g_action_to_gtk_action(
  #     $g_action_map,
  #     $detailed_g_action_name_without_prefix,
  #     $gtk_action_group,
  #     $gtk_action_name
  #   );
  # }

  method create_gtk_action (|) is also<create-gtk-action> {
    die 'This method not implemented due to the deprecation of GtkAction';
  }

  # method create_gtk_action (
  #   GActionMap() $g_action_map,
  #   Str() $detailed_g_action_name_with_prefix,
  #   GtkActionGroup() $gtk_action_group,
  #   Str() $gtk_action_name
  # ) {
  #   amtk_utils_create_gtk_action(
  #     $g_action_map,
  #     $detailed_g_action_name_with_prefix,
  #     $gtk_action_group,
  #     $gtk_action_name
  #   );
  # }

  method recent_chooser_menu_get_item_uri (
    GtkRecentChooserMenu() $menu,
    GtkMenuItem() $item
  )
    is also<recent-chooser-menu-get-item-uri>
  {
    amtk_utils_recent_chooser_menu_get_item_uri($menu, $item);
  }

  method remove_mnemonic (Str() $str) is also<remove-mnemonic> {
    amtk_utils_remove_mnemonic($str);
  }

}

# GObject

class AMTK::ActionInfoStore {
  also does GTK::Compat::Roles::Object;

  has AmtkActionInfoStore $!ais;

  submethod BUILD (:$store) {
    self!setObject($!ais = $store);
  }

  multi method new (AmtkActionInfoStore $store) {
    self.bless(:$store);
  }
  multi method new {
    self.bless( store => amtk_action_info_store_new() );
  }

  method AMTK::Raw::Types::AmtkActionInfoStore
    is also<
      AmtkActionInfoStore
      ActionInfoStore
    >
  { $!ais }

  method add (AmtkActionInfo() $info) {
    amtk_action_info_store_add($!ais, $info);
  }

  proto method add_entries (|)
    is also<add-entries>
  { * }

  multi method add_entries(
    @entries,
    Str() $translation_domain = Str
  ) {
    my $b = AMTK::ActionInfoEntryBlock.new(@entries);
    samewith($b, $b.elems, $translation_domain);
  }
  multi method add_entries (
    Pointer() $entries,
    Int()     $n_entries,
    Str()     $translation_domain = Str
  ) {
    my gint $n = $n_entries;
    amtk_action_info_store_add_entries(
      $!ais,
      $entries,
      $n,
      $translation_domain
    );
  }

  method check_all_used is also<check-all-used> {
    amtk_action_info_store_check_all_used($!ais);
  }

  method get_type is also<get-type> {
    state ($n, $t);
    unstable_get_type( self.^name, &amtk_action_info_store_get_type, $n, $t );
  }

  method lookup (Str() $action_name) {
    say "Looking up action: { $action_name }..." if $DEBUG;;
    my $info = amtk_action_info_store_lookup($!ais, $action_name);
    say "ActionInfo: $info" if $DEBUG;
    $info.defined ?? AMTK::ActionInfo.new($info) !! Nil;
  }

  method set_all_accels_to_app (GtkApplication() $application)
    is also<set-all-accels-to-app>
  {
    amtk_action_info_store_set_all_accels_to_app($!ais, $application);
  }
}

sub EXPORT {
  %(
    AMTK::Raw::Types::EXPORT::DEFAULT::,
  );
}
