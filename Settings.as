// ====== Features ======

[Setting category="Features" name="Plugin Enabled"]
bool Setting_PluginEnabled = true;

[Setting category="Features" name="Show/Hide With Game UI"]
bool Setting_HideWithGame = true;

[Setting category="Features" name="Show Gear Change Color Pulse"]
bool Setting_ShowAnimatedGearChange = true;

[Setting category="Features" name="Show Gear Prediction Outline"]
bool Setting_ShowPredictedGear = true;

// ====== layout ======

[Setting category="Layout" name="Gearbox Position" description="(horizontal, vertical)"]
vec2 Setting_Position = vec2(0.5, 0.1);

[Setting category="Layout" name="Gearbox Size" description="(width, height)"]
vec2 Setting_Size = vec2(280, 30);

[Setting category="Layout" name="Padding Size"]
float Setting_BackdropPadding = 20;

[Setting category="Layout" name="Block Gap"]
float Setting_CapsuleGap = 15;

// ====== Style ======

[Setting category="Style" name="Backdrop color" color]
vec4 Setting_BackdropColor = vec4(0.2, 0.2, 0.2, 0.8);

[Setting category="Style" name="Engaged Gear Color" color]
vec4 Setting_EngagedColor = vec4(1, 1, 1, 1.0);

[Setting category="Style" name="Disengaged Gear Color" color]
vec4 Setting_DisengagedColor = vec4(0.3, 0.3, 0.3, 1.0);

[Setting category="Style" name="Gear-Up Color" color]
vec4 Setting_GearUpColor = vec4(0.2,1,0.2,1);

[Setting category="Style" name="Gear-Down Color" color]
vec4 Setting_GearDownColor = vec4(1, 0.2, 0.2, 1);
