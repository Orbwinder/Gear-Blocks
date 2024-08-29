// this file manages the event system to generate and delete events in the event queue

array<Event@> g_events;
uint g_prevGear = 1;
uint g_prevCheckpoints = 0;
uint g_prevRespawns = 0;
int g_prevRaceTime = 0;
bool g_skipNextFrame = false;


void UpdateEvents(){
    if (!Setting_PluginEnabled) return; // escape if the plugin is disabled
    if (GetApp().CurrentPlayground is null) return; // escape if there is no loaded map

    auto nowState = VehicleState::ViewingPlayerState();
    auto RaceData = MLFeed::GetRaceData_V2();
    auto player = RaceData.GetPlayer_V2(MLFeed::LocalPlayersName);

    if (nowState is null || player is null) return; // escape if there is no player info 

    if(!g_skipNextFrame){
        auto rpm = VehicleState::GetRPM(nowState);
        // check for gear changes
        auto prevGear = g_prevGear;
        auto nowGear = nowState.CurGear;
        
        if (prevGear != nowGear) {
            // change detected
            if (prevGear > nowGear) {
                // lost a gear
                g_events.InsertAt(0, Event(uint64(Time::get_Now()), EVENT_TYPE::Gear_Loss, prevGear));
            } else {   
                // gained a gear
                g_events.InsertAt(0, Event(uint64(Time::get_Now()), EVENT_TYPE::Gear_Gain, nowGear));
            }
        }

        // check for respawn/reset changes
        if ( player.NbRespawnsRequested != g_prevRespawns 
        || uint(player.CpCount) < g_prevCheckpoints 
        || player.TheoreticalRaceTime < g_prevRaceTime
        ) {
            // erase all events to cancel all animations
            g_events.set_Length(0);
            g_skipNextFrame = true;
        }
    } else {
        // after skipping the frame, reset flag
        g_skipNextFrame = false; 
    }

    // update prevGear
    g_prevGear = int(nowState.CurGear);
    // update others
    g_prevRespawns = uint(player.NbRespawnsRequested);
    g_prevCheckpoints = int(player.CpCount);
    g_prevRaceTime = int(player.TheoreticalRaceTime);
    
    // cleanup events array (remove expired events)
    const int eventExpiryMilis = 2000;
    for(int i=g_events.Length-1; i>=0; i--){
        if (Time::Now - g_events[i].t > eventExpiryMilis) {
            // remove the event from array
            g_events.RemoveAt(i);
        }
    }
}

// copied from NoRespawnTimer
int64 GetRaceTime(CSmScriptPlayer& scriptPlayer)
{
	if (scriptPlayer is null)
		// not playing
		return 0;
	
	auto playgroundScript = cast<CSmArenaRulesMode>(GetApp().PlaygroundScript);

	if (playgroundScript is null)
		// Online 
		return GetApp().Network.PlaygroundClientScriptAPI.GameTime - scriptPlayer.StartTime;
	else
		// Solo
		return playgroundScript.Now - scriptPlayer.StartTime;
}