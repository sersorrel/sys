{ lib, ... }:

{
  options = {};
  config = lib.mkMkerge [
    ({
      home.file.".ideavimrc".source = ./ideavimrc;
    })
  ];
}
