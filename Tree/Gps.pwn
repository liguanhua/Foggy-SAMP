#define GPS_COLOR 0xFFFF00C8
#define GPS_UPDATE_TIME 1000
#define MAX_DOTS 2000
#define MAX_DOTS_SHOW 100
new bool:playerHasGPSActive[MAX_PLAYERS]= {false, ...},
	Timer:PlayerGPSTimer[MAX_PLAYERS]= {NONE, ...},
	Float:playerMapPos[MAX_PLAYERS][3];
	
	//Routes[MAX_PLAYERS][MAX_DOTS];
	
	
enum Routes_InFo
{
    bool:_Use,
    _Zoneid,
    _TargetZoneid,
	_Areaid,
	MapNode:_Nodeid,
	Float:_X,
	Float:_Y,
	Float:_MinX,
	Float:_MinY,
	Float:_MaxX,
	Float:_MaxY
	
};
new Routes[MAX_PLAYERS][MAX_DOTS][Routes_InFo];
new PlayerRoutesMapIcon[MAX_PLAYERS]= {INVALID_STREAMER_ID, ...};
new RoutesCount[MAX_PLAYERS]= {0, ...};
new RoutesEndCount[MAX_PLAYERS]= {0, ...};
stock Float:GDBP(Float:X, Float:Y, Float:Z, Float: PointX, Float: PointY, Float: PointZ) return floatsqroot(floatadd(floatadd(floatpower(floatsub(X, PointX), 2.0), floatpower(floatsub(Y, PointY), 2.0)), floatpower(floatsub(Z, PointZ), 2.0)));
FUNC::Gps_OnPlayerDisconnect(playerid, reason)
{
	if(playerHasGPSActive[playerid])ForcePlayerEndLastRoute(playerid);
	
	return 1;
}
FUNC::Gps_OnGameModeInit()
{
	forex(i,MAX_PLAYERS)RestRoutes(i);
	return 1;
}
FUNC::Gps_OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	StartPlayerPath(playerid, fX, fY, fZ);
	return 1;
}
FUNC::UpdatePlayerPath(playerid)
{
    if(playerHasGPSActive[playerid]==true)
    {
        new EndRouteID;
		forex(i,MAX_DOTS)
		{
		    if(Routes[playerid][i][_Use]==true)
		    {
			    if(IsPlayerInDynamicArea(playerid,Routes[playerid][i][_Areaid]))
			    {
			        EndRouteID=RoutesEndCount[playerid]-1;
			        if(Routes[playerid][EndRouteID][_Use]==true)
			        {
			            if(EndRouteID==i)
			            {
							SCM(playerid, -1, "你已经到达了目的地!");
							ForcePlayerEndLastRoute(playerid);
							return 1;
			            }
			        }
					for(new s=MAX_DOTS-1;s>-1;s--)
			        {
					    if(Routes[playerid][s][_Use]==true)
					    {
				            if(s<=i)
				            {
							    DestroyRoutesIndex(playerid,s);
		   					}
	   					}
			        }
     				forex(s,MAX_DOTS)
					{
					    if(Routes[playerid][s][_Use]==true)
					    {
						    if(Routes[playerid][s][_Zoneid]==INVALID_GANG_ZONE)
							{
							    if(GetRoutesZoneShowAmount(playerid)<MAX_DOTS_SHOW)
							    {
									Routes[playerid][s][_Zoneid]=PlayerGangZoneCreate(playerid,Routes[playerid][s][_MinX],Routes[playerid][s][_MinY],Routes[playerid][s][_MaxX],Routes[playerid][s][_MaxY]);
									if(Routes[playerid][s][_Zoneid]!=INVALID_GANG_ZONE)PlayerGangZoneShow(playerid, Routes[playerid][s][_Zoneid], GPS_COLOR);
	                            }
							}
						}
					}
			    }
		    }
		}
	}
	new First=GetFirstRoutesIndex(playerid);
    if(First!=NONE)
    {
	    if(GetDistanceBetweenPoints2D(Routes[playerid][First][_X],Routes[playerid][First][_Y],PlayerPos[playerid][0], PlayerPos[playerid][1])>=50.0)
		{
	        SCM(playerid, -1, "由于你自行变更线路,导航重新为你规划线路.");
			AssignatePlayerPath(playerid,playerMapPos[playerid][0], playerMapPos[playerid][1], playerMapPos[playerid][2]);
		}
	}
	return 1;
}
FUNC::GetRoutesZoneShowAmount(playerid)
{
	new Amount=0;
	forex(i,MAX_DOTS)
	{
	    if(Routes[playerid][i][_Zoneid]!=INVALID_GANG_ZONE)Amount++;
	}
	return Amount;
}
FUNC::GetFirstRoutesIndex(playerid)
{
	forex(i,MAX_DOTS)
	{
	    if(Routes[playerid][i][_Use]==true)return i;
	}
	return NONE;
}
FUNC::AssignatePlayerPath(playerid, Float:X, Float:Y, Float:Z)
{
	new MapNode:start, MapNode:target;
	if((GDBP(X, Y, 0.0, PlayerPos[playerid][0], PlayerPos[playerid][1], 0.0) <= 7.5))
	{
		SCM(playerid, -1, "你已经到达了目的地!");
		ForcePlayerEndLastRoute(playerid);
		return 1;
	}
    if (GetClosestMapNodeToPoint(PlayerPos[playerid][0], PlayerPos[playerid][1], PlayerPos[playerid][2], start) != 0) return print("导航出现错误. (1)");
    if (GetClosestMapNodeToPoint(X, Y, Z, target)) return print("导航出现错误. (2)");
    if (FindPathThreaded(start, target, "OnPathFound", "i", playerid))
    {
    	SCM(playerid, -1, "进程使用中.");
    	return 1;
    }
    return 1;
}
FUNC::OnPathFound(Path:pathid, playerid)
{
    if(!IsValidPath(pathid)) return SCM(playerid, -1, "GPS未发现路径!");
	DestroyRoutes(playerid);
	new size, Float:length;
	GetPathSize(pathid, size);
	GetPathLength(pathid, length);
	if(size == 1)
	{
		ForcePlayerEndLastRoute(playerid);
		return SCM(playerid, -1, "你已经到达了终点,感谢您的使用!");
	}
	new MapNode:nodeid, index, Float:lastx, Float:lasty,Float:lastz;
	GetPlayerPos(playerid, lastx, lasty, lastz);
	GetClosestMapNodeToPoint(lastx, lasty, lastz, nodeid);
	GetMapNodePos(nodeid, lastx, lasty, lastz);
	new _max = MAX_DOTS;
	if(MAX_DOTS > size) _max = size;
	new Float:X,Float:Y,Float:Z;
	forex(i,_max)
	{
		GetPathNode(pathid, i, nodeid);
		GetPathNodeIndex(pathid, nodeid, index);
		GetMapNodePos(nodeid, X, Y, Z);
		if(i == index) CreateMapRoute(playerid,nodeid, lastx, lasty, X, Y, GPS_COLOR);
		lastx = X+0.5;
		lasty = Y+0.5;
	}
	if(PlayerRoutesMapIcon[playerid]!=INVALID_STREAMER_ID)DestroyDynamicMapIcon(PlayerRoutesMapIcon[playerid]);
	PlayerRoutesMapIcon[playerid]=INVALID_STREAMER_ID;
	PlayerRoutesMapIcon[playerid]=CreateDynamicMapIcon(playerMapPos[playerid][0],playerMapPos[playerid][1],playerMapPos[playerid][2],56,0,-1,-1,playerid,10000.0,MAPICON_GLOBAL);
    Streamer_Update(playerid,STREAMER_TYPE_MAP_ICON);
    SCM(playerid, -1, "路径计算完成,请沿路线行走[/gps 关闭导航]!");
    return 1;
}
FUNC::ForcePlayerEndLastRoute(playerid)
{
	if(Timer:PlayerGPSTimer[playerid]!=NONE)KillTimer(Timer:PlayerGPSTimer[playerid]);
	Timer:PlayerGPSTimer[playerid]=NONE;
	playerHasGPSActive[playerid] = false;
	DestroyRoutes(playerid);
}

FUNC::StartPlayerPath(playerid, Float:X, Float:Y, Float:Z)
{
    formatex64("%f,%f,%f",X,Y,Z);
	SetPVarString(playerid,"_Gps_Pos_Info",string64);
	if(playerHasGPSActive[playerid]==true)
	{
		SPD(playerid,_SPD_GPS_REUSE,DIALOG_STYLE_MSGBOX,"GPS系统","你已经开始导航了,是否更改此地为导航目的地点","是的","取消");
	}
	else
	{
	    SPD(playerid,_SPD_GPS_USE,DIALOG_STYLE_MSGBOX,"GPS系统","是否设置此地为导航目的地点","是的","取消");
	}
}
FUNC::CreateMapRoute(playerid,MapNode:nodeid, Float:X1, Float:Y1, Float:X2, Float:Y2, color)
{
	new Float:Dis = 5.0;
	new Float:TotalDis = GDBP(X1, Y1, 0.0, X2, Y2, 0.0);
	new Points = floatround(TotalDis / Dis);
	for(new i = 1; i <= Points; i++)
	{
		new Float:x, Float:y;
		if(i != 0)
		{
			x = X1 + (((X2 - X1) / Points)*i);
			y = Y1 + (((Y2 - Y1) / Points)*i);
		}
		else
		{
			x = X1;
			y = Y1;
		}

		if(RoutesCount[playerid]>=MAX_DOTS)return 0;
		if(RoutesCount[playerid]>=MAX_DOTS_SHOW)
		{
		    Routes[playerid][RoutesCount[playerid]][_Zoneid]=INVALID_GANG_ZONE;
		}
		else
		{
			Routes[playerid][RoutesCount[playerid]][_Zoneid] = PlayerGangZoneCreate(playerid,x-(Dis / 2)-1.0, y-(Dis / 2)-1.0, x+(Dis / 2)+1.0, y+(Dis / 2)+1.0);
			PlayerGangZoneShow(playerid, Routes[playerid][RoutesCount[playerid]][_Zoneid], color);
		}
		Routes[playerid][RoutesCount[playerid]][_Areaid] = CreateDynamicCircle(x,y,20.0,0,-1,playerid);
		Routes[playerid][RoutesCount[playerid]][_Nodeid] = nodeid;
		Routes[playerid][RoutesCount[playerid]][_MaxX]=x+(Dis/2)+1.0;
		Routes[playerid][RoutesCount[playerid]][_MaxY]=y+(Dis/2)+1.0;
		Routes[playerid][RoutesCount[playerid]][_MinX]=x-(Dis/2)-1.0;
		Routes[playerid][RoutesCount[playerid]][_MinY]=y-(Dis/2)-1.0;
		Routes[playerid][RoutesCount[playerid]][_X]=x;
		Routes[playerid][RoutesCount[playerid]][_Y]=y;
		Routes[playerid][RoutesCount[playerid]][_Use]=true;
		RoutesCount[playerid]++;
		RoutesEndCount[playerid]++;
	}
	return 1;
}
FUNC::DestroyRoutesIndex(playerid,index)
{
    if(Routes[playerid][index][_Zoneid]!=INVALID_GANG_ZONE)PlayerGangZoneDestroy(playerid,Routes[playerid][index][_Zoneid]);
    Routes[playerid][index][_Zoneid]=INVALID_GANG_ZONE;
    if(Routes[playerid][index][_Areaid]!=INVALID_STREAMER_ID)DestroyDynamicArea(Routes[playerid][index][_Areaid]);
    Routes[playerid][index][_Areaid]=INVALID_STREAMER_ID;
    Routes[playerid][index][_Nodeid]=INVALID_MAP_NODE_ID;
    Routes[playerid][index][_Use]=false;
    RoutesCount[playerid]--;
    if(RoutesCount[playerid]<0)RoutesCount[playerid]=0;
	return 1;
}
FUNC::DestroyRoutes(playerid)
{
	forex(i,MAX_DOTS)
	{
	    if(Routes[playerid][i][_Zoneid]!=INVALID_GANG_ZONE)PlayerGangZoneDestroy(playerid,Routes[playerid][i][_Zoneid]);
	    Routes[playerid][i][_Zoneid]=INVALID_GANG_ZONE;
	    if(Routes[playerid][i][_Areaid]!=INVALID_STREAMER_ID)DestroyDynamicArea(Routes[playerid][i][_Areaid]);
	    Routes[playerid][i][_Areaid]=INVALID_STREAMER_ID;
	    Routes[playerid][i][_Nodeid]=INVALID_MAP_NODE_ID;
	    Routes[playerid][i][_Use]=false;
	}
	RoutesCount[playerid]=0;
	RoutesEndCount[playerid]=0;
	if(PlayerRoutesMapIcon[playerid]!=INVALID_STREAMER_ID)DestroyDynamicMapIcon(PlayerRoutesMapIcon[playerid]);
	PlayerRoutesMapIcon[playerid]=INVALID_STREAMER_ID;
	return 1;
}
FUNC::RestRoutes(playerid)
{
	forex(i,MAX_DOTS)
	{
	    Routes[playerid][i][_Zoneid]=INVALID_GANG_ZONE;
	    Routes[playerid][i][_Areaid]=INVALID_STREAMER_ID;
	    Routes[playerid][i][_Nodeid]=INVALID_MAP_NODE_ID;
	    Routes[playerid][i][_Use]=false;
	}
	RoutesCount[playerid]=0;
	RoutesEndCount[playerid]=0;
	PlayerRoutesMapIcon[playerid]=INVALID_STREAMER_ID;
	return 1;
}
CMD:gps(playerid)
{
	if(playerHasGPSActive[playerid]==true)
	{
	    ForcePlayerEndLastRoute(playerid);
	    SCM(playerid, -1, "导航系统关闭了,感谢您的使用!");
	}
	else SCM(playerid, -1, "你没有开启导航系统[ESC>MAP 点击地图某处可开启导航系统]");
	return 1;
}
