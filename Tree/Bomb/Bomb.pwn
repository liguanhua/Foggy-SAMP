#define MAX_BOMBS 100
#define MAX_BOOMS 31
enum Bomb_Info
{
	_CreaterKey[37],
	_Key[37],
	_ItemID,
	Float:_Pos[3],
	_World,
	_Interior,
	_CountTime,
	_Count,
	Timer:_Explosion,
	_ObjectID,
	_ExplosionObjectID[MAX_BOOMS],
	_AreaID,
	Bar3D:_BombBar,
}
new Bomb[MAX_BOMBS][Bomb_Info];
new Iterator:Bomb<MAX_BOMBS>;
FUNC::CreateBomb(playerid,ItemKey[],Float:X,Float:Y,Float:Z,World,Interior,CountDown)
{
	new ItemID=GetItemIDByItemKey(ItemKey);
	if(ItemID==NONE)
	{
	    formatex80("%i-cb error0",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
	if(Iter_Count(Bomb)>=MAX_BOMBS)
	{
	    formatex80("%i-cb error1",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
    
	SetPlayerInvItemUseAttach(playerid,ItemID,9,6);
	ApplyInvItemAnimation(playerid,ItemID);
	if(Timer:PlayerUseItemAnim[playerid]!=NONE)KillTimer(Timer:PlayerUseItemAnim[playerid]);
	Timer:PlayerUseItemAnim[playerid]=NONE;
	Timer:PlayerUseItemAnim[playerid]=SetTimerEx("RemovePlayerUseItemAttach",2000,false,"i",playerid);

    new i=Iter_Free(Bomb);
   	format(Bomb[i][_CreaterKey],UUID_LEN,Account[playerid][_Key]);
   	UUID(Bomb[i][_Key], UUID_LEN);
    Bomb[i][_Pos][0]=X;
    Bomb[i][_Pos][1]=Y;
    Bomb[i][_Pos][2]=Z;
    Bomb[i][_World]=GetPlayerVirtualWorld(playerid);
    Bomb[i][_Interior]=GetPlayerInterior(playerid);
    Bomb[i][_Count]=0;
    Bomb[i][_CountTime]=CountDown;
    Bomb[i][_ItemID]=ItemID;
    Iter_Add(Bomb,i);
    Bomb[i][_ObjectID]=CreateDynamicObject(Item[Bomb[i][_ItemID]][_Model],Bomb[i][_Pos][0],Bomb[i][_Pos][1],Bomb[i][_Pos][2],0.0,0.0,0.0,Bomb[i][_World],Bomb[i][_Interior],-1,Item[Bomb[i][_ItemID]][_ExplosionSize]*5.0);
    Bomb[i][_BombBar]=CreateProgressBar3D(Bomb[i][_Pos][0],Bomb[i][_Pos][1],Bomb[i][_Pos][2]+0.4,BAR_3D_LAYOUT_NORMAL,0xFF8000C8, 0x400000C8,Bomb[i][_CountTime],Bomb[i][_Count],Item[Bomb[i][_ItemID]][_ExplosionSize]*2.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,Bomb[i][_World],Bomb[i][_Interior]);
    Bomb[i][_AreaID]=CreateDynamicSphere(Bomb[i][_Pos][0],Bomb[i][_Pos][1],Bomb[i][_Pos][2],floatdiv(Item[Bomb[i][_ItemID]][_ExplosionSize],2.0),Bomb[i][_World],Bomb[i][_Interior]);
    Bomb[i][Timer:_Explosion]=SetTimerEx("BombExplosion",1000,true,"i",i);
	UpdateStreamer(X,Y,Z,Bomb[i][_World],Bomb[i][_Interior]);
	return RETURN_SUCCESS;
}
FUNC::DestoryBomb(index)
{
	if(!Iter_Contains(Bomb,index))
	{
	    formatex80("%i-db error0",NONE);
        Debug(NONE,string80);
		return RETURN_ERROR;
	}
	if(IsValidDynamicObject(Bomb[index][_ObjectID]))DestroyDynamicObject(Bomb[index][_ObjectID]);
	if(IsValidProgressBar3D(Bomb[index][_BombBar]))DestroyProgressBar3D(Bomb[index][_BombBar]);
	if(IsValidDynamicArea(Bomb[index][_AreaID]))DestroyDynamicArea(Bomb[index][_AreaID]);
	forex(i,MAX_BOOMS)
	{
		if(IsValidDynamicObject(Bomb[index][_ExplosionObjectID][i]))DestroyDynamicObject(Bomb[index][_ExplosionObjectID][i]);
		Bomb[index][_ExplosionObjectID][i]=INVALID_STREAMER_ID;
	}
	Bomb[index][_ObjectID]=INVALID_STREAMER_ID;
	Bomb[index][_BombBar]=INVALID_3D_BAR;
	Bomb[index][_AreaID]=INVALID_STREAMER_ID;
    KillTimer(Bomb[index][Timer:_Explosion]);
    Bomb[index][Timer:_Explosion]=NONE;
	Iter_Remove(Bomb,index);
	return RETURN_SUCCESS;
}
FUNC::BombExplosion(index)
{
	if(Bomb[index][_Count]>=Bomb[index][_CountTime])
	{
		if(IsValidDynamicObject(Bomb[index][_ObjectID]))DestroyDynamicObject(Bomb[index][_ObjectID]);
		if(IsValidProgressBar3D(Bomb[index][_BombBar]))DestroyProgressBar3D(Bomb[index][_BombBar]);
		Bomb[index][_ObjectID]=INVALID_STREAMER_ID;
		Bomb[index][_BombBar]=INVALID_3D_BAR;
        Bomb[index][_ExplosionObjectID][0]=CreateDynamicObject(Item[Bomb[index][_ItemID]][_WeaponID],Bomb[index][_Pos][0],Bomb[index][_Pos][1],Bomb[index][_Pos][2],0.0,0.0,0.0,Bomb[index][_World],Bomb[index][_Interior],-1,Item[Bomb[index][_ItemID]][_ExplosionSize]*5.0);
		new Float:BoomX=Bomb[index][_Pos][0],Float:BoomY=Bomb[index][_Pos][1];
		loop(i,1,MAX_BOOMS-20)
		{
		    BoomX=Bomb[index][_Pos][0],Float:BoomY=Bomb[index][_Pos][1];
		    GetAngleDistancePoint(40.0*(i-1),2.0,BoomX,BoomY);
		    Bomb[index][_ExplosionObjectID][i]=CreateDynamicObject(Item[Bomb[index][_ItemID]][_WeaponID],BoomX,BoomY,Bomb[index][_Pos][2],0.0,0.0,0.0,Bomb[index][_World],Bomb[index][_Interior],-1,Item[Bomb[index][_ItemID]][_ExplosionSize]*5.0);
		}
		loop(i,MAX_BOOMS-20,MAX_BOOMS-10)
		{
		    BoomX=Bomb[index][_Pos][0],Float:BoomY=Bomb[index][_Pos][1];
		    GetAngleDistancePoint(40.0*(i-1),4.0,BoomX,BoomY);
		    Bomb[index][_ExplosionObjectID][i]=CreateDynamicObject(Item[Bomb[index][_ItemID]][_WeaponID],BoomX,BoomY,Bomb[index][_Pos][2],0.0,0.0,0.0,Bomb[index][_World],Bomb[index][_Interior],-1,Item[Bomb[index][_ItemID]][_ExplosionSize]*5.0);
		}
		loop(i,MAX_BOOMS-10,MAX_BOOMS)
		{
		    BoomX=Bomb[index][_Pos][0],Float:BoomY=Bomb[index][_Pos][1];
		    GetAngleDistancePoint(40.0*(i-1),6.0,BoomX,BoomY);
		    Bomb[index][_ExplosionObjectID][i]=CreateDynamicObject(Item[Bomb[index][_ItemID]][_WeaponID],BoomX,BoomY,Bomb[index][_Pos][2],0.0,0.0,0.0,Bomb[index][_World],Bomb[index][_Interior],-1,Item[Bomb[index][_ItemID]][_ExplosionSize]*5.0);
		}
		UpdateStreamer(Bomb[index][_Pos][0],Bomb[index][_Pos][1],Bomb[index][_Pos][2],Bomb[index][_World],Bomb[index][_Interior]);
		new Float:health;
		foreach(new i:Player)
		{
		    if(RealPlayer(i))
		    {
			    PlayerPlaySound(i,1159,Bomb[index][_Pos][0],Bomb[index][_Pos][1],Bomb[index][_Pos][2]);
				if(IsPlayerInDynamicArea(i,Bomb[index][_AreaID]))
				{
					if(!IsPlayerInAnyVehicle(i))
					{
					    new Float:px, Float:py, Float:pz;
						GetPlayerPos(i,px,py,pz);
					    new Float:percentage=floatdiv(GetDistanceBetweenPoints3D(px,py,pz,Bomb[index][_Pos][0],Bomb[index][_Pos][1],Bomb[index][_Pos][2]),Item[Bomb[index][_ItemID]][_ExplosionSize]);
					    if(percentage>1.0)percentage=1.0;
					    percentage=floatsub(1.0,percentage);
					    new Float:BuffEffect=floatmul(Item[Bomb[index][_ItemID]][_BuffEffect],percentage);
						if(BuffEffect>0.0)DamagePlayer(i,BuffEffect,INVALID_PLAYER_ID,51,3);
					}
				}
				//else CreateExplosionForPlayer(i,x,y,z,type,0.0);
			}
		}
	 	for(new i=1,j=GetVehiclePoolSize();i<=j;i++)
	    {
			if(GetVehicleVirtualWorld(i)==Bomb[index][_World])
			{
	 			new Float:px, Float:py, Float:pz;
				GetVehiclePos(i,px,py,pz);
	   			if(IsPointInDynamicArea(Bomb[index][_AreaID],px,py,pz))
			    {
				    new Float:percentage=floatdiv(GetDistanceBetweenPoints3D(px,py,pz,Bomb[index][_Pos][0],Bomb[index][_Pos][1],Bomb[index][_Pos][2]),Item[Bomb[index][_ItemID]][_ExplosionSize]);
				    if(percentage>1.0)percentage=1.0;
				    percentage=floatsub(1.0,percentage);
				    new Float:BuffEffect=floatmul(floatmul(Item[Bomb[index][_ItemID]][_BuffEffect],2.0),percentage);
					GetVehicleHealth(i,health);
					health-=BuffEffect;
					if(health<0.0)health=0.0;
					SetVehicleHealth(i,health);
					GobalVehicleHP[i]=health;
			    }
			}
	    }
		foreach(new i:Zombies)
	    {
	        if(Zombies[i][_zExecute]==false)continue;
	        if(Zombies[i][_zState]==ZOMBIE_STATE_DEATH)continue;
			if((FCNPC_GetInterior(Zombies[i][_zNpcid])==Bomb[index][_World])&&(FCNPC_GetVirtualWorld(Zombies[i][_zNpcid])==Bomb[index][_Interior]))
			{
		        new Float:px, Float:py, Float:pz;
		        FCNPC_GetPosition(Zombies[i][_zNpcid],px,py,pz);
		        if(IsPointInDynamicArea(Bomb[index][_AreaID],px,py,pz))
			    {
				    new Float:percentage=floatdiv(GetDistanceBetweenPoints3D(px,py,pz,Bomb[index][_Pos][0],Bomb[index][_Pos][1],Bomb[index][_Pos][2]),Item[Bomb[index][_ItemID]][_ExplosionSize]);
				    if(percentage>1.0)percentage=1.0;
				    percentage=floatsub(1.0,percentage);
				    new Float:BuffEffect=floatmul(floatmul(Item[Bomb[index][_ItemID]][_BuffEffect],0.7),percentage);
					Zombies[i][_zHp]-=BuffEffect;
					if(Zombies[i][_zHp]<0.0)Zombies[i][_zHp]=0.0;
					FCNPC_SetHealth(Zombies[i][_zNpcid],Zombies[i][_zHp]);
					SetProgressBar3DValue(Zombies[i][_zHpText],Zombies[i][_zHp]);
				}
			}
		}
		foreach(new i:CraftBulid)
	    {
			if(CraftBulid[i][_CraftWorld]==Bomb[index][_World])
			{
			    new Float:px=CraftBulid[i][_Cx],Float:py=CraftBulid[i][_Cy],Float:pz=CraftBulid[i][_Cz];
			    if(IsPointInDynamicArea(Bomb[index][_AreaID],px,py,pz))
			    {
					new Float:percentage=floatdiv(GetDistanceBetweenPoints3D(px,py,pz,Bomb[index][_Pos][0],Bomb[index][_Pos][1],Bomb[index][_Pos][2]),Item[Bomb[index][_ItemID]][_ExplosionSize]);
				    if(percentage>1.0)percentage=1.0;
				    percentage=floatsub(1.0,percentage);
				    new Float:BuffEffect=floatmul(floatmul(Item[Bomb[index][_ItemID]][_BuffEffect],0.5),percentage);
				    CraftBulid[i][_Chp]-=BuffEffect;
				    if(CraftBulid[i][_Chp]<=0.0)
					{
						DestoryCraftBulidModel(i);
						formatex128("DELETE FROM `"MYSQL_DB_CRAFTBULID"` WHERE `"MYSQL_DB_CRAFTBULID"`.`ÃÜ³×` ='%s'",CraftBulid[i][_Key]);
						mysql_query(Account@Handle,string128,false);
						new	cur = i;
	   					Iter_SafeRemove(CraftBulid,cur,i);
					}
				    else
				    {
				        if(IsValidDynamic3DTextLabel(CraftBulid[i][_C3dtext]))
				        {
							UpdateCraftBulidText(i);
						}
					}
			    }
			}
	    }
	    KillTimer(Bomb[index][Timer:_Explosion]);
	    Bomb[index][Timer:_Explosion]=NONE;
	    Bomb[index][Timer:_Explosion]=SetTimerEx("DestoryBomb",2000,false,"i",index);
   	}
   	else SetProgressBar3DValue(Bomb[index][_BombBar],Bomb[index][_Count]);
   	Bomb[index][_Count]++;
	return 1;
}
