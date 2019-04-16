use v6.c;

use GTK::Compat::Types;
use GTK::Raw::Types;
use AMTK::Raw::Types;

use GTK::Raw::Utils;

use GTK::Compat::Roles::Object;
use AMTK::Roles::Signals;

# CLASS OBJECT
class AMTK {
  
  method amtk_finalize {
    amtk_finalize;
  }

  method amtk_init {
    amtk_init;
  }
  
}

# BOXED TYPE
class AMTK::ActionInfo { 
  has AmtrackActionInfo $!i;
  
  submethod BUILD (:$info) {
    $!i = $info;
  }
  
  method new {
    self.bless( info => amtk_action_info_new() );
  }

  method new_from_entry (
    AmtkActionInfoEntry $info_entry, 
    Str() $translation_domain
  ) {
    self.bless( 
      info => amtk_action_info_new_from_entry(
        $info_entry, 
        $translation_domain
      )
    );
  }
  
  method action_name is rw {
    Proxy.new:
      FETCH => -> $           { self.get_action_name },
      STORE => -> $, Str() $v { self.set_action_name($v) };
  }
  
  method icon_name is rw {
    Proxy.new:
      STORE => -> $, Str() $v { self.set_icon_name($v) };
      FETCH => -> $           { self.get_icon_name     },
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

  method get_accels {
    my $c = amtk_action_info_get_accels($!i);
    my ($i, @c) = (0);
    @c[$i] = $c[$i++] while $c[$i].defined;
    @c;
  }

  method get_action_name {
    amtk_action_info_get_action_name($!i);
  }

  method get_icon_name {
    amtk_action_info_get_icon_name($!i);
  }

  method get_label {
    amtk_action_info_get_label($!i);
  }

  method get_tooltip {
    amtk_action_info_get_tooltip($!i);
  }

  method get_type {
    amtk_action_info_get_type();
  }

  method has_been_used {
    so amtk_action_info_has_been_used($!i);
  }

  method mark_as_used {
    amtk_action_info_mark_as_used($!i);
  }

  method ref {
    amtk_action_info_ref($!i);
  }

  method set_action_name (Str() $action_name) {
    amtk_action_info_set_action_name($!i, $action_name);
  }

  method set_icon_name (Str() $icon_name) {
    amtk_action_info_set_icon_name($!i, $icon_name);
  }

  method set_label (Str() $label) {
    amtk_action_info_set_label($!i, $label);
  }

  method set_tooltip (Str() $tooltip) {
    amtk_action_info_set_tooltip($!i, $tooltip);
  }

  method unref {
    amtk_action_info_unref($!i);
  }
}

class AMTK::ActionInfoCentralStore {
  my $singleton 
  
  submethod BUILD (:$store) {
    $singleton //= $store;
  }

  method get_singleton (AMTK::ActionInfoCentralStore:U: ) {
    self.bless( 
      store => $singleton // amtk_action_info_central_store_get_singleton() 
    );
  }

  method get_type {
    state ($n, $t);
    unstable_get_type( 
      self.^name, 
      &amtk_action_info_central_store_get_type, 
      $t
      $n, 
    );
  }

  method lookup (AMTK::ActionINfoCentralStore:D: Str() $action_name) {
    AMTK::ActionInfo.new(
      amtk_action_info_central_store_lookup(
        amtk_action_info_central_store_get_singleton(),
        $action_name
      )
    );
  }

}

# CLASS OBJECT
class AMTK::ActionMap {
  
  method add_action_entries_check_dups (
    GActionMap() $action_map, 
    GActionEntry() $entries, 
    Int() $n_entries, 
    gpointer $user_data = Pointer
  ) {
    my gint $ne = resolve-int($n_entries);
    amtk_action_map_add_action_entries_check_dups(
      $action_map, 
      $entries, 
      $ne, 
      $user_data
    );
  }
  
  method new (|) {
    die 'AMTK::ActionMap cannot be instantiated, please use the class type.'
  }
  
}

class AMTK::ApplicationWindow {
  use GTK::Application;
  use GTK::MenuItem;
  #use GTK::RecentChooserMenu;
  #use GTK::RecentMenuItem;
  use GTK::Statusbar;
  
  also does GTK::Compat::Roles::Object;
  
  has AmtkApplicationWindow $!aaw;
  
  submethod BUILD (:$window) {
    self!setObject($!aaw = $window);
  }
  
  method get_from_gtk_application_window (
    GtkApplicationWindow $gtk_window
  ) {
    self.bless(
      window => amtk_application_window_get_from_gtk_application_window(
        $gtk_window
      )
    );
  }
  
  method statusbar is rw {
    Proxy.new:
      FETCH => -> $                    { self.get_statusbar     },
      STORE => -> $, GtkStatusbar() $v { self.set_statusbar($v) };
  }

  method connect_menu_to_statusbar (
    GtkMenuShell() $menu_shell
  ) {
    amtk_application_window_connect_menu_to_statusbar(
      $amtk_window, 
      $menu_shell
    );
  }

  method connect_recent_chooser_menu_to_statusbar (
    GtkRecentChooserMenu() $menu
  ) {
    amtk_application_window_connect_recent_chooser_menu_to_statusbar(
      $amtk_window, 
      $menu
    );
  }

  method create_open_recent_menu {
    #GTK::RecentChooserMenu.new(
      amtk_application_window_create_open_recent_menu($amtk_window)
    #);
  }

  method create_open_recent_menu_item {
    #GTK::RecentMenuItem.new(
      amtk_application_window_create_open_recent_menu_item($amtk_window)
    #);
  }

  method get_application_window {
    GTK::MenuItem.new(
      amtk_application_window_get_application_window($amtk_window)
    );
  }

  method get_statusbar {
    GTK::Statusbar.new(
      amtk_application_window_get_statusbar($amtk_window)
    );
  }

  method get_type {
    state ($n, $t)
    unstable_get_type( 
      self.^name, 
      &amtk_application_window_get_type, 
      $n, 
      $t
    );
  }

  method set_statusbar (GtkStatusbar() $statusbar) {
    amtk_application_window_set_statusbar($amtk_window, $statusbar);
  }
  
}

class AMTK::Factory {
  use GTK::Compat::MenuItem;
  use GTK::Application;
  use GTK::CheckMenuItem;
  use GTK::MenuItem;
  use GTK::MenuToolButton;
  use GTK::ToolItem;
  use GTK::ShortcutsShortcut;
  
  also does GTK::Compat::Roles::Object;
  
  has AmtkFactory $!af;
  
  submethod BUILD (:$factory) {
    self!setObject($!af = $factory);
  }
  
  method new (GtkApplication() $application) {
    self.bless( factory => amtk_factory_new($application) );
  }

  method new_with_default_application {
    self.bless( factory => amtk_factory_new_with_default_application );
  }
  
  method default_flags is rw {
    Proxy.new: 
      FETCH => -> $           { self.get_default_flags },
      STORE => -> $, Int() $f { self.set_default_flags($f) };
  }
  
  # ↓↓↓↓ Return objects here!
  method create_check_menu_item (Str() $action_name) {
    GTK::CheckMenuItem.new(
      amtk_factory_create_check_menu_item($!af, $action_name)
    );
  }

  method create_check_menu_item_full (
   Str() $action_name, 
   Int() $flags
  ) {
    my guint $f = resolve-uint($flags);
    GTK::CheckMenuItem.new(
      amtk_factory_create_check_menu_item_full($!af, $action_name, $f)
    );
  }

  method create_gmenu_item (Str() $action_name) {
    GTK::Compat::MenuItem.new( 
      amtk_factory_create_gmenu_item($!af, $action_name)
    );
  }

  method create_gmenu_item_full (
    Str() $action_name, 
    Int() $flags
  ) {
    GTK::Compat::MenuItem.new(
      amtk_factory_create_gmenu_item_full($!af, $action_name, $f)
    );
  }

  method create_menu_item (Str() $action_name) {
    GTK::MenuItem.new(
      amtk_factory_create_menu_item($!af, $action_name)
    );
  }

  method create_menu_item_full (Str() $action_name, Int() $flags) {
    my guint $f = resolve-uint($flags);
    GTK::MenuItem.new(
      amtk_factory_create_menu_item_full($!af, $action_name, $f)
    );
  }

  method create_menu_tool_button (Str() $action_name) {
    GTK::MenuToolButton.new(
      amtk_factory_create_menu_tool_button($!af, $action_name)
    );
  }

  method create_menu_tool_button_full (Str() $action_name, Int() $flags) {
    my guint $f = resolve-uint($flags);
    GTK::MenuToolButton.new(
      amtk_factory_create_menu_tool_button_full($!af, $action_name, $f)
    );
  }

  method create_shortcut (Str() $action_name) {
    GTK::ShortcutsShortcut.new(
      amtk_factory_create_shortcut($!af, $action_name)
    );
  }

  method create_shortcut_full (Str() $action_name, Int() $flags) {
    my guint $f = resolve-uint($flags);
    GTK::ShortcutsShortcut.new(
      amtk_factory_create_shortcut_full($!af, $action_name, $f)
    );
  }

  method create_simple_menu (
    AmtkActionInfoEntry() $entries, 
    Int() $n_entries
  ) {
    my gint $n = resolve-int($n_entries);
    GTK::Menu.new(
      mtk_factory_create_simple_menu($!af, $entries, $n)
    );
  }

  method create_simple_menu_full (
    AmtkActionInfoEntry $entries, 
    Int() $n_entries, 
    Int() $flags
  ) {
    my guint $f = resolve-uint($flags);
    my gint $n = resolve-int($n_entries);
    GTK::Menu.new(
      amtk_factory_create_simple_menu_full($!af, $entries, $n, $f)
    );
  }

  method create_tool_button (Str() $action_name) {
    GTK::ToolButton.new(
      amtk_factory_create_tool_button($!af, $action_name)
    );
  }

  method create_tool_button_full (Str() $action_name, Int() $flags) {
    my guint $f = resolve-uint($flags);
    GTK::ToolButton.new(
      amtk_factory_create_tool_button_full($!af, $action_name, $f)
    );
  }
  # ↑↑↑↑ Return objects here!

  method get_application {
    GTK::Application.new( amtk_factory_get_application($!af) );
  }

  method get_default_flags {
    AmtkFactoryFlags( amtk_factory_get_default_flags($!af) );
  }

  method get_type {
    state ($n, $t);
    unstable_get_type( self.^name, &amtk_factory_get_type, $n, $t );
  }

  method set_default_flags (Int() $default_flags) {
    my guint $d = resolve-uint($default_flags);
    amtk_factory_set_default_flags($!af, $d);
  }
  
}

# CLASS OBJECT
class AMTK::MenuItem {
  
  method get_long_description (GtkMenuItem() $menu_item) {
    amtk_menu_item_get_long_description($menu_item);
  }

  method set_icon_name (GtkMenuItem() $item, Str() $icon_name) {
    amtk_menu_item_set_icon_name($item, $icon_name);
  }

  method set_long_description (
    GtkMenuItem() $menu_item, 
    Str() $long_description
  ) {
    amtk_menu_item_set_long_description($menu_item, $long_description);
  }
  
}

class AMTK::MenuShell {
  also does GTK::Roles::Compat::Object;
  also does AMTK::Roles::Signals::MenuShell;
  
  has AmtkMenuShell $!ams
  
  submethod BUILD (:$shell) {
    self!setObject($!ams = $shell);
  }
  
  # Is originally:
  # AmtkMenuShell, GtkMenuItem, gpointer --> void
  method menu-item-deselected {
    self.connect-menu-item-deselected($!ams);
  }

  # Is originally:
  # AmtkMenuShell, GtkMenuItem, gpointer --> void
  method menu-item-selected {
    self.connect-menu-item-selected($!ams);
  }
  
  method get_from_gtk_menu_shell (GtkMenuShell $gtk_menu_shell) {
    self.bless(
      shell => amtk_menu_shell_get_from_gtk_menu_shell($gtk_menu_shell)
    )
  }

  method get_menu_shell {
    GTK::MenuShell.new(
      amtk_menu_shell_get_menu_shell($!ams)
    );
  }

  method get_type {
    state ($n, $t)
    unstable_get_type( self.^name, &amtk_menu_shell_get_type, $n, $t );
  }
  
)

# CLASS OBJECT

class AMTL::GMenu {
  
  method append_item (GMenu() $menu, GMenuItem() $item) {
    amtk_gmenu_append_item($menu, $item);
  }

  method append_section (GMenu() $menu, Str() $label, GMenu() $section) {
    amtk_gmenu_append_section($menu, $label, $section);
  }
  
}

# CLASS OBJECT

class AMTK::Shortcuts {
  use GTK::ShortcutsGroup;
  use GTK::ShortcutsSection;
  use GTK::ShortcutsWindow;
  
  method amtk_shortcuts_group_new (Str() $title) {
    GTK::ShortcutsGroup.new(
      amtk_shortcuts_group_new($title)
    )
  }

  method amtk_shortcuts_section_new (Str() $title) {
    GTK::ShortcutsSection.new(
      amtk_shortcuts_section_new($title)
    )
  }

  method amtk_shortcuts_window_new (GtkWindow() $parent) {
    GTK::ShortcutsWindow.new(
      amtk_shortcuts_window_new($parent)
    );
  }
  
}

# CLASS OBJECT
class AMTK::Utils {
  
  method bind_g_action_to_gtk_action (|) is DEPRECATED {
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
  
  method create_gtk_action (|) {
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
  ) {
    amtk_utils_recent_chooser_menu_get_item_uri($menu, $item);
  }

  method remove_mnemonic (Str() $str) {
    amtk_utils_remove_mnemonic($str);
  }
  
}

  
  
