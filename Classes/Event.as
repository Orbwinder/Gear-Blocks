enum EVENT_TYPE{
    None,       // default, does nothing
    Gear_Gain,  // when you gear up
    Gear_Loss,  // when you gear down
}

class Event {

    uint64 t = 0.0;
    EVENT_TYPE eventType = EVENT_TYPE::None;
    uint gearNumber = 0;

    // Constructor
    Event(uint64 timestamp, EVENT_TYPE type, int8 gearNum){
        t = timestamp;
        eventType = type;
        gearNumber = gearNum;
    }

    // class comparison handler
    int opCmp(const Event &in a){
        if (this.eventType == a.eventType && this.gearNumber == a.gearNumber) {
            return 0;
        }
        return -1;
    }
}