#define MAX_WEAPON_HUD 5
new PlayerText:WeaponHudTextDraw[MAX_PLAYERS][MAX_WEAPON_HUD];
new PlayerText:WeaponHudBarBGTextDraw[MAX_PLAYERS][MAX_WEAPON_HUD];
new PlayerText:WeaponHudBarTextDraw[MAX_PLAYERS][MAX_WEAPON_HUD];
new WeaponHudBarLevel[MAX_PLAYERS][MAX_WEAPON_HUD];
new WeaponHudWeaponID[MAX_PLAYERS][MAX_WEAPON_HUD];
new bool:WeaponHudShow[MAX_PLAYERS]= {false, ...};
new LastTimeWeapon[MAX_PLAYERS];
new WeaponTXDs[47][] =
{
	{"Unarmed"},{"Brass Knuckles"},{"Golf Club"},{"Nite Stick"},{"mdl-2005:Knife"},{"mdl-2005:Bat"},{"Shovel"},{"Pool Cue"},{"Katana"},{"Chainsaw"},{"Purple Dildo"},
	{"Smal White Vibrator"},{"Large White Vibrator"},{"Silver Vibrator"},{"Flowers"},{"Cane"},{"mdl-2005:Grenade"},{"Tear Gas"},{"mdl-2005:Molotov"},
	{""},{""},{""}, 
	{"mdl-2005:Glock"},{"mdl-2005:Glock"},{"mdl-2005:DesertEagle"},{"mdl-2005:Shotgun"},{"mdl-2005:Pumpshot"},{"mdl-2005:Pumpshot"},{"mdl-2005:Uzi"},{"mdl-2005:MP5"},{"mdl-2005:AK47"},{"mdl-2005:M4"},{"mdl-2005:Uzi"},
	{"mdl-2005:Rifle"},{"mdl-2005:Rifle"},{"mdl-2005:RPG"},{"mdl-2005:RPG"},{"Flamethrower"},{"Minigun"},{"Satchel Charge"},{"Detonator"},
	{"Spraycan"},{"Fire Extinguisher"},{"Camera"},{"Nightvision Goggles"},{"Thermal Goggles"},{"Parachute"}
};
FUNC::Weapon_OnPlayerUpdate(playerid)
{
	new const CurrentWeapon = GetPlayerWeapon(playerid);
    if(CurrentWeapon!=LastTimeWeapon[playerid])
    {
        OnPlayerWeaponChange(playerid,CurrentWeapon,LastTimeWeapon[playerid]);
        LastTimeWeapon[playerid]=CurrentWeapon;
    }
	return 1;
}
FUNC::UpdateWeaponDurable(playerid,weaponid,Float:Durable)
{
	new index=NONE;
	forex(i,MAX_WEAPON_HUD)
	{
	    if(WeaponHudWeaponID[playerid][i]==weaponid)index=i;
	}
	if(index!=NONE)
	{
        new Float:Percentage=floatdiv(Durable,100.0);
		if(Percentage>1.0)Percentage=1.0;
		new BarLevel=GetWeaponDurableLevel(Percentage);
		if(WeaponHudBarLevel[playerid][index]!=BarLevel)
		{
		    WeaponHudBarLevel[playerid][index]=BarLevel;
		    PlayerTextDrawTextSize(playerid, WeaponHudBarTextDraw[playerid][index], 1.500000, -18.000000*Percentage);
            PlayerTextDrawShow(playerid, WeaponHudBarTextDraw[playerid][index]);
		}
	}
	return 1;
}
FUNC::OnPlayerWeaponChange(playerid,NewWeapon,OldWeapon)
{
    PlayerGunAttach(playerid,NewWeapon);
    if(InventoryTextDrawShow[playerid]==false&&CraftTextDrawShow[playerid]==false)
    {
		new weapons[13][2];
		forex(i,12)
		{
		    GetPlayerWeaponData(playerid,i,weapons[i][0],weapons[i][1]);
		}
		new Count=0;
		forex(i,MAX_WEAPON_HUD)
		{
			PlayerTextDrawHide(playerid, WeaponHudTextDraw[playerid][i]);
			PlayerTextDrawHide(playerid, WeaponHudBarBGTextDraw[playerid][i]);
			PlayerTextDrawHide(playerid, WeaponHudBarTextDraw[playerid][i]);
            WeaponHudBarLevel[playerid][i]=0;
            WeaponHudWeaponID[playerid][i]=0;
		}
		for(new i=12;i>0;i--)
		{
		    if(weapons[i][1]!=0)
		    {
		    	PlayerTextDrawSetString(playerid, WeaponHudTextDraw[playerid][Count],WeaponTXDs[weapons[i][0]]);
		    	if(weapons[i][0]==NewWeapon)
				{
					PlayerTextDrawColor(playerid, WeaponHudTextDraw[playerid][Count], -1);
					PlayerTextDrawBoxColor(playerid, WeaponHudBarBGTextDraw[playerid][Count], 255);
					PlayerTextDrawColor(playerid, WeaponHudBarTextDraw[playerid][Count], -1);
				}
	            else
				{
					PlayerTextDrawColor(playerid, WeaponHudTextDraw[playerid][Count], -206);
					PlayerTextDrawBoxColor(playerid, WeaponHudBarBGTextDraw[playerid][Count], 50);
	            	PlayerTextDrawColor(playerid, WeaponHudBarTextDraw[playerid][Count], -206);
	            }
	            new Float:Percentage=floatdiv(GetWeaponDurableByWeaponID(playerid,weapons[i][0]),100.0);
				if(Percentage>1.0)Percentage=1.0;
				WeaponHudWeaponID[playerid][Count]=weapons[i][0];
				WeaponHudBarLevel[playerid][Count]=GetWeaponDurableLevel(Percentage);
			    PlayerTextDrawTextSize(playerid, WeaponHudBarTextDraw[playerid][Count], 1.500000, -18.000000*Percentage);
	            PlayerTextDrawShow(playerid, WeaponHudTextDraw[playerid][Count]);
	            PlayerTextDrawShow(playerid, WeaponHudBarBGTextDraw[playerid][Count]);
	            PlayerTextDrawShow(playerid, WeaponHudBarTextDraw[playerid][Count]);
		        Count++;
		    }
		}
		WeaponHudShow[playerid]=true;
	}
	return 1;
}
FUNC::GetWeaponDurableLevel(Float:Percentage)
{
	if(Percentage>0.9&&Percentage<=1.0)return 0;
	if(Percentage>0.8&&Percentage<=0.9)return 1;
	if(Percentage>0.7&&Percentage<=0.8)return 2;
	if(Percentage>0.6&&Percentage<=0.7)return 3;
	if(Percentage>0.5&&Percentage<=0.6)return 4;
	if(Percentage>0.4&&Percentage<=0.5)return 5;
	if(Percentage>0.3&&Percentage<=0.4)return 6;
	if(Percentage>0.2&&Percentage<=0.3)return 7;
	if(Percentage>0.1&&Percentage<=0.2)return 8;
	return 9;
}
FUNC::WeaponShow_OnPlayerConnect(playerid)
{
	forex(i,MAX_WEAPON_HUD)
	{
		WeaponHudTextDraw[playerid][i] = CreatePlayerTextDraw(playerid, 503.000000, 121.000000+i*31.0, "mdl-2005:PSG1");
		PlayerTextDrawFont(playerid, WeaponHudTextDraw[playerid][i], 4);
		PlayerTextDrawLetterSize(playerid, WeaponHudTextDraw[playerid][i], 0.600000, 2.000000);
		PlayerTextDrawTextSize(playerid, WeaponHudTextDraw[playerid][i], 104.000000, 51.000000);
		PlayerTextDrawSetOutline(playerid, WeaponHudTextDraw[playerid][i], 1);
		PlayerTextDrawSetShadow(playerid, WeaponHudTextDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, WeaponHudTextDraw[playerid][i], 1);
		PlayerTextDrawColor(playerid, WeaponHudTextDraw[playerid][i], -256);
		PlayerTextDrawBackgroundColor(playerid, WeaponHudTextDraw[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, WeaponHudTextDraw[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, WeaponHudTextDraw[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, WeaponHudTextDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, WeaponHudTextDraw[playerid][i], 0);
		
		WeaponHudBarBGTextDraw[playerid][i] = CreatePlayerTextDraw(playerid, 609.000000, 129.000000+i*31.0, "_");
		PlayerTextDrawFont(playerid, WeaponHudBarBGTextDraw[playerid][i], 1);
		PlayerTextDrawLetterSize(playerid, WeaponHudBarBGTextDraw[playerid][i], -0.066666, 1.700000);
		PlayerTextDrawTextSize(playerid, WeaponHudBarBGTextDraw[playerid][i], 212.000000, 0.000000);
		PlayerTextDrawSetOutline(playerid, WeaponHudBarBGTextDraw[playerid][i], 1);
		PlayerTextDrawSetShadow(playerid, WeaponHudBarBGTextDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, WeaponHudBarBGTextDraw[playerid][i], 2);
		PlayerTextDrawColor(playerid, WeaponHudBarBGTextDraw[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, WeaponHudBarBGTextDraw[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, WeaponHudBarBGTextDraw[playerid][i], 255);
		PlayerTextDrawUseBox(playerid, WeaponHudBarBGTextDraw[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, WeaponHudBarBGTextDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, WeaponHudBarBGTextDraw[playerid][i], 0);

		WeaponHudBarTextDraw[playerid][i] = CreatePlayerTextDraw(playerid, 608.200000, 146.000000+i*31.0, "LD_SPAC:WHITE");
		PlayerTextDrawFont(playerid, WeaponHudBarTextDraw[playerid][i], 4);
		PlayerTextDrawLetterSize(playerid, WeaponHudBarTextDraw[playerid][i], 0.600000, 2.000000);
		PlayerTextDrawTextSize(playerid, WeaponHudBarTextDraw[playerid][i], 1.500000, -18.000000);
		PlayerTextDrawSetOutline(playerid, WeaponHudBarTextDraw[playerid][i], 1);
		PlayerTextDrawSetShadow(playerid, WeaponHudBarTextDraw[playerid][i], 0);
		PlayerTextDrawAlignment(playerid, WeaponHudBarTextDraw[playerid][i], 1);
		PlayerTextDrawColor(playerid, WeaponHudBarTextDraw[playerid][i], -16776961);
		PlayerTextDrawBackgroundColor(playerid, WeaponHudBarTextDraw[playerid][i], 255);
		PlayerTextDrawBoxColor(playerid, WeaponHudBarTextDraw[playerid][i], 50);
		PlayerTextDrawUseBox(playerid, WeaponHudBarTextDraw[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, WeaponHudBarTextDraw[playerid][i], 1);
		PlayerTextDrawSetSelectable(playerid, WeaponHudBarTextDraw[playerid][i], 0);
	}
	return 1;
}
FUNC::WeaponShow_OnPlayerDisconnect(playerid)
{
	forex(i,MAX_WEAPON_HUD)
	{
		if(WeaponHudTextDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,WeaponHudTextDraw[playerid][i]);
		WeaponHudTextDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(WeaponHudBarBGTextDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,WeaponHudBarBGTextDraw[playerid][i]);
		WeaponHudBarBGTextDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		if(WeaponHudBarTextDraw[playerid][i]!=PlayerText:INVALID_TEXT_DRAW)PlayerTextDrawDestroy(playerid,WeaponHudBarTextDraw[playerid][i]);
		WeaponHudBarTextDraw[playerid][i]=PlayerText:INVALID_TEXT_DRAW;
		WeaponHudBarLevel[playerid][i]=0;
		WeaponHudWeaponID[playerid][i]=0;
	}
	return 1;
}
FUNC::WeaponShow_OnGameModeInit()
{
	forex(i,MAX_PLAYERS)
	{
	    forex(s,MAX_WEAPON_HUD)
		{
			WeaponHudTextDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			WeaponHudBarBGTextDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
			WeaponHudBarTextDraw[i][s]=PlayerText:INVALID_TEXT_DRAW;
            WeaponHudBarLevel[i][s]=0;
            WeaponHudWeaponID[i][s]=0;
		}
	}
	return 1;
}
FUNC::HideWeaponHudTextDrawForPlayer(playerid)
{
    forex(i,MAX_WEAPON_HUD)
	{
		PlayerTextDrawHide(playerid, WeaponHudTextDraw[playerid][i]);
		PlayerTextDrawHide(playerid, WeaponHudBarBGTextDraw[playerid][i]);
		PlayerTextDrawHide(playerid, WeaponHudBarTextDraw[playerid][i]);
		WeaponHudBarLevel[playerid][i]=0;
		WeaponHudWeaponID[playerid][i]=0;
	}
    WeaponHudShow[playerid]=false;
	return 1;
}
