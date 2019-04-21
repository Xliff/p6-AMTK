use v6.c;

use AMTK;

use Test;

plan 6;

sub check_remove_mnemonic($s, $es) {
  my $wm = AMTK::Utils.remove_mnemonic($s);
  ok $wm eq $es, "String '{ $s }' resolves to '{ $es }'";
}

sub MAIN {

  check_remove_mnemonic('', '');
  check_remove_mnemonic('a', 'a');
  check_remove_mnemonic('_a', 'a');
  check_remove_mnemonic('__a', '_a');
  check_remove_mnemonic('___a', '_a');
  check_remove_mnemonic('S_maller Text', 'Smaller Text');

}
