use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GTK::Raw::Types;
use AMTK::Raw::Types;

unit package AMTK::Raw::Subs;

sub _amtk_action_info_central_store_add (
  AmtkActionInfoCentralStore $central_store,
  AmtkActionInfo $info
)
  is native(amtk)
  is export
  { * }

sub _amtk_action_info_central_store_unref_singleton ()
  is native(amtk)
  is export
  { * }

sub amtk_action_info_central_store_get_singleton ()
  returns AmtkActionInfoCentralStore
  is native(amtk)
  is export
  { * }

sub amtk_action_info_central_store_get_type ()
  returns GType
  is native(amtk)
  is export
  { * }

sub amtk_action_info_central_store_lookup (
  AmtkActionInfoCentralStore $central_store,
  Str $action_name
)
  returns AmtkActionInfo
  is native(amtk)
  is export
  { * }


sub amtk_action_info_copy (AmtkActionInfo $info)
  returns AmtkActionInfo
  is native(amtk)
  is export
  { * }

sub amtk_action_info_get_accels (AmtkActionInfo $info)
  returns CArray[Str]
  is native(amtk)
  is export
  { * }

sub amtk_action_info_get_action_name (AmtkActionInfo $info)
  returns Str
  is native(amtk)
  is export
  { * }

sub amtk_action_info_get_icon_name (AmtkActionInfo $info)
  returns Str
  is native(amtk)
  is export
  { * }

sub amtk_action_info_get_label (AmtkActionInfo $info)
  returns Str
  is native(amtk)
  is export
  { * }

sub amtk_action_info_get_tooltip (AmtkActionInfo $info)
  returns Str
  is native(amtk)
  is export
  { * }

sub amtk_action_info_get_type ()
  returns GType
  is native(amtk)
  is export
  { * }

sub amtk_action_info_has_been_used (AmtkActionInfo $info)
  returns uint32
  is native(amtk)
  is export
  { * }

sub amtk_action_info_mark_as_used (AmtkActionInfo $info)
  is native(amtk)
  is export
  { * }

sub amtk_action_info_new ()
  returns AmtkActionInfo
  is native(amtk)
  is export
  { * }

sub amtk_action_info_new_from_entry (
  AmtkActionInfoEntry $info_entry,
  Str $translation_domain
)
  returns AmtkActionInfo
  is native(amtk)
  is export
  { * }

sub amtk_action_info_ref (AmtkActionInfo $info)
  returns AmtkActionInfo
  is native(amtk)
  is export
  { * }

sub amtk_action_info_set_action_name (
  AmtkActionInfo $info,
  Str $action_name
)
  is native(amtk)
  is export
  { * }

sub amtk_action_info_set_icon_name (
  AmtkActionInfo $info,
  Str $icon_name
)
  is native(amtk)
  is export
  { * }

sub amtk_action_info_set_label (
  AmtkActionInfo $info,
  Str $label
)
  is native(amtk)
  is export
  { * }

sub amtk_action_info_set_tooltip (
  AmtkActionInfo $info,
  Str $tooltip
)
  is native(amtk)
  is export
  { * }

sub amtk_action_info_unref (AmtkActionInfo $info)
  is native(amtk)
  is export
  { * }


sub amtk_action_info_store_add (
  AmtkActionInfoStore $store,
  AmtkActionInfo $info
)
  is native(amtk)
  is export
  { * }

sub amtk_action_info_store_add_entries (
  AmtkActionInfoStore $store,
  Pointer $entries,                         # BLOCK of AmtkActionInfo
  gint $n_entries,
  Str $translation_domain
)
  is native(amtk)
  is export
  { * }

sub amtk_action_info_store_check_all_used (
  AmtkActionInfoStore $store
)
  is native(amtk)
  is export
  { * }

sub amtk_action_info_store_get_type ()
  returns GType
  is native(amtk)
  is export
  { * }

sub amtk_action_info_store_lookup (
  AmtkActionInfoStore $store,
  Str $action_name
)
  returns AmtkActionInfo
  is native(amtk)
  is export
  { * }

sub amtk_action_info_store_new ()
  returns AmtkActionInfoStore
  is native(amtk)
  is export
  { * }

sub amtk_action_info_store_set_all_accels_to_app (
  AmtkActionInfoStore $store,
  GtkApplication $application
)
  is native(amtk)
  is export
  { * }


sub amtk_action_map_add_action_entries_check_dups (
  GActionMap $action_map,
  GActionEntry $entries,
  gint $n_entries,
  gpointer $user_data
)
  is native(amtk)
  is export
  { * }


sub amtk_application_window_connect_menu_to_statusbar (
  AmtkApplicationWindow $amtk_window,
  GtkMenuShell $menu_shell
)
  is native(amtk)
  is export
  { * }

sub amtk_application_window_connect_recent_chooser_menu_to_statusbar (
  AmtkApplicationWindow $amtk_window,
  GtkRecentChooserMenu $menu
)
  is native(amtk)
  is export
  { * }

sub amtk_application_window_create_open_recent_menu (
  AmtkApplicationWindow $amtk_window
)
  returns GtkRecentChooserMenu
  is native(amtk)
  is export
  { * }

sub amtk_application_window_create_open_recent_menu_item (
  AmtkApplicationWindow $amtk_window
)
  returns GtkMenuItem
  is native(amtk)
  is export
  { * }

sub amtk_application_window_get_application_window (
  AmtkApplicationWindow $amtk_window
)
  returns GtkApplicationWindow
  is native(amtk)
  is export
  { * }

sub amtk_application_window_get_from_gtk_application_window (
  GtkApplicationWindow $gtk_window
)
  returns AmtkApplicationWindow
  is native(amtk)
  is export
  { * }

sub amtk_application_window_get_statusbar (
  AmtkApplicationWindow $amtk_window
)
  returns GtkStatusbar
  is native(amtk)
  is export
  { * }

sub amtk_application_window_get_type ()
  returns GType
  is native(amtk)
  is export
  { * }

sub amtk_application_window_set_statusbar (
  AmtkApplicationWindow $amtk_window,
  GtkStatusbar $statusbar
)
  is native(amtk)
  is export
  { * }


sub amtk_factory_flags_get_type ()
  returns GType
  is native(amtk)
  is export
  { * }


sub amtk_factory_create_check_menu_item (
  AmtkFactory $factory,
  Str $action_name
)
  returns GtkWidget
  is native(amtk)
  is export
  { * }

sub amtk_factory_create_check_menu_item_full (
  AmtkFactory $factory,
  Str $action_name,
  uint32 $flags               # AmtkFactoryFlagsflags
)
  returns GtkWidget
  is native(amtk)
  is export
  { * }

sub amtk_factory_create_gmenu_item (AmtkFactory $factory, Str $action_name)
  returns GMenuItem
  is native(amtk)
  is export
  { * }

sub amtk_factory_create_gmenu_item_full (
  AmtkFactory $factory,
  Str $action_name,
  uint32 $flags               # AmtkFactoryFlagsflags
)
  returns GMenuItem
  is native(amtk)
  is export
  { * }

sub amtk_factory_create_menu_item (AmtkFactory $factory, Str $action_name)
  returns GtkWidget
  is native(amtk)
  is export
  { * }

sub amtk_factory_create_menu_item_full (
  AmtkFactory $factory,
  Str $action_name,
  uint32 $flags               # AmtkFactoryFlagsflags
)
  returns GtkWidget
  is native(amtk)
  is export
  { * }

sub amtk_factory_create_menu_tool_button (
  AmtkFactory $factory,
  Str $action_name
)
  returns GtkMenuToolButton
  is native(amtk)
  is export
  { * }

sub amtk_factory_create_menu_tool_button_full (
  AmtkFactory $factory,
  Str $action_name,
  uint32 $flags               # AmtkFactoryFlagsflags
)
  returns GtkMenuToolButton
  is native(amtk)
  is export
  { * }

sub amtk_factory_create_shortcut (AmtkFactory $factory, Str $action_name)
  returns GtkWidget
  is native(amtk)
  is export
  { * }

sub amtk_factory_create_shortcut_full (
  AmtkFactory $factory,
  Str $action_name,
  uint32 $flags               # AmtkFactoryFlagsflags
)
  returns GtkWidget
  is native(amtk)
  is export
  { * }

sub amtk_factory_create_simple_menu (
  AmtkFactory $factory,
  AmtkActionInfoEntry $entries,
  gint $n_entries
)
  returns GtkWidget
  is native(amtk)
  is export
  { * }

sub amtk_factory_create_simple_menu_full (
  AmtkFactory $factory,
  AmtkActionInfoEntry $entries,
  gint $n_entries,
  uint32 $flags               # AmtkFactoryFlagsflags
)
  returns GtkWidget
  is native(amtk)
  is export
  { * }

sub amtk_factory_create_tool_button (
  AmtkFactory $factory,
  Str $action_name
)
  returns GtkToolItem
  is native(amtk)
  is export
  { * }

sub amtk_factory_create_tool_button_full (
  AmtkFactory $factory,
  Str $action_name,
  uint32 $flags               # AmtkFactoryFlagsflags
)
  returns GtkToolItem
  is native(amtk)
  is export
  { * }

sub amtk_factory_get_application (AmtkFactory $factory)
  returns GtkApplication
  is native(amtk)
  is export
  { * }

sub amtk_factory_get_default_flags (AmtkFactory $factory)
  returns uint32              # AmtkFactoryFlags
  is native(amtk)
  is export
  { * }

sub amtk_factory_get_type ()
  returns GType
  is native(amtk)
  is export
  { * }

sub amtk_factory_new (GtkApplication $application)
  returns AmtkFactory
  is native(amtk)
  is export
  { * }

sub amtk_factory_new_with_default_application ()
  returns AmtkFactory
  is native(amtk)
  is export
  { * }

sub amtk_factory_set_default_flags (
  AmtkFactory $factory,
  uint32 $default_flags       # AmtkFactoryFlags $default_flags
)
  is native(amtk)
  is export
  { * }


sub amtk_gmenu_append_item (GMenu $menu, GMenuItem $item)
  is native(amtk)
  is export
  { * }

sub amtk_gmenu_append_section (GMenu $menu, Str $label, GMenu $section)
  is native(amtk)
  is export
  { * }



sub amtk_finalize ()
  is native(amtk)
  is export
  { * }

sub amtk_init ()
  is native(amtk)
  is export
  { * }


sub amtk_menu_item_get_long_description (GtkMenuItem $menu_item)
  returns Str
  is native(amtk)
  is export
  { * }

sub amtk_menu_item_set_icon_name (GtkMenuItem $item, Str $icon_name)
  is native(amtk)
  is export
  { * }

sub amtk_menu_item_set_long_description (
  GtkMenuItem $menu_item,
  Str $long_description
)
  is native(amtk)
  is export
  { * }


sub amtk_menu_shell_get_from_gtk_menu_shell (GtkMenuShell $gtk_menu_shell)
  returns AmtkMenuShell
  is native(amtk)
  is export
  { * }

sub amtk_menu_shell_get_menu_shell (AmtkMenuShell $amtk_menu_shell)
  returns GtkMenuShell
  is native(amtk)
  is export
  { * }

sub amtk_menu_shell_get_type ()
  returns GType
  is native(amtk)
  is export
  { * }


sub amtk_shortcuts_group_new (Str $title)
  returns GtkContainer
  is native(amtk)
  is export
  { * }

sub amtk_shortcuts_section_new (Str $title)
  returns GtkContainer
  is native(amtk)
  is export
  { * }

sub amtk_shortcuts_window_new (GtkWindow $parent)
  returns GtkShortcutsWindow
  is native(amtk)
  is export
  { * }

sub _amtk_utils_replace_home_dir_with_tilde (Str $filename)
  returns Str
  is native(amtk)
  is export
  { * }

sub amtk_utils_bind_g_action_to_gtk_action (
  GActionMap $g_action_map,
  Str $detailed_g_action_name_without_prefix,
  Pointer $gtk_action_group,                        # GtkActionGroup
  Str $gtk_action_name
)
  is native(amtk)
  is export
  { * }

sub amtk_utils_create_gtk_action (
  GActionMap $g_action_map,
  Str $detailed_g_action_name_with_prefix,
  Pointer $gtk_action_group,                        # GtkActionGroup
  Str $gtk_action_name
)
  is native(amtk)
  is export
  { * }

sub amtk_utils_recent_chooser_menu_get_item_uri (
  GtkRecentChooserMenu $menu,
  GtkMenuItem $item
)
  returns Str
  is native(amtk)
  is export
  { * }

sub amtk_utils_remove_mnemonic (Str $str)
  returns Str
  is native(amtk)
  is export
  { * }
