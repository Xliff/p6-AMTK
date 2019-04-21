use v6.c;

use GTK::Compat::Types;
use GTK::Compat::PropertyAction;

use GTK::Application;
use GTK::Grid;
use GTK::Label;
use GTK::Menu;
use GTK::MenuItem;
use GTK::MenuBar;

use AMTK;

my ($app, $action_info_store);

my @file_action_info_entries = (
  AmtkActionInfoEntry.new(
    'win.open',
    'document-open',
    '_Open',
    '<Control>o',
    'Open a file'
  ),
  AmtkActionInfoEntry.new(
    'app.quit',
    'application-exit',
    '_Quit',
    '<Control>q',
    'Quit the application'
  )
);

sub add_action_info_entries {
  my @entries = (
    AmtkActionInfoEntry.new(
      'app.about',
      'help-about',
      '_About',
      Str,
      'About this application'
    ),
    AmtkActionInfoEntry.new(
      'win.show-side-panel',
      Str,
      '_Side Panel',
      'F9',
      'Toggle side panel visibility'
    )
  );

  $action_info_store = AMTK::ActionInfoStore.new;
  $action_info_store.add_entries(@entries);
  $action_info_store.add_entries(@file_action_info_entries);
}

sub add_app_action_entries {
  my @entries = (
    GActionEntry.new('quit',  -> $, $, $ { $app.exit  }),
    GActionEntry.new('about', -> $, $, $ { say 'About' })
  );

  AMTK::ActionMap.add_action_entries_check_dups($app, @entries);
}

sub create_view_submenu {
  my $view_submenu = GTK::Menu.new;
  my $factory = AMTK::Factory.new;

  $view_submenu.append(
    $factory.create_check_menu_item('win.show-side-panel')
  );
  $view_submenu;
}

sub create_help_submenu {
  my $help_submenu = GTK::Menu.new;
  my $factory = AMTK::Factory.new;

  $help_submenu.append( $factory.create_menu_item('app.about') );
  $help_submenu
}

sub create_menu_bar {
  my $factory = AMTK::Factory.new;

  my $file_menu_item = GTK::MenuItem.new_with_mnemonic('_File');
  $file_menu_item.submenu =
    $factory.create_simple_menu(@file_action_info_entries);

  my $view_menu_item = GTK::MenuItem.new_with_mnemonic('_View');
  $view_menu_item.submenu = create_view_submenu;

  my $help_menu_item = GTK::MenuItem.new_with_mnemonic('_Help');
  $help_menu_item.submenu = create_help_submenu;

  my $menu_bar = GTK::MenuBar.new;
  $menu_bar.append($_) for $file_menu_item, $view_menu_item, $help_menu_item;
  $action_info_store.check_all_used;

  $menu_bar;
}

sub add_win_actions ($sp) {
  my $side_panel_action = GTK::Compat::PropertyAction.new(
    'show-side-panel', $sp, 'visible'
  );
  $app.window.add_action($side_panel_action);
}

sub activate_cb {
  $app.window.set_default_size(800, 600);

  my $vgrid = GTK::Grid.new-vgrid;
  $vgrid.add(create_menu_bar);

  my $hgrid = GTK::Grid.new-hgrid;
  my $side_panel = GTK::Label.new('Side Panel');
  my $text_view  = GTK::Label.new('Text View');
  $hgrid.add($side_panel);
  $hgrid.add($text_view);
  $vgrid.add($hgrid);

  add_win_actions($side_panel);

  $app.window.add($vgrid);
  $app.window.show_all;
}

sub MAIN {
  AMTK::Main.init;
  $app = GTK::Application.new( title => 'org.genex.amtk.traditional-ui' );
  $app.startup.tap({ add_action_info_entries; add_app_action_entries });
  $app.activate.tap({ activate_cb });
  my $status = $app.run;
  AMTK::Main.finalize;

  exit $status;
}
