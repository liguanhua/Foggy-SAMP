new Text:SpeedoBackGroundDraws[3]= {Text:INVALID_TEXT_DRAW, ...};
new bool:PlayerSpeedoShow[MAX_PLAYERS]= {false, ...};
new PlayerSpeedoOldFloor[MAX_PLAYERS]={NONE, ...};
new PlayerHPOldFloor[MAX_PLAYERS]={NONE, ...};
new PlayerText:PSpeedoTextDraw[MAX_PLAYERS]= {PlayerText:INVALID_TEXT_DRAW, ...};
new PlayerText:PSpeedoFuelTextDraw[MAX_PLAYERS]= {PlayerText:INVALID_TEXT_DRAW, ...};
new PlayerText:PSpeedoHPTextDraw[MAX_PLAYERS]= {PlayerText:INVALID_TEXT_DRAW, ...};
#define MAX_SPEED_FLOOR 36
new GobalVeh[MAX_VEHICLES]= {NONE, ...};
new Float:GobalVehicleFuel[MAX_VEHICLES]= {60.0, ...};
new Float:GobalVehicleHP[MAX_VEHICLES]= {1000.0, ...};
new bool:GobalVehicleEngine[MAX_VEHICLES]= {false, ...};
#define MAX_FUEL_FLOOR 18
new PlayerFuelOldFloor[MAX_PLAYERS]={NONE, ...};
FUNC::Speedo_OnGameModeInit()
{
	SpeedoBackGroundDraws[0] = TextDrawCreate(498.666534, 333.785217, "mdl-2001:speedback1");
	TextDrawLetterSize(SpeedoBackGroundDraws[0], 0.000000, 0.000000);
	TextDrawTextSize(SpeedoBackGroundDraws[0], 144.000000, 161.000000);
	TextDrawAlignment(SpeedoBackGroundDraws[0], 1);
	TextDrawColor(SpeedoBackGroundDraws[0], -1);
	TextDrawSetShadow(SpeedoBackGroundDraws[0], 0);
	TextDrawSetOutline(SpeedoBackGroundDraws[0], 0);
	TextDrawBackgroundColor(SpeedoBackGroundDraws[0], 255);
	TextDrawFont(SpeedoBackGroundDraws[0], 4);
	TextDrawSetProportional(SpeedoBackGroundDraws[0], 0);
	TextDrawSetShadow(SpeedoBackGroundDraws[0], 0);

	SpeedoBackGroundDraws[1] = TextDrawCreate(555.332763, 261.607421, "mdl-2001:speedback2");
	TextDrawLetterSize(SpeedoBackGroundDraws[1], 0.000000, 0.000000);
	TextDrawTextSize(SpeedoBackGroundDraws[1], 139.000000, 146.000000);
	TextDrawAlignment(SpeedoBackGroundDraws[1], 1);
	TextDrawColor(SpeedoBackGroundDraws[1], -1);
	TextDrawSetShadow(SpeedoBackGroundDraws[1], 0);
	TextDrawSetOutline(SpeedoBackGroundDraws[1], 0);
	TextDrawBackgroundColor(SpeedoBackGroundDraws[1], 255);
	TextDrawFont(SpeedoBackGroundDraws[1], 4);
	TextDrawSetProportional(SpeedoBackGroundDraws[1], 0);
	TextDrawSetShadow(SpeedoBackGroundDraws[1], 0);
	
	SpeedoBackGroundDraws[2] = TextDrawCreate(596.000000, 432.000000, "mdl-2000:veh_hp");
	TextDrawFont(SpeedoBackGroundDraws[2], 4);
	TextDrawLetterSize(SpeedoBackGroundDraws[2], 0.600000, 2.000000);
	TextDrawTextSize(SpeedoBackGroundDraws[2], 19.000000, 10.000000);
	TextDrawSetOutline(SpeedoBackGroundDraws[2], 1);
	TextDrawSetShadow(SpeedoBackGroundDraws[2], 0);
	TextDrawAlignment(SpeedoBackGroundDraws[2], 1);
	TextDrawColor(SpeedoBackGroundDraws[2], -1);
	TextDrawBackgroundColor(SpeedoBackGroundDraws[2], 255);
	TextDrawBoxColor(SpeedoBackGroundDraws[2], 50);
	TextDrawUseBox(SpeedoBackGroundDraws[2], 1);
	TextDrawSetProportional(SpeedoBackGroundDraws[2], 1);
	TextDrawSetSelectable(SpeedoBackGroundDraws[2], 0);
	return 1;
}

FUNC::Speedo_OnPlayerConnect(playerid)
{
	Speedo_OnPlayerDisconnect(playerid);
	PSpeedoTextDraw[playerid] = CreatePlayerTextDraw(playerid, 518.000000, 358.259338, "mdl-2001:needle0");
	PlayerTextDrawLetterSize(playerid, PSpeedoTextDraw[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PSpeedoTextDraw[playerid], 104.000000, 100.000000);
	PlayerTextDrawAlignment(playerid, PSpeedoTextDraw[playerid], 1);
	PlayerTextDrawColor(playerid, PSpeedoTextDraw[playerid], -1);
	PlayerTextDrawSetShadow(playerid, PSpeedoTextDraw[playerid], 0);
	PlayerTextDrawSetOutline(playerid, PSpeedoTextDraw[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PSpeedoTextDraw[playerid], 255);
	PlayerTextDrawFont(playerid, PSpeedoTextDraw[playerid], 4);
	PlayerTextDrawSetProportional(playerid, PSpeedoTextDraw[playerid], 0);
	PlayerTextDrawSetShadow(playerid, PSpeedoTextDraw[playerid], 0);

	PSpeedoFuelTextDraw[playerid] = CreatePlayerTextDraw(playerid, 588.333312, 291.059356, "mdl-2001:needle5");
	PlayerTextDrawLetterSize(playerid, PSpeedoFuelTextDraw[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PSpeedoFuelTextDraw[playerid], 70.000000, 86.000000);
	PlayerTextDrawAlignment(playerid, PSpeedoFuelTextDraw[playerid], 1);
	PlayerTextDrawColor(playerid, PSpeedoFuelTextDraw[playerid], 16777215);
	PlayerTextDrawSetShadow(playerid, PSpeedoFuelTextDraw[playerid], 0);
	PlayerTextDrawSetOutline(playerid, PSpeedoFuelTextDraw[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PSpeedoFuelTextDraw[playerid], 255);
	PlayerTextDrawFont(playerid, PSpeedoFuelTextDraw[playerid], 4);
	PlayerTextDrawSetProportional(playerid, PSpeedoFuelTextDraw[playerid], 0);
	PlayerTextDrawSetShadow(playerid, PSpeedoFuelTextDraw[playerid], 0);

	PSpeedoHPTextDraw[playerid] = CreatePlayerTextDraw(playerid, 627.000000, 431.000000, "_");
	PlayerTextDrawFont(playerid, PSpeedoHPTextDraw[playerid], 2);
	PlayerTextDrawLetterSize(playerid, PSpeedoHPTextDraw[playerid], 0.204166, 1.299999);
	PlayerTextDrawTextSize(playerid, PSpeedoHPTextDraw[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PSpeedoHPTextDraw[playerid], 0);
	PlayerTextDrawSetShadow(playerid, PSpeedoHPTextDraw[playerid], 0);
	PlayerTextDrawAlignment(playerid, PSpeedoHPTextDraw[playerid], 2);
	PlayerTextDrawColor(playerid, PSpeedoHPTextDraw[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PSpeedoHPTextDraw[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PSpeedoHPTextDraw[playerid], 50);
	PlayerTextDrawUseBox(playerid, PSpeedoHPTextDraw[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PSpeedoHPTextDraw[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PSpeedoHPTextDraw[playerid], 0);
	return 1;
}
FUNC::Speedo_OnPlayerDisconnect(playerid)
{
	if(PSpeedoTextDraw[playerid]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PSpeedoTextDraw[playerid]);
	PSpeedoTextDraw[playerid]=PlayerText:INVALID_TEXT_DRAW;
	if(PSpeedoFuelTextDraw[playerid]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PSpeedoFuelTextDraw[playerid]);
	PSpeedoFuelTextDraw[playerid]=PlayerText:INVALID_TEXT_DRAW;
	if(PSpeedoHPTextDraw[playerid]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,PSpeedoHPTextDraw[playerid]);
	PSpeedoHPTextDraw[playerid]=PlayerText:INVALID_TEXT_DRAW;
	PlayerSpeedoShow[playerid]=false;
	PlayerSpeedoOldFloor[playerid]=NONE;
	PlayerHPOldFloor[playerid]=NONE;
	return 1;
}

FUNC::SpeedoUpdate(playerid)
{
    /*new Float:drawxy[2];
    pTD_GetTextSize(playerid,PSpeedoTextDraw[playerid], drawxy[0], drawxy[1]);
    printf("TextSize:%f,%f",drawxy[0], drawxy[1]);
    pTD_GetLetterSize(playerid,PSpeedoTextDraw[playerid], drawxy[0], drawxy[1]);
    printf("LetterSize:%f,%f",drawxy[0], drawxy[1]);*/
	if(PlayerSpeedoShow[playerid]==true)
	{
	    if(IsPlayerInAnyVehicle(playerid))
	    {
	        new PVid=GetPlayerVehicleID(playerid);
	        new SpeedFloor=floatround(floatdiv(GetVehicleSpeed(PVid),5),floatround_floor);
            if(SpeedFloor>MAX_SPEED_FLOOR)SpeedFloor=MAX_SPEED_FLOOR;
			if(SpeedFloor!=PlayerSpeedoOldFloor[playerid])
			{
		        formatex32("mdl-2001:needle%i",SpeedFloor);
		        PlayerTextDrawSetString(playerid,PSpeedoTextDraw[playerid],string32);
		        PlayerSpeedoOldFloor[playerid]=SpeedFloor;
	        }
	        new FuelFloor=floatround(floatdiv(GobalVehicleFuel[PVid],3),floatround_floor);
            if(FuelFloor>MAX_FUEL_FLOOR)FuelFloor=MAX_FUEL_FLOOR;
            formatex64("см %i,%0.1f",FuelFloor,GobalVehicleFuel[PVid]);
            Debug(-1,string64);
			if(FuelFloor!=PlayerFuelOldFloor[playerid])
	        {
		        formatex32("mdl-2001:needle%i",FuelFloor+5);
		        PlayerTextDrawSetString(playerid,PSpeedoFuelTextDraw[playerid],string32);
		        PlayerFuelOldFloor[playerid]=SpeedFloor;
	        }
			GetVehicleHealth(PVid,GobalVehicleHP[PVid]);
			new HpFloor=floatround(floatmul(floatdiv(floatsub(1000.0,GobalVehicleHP[PVid]),1000.0),100.0));
			if(HpFloor!=PlayerHPOldFloor[playerid])
			{
				formatex32("%i%",HpFloor);
				PlayerTextDrawSetString(playerid,PSpeedoHPTextDraw[playerid],string32);
				PlayerHPOldFloor[playerid]=HpFloor;
			}
	    }
    }
	return 1;
}
FUNC::FuleUpdate(vehicleid)
{
	if(IsValidVehicle(vehicleid))
	{
		if(GobalVehicleEngine[vehicleid]==true)
		{
		    if(GobalVehicleFuel[vehicleid]>0.0)
		    {
		        GobalVehicleFuel[vehicleid]=floatsub(GobalVehicleFuel[vehicleid],0.001);
		        if(GobalVehicleFuel[vehicleid]<0.0)GobalVehicleFuel[vehicleid]=0.0;
		        ToggleVehicleEngine(vehicleid,1);
		    }
		    else
		    {
		        GobalVehicleEngine[vehicleid]=false;
		        ToggleVehicleEngine(vehicleid,0);
		        //SetVehicleParamsEx(vehicleid,0,0,0,0,0,0,0);
		    }
		}
	}
	return 1;
}
FUNC::ShowPlayerSpeedo(playerid)
{
    forex(i,sizeof(SpeedoBackGroundDraws))TextDrawShowForPlayer(playerid,SpeedoBackGroundDraws[i]);
    PlayerTextDrawShow(playerid,PSpeedoTextDraw[playerid]);
    PlayerTextDrawShow(playerid,PSpeedoFuelTextDraw[playerid]);
    PlayerTextDrawShow(playerid,PSpeedoHPTextDraw[playerid]);
    PlayerSpeedoShow[playerid]=true;
    PlayerSpeedoOldFloor[playerid]=NONE;
    PlayerHPOldFloor[playerid]=NONE;
    SpeedoUpdate(playerid);
	return 1;
}
FUNC::HidePlayerSpeedo(playerid)
{
    forex(i,sizeof(SpeedoBackGroundDraws))TextDrawHideForPlayer(playerid,SpeedoBackGroundDraws[i]);
    PlayerTextDrawHide(playerid,PSpeedoTextDraw[playerid]);
    PlayerTextDrawHide(playerid,PSpeedoFuelTextDraw[playerid]);
    PlayerTextDrawHide(playerid,PSpeedoHPTextDraw[playerid]);
    PlayerSpeedoShow[playerid]=false;
    PlayerSpeedoOldFloor[playerid]=NONE;
    PlayerHPOldFloor[playerid]=NONE;
	return 1;
}

