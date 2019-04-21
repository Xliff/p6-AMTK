use v6.c;

use AMTK;

use Test;

plan 4;

my @entries = (
  AmtkActionInfoEntry.new(
    'app.quit',
    'application-exit',
    '_Quit',
    '<Control>q',
    'Quit the application'
  ),
  # Tooltop field missing, must be NULL
  AmtkActionInfoEntry.new(
    'win.open',
    'document-open',
    '_Open',
    '<Control>o'
  )
);

my $store = AMTK::ActionInfoStore.new;
$store.add_entries(@entries);

my $info1 = $store.lookup('win.open');
ok  $info1.defined,
  "Lookup of 'win.open' action was successful";
ok  $info1.icon_name eq 'document-open',
  "Icon name of 'win.open' action is 'document-open'";
nok $info1.tooltip.defined,
  "Tooltip for 'win.open' is not defined";

$info1 = $store.lookup('plouf');
nok $info1.defined,
  "Lookup of 'plouf' action failed";
