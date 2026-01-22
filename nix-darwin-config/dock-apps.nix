{ config, ... }:
{
  system.defaults.dock = {
    persistent-apps = [
      "/System/Applications/Mail.app"
      "/Applications/Dia.app"
      "/Applications/WhatsApp.app"
      "/System/Applications/Photos.app"
      "/System/Applications/Notes.app"
      "/System/Applications/Reminders.app"
      "/Applications/Goodnotes.app"
      "/Applications/Microsoft Teams.app"
      "/Applications/Notion.app"
      "/System/Applications/Calendar.app"
      "/System/Applications/Passwords.app"
      "/Applications/Spotify.app"
      "/System/Applications/System Settings.app"
      "/Applications/Warp.app"
    ];
  };
}
