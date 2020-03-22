use v6.c;

unit package AMTK::Raw::Exports;

our @amtk-exports is export;

BEGIN {
  @amtk-exports = <
    AMTK::Raw::Definitions
  >;
}
