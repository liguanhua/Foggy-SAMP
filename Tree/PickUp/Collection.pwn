
FUNC::Collect_OnShootDynamicObject(playerid, weaponid, STREAMER_TAG_OBJECT:objectid, Float:x, Float:y, Float:z)
{
/*  if(RealPlayer(playerid))
    {
		if(weaponid>=0&&weaponid<sizeof(s_WeaponDamage))
		{
		    new CollectID=GetCollectIDbyObject(objectid);
		    if(CollectID!=NONE)
			{
			    if(GetTickCount()-Collect[CollectID][_HitDalay]>=300)
			    {
	                Collect[CollectID][_HitDalay]=GetTickCount();
				    Collect[CollectID][_Hp]-=floatdiv(s_WeaponDamage[weaponid],3.0);
				    if(Collect[CollectID][_Hp]<=0.0)DestoryCollect(CollectID);
				    else UpdateCollectText(CollectID);
				}
				return true;
	    	}
		}
    }*/
    return false;
}
FUNC::GetCollectIDbyObject(objectid)
{
 	new ObjectIndex=GetDynamicObjectIndexByObjectID(objectid);
	if(ObjectIndex!=NONE)
	{
		foreach(new i:Collect)
		{
			if(Collect[i][_ObjectIndex]==ObjectIndex)return i;
		}
	}
	return NONE;
}
FUNC::CreateCollectData(type,model,Float:x,Float:y,Float:z,Float:rx,Float:ry,Float:rz,Float:chp,Float:mhp)
{
	if(Iter_Count(Collect)>=MAX_COLLECT)
	{
	    formatex80("-cct error0");
        Debug(-1,string80);
		return RETURN_ERROR;
    }
    new i=Iter_Free(Collect);
    UUID(Collect[i][_Key], UUID_LEN);
    Collect[i][_Model]=model;
    Collect[i][_Type]=type;
    Collect[i][_X]=x;
    Collect[i][_Y]=y;
    Collect[i][_Z]=z;
    Collect[i][_RX]=rx;
    Collect[i][_RY]=ry;
    Collect[i][_RZ]=rz;
    Collect[i][_Hp]=chp;
    Collect[i][_MaxHp]=mhp;
    Iter_Add(Collect,i);
 /*   formatex1024("INSERT INTO `"MYSQL_DB_COLLECT"`(`密匙`,`类型`,`模型`,`X坐标`,`Y坐标`,`Z坐标`,`RX坐标`,`RY坐标`,`RZ坐标`,`数量`) VALUES ('%s','%i','%i','%f','%f','%f','%f','%f','%f','%i')",\
	Collect[i][_Key],\
	type,\
	model,\
	x,\
	y,\
	z,\
	rx,\
	ry,\
	rz,\
	Amount
	);
   	mysql_query(Account@Handle,string1024,true);*/
    CreateCollectModel(i);
	return RETURN_SUCCESS;
}
FUNC::CreateCollectModel(index)
{
	Collect[index][_ObjectIndex]=CA_CreateDynamicObject_DC(Collect[index][_Model],Collect[index][_X],Collect[index][_Y],Collect[index][_Z]+0.5,Collect[index][_RX],Collect[index][_RY],Collect[index][_RZ],0,.streamdistance = 150.0,.drawdistance = 150.0);
    Collect[index][_AreaID]=CreateDynamicCylinder(Collect[index][_X],Collect[index][_Y],Collect[index][_Z]-2.0,Collect[index][_Z]+2.0,3.0,0);
    Collect[index][_HpText]=CreateProgressBar3D(Collect[index][_X],Collect[index][_Y],Collect[index][_Z]+0.4,BAR_3D_LAYOUT_THICK, 0x00FF80C8, 0x004040C8, Collect[index][_MaxHp], Collect[index][_Hp], 10.0, INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,-1,-1);
    formatex64("ID:%i",index);
    Collect[index][_3DtextID]=CreateDynamic3DTextLabel(string64, -1,Collect[index][_X],Collect[index][_Y],Collect[index][_Z]+0.8,10.0,.testlos = 0,.worldid = 0);
    Collect[index][_HitDalay]=GetTickCount();
    UpdateStreamer(Collect[index][_X],Collect[index][_Y],Collect[index][_Z],0);
	return 1;
}
FUNC::UpdateCollectText(index)
{
	if(!Iter_Contains(Collect,index))
	{
	    formatex80("%i-uct error0",NONE);
        Debug(NONE,string80);
		return RETURN_ERROR;
	}
    formatex64("ID:%i",index);
    UpdateDynamic3DTextLabelText(Collect[index][_3DtextID],-1,string64);
	SetProgressBar3DValue(Collect[index][_HpText],Collect[index][_Hp]);
	/*formatex128("UPDATE `"MYSQL_DB_COLLECT"` SET  `血量`='%f' WHERE  `"MYSQL_DB_COLLECT"`.`密匙` ='%s'",Collect[index][_Hp],Collect[index][_Key]);
	mysql_query(Account@Handle,string128,false);*/
	return 1;
}
FUNC::DestoryCollectModel(index)
{
	if(!Iter_Contains(Collect,index))
	{
	    formatex80("%i-dct error0",NONE);
        Debug(NONE,string80);
		return RETURN_ERROR;
	}
	CA_DestroyObject_DC(Collect[index][_ObjectIndex]);
	Collect[index][_ObjectIndex]=INVALID_STREAMER_ID;
	DestroyDynamicArea(Collect[index][_AreaID]);
	Collect[index][_AreaID]=INVALID_STREAMER_ID;
	DestroyProgressBar3D(Collect[index][_HpText]);
	Collect[index][_HpText]=INVALID_3D_BAR;
	DestroyDynamic3DTextLabel(Collect[index][_3DtextID]);
	Collect[index][_3DtextID]=Text3D:INVALID_STREAMER_ID;
	Iter_Remove(Collect,index);
	return RETURN_SUCCESS;
}
FUNC::DestoryCollect(index)
{
	if(!Iter_Contains(Collect,index))
	{
	    formatex80("%i-dct error0",NONE);
        Debug(NONE,string80);
		return RETURN_ERROR;
	}
	DestoryCollectModel(index);
	/*formatex128("DELETE FROM `"MYSQL_DB_COLLECT"` WHERE `"MYSQL_DB_COLLECT"`.`密匙`='%s'",Collect[index][_Key]);
	mysql_query(Account@Handle,string128,false);*/
	return RETURN_SUCCESS;
}
/*FUNC::LoadCollects()//读取拾取物
{
    RestCollects();
	formatex128("SELECT * FROM `"MYSQL_DB_COLLECT"`");
    mysql_tquery(Account@Handle,string128, "OnCollectsLoad");
	return 1;
}
FUNC::OnCollectsLoad()
{
    forex(i,cache_num_rows())
	{
	    if(i<MAX_COLLECT)
	    {
            cache_get_field_content(i,"密匙",Collect[i][_Key],Account@Handle,37);
     	    Collect[i][_Type]=cache_get_field_content_int(i,"类型",Account@Handle);
     	    Collect[i][_Model]=cache_get_field_content_int(i,"模型",Account@Handle);
			Collect[i][_X]=cache_get_field_content_float(i,"X坐标",Account@Handle);
			Collect[i][_Y]=cache_get_field_content_float(i,"Y坐标",Account@Handle);
			Collect[i][_Z]=cache_get_field_content_float(i,"Z坐标",Account@Handle);
			PickUp[i][_RX]=cache_get_field_content_float(i,"RX坐标",Account@Handle);
			Collect[i][_RY]=cache_get_field_content_float(i,"RY坐标",Account@Handle);
			Collect[i][_RZ]=cache_get_field_content_float(i,"RZ坐标",Account@Handle);
			Collect[i][_Hp]=cache_get_field_content_float(i,"血量",Account@Handle);
			Collect[i][_MaxHp]=cache_get_field_content_float(i,"最大血量",Account@Handle);
			Iter_Add(Collect,i);
			printf("收集物密匙-[%s]",Collect[i][_Key]);
		}
		else
		{
		    printf("收集物溢出");
			break;
		}
	}
	if(Iter_Count(Collect)>0)
	{
	    foreach(new i:Collect)CreateCollectModel(i);
	}
	return 1;
}
FUNC::RestCollects()
{
   	Iter_Clear(Collect);
	return 1;
}*/
CMD:co(playerid, params[])
{
	new ownerkey,Float:chp,Float:mhp;
    sscanf(params, "iff",ownerkey,chp,mhp);
    new Float:InFrontPlayerPos[3];
    GetRandomXYInFrontOfPlayer(playerid,InFrontPlayerPos[0],InFrontPlayerPos[1],5.0);
    CA_FindZ_For2DCoord(InFrontPlayerPos[0],InFrontPlayerPos[1],InFrontPlayerPos[2]);
    CreateCollectData(0,ownerkey,InFrontPlayerPos[0],InFrontPlayerPos[1],InFrontPlayerPos[2],0.0,0.0,0.0,chp,mhp);
	return 1;
}
CMD:cod(playerid, params[])
{
	new ownerkey;
    sscanf(params, "i",ownerkey);
    DestoryCollect(ownerkey);
	return 1;
}
FUNC::GetNearstCollect(playerid)
{
    if(Iter_Count(Collect)<=0)return NONE;
	new Float:dis,Float:dis2,index;
	index=NONE;
	dis=99999.99;
	foreach(new i:Collect)
	{
		if(IsPlayerInDynamicArea(playerid,Collect[i][_AreaID]))
		{
			new Float:x1, Float:y1, Float:z1;
			GetPlayerPos(playerid, x1, y1, z1);
			dis2 = floatsqroot(floatpower(floatabs(floatsub(Collect[i][_X],x1)),2)+floatpower(floatabs(floatsub(Collect[i][_Y],y1)),2)+floatpower(floatabs(floatsub(Collect[i][_Z],z1)),2));
			if(dis2<dis&&dis2 != -1.00)
			{
				dis=dis2;
				index=i;
			}
		}
	}
	return index;
}
FUNC::Collect_OnPlayerKeyStateChange(playerid,newkeys,oldkeys)
{
	if(PRESSED(KEY_FIRE))
	{
    	if(GetTickCount()-PlayerCollect[playerid][_Dalay]>810)
    	{
			new index=GetNearstCollect(playerid);
			if(index!=NONE)
			{
				PlayerCollectIng(playerid,index);
				return true;
			}
		}
	}
	return false;
}
FUNC::PlayerCollectIng(playerid,index)
{
	if(!Iter_Contains(Collect,index))return SCM(playerid,-1,"该采集点已失效!");
    if(GetPlayerState(playerid)!=PLAYER_STATE_ONFOOT)return SCM(playerid,-1,"只能在不行下采集!");
    if(!IsPlayerInDynamicArea(playerid,Collect[index][_AreaID])) return SCM(playerid,-1,"你没有在采集点附近!");
	SetPlayerArmedWeapon(playerid,0);
	PlayerCollect[playerid][_Dalay]=GetTickCount();
	Collect[index][_Hp]-=10.0;
	if(Collect[index][_Hp]<=0.0)
	{
		new Float:RandPos[3];
		RandPos[0]=Collect[index][_X];
		RandPos[1]=Collect[index][_Y];
		RandPos[2]=Collect[index][_Z];
		if(DestoryCollect(index)==RETURN_SUCCESS)
		{
		    switch(Collect[index][_Type])
		    {
		        case COLLECT_TREE:
				{
					GetAngleDistancePoint(0.0,1.5,RandPos[0],RandPos[1]);
					CA_FindZ_For2DCoord(RandPos[0],RandPos[1],RandPos[2]);
					CreatePickUpData("A008_000",3,0.0,RandPos[0],RandPos[1],RandPos[2],0.0,0.0,0.0,0,0,0);
					GetAngleDistancePoint(180.0,1.5,RandPos[0],RandPos[1]);
					CA_FindZ_For2DCoord(RandPos[0],RandPos[1],RandPos[2]);
					CreatePickUpData("A008_001",1,0.0,RandPos[0],RandPos[1],RandPos[2],0.0,0.0,0.0,0,0,0);
				}
		        case COLLECT_STONE:
				{
					GetAngleDistancePoint(0.0,1.5,RandPos[0],RandPos[1]);
					CA_FindZ_For2DCoord(RandPos[0],RandPos[1],RandPos[2]);
					CreatePickUpData("A008_003",3,0.0,RandPos[0],RandPos[1],RandPos[2],0.0,0.0,0.0,0,0,0);
					GetAngleDistancePoint(180.0,1.5,RandPos[0],RandPos[1]);
					CA_FindZ_For2DCoord(RandPos[0],RandPos[1],RandPos[2]);
					CreatePickUpData("A008_002",1,0.0,RandPos[0],RandPos[1],RandPos[2],0.0,0.0,0.0,0,0,0);
		    	}
            }
		}
  	}
	else
	{
		UpdateCollectText(index);
		ApplyAnimation(playerid,"BASEBALL","BAT_1",4.1,0,0,0,0,0,1);
		PlayerPlaySound(playerid, 1190, 0.0, 0.0, 0.0);
		TurnPlayerFaceToPos(playerid,Collect[index][_X],Collect[index][_Y],Collect[index][_Z]);
	}
	return 1;
}
