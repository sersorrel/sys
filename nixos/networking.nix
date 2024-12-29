{
  networking.networkmanager.connectionConfig."connection.mdns" = 2; # aka "yes", i.e. "register hostname and resolving for the connection", see nm-settings(5)
  networking.networkmanager.connectionConfig."mdns" = 2; # unclear whether this or the above is the correct syntax
}
