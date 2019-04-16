use v6.c;

use File::Find;

my regex name {
  <[_ A..Z a..z]>+
}

# my rule enum_entry {
#   <[A..Z]>+ [ '=' [ \d+ | \d+ '<<' \d+ ] ]? ','
# }

my token d {
  <[0..9 x]>
}

my rule enum_entry {
  \s* ( <[_ A..Z]>+ ) ( [ '=' <d>+ [ '<<' <d>+ ]? ]? ) ','? \v*
}

my rule enum {
  'typedef enum' <n=name>? \v* '{' \v* <enum_entry>+ \v* '}' <rn=name>?
}

sub MAIN ($dir) {
  my %enums;
  
  die "Directory '$dir' either does not exist, or is not a directory"
    unless $dir.IO.e && $dir.IO.d;
  
  my @files = find
    dir => $dir,
    name => /'.h' $/;
    
  for @files -> $file {
    say "Checking { $file } ...";
    my $contents = $file.IO.slurp;
    
    my $m = $contents ~~ m:g/<enum>/;
    for $m.Array -> $l {
      my @e;
      for $l<enum><enum_entry> -> $el {
        for $el -> $e {
          ((my $n = $e[1].Str.trim) ~~ s/'='//);
          $n ~~ s/'<<'/+</;
          my $ee;
          $ee.push: $e[0].Str.trim;
          $ee.push: $n if $n.chars;
          @e.push: $ee;
        }
        %enums{$l<enum><rn>} = @e;
      }
    }
  }
  
  for %enums.keys -> $k {
    #say %enums{$k}.gist;
    my $m = %enums{$k}.map( *.map( *.elems ) ).max;
    say "  our enum {$k} is export { $m == 2 ?? '(' !! '<' }";
    for %enums{$k} -> $ek {
      for $ek -> $el {
        for $el.List -> $eel {
          given $m {
            when 1 {
              say "      { $eel[0] },";
            }
            when 2 {
              with $eel[1] {
                say "      { $eel[0] } => { $eel[1] },"; 
              } else {
                say "      '{ $eel[0] }',";
              }
            }
          }
        }
      }
    }
    say "  { $m == 2 ?? ')' !! '>' };\n";
  }
}
