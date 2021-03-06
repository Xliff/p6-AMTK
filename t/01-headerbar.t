use v6.c;

use AMTK::Raw::Types;

use GIO::Menu;
use GIO::PropertyAction;
use GTK::Application;
use GTK::Grid;
use GTK::HeaderBar;
use GTK::Label;
use GTK::MenuButton;

use AMTK;

my ($app, $action_info_store);

sub add_action_info_entries {
  my @entries = (
    AmtkActionInfoEntry.new('win.show-side-panel', Str, '_Side Panel', 'F9',
      'Toggle side panel visibility'),
    AmtkActionInfoEntry.new('win.print', Str, '_Print', '<Control>p'),
    AmtkActionInfoEntry.new('win.shortcuts-window', Str, '_Keyboard Shortcuts')
  );

  $action_info_store = AMTK::ActionInfoStore.new;
  # Although this should work, it does not. Therefore we use a fortunate
  # workaround.
  #$action_info_store.add_entries(@entries);
  $action_info_store.add( AMTK::ActionInfo.new_from_entry($_) ) for @entries;

  my @accels = ('<Control>F1', '<Control>question');
  my $action_info = $action_info_store.lookup('win.shortcuts-window');
  $action_info.accels = @accels;
}

sub shortcuts_window_activate_cb ($w) {
  CATCH { default { .message.say; } }

  my $group   = AMTK::Shortcuts.new_group('General');
  my $section = AMTK::Shortcuts.new_section('');
  my $window  = AMTK::Shortcuts.new_window($w);
  my $factory = AMTK::Factory.new;

  $factory.default_flags = AMTK_FACTORY_IGNORE_GACTION;
  $group.add: $factory.create_shortcut('win.show-side-panel');
  $group.add: $factory.create_shortcut('win.print');
  $section.add($group);
  $window.add($section);
  $window.show_all;
}

sub add_win_actions ($w, $sp) {
  my @entries = (
    GActionEntry.new('print', -> GSimpleAction, GVariant, gpointer {
      say 'Print'
    }),
    GActionEntry.new(
      'shortcuts-window',
      -> GSimpleAction, GVariant, gpointer {
        shortcuts_window_activate_cb ($w);
      }
    )
  );

  AMTK::ActionMap.add_action_entries_check_dups($w, @entries);

  my $side_panel_action = GIO::PropertyAction.new(
    'show-side-panel', $sp, 'visible'
  );
  $w.add_action($side_panel_action);
}

sub create_window_menu {
  my $menu = GIO::Menu.new;
  my $factory = AMTK::Factory.new;

  AMTK::GMenu.append_item(
    $menu,
    $factory.create_gmenu_item('win.show-side-panel')
  );
  AMTK::GMenu.append_item(
    $menu,
    $factory.create_gmenu_item('win.print')
  );
  AMTK::GMenu.append_item(
    $menu,
    $factory.create_gmenu_item('win.shortcuts-window')
  );
  $menu.freeze;
  $menu.GMenuModel;
}

sub create_header_bar {
  my $header_bar = GTK::HeaderBar.new;
  $header_bar.title = 'Amtk Test Headerbar';
  $header_bar.show_close_button = True;

  my $menu_button = GTK::MenuButton.new;
  $menu_button.direction = GTK_ARROW_NONE;
  $menu_button.menu_model = create_window_menu;
  $header_bar.pack_end($menu_button);
  $header_bar;
}

sub MAIN {
  AMTK::Main.init;
  $app = GTK::Application.new(
    title => 'org.genex.amtk.test-headerbar',
    flags => G_APPLICATION_FLAGS_NONE
  );

  my $menu = GIO::Menu.new;

  $app.startup. tap({ add_action_info_entries });
  $app.activate.tap({
    $app.wait-for-init;
    $app.window.set_default_size(800, 600);
    $app.window.titlebar = create_header_bar;

    my $hgrid = GTK::Grid.new;
    my $side_panel = GTK::Label.new('Side Panel');
    my $label = GTK::Label.new('Text view');
    $hgrid.add($side_panel);
    $hgrid.add($label);

    add_win_actions($app.window, $side_panel);
    $app.window.add($hgrid);
    $app.window.show_all;

    $action_info_store.check_all_used;
  });

  my $status = $app.run;
  AMTK::Main.finalize;
  exit $status;
}
