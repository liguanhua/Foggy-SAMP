#define MAX_PLAYER_GZ 100
#define PLAYER_GZ_DEFAULT_COLOR 0xFFFFFFAA
enum E_PLAYER_GZ_DATA
{
	Float:player_GZ_MinX,
	Float:player_GZ_MinY,
	Float:player_GZ_MaxX,
	Float:player_GZ_MaxY,
	player_GZ_Color,
	bool:player_GZ_Used,
	bool:player_GZ_Shown
}
new PlayerGangZoneData[MAX_PLAYERS][MAX_PLAYER_GZ][E_PLAYER_GZ_DATA];
new Iterator:PlayerGangZoneData[MAX_PLAYERS]<MAX_PLAYER_GZ>;
FUNC::PlayerGangZoneCreate(playerid, Float:minx, Float:miny, Float:maxx, Float:maxy)
{
    if(Iter_Count(PlayerGangZoneData[playerid])>=MAX_PLAYER_GZ)return INVALID_GANG_ZONE;
    new idx=Iter_Free(PlayerGangZoneData[playerid]);
	PlayerGangZoneData[playerid][idx][player_GZ_MinX]	= minx;
	PlayerGangZoneData[playerid][idx][player_GZ_MinY]	= miny;
	PlayerGangZoneData[playerid][idx][player_GZ_MaxX]	= maxx;
	PlayerGangZoneData[playerid][idx][player_GZ_MaxY]	= maxy;
	PlayerGangZoneData[playerid][idx][player_GZ_Color]	= PLAYER_GZ_DEFAULT_COLOR;
	PlayerGangZoneData[playerid][idx][player_GZ_Used]	= true;
	PlayerGangZoneData[playerid][idx][player_GZ_Shown]	= false;
	Iter_Add(PlayerGangZoneData[playerid],idx);
	return idx;
}
stock PlayerGangZoneShow(playerid, gangzoneid, color = PLAYER_GZ_DEFAULT_COLOR)
{
    if(Iter_Contains(PlayerGangZoneData[playerid],gangzoneid))
    {
		if(!PlayerGangZoneData[playerid][gangzoneid][player_GZ_Used] || gangzoneid > MAX_PLAYER_GZ-1 || gangzoneid < 0) return 0;
		PlayerGangZoneData[playerid][gangzoneid][player_GZ_Color] = color;
		PlayerGangZoneData[playerid][gangzoneid][player_GZ_Shown] = true;
		new abgr_color = (((color << 16) | color & 0xFF00) << 8) | (((color >>> 16) | color & 0xFF0000) >>> 8);
		new BitStream:gz_bs = BS_New();
		BS_WriteValue
		(
			gz_bs,
			PR_UINT16, 1023 - gangzoneid,
			PR_FLOAT, PlayerGangZoneData[playerid][gangzoneid][player_GZ_MinX],
			PR_FLOAT, PlayerGangZoneData[playerid][gangzoneid][player_GZ_MinY],
			PR_FLOAT, PlayerGangZoneData[playerid][gangzoneid][player_GZ_MaxX],
			PR_FLOAT, PlayerGangZoneData[playerid][gangzoneid][player_GZ_MaxY],
			PR_UINT32, abgr_color
		);
		BS_RPC(gz_bs, playerid, 0x6C);
		BS_Delete(gz_bs);
	}
	return 1;
}
FUNC::PlayerGangZoneHide(playerid, gangzoneid)
{
    if(Iter_Contains(PlayerGangZoneData[playerid],gangzoneid))
    {
		if(!PlayerGangZoneData[playerid][gangzoneid][player_GZ_Used] ||
			!PlayerGangZoneData[playerid][gangzoneid][player_GZ_Shown]) return 0;
		PlayerGangZoneData[playerid][gangzoneid][player_GZ_Shown] = false;
		new BitStream:gz_bs = BS_New();
		BS_WriteValue(
			gz_bs,
			PR_UINT16, 1023 - gangzoneid
		);
		BS_RPC(gz_bs, playerid, 0x78);
		BS_Delete(gz_bs);
	}
	return 1;
}

FUNC::PlayerGangZoneDestroy(playerid, gangzoneid)
{
    if(Iter_Contains(PlayerGangZoneData[playerid],gangzoneid))
    {
		if(!PlayerGangZoneData[playerid][gangzoneid][player_GZ_Used] || gangzoneid > MAX_PLAYER_GZ-1 || gangzoneid < 0) return 0;
		if(PlayerGangZoneData[playerid][gangzoneid][player_GZ_Shown])
		PlayerGangZoneHide(playerid, gangzoneid);
		PlayerGangZoneData[playerid][gangzoneid][player_GZ_Used]= false;
		PlayerGangZoneData[playerid][gangzoneid][player_GZ_MinX]= 0.0;
		PlayerGangZoneData[playerid][gangzoneid][player_GZ_MinY]= 0.0;
		PlayerGangZoneData[playerid][gangzoneid][player_GZ_MaxX]= 0.0;
		PlayerGangZoneData[playerid][gangzoneid][player_GZ_MaxY]= 0.0;
		PlayerGangZoneData[playerid][gangzoneid][player_GZ_Color]= 0;
		new	cur = gangzoneid;
		Iter_SafeRemove(PlayerGangZoneData[playerid],cur,gangzoneid);
	}
	return 1;
}
FUNC::PlayerGangZoneDataRest(playerid)
{
    Iter_Clear(PlayerGangZoneData[playerid]);
	return 1;
}

