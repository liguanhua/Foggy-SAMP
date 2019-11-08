FUNC::Domain_OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA:areaid)
{
	if(RealPlayer(playerid))
	{
	    if(GetPlayerState(playerid)==PLAYER_STATE_ONFOOT)
	    {
		   	foreach(new i:PrivateDomain)
			{
			    if(areaid==PrivateDomain[i][_In_Area])
			    {
					SetPlayerVirtualWorld(playerid,0);
					SetPlayerWeather(playerid, 0);
				    SetPlayerTime(playerid,5,0);
			    }
			}
		}
	}
	return false;
}
FUNC::Domain_OnPlayerPickDynamicPick(playerid, STREAMER_TAG_PICKUP:pickupid)
{
	if(RealPlayer(playerid))
	{
	    if(GetPlayerState(playerid)==PLAYER_STATE_ONFOOT)
	    {
			foreach(new i:PrivateDomain)
			{
				if(PrivateDomain[i][_Out_Cp]==pickupid)
				{
			        SetPlayerVirtualWorld(playerid,PRIVATEDOMAIN_LIMIT+PrivateDomain[i][_Index]);
					return true;
				}
			}
		}
	}
	return false;
}
FUNC::GetPlayerInDomainState(playerid)
{
	new VWorld=GetPlayerVirtualWorld(playerid);
	if(VWorld==0)
	{
		new factionid=GetPlayerInFactionAreaID(playerid);
		if(factionid!=NONE)
		{
		    if(isequal(PrivateDomain[factionid][_OwnerKey],Account[playerid][_Key],false))return PLAYER_DOMAIN_FACTION_ALLOW;
			if(PlayerFaction[playerid][_FactionID]==factionid)
	        {
	            if(PlayerFaction[playerid][_AuthorCraft]==1)return PLAYER_DOMAIN_FACTION_ALLOW;
	            else return PLAYER_DOMAIN_FACTION_OTHER;
	        }
		    if(GetPlayerAdminLevelByKey(Account[playerid][_Key])>=5)return PLAYER_DOMAIN_FACTION_ALLOW;
	        return PLAYER_DOMAIN_FACTION_FORBID;
		}
	}
	else
	{
		if(VWorld<PRIVATEDOMAIN_LIMIT)return PLAYER_DOMAIN_NONE;
		if(VWorld>PRIVATEDOMAIN_LIMIT+MAX_PRIVATEDOMAIN)return PLAYER_DOMAIN_NONE;
		new index=GetPrivateDomainIDbyIndexKey(VWorld-PRIVATEDOMAIN_LIMIT);
		if(index==NONE)return PLAYER_DOMAIN_NONE;
		if(isequal(PrivateDomain[index][_OwnerKey],Account[playerid][_Key],false))return PLAYER_DOMAIN_OWNER;
		if(GetPlayerAdminLevelByKey(Account[playerid][_Key])>=5)return PLAYER_DOMAIN_OWNER;
		return PLAYER_DOMAIN_OTHER;
	}
	return PLAYER_DOMAIN_NONE;
}
FUNC::GetPrivateDomainIDbyIndexKey(IndexKey)
{
	foreach(new i:PrivateDomain)
	{
	    if(PrivateDomain[i][_Index]==IndexKey)return i;
	}
	return NONE;
}
FUNC::GetPlayerHavePrivateDomainID(playerid)
{
	foreach(new i:PrivateDomain)
	{
	    if(isequal(PrivateDomain[i][_OwnerKey],Account[playerid][_Key],false))return i;
	}
	return NONE;
}
FUNC::CreatePrivateDomainData(playerid,Name[],Float:x,Float:y,Float:z)
{
	if(Iter_Count(PrivateDomain)>=MAX_PRIVATEDOMAIN)
	{
	    formatex80("-cpdd error0");
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
    if(GetPlayerHavePrivateDomainID(playerid)!=NONE)
    {
	    formatex80("-cpdd error1");
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
    new i=Iter_Free(PrivateDomain);
    format(PrivateDomain[i][_OwnerKey],UUID_LEN,Account[playerid][_Key]);
    UUID(PrivateDomain[i][_Key], UUID_LEN);
    format(PrivateDomain[i][_Name],24,Name);
    PrivateDomain[i][_OutX]=x;
    PrivateDomain[i][_OutY]=y;
    PrivateDomain[i][_OutZ]=z;
    PrivateDomain[i][_Level]=0;
    PrivateDomain[i][_Weather]=0;
    PrivateDomain[i][_Time]=12;
    PrivateDomain[i][_ProtectTime]=0;

    Iter_Add(PrivateDomain,i);
    formatex512("INSERT INTO `"MYSQL_DB_DOMAIN"`(`密匙`,`创建者密匙`,`名称`,`出口X`,`出口Y`,`出口Z`) VALUES ('%s','%s','%s','%f','%f','%f')",PrivateDomain[i][_Key],PrivateDomain[i][_OwnerKey],PrivateDomain[i][_Name],PrivateDomain[i][_OutX],PrivateDomain[i][_OutY],PrivateDomain[i][_OutZ]);
   	mysql_query(Account@Handle,string512,true);
   	PrivateDomain[i][_Index]=cache_insert_id();
   	
   	CreatePrivateDomainModel(i);
	return RETURN_SUCCESS;
}
FUNC::DestoryPrivateDomain(index)
{
	DestroyDynamicPickup(PrivateDomain[index][_Out_Cp]);
	DestroyDynamic3DTextLabel(PrivateDomain[index][_Out_3Dtext]);
	DestroyDynamicArea(PrivateDomain[index][_Out_Area]);
	DestroyDynamic3DTextLabel(PrivateDomain[index][_In_3Dtext]);
	DestroyDynamicArea(PrivateDomain[index][_In_Area]);
	PrivateDomain[index][_Out_Cp]=INVALID_STREAMER_ID;
	PrivateDomain[index][_Out_3Dtext]=Text3D:INVALID_STREAMER_ID;
	PrivateDomain[index][_Out_Area]=INVALID_STREAMER_ID;
	PrivateDomain[index][_In_3Dtext]=Text3D:INVALID_STREAMER_ID;
	PrivateDomain[index][_In_Area]=INVALID_STREAMER_ID;
    forex(i,MAX_WALL)
    {
    	DestroyDynamicObject(PrivateDomain[index][Wall0][i]);
    	DestroyDynamicObject(PrivateDomain[index][Wall1][i]);
    	DestroyDynamicObject(PrivateDomain[index][Wall2][i]);
    	DestroyDynamicObject(PrivateDomain[index][Wall3][i]);
        PrivateDomain[index][Wall0][i]=INVALID_STREAMER_ID;
        PrivateDomain[index][Wall1][i]=INVALID_STREAMER_ID;
        PrivateDomain[index][Wall2][i]=INVALID_STREAMER_ID;
        PrivateDomain[index][Wall3][i]=INVALID_STREAMER_ID;
    }
	formatex128("DELETE FROM `"MYSQL_DB_DOMAIN"` WHERE `"MYSQL_DB_DOMAIN"`.`密匙`='%s'",PrivateDomain[index][_Key]);
	mysql_query(Account@Handle,string128,false);
	Iter_Remove(PrivateDomain,index);
	return 1;
}
FUNC::CreatePrivateDomainModel(index)
{
    PrivateDomain[index][_Out_Cp]=CreateDynamicPickup(1277,1,PrivateDomain[index][_OutX],PrivateDomain[index][_OutY],PrivateDomain[index][_OutZ]-0.5,0,-1,-1,20.0);
	formatex64("%s 的领地\nID:%i",GetPlayerMySqlNameFromKey(PrivateDomain[index][_OwnerKey]),index);
    PrivateDomain[index][_Out_3Dtext]=CreateDynamic3DTextLabel(string64, -1,PrivateDomain[index][_OutX],PrivateDomain[index][_OutY],PrivateDomain[index][_OutZ]-0.5,20.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,-1,-1,20.0);
    PrivateDomain[index][_Out_Area]=CreateDynamicCylinder(PrivateDomain[index][_OutX],PrivateDomain[index][_OutY],PrivateDomain[index][_OutZ]-2.0,PrivateDomain[index][_OutZ]+2.0,3.0,0,-1,-1,0);
	UpdateStreamer(PrivateDomain[index][_OutX],PrivateDomain[index][_OutY],PrivateDomain[index][_OutZ],0);

	formatex64("%s 的领地\nID:%i",GetPlayerMySqlNameFromKey(PrivateDomain[index][_OwnerKey]),index);
    PrivateDomain[index][_In_3Dtext]=CreateDynamic3DTextLabel(string64, -1,PrivateDomain[index][_OutX],PrivateDomain[index][_OutY],PrivateDomain[index][_OutZ],20.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,PRIVATEDOMAIN_LIMIT+PrivateDomain[index][_Index],-1,-1,20.0);
    PrivateDomain[index][_In_Area]=CreateDynamicRectangle(PrivateDomain[index][_OutX]-30.0,PrivateDomain[index][_OutY]-30.0,PrivateDomain[index][_OutX]+30.0,PrivateDomain[index][_OutY]+50.0,PRIVATEDOMAIN_LIMIT+PrivateDomain[index][_Index]);
    CreatePrivateDomainWall(index,10444,PrivateDomain[index][_OutX]-30.0,PrivateDomain[index][_OutY]-30.0,PrivateDomain[index][_OutX]+30.0,PrivateDomain[index][_OutY]+30.0,PrivateDomain[index][_OutZ]);
	UpdateStreamer(PrivateDomain[index][_OutX],PrivateDomain[index][_OutY],PrivateDomain[index][_OutZ],0);
	return RETURN_SUCCESS;
}
FUNC::LoadPrivateDomains()//读取私人领地
{
    RestPrivateDomains();
	formatex128("SELECT * FROM `"MYSQL_DB_DOMAIN"`");
    mysql_tquery(Account@Handle,string128, "OnPrivateDomainsLoad");
	return 1;
}
FUNC::OnPrivateDomainsLoad()
{
	forex(i,MAX_PRIVATEDOMAIN)
	{
	    forex(s,MAX_WALL)
	    {
	        PrivateDomain[i][Wall0][s]=INVALID_STREAMER_ID;
	        PrivateDomain[i][Wall1][s]=INVALID_STREAMER_ID;
	        PrivateDomain[i][Wall2][s]=INVALID_STREAMER_ID;
	        PrivateDomain[i][Wall3][s]=INVALID_STREAMER_ID;
	    }
	}
    forex(i,cache_num_rows())
	{
	    if(i<MAX_FACTIONS)
	    {
	        PrivateDomain[i][_Index]=cache_get_field_content_int(i,"编号",Account@Handle);
            cache_get_field_content(i,"密匙",PrivateDomain[i][_Key],Account@Handle,37);
            cache_get_field_content(i,"创建者密匙",PrivateDomain[i][_OwnerKey],Account@Handle,37);
            cache_get_field_content(i,"名称",PrivateDomain[i][_Name],Account@Handle,24);
           	PrivateDomain[i][_OutX]=cache_get_field_content_float(i,"出口X",Account@Handle);
    		PrivateDomain[i][_OutY]=cache_get_field_content_float(i,"出口Y",Account@Handle);
   			PrivateDomain[i][_OutZ]=cache_get_field_content_float(i,"出口Z",Account@Handle);
    		PrivateDomain[i][_Level]=cache_get_field_content_int(i,"等级",Account@Handle);
    		PrivateDomain[i][_Weather]=cache_get_field_content_int(i,"天气",Account@Handle);
    		PrivateDomain[i][_Time]=cache_get_field_content_int(i,"时间",Account@Handle);
    		PrivateDomain[i][_ProtectTime]=cache_get_field_content_int(i,"保护时间",Account@Handle);
    		Iter_Add(PrivateDomain,i);
			printf("私人领地-[%s][%s]",PrivateDomain[i][_Key],PrivateDomain[i][_Name]);
		}
		else
		{
		    printf("私人领地");
			break;
		}
	}
	if(Iter_Count(PrivateDomain)>0)
	{
	    foreach(new i:PrivateDomain)CreatePrivateDomainModel(i);
	}
	return 1;
}
FUNC::RestPrivateDomains()
{
   	Iter_Clear(PrivateDomain);
	return 1;
}

FUNC::CreatePrivateDomainWall(index,model,Float:minX,Float:minY,Float:maxX,Float:maxY,Float:posZ)
{
	new pointdistance[4];
	pointdistance[0]=floatround(GetDistanceBetweenPoints2D(minX,minY,minX,maxY));
	pointdistance[1]=floatround(GetDistanceBetweenPoints2D(minX,minY,maxX,minY));
	pointdistance[2]=floatround(GetDistanceBetweenPoints2D(maxX,minY,maxX,maxY));
	pointdistance[3]=floatround(GetDistanceBetweenPoints2D(maxX,maxY,minX,maxY));
	new amouts[4];
	amouts[0]=floatround(pointdistance[0]/12.5,floatround_ceil);
	amouts[1]=floatround(pointdistance[1]/12.5,floatround_ceil);
	amouts[2]=floatround(pointdistance[2]/12.5,floatround_ceil);
	amouts[3]=floatround(pointdistance[3]/12.5,floatround_ceil);
	if(amouts[0]>=MAX_WALL||amouts[1]>=MAX_WALL||amouts[2]>=MAX_WALL||amouts[3]>=MAX_WALL)return 0;
	new Rates=0;
	for(new i=0;i<=amouts[0];i++)
	{
	    forex(s,10)
	    {
	        if(Rates<MAX_WALL)
	        {
				PrivateDomain[index][Wall0][Rates]=CreateDynamicObject(model,minX,minY+(((maxY-minY)/amouts[0])*i),posZ-10.0+(s*9.5),90.0000,90.0000,0.0000,PRIVATEDOMAIN_LIMIT+PrivateDomain[index][_Index],0,-1,200.0,200.0);
		        //SetDynamicObjectMaterialText(PrivateDomain[index][Wall0][i],0, "fsdged",  OBJECT_MATERIAL_SIZE_512x512,"Arial",200, 1, 0xFFFFFFFF, 0, 1);
		        //SetDynamicObjectMaterialText(STREAMER_TAG_OBJECT:objectid, materialindex, const text[], materialsize = OBJECT_MATERIAL_SIZE_256x128, const fontface[] = "Arial", fontsize = 24, bold = 1, fontcolor = 0xFFFFFFFF, backcolor = 0, textalignment = 0);
				//SetDynamicObjectMaterial(PrivateDomain[index][Wall0][Rates],0,19604,"ballyswater","waterclear256");
				Rates++;
			}
		}
	}
	Rates=0;
	for(new i=0;i<=amouts[1];i++)
	{
	    forex(s,10)
	    {
	        if(Rates<MAX_WALL)
	        {
				PrivateDomain[index][Wall1][Rates]=CreateDynamicObject(model,minX+(((maxX-minX)/amouts[1])*i),minY,posZ-10.0+(s*9.5),90.0000,180.0000,0.0000,PRIVATEDOMAIN_LIMIT+PrivateDomain[index][_Index],0,-1,200.0,200.0);
	        	//SetDynamicObjectMaterialText(PrivateDomain[index][Wall1][i],0, "fsdged",  OBJECT_MATERIAL_SIZE_512x512,"Arial",200, 1, 0xFFFFFFFF, 0, 1);
				//SetDynamicObjectMaterial(PrivateDomain[index][Wall1][Rates],0,19604,"ballyswater","waterclear256");
                Rates++;
			}
		}
    }
    Rates=0;
	for(new i=0;i<=amouts[2];i++)
	{
	    forex(s,10)
	    {
	        if(Rates<MAX_WALL)
	        {
				PrivateDomain[index][Wall2][Rates]=CreateDynamicObject(model,maxX,minY+(((maxY-minY)/amouts[2])*i),posZ-10.0+(s*9.5),90.0000,270.0000,0.0000,PRIVATEDOMAIN_LIMIT+PrivateDomain[index][_Index],0,-1,200.0,200.0);
		        //SetDynamicObjectMaterialText(PrivateDomain[index][Wall2][i], 0,"fsdged",  OBJECT_MATERIAL_SIZE_512x512,"Arial",200, 1, 0xFFFFFFFF, 0, 1);
				//SetDynamicObjectMaterial(PrivateDomain[index][Wall2][Rates],0,19604,"ballyswater","waterclear256");
	            Rates++;
			}
		}
    }
    Rates=0;
	for(new i=0;i<=amouts[3];i++)
	{
	    forex(s,10)
	    {
	        if(Rates<MAX_WALL)
	        {
				PrivateDomain[index][Wall3][Rates]=CreateDynamicObject(model,maxX-(((maxX-minX)/amouts[3])*i),maxY,posZ-10.0+(s*9.5),90.0000,360.0000,0.0000,PRIVATEDOMAIN_LIMIT+PrivateDomain[index][_Index],0,-1,200.0,200.0);
				//SetDynamicObjectMaterialText(PrivateDomain[index][Wall3][i], 0,"fsdged",  OBJECT_MATERIAL_SIZE_512x512,"Arial",200, 1, 0xFFFFFFFF, 0, 1);
				//SetDynamicObjectMaterial(PrivateDomain[index][Wall3][Rates],0,19604,"ballyswater","waterclear256");
	            Rates++;
            }
		}
	}
	return 1;
}
