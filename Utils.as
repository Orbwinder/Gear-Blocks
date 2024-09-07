// defining gear speeds for different vehicles
// prediction should consistently trigger approx 1 frame before the gear changes when driving straight concrete 
const array<float> sportGears =     {0, 101, 161, 234, 341};
const array<float> snowGears =      {0, 67.6, 117.9, 170.7, 234.2};
const array<float> rallyGears =     {0, 78.5, 105.7, 145.3, 188};
const array<float> desertGears =    {0, 78, 139.1, 210.4, 279};

/**
 * predicting the car's current gear based on other relevant stats
 * useful when internal value is locked or delayed
 */
uint getPredictedGear(const float displaySpeed, const VehicleState::VehicleType vehicleType) {
    array<float> currentVehicleGears = {}; 

    switch(vehicleType){
        case VehicleState::VehicleType::CarSnow: {
            currentVehicleGears = snowGears; 
            break;
        }
        case VehicleState::VehicleType::CarRally: {
            currentVehicleGears = rallyGears; 
            break;
        }
        case VehicleState::VehicleType::CarDesert: {
            currentVehicleGears = desertGears; 
            break;
        }
        default: {
            currentVehicleGears = sportGears; 
        }
    }

    if (displaySpeed > currentVehicleGears[4]) {
        return 5;
    } else if (displaySpeed > currentVehicleGears[3]) {
        return 4;
    } else if (displaySpeed > currentVehicleGears[2]) {
        return 3;
    } else if (displaySpeed > currentVehicleGears[1]) {
        return 2;
    } else if (displaySpeed > currentVehicleGears[0]) {
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