

void OnSettingsChanged() {}

void Main() {
    // loop to update events
    while (true) {
        UpdateEvents();
        yield();
    }
}

void RenderMenu() {
    if (UI::MenuItem("\\$1BA" + Icons::Kenney::Cog + "\\$G Gear-Blocks", "", Setting_PluginEnabled))
        Setting_PluginEnabled = !Setting_PluginEnabled;
}