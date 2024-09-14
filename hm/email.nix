{ config, lib, ... }:

{
  options = {
    sys.email.enable = lib.mkOption {
      description = "Whether to set up email configuration.";
      type = lib.types.bool;
      default = false;
    };
    sys.email.passwordCommands = lib.mkOption {
      description = "How to find the password for each configured email account.";
      type = lib.types.attrsOf lib.types.str;
      default = {};
      example = { "me@example.net" = "echo hunter2"; };
    };
    sys.email.thunderbird.enable = lib.mkOption {
      description = "Whether to install Thunderbird, a graphical mail client.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = {
    assertions = [
      {
        assertion = config.sys.email.thunderbird.enable -> config.sys.email.enable;
        message = "Enabling Thunderbird requires that email config in general be enabled";
      }
    ];
    accounts.email = lib.mkIf config.sys.email.enable {
      accounts = {
        "ash@sorrel.sh" = {
          address = "ash@sorrel.sh";
          imap.host = "ocelot.mythic-beasts.com";
          imap.port = 993;
          passwordCommand = config.sys.email.passwordCommands."ash@sorrel.sh";
          primary = true;
          realName = "Ash Holland";
          signature.showSignature = "append";
          signature.text = ''

            thanks,<br>
            Ash<br>
            she/her
          '';
          smtp.host = "smtp-auth.mythic-beasts.com";
          smtp.port = 587;
          smtp.tls.useStartTls = true;
          thunderbird.enable = config.sys.email.thunderbird.enable;
          thunderbird.settings = id: {
            "mail.identity.id_${id}.archive_granularity" = 0;
            "mail.identity.id_${id}.archive_keep_folder_structure" = false;
            "mail.identity.id_${id}.drafts_folder_picker_mode" = "0";
            "mail.identity.id_${id}.fcc_folder_picker_mode" = "0";
            "mail.identity.id_${id}.htmlSigFormat" = true;
            "mail.identity.id_${id}.reply_on_top" = 1;
            "mail.identity.id_${id}.sig_bottom" = false;
            "mail.identity.id_${id}.sig_on_fwd" = true;
            "mail.tabs.autoHide" = false;
            "mail.tabs.drawInTitlebar" = false;
            "mail.wrap_long_lines" = false;
            "mail.warn_on_collapsed_thread_operation" = false;
            "mailnews.start_page.enabled" = false;
            "network.cookie.cookieBehavior" = 2; # disable cookies
            "privacy.donottrackheader.enabled" = true;
            "toolkit.tabbox.switchByScrolling" = true;
          };
          userName = "ash@sorrel.sh";
        };
      };
    };
    programs.thunderbird = lib.mkIf config.sys.email.thunderbird.enable {
      enable = true;
      profiles.default = {
        isDefault = true;
      };
    };
  };
}
