// types gear indications
enum GearIndicator
{
    Disengaged,   // gear is disengaged
	Engaged,   // gear is engaged
    
}

void Render() {
    if (!Setting_PluginEnabled || (Setting_HideWithGame && !UI::IsGameUIVisible())) return; // escape if the plugin is disabled
    
    auto visState = VehicleState::ViewingPlayerState();
    if (visState is null) return; // escape if we there is no active player
    if (isPlayingCutscene()) return; // hide overlay during intro cutscene

    vec2 screenSize = vec2(Draw::GetWidth(), Draw::GetHeight());
    vec2 relativePos = Setting_Position * (screenSize - Setting_Size);

    // calculate predicted gear ===============
    // displaySpeed2 is the same as displaySpeed1 when traveling forward, but ignores vehicle rotation 
    // float displaySpeed2 = visState.WorldVel.Length() * 3.6f;
    float displaySpeed = visState.FrontSpeed * 3.6f;
    uint predictedGear = getPredictedGear(displaySpeed);
            
    // draw backing card
    nvg::BeginPath();
    nvg::RoundedRect(
        relativePos.x-Setting_BackdropPadding, 
        relativePos.y-Setting_BackdropPadding, 
        Setting_Size.x+2*Setting_BackdropPadding, 
        Setting_Size.y+2*Setting_BackdropPadding, 
        20
    );
    nvg::FillColor(Setting_BackdropColor);
    nvg::Fill();
    nvg::ClosePath();
    // draw 5 gear capsules
    for (uint i = 1; i <= 5; i++) {
        auto style = GearIndicator::Disengaged;
        // && VehicleState::GetRPM(visState) > 200.0f
        bool isStationary = VehicleState::GetRPM(visState) < 200.0f && displaySpeed == 0.0f;
        if(i <= visState.CurGear && !isStationary) {
            style = GearIndicator::Engaged;
        }
        drawGearCapsule(relativePos, i, style, predictedGear);
    }
}

void drawGearCapsule(const vec2 pos, const uint gearNum, const GearIndicator style, const uint predict ) {
    float capsuleWidth = (Setting_Size.x-4*Setting_CapsuleGap)/5;
    vec2 displayPos = pos + vec2((gearNum-1)*(capsuleWidth+Setting_CapsuleGap), 0);
    nvg::BeginPath();
    nvg::RoundedRect(displayPos.x, displayPos.y, capsuleWidth, Setting_Size.y, 10);

    switch(style){
        case GearIndicator::Disengaged: {
            // the gear is not engaged! check for a recent Gear_Loss event
            auto foundIndex = g_events.Find(Event(0, EVENT_TYPE::Gear_Loss, gearNum));
            uint diffTime = 2000;
            if (foundIndex != -1 && Setting_ShowAnimatedGearChange) {
                diffTime = Time::Now - g_events[foundIndex].t;
            }
            
            nvg::FillColor(Math::Lerp(
                Setting_GearDownColor, 
                Setting_DisengagedColor, 
                Animate(2000.0f, diffTime)
            ));

            if (gearNum <= predict && Setting_ShowPredictedGear) {
                nvg::StrokeWidth(5.0f);
                nvg::StrokeColor(Setting_GearUpColor);
                nvg::Stroke();
            }
            break;
        }
        case GearIndicator::Engaged: {
            // the gear is engaged! check for a recent Gear_Gain event
            auto foundIndex = g_events.Find(Event(0, EVENT_TYPE::Gear_Gain, gearNum));
            uint diffTime = 1000;
            if (foundIndex != -1 && Setting_ShowAnimatedGearChange) {
                diffTime = Time::Now - g_events[foundIndex].t;
            }
            
            nvg::FillColor(vec4(Math::Lerp(
                Setting_GearUpColor, 
                Setting_EngagedColor, 
                Animate(1000.0f, diffTime)
            )));

            if (gearNum > predict && Setting_ShowPredictedGear) {
                nvg::StrokeWidth(5.0f);
                nvg::StrokeColor(Setting_GearDownColor);
                nvg::Stroke();
            }
            break;
        }
            
    }
    // highlight the predicted gear in blue
    // if (gearNum == predict) {
    //     nvg::StrokeWidth(5.0f);
	// 	nvg::StrokeColor(vec4(0.2f, 0.2f, 1, 1));
    //     nvg::Stroke();
    // }

    nvg::Fill();
    nvg::ClosePath();
}

// function to calculate the % transition based on the lenght of animation and current progress. clamped to 0~1
float Animate(const float runtime, const uint diffTime) {
    return Math::Min(diffTime/runtime, 1.0f);
}
