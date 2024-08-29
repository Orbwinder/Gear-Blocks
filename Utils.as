
/**
 * predicting the car's current gear based on other relevant stats
 * useful when internal value is locked or delayed
 */
uint getPredictedGear(const float displaySpeed) {
    if (displaySpeed > 341) {
        return 5;
    } else if (displaySpeed > 235) {
        return 4;
    } else if (displaySpeed > 161) {
        return 3;
    } else if (displaySpeed > 101) {
        return 2;
    } else if (displaySpeed > 0) {
        return 1;
    }
    return 0;
}

/**
 * determines if the game is currently playing the intro cutscene for a map
 */
bool isPlayingCutscene() {
    auto playground = GetApp().CurrentPlayground;

    if (playground !is null && (playground.UIConfigs.Length > 0)) {
        if (playground.UIConfigs[0].UISequence == CGamePlaygroundUIConfig::EUISequence::Intro) {
            return true;
        }
    }
    return false;
}