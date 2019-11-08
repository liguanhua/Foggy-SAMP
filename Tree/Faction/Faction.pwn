FUNC::IsPlayerInFactionArea(playerid)
{
	foreach(new i:Faction)
	{
		if(IsPlayerInDynamicArea(playerid,Faction[i][_Areaid]))return 1;
	}
	return 0;
}
FUNC::GetPlayerInFactionAreaID(playerid)
{
	foreach(new i:Faction)
	{
		if(IsPlayerInDynamicArea(playerid,Faction[i][_Areaid]))return i;
	}
	return NONE;
}
FUNC::IsPosInFactionArea(Float:xx,Float:yy,Float:zz)
{
	foreach(new i:Faction)if(IsPointInDynamicArea(Faction[i][_Areaid], xx, yy, zz))return 1;
	return 0;
}
FUNC::GetPlayerFactionID(playerid)
{
	if(strlen(PlayerFaction[playerid][_FactionKey])<1)return NONE;
	foreach(new i:Faction)
	{
		if(isequal(Faction[i][_Key],PlayerFaction[playerid][_FactionKey],false))return i;
	}
	return NONE;
}
FUNC::IsWirelessChannelKeySame(ChannelKey[])
{
	foreach(new i:Faction)
	{
		if(isequal(Faction[i][_Wireless],ChannelKey,false))return 1;
	}
	return 0;
}
FUNC::GetWirelessChannelKeyID(ChannelKey[])
{
	foreach(new i:Faction)
	{
		if(isequal(Faction[i][_Wireless],ChannelKey,false))return i;
	}
	return NONE;
}
stock GenerateWirelessChannelKey()
{
    new ChannelKey[8];
    format(ChannelKey,8,"%i%i%i.%i%i%i",random(10),random(10),random(10),random(10),random(10),random(10));
   	while(IsWirelessChannelKeySame(ChannelKey)==1)format(ChannelKey,8,"%i%i%i.%i%i%i",random(10),random(10),random(10),random(10),random(10),random(10));
	return ChannelKey;
}
FUNC::CreateFactionData(playerid,FactionName[])
{
	if(Iter_Count(Faction)>=MAX_FACTIONS)
	{
	    formatex80("%i-cfd error0",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
    new i=Iter_Free(Faction);
    format(Faction[i][_OwnerKey],UUID_LEN,Account[playerid][_Key]);
    UUID(Faction[i][_Key], UUID_LEN);
    format(Faction[i][_Name],24,toUpperCase(FactionName));
    format(Faction[i][_Wireless],8,GenerateWirelessChannelKey());
    Faction[i][_Level]=0;
    Faction[i][_WirelessOpen]=1;
    GetPlayerPos(playerid,Faction[i][_x],Faction[i][_y],Faction[i][_z]);
	if(IsFactionCover(i,Faction[i][_x],Faction[i][_y],Faction[i][_z]))
	{
	    SCM(playerid,-1,"该位置不可用![可能覆盖他人地盘]");
	    formatex80("%i-cfd error1",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
	}

    format(FactionRank[i][0][_RankName],24,"新兵");
    format(FactionRank[i][1][_RankName],24,"护卫");
    format(FactionRank[i][2][_RankName],24,"长官");
    format(FactionRank[i][3][_RankName],24,"指挥");
    format(FactionRank[i][4][_RankName],24,"城主");

    Iter_Add(Faction,i);
    formatex512("INSERT INTO `"MYSQL_DB_FACTION"`(`密匙`,`创建者密匙`,`名称`,`等级`,`无线电频段`,`X坐标`,`Y坐标`,`Z坐标`) VALUES ('%s','%s','%s','%i','%s','%f','%f','%f')",Faction[i][_Key],Faction[i][_OwnerKey],Faction[i][_Name],Faction[i][_Level],Faction[i][_Wireless],Faction[i][_x],Faction[i][_y],Faction[i][_z]);
   	mysql_query(Account@Handle,string512,true);

    SetPlayerToFaction(playerid,Faction[i][_Key],i,4,1);
	
   	CreateFactionModel(i);
	return RETURN_SUCCESS;
}
FUNC::RestPlayerFaction(playerid)
{
    format(PlayerFaction[playerid][_FactionKey],37,"null");
    PlayerFaction[playerid][_Rank]=0;
    PlayerFaction[playerid][_AuthorCraft]=0;
    PlayerFaction[playerid][_FactionID]=NONE;
	formatex512("UPDATE `"MYSQL_DB_ACCOUNT"` SET  `阵营密匙`='%s',`阵营阶级`='%i',`阵营建筑许可`='%i' WHERE  `"MYSQL_DB_ACCOUNT"`.`密匙` ='%s'",PlayerFaction[playerid][_FactionKey],PlayerFaction[playerid][_Rank],PlayerFaction[playerid][_AuthorCraft],Account[playerid][_Key]);
	mysql_query(Account@Handle,string512,false);
	return 1;
}
FUNC::SetPlayerToFaction(playerid,FactionKey[],index,Rank,AuthorCraft)
{
    format(PlayerFaction[playerid][_FactionKey],37,FactionKey);
    PlayerFaction[playerid][_Rank]=Rank;
    PlayerFaction[playerid][_AuthorCraft]=AuthorCraft;
    PlayerFaction[playerid][_FactionID]=index;
	formatex512("UPDATE `"MYSQL_DB_ACCOUNT"` SET  `阵营密匙`='%s',`阵营阶级`='%i',`阵营建筑许可`='%i' WHERE  `"MYSQL_DB_ACCOUNT"`.`密匙` ='%s'",PlayerFaction[playerid][_FactionKey],PlayerFaction[playerid][_Rank],PlayerFaction[playerid][_AuthorCraft],Account[playerid][_Key]);
	mysql_query(Account@Handle,string512,false);
	return 1;
}
stock GetFactionFromKey(Key[])
{
	formatex128("SELECT `名称` FROM `"MYSQL_DB_FACTION"` WHERE `密匙` = '%s' LIMIT 1",Key);
	mysql_query(Account@Handle,string128);
    new FactionName[24];
	if(cache_get_row_count(Account@Handle)==1)cache_get_field_content(0,"名称",FactionName,Account@Handle,24);
	else format(FactionName,24,"null");
	return FactionName;
}
stock GetFactionIDKey(Key[])
{
	new index=NONE;
	foreach(new i:Faction)
	{
		if(isequal(Faction[i][_Key],Key,false))index=i;
	}
	return index;
}
FUNC::IsFactionCover(index,Float:x,Float:y,Float:z)
{
	foreach(new i:Faction)
	{
    	if(IsLineInDynamicArea(Faction[i][_Areaid],x-50*(Faction[index][_Level]+1),y-50*(Faction[index][_Level]+1),z,x+50*(Faction[index][_Level]+1),y+50*(Faction[index][_Level]+1),z))return 1;
    	if(IsLineInDynamicArea(Faction[i][_Areaid],x-50*(Faction[index][_Level]+1),y-50*(Faction[index][_Level]+1),z,x-50*(Faction[index][_Level]+1),y+50*(Faction[index][_Level]+1),z))return 1;
    	if(IsLineInDynamicArea(Faction[i][_Areaid],x-50*(Faction[index][_Level]+1),y-50*(Faction[index][_Level]+1),z,x+50*(Faction[index][_Level]+1),y-50*(Faction[index][_Level]+1),z))return 1;
    	if(IsLineInDynamicArea(Faction[i][_Areaid],x-50*(Faction[index][_Level]+1),y+50*(Faction[index][_Level]+1),z,x+50*(Faction[index][_Level]+1),y+50*(Faction[index][_Level]+1),z))return 1;
    	if(IsLineInDynamicArea(Faction[i][_Areaid],x-50*(Faction[index][_Level]+1),y+50*(Faction[index][_Level]+1),z,x+50*(Faction[index][_Level]+1),y-50*(Faction[index][_Level]+1),z))return 1;
    	if(IsLineInDynamicArea(Faction[i][_Areaid],x+50*(Faction[index][_Level]+1),y+50*(Faction[index][_Level]+1),z,x+50*(Faction[index][_Level]+1),y-50*(Faction[index][_Level]+1),z))return 1;
	}
	return 0;
}
FUNC::CreateFactionModel(index)
{
    Faction[index][_Zoneid]=CreateZone(Faction[index][_x]-50*(Faction[index][_Level]+1),Faction[index][_y]-50*(Faction[index][_Level]+1),Faction[index][_x]+50*(Faction[index][_Level]+1),Faction[index][_y]+50*(Faction[index][_Level]+1));
    CreateZoneNumber(Faction[index][_Zoneid],index);
    CreateZoneBorders(Faction[index][_Zoneid]);
    Faction[index][_Areaid]=CreateDynamicRectangle(Faction[index][_x]-50*(Faction[index][_Level]+1),Faction[index][_y]-50*(Faction[index][_Level]+1),Faction[index][_x]+50*(Faction[index][_Level]+1),Faction[index][_y]+50*(Faction[index][_Level]+1));
    Faction[index][_WirelessAreaid]=CreateDynamicCircle(Faction[index][_x],Faction[index][_y],1000.0*(Faction[index][_Level]+1),0);
	CreateDynamicRectangle(Faction[index][_x]-50*(Faction[index][_Level]+1),Faction[index][_y]-50*(Faction[index][_Level]+1),Faction[index][_x]+50*(Faction[index][_Level]+1),Faction[index][_y]+50*(Faction[index][_Level]+1));

	new Float:FindZ;
    CA_FindZ_For2DCoord(Faction[index][_x],Faction[index][_y],FindZ);
    formatex80("阵营ID:%i\n%s",index,Faction[index][_Name]);
    Faction[index][_3Dtext]=CreateDynamic3DTextLabel(string80, -1,Faction[index][_x],Faction[index][_y],FindZ,50.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0,-1,-1,50.0);
    Faction[index][_WirelessDC]=CA_CreateDynamicObject_DC(3763,Faction[index][_x],Faction[index][_y],FindZ+33.029922,0.0,0.0,0.0,0,-1,-1,500.0,500.0);
//	CreateFactionsWall(index,10444,Faction[index][_x]-50*(Faction[index][_Level]+1),Faction[index][_y]-50*(Faction[index][_Level]+1),Faction[index][_x]+50*(Faction[index][_Level]+1),Faction[index][_y]+50*(Faction[index][_Level]+1),Faction[index][_z]);
	ClearFactionAreaIDObjs(index);
	ShowFactionZoneForAll(index);
	UpdateStreamer(Faction[index][_x],Faction[index][_y],Faction[index][_z],0);
	return RETURN_SUCCESS;
}
FUNC::DestoryFactionModel(index)
{
	if(!Iter_Contains(Faction,index))
	{
	    formatex80("%i-dfm error0",NONE);
        Debug(NONE,string80);
		return RETURN_ERROR;
	}
	foreach(new i:Player)
	{
	    if(RealPlayer(i))
	    {
	        foreach(new s:PlayerWireless[i])
	        {
	    		if(isequal(Faction[index][_Wireless],PlayerWireless[i][s][_WirelessChannel],false))
	    		{
	    		    new	cur = s;
					Iter_SafeRemove(PlayerWireless[i],cur,s);
	    		}
    		}
		}
	}
	formatex128("DELETE FROM `"MYSQL_DB_PLAYERWIRELESS"` WHERE `"MYSQL_DB_PLAYERWIRELESS"`.`无线电频段` ='%s'",Faction[index][_Wireless]);
	mysql_query(Account@Handle,string128,false);
	
	DestroyZone(Faction[index][_Zoneid]);
	Faction[index][_Zoneid]=INVALID_GANG_ZONE;
	DestroyDynamicArea(Faction[index][_WirelessAreaid]);
	Faction[index][_WirelessAreaid]=INVALID_STREAMER_ID;
	DestroyDynamicArea(Faction[index][_Areaid]);
	Faction[index][_Areaid]=INVALID_STREAMER_ID;
	CA_DestroyObject_DC(Faction[index][_WirelessDC]);
	Faction[index][_WirelessDC]=INVALID_STREAMER_ID;
	DestroyDynamic3DTextLabel(Faction[index][_3Dtext]);
	Faction[index][_3Dtext]=Text3D:INVALID_STREAMER_ID;
/*    forex(i,MAX_WALL)
    {
    	DestroyDynamicObject(Faction[index][Wall0][i]);
    	DestroyDynamicObject(Faction[index][Wall1][i]);
    	DestroyDynamicObject(Faction[index][Wall2][i]);
    	DestroyDynamicObject(Faction[index][Wall3][i]);
        Faction[index][Wall0][i]=INVALID_STREAMER_ID;
        Faction[index][Wall1][i]=INVALID_STREAMER_ID;
        Faction[index][Wall2][i]=INVALID_STREAMER_ID;
        Faction[index][Wall3][i]=INVALID_STREAMER_ID;
    }*/
	return 1;
}
FUNC::DestoryFaction(index)
{
	if(!Iter_Contains(Faction,index))
	{
	    formatex80("%i-df error0",NONE);
        Debug(NONE,string80);
		return RETURN_ERROR;
	}
	RestFactionAreaIDObjs(index);
	DestoryFactionModel(index);

	foreach(new i:Player)
	{
	    if(RealPlayer(i))
	    {
	        if(isequal(PlayerFaction[i][_FactionKey],Faction[index][_Key],false))
	        {
		        format(PlayerFaction[i][_FactionKey],37,"");
		        PlayerFaction[i][_Rank]=0;
		        PlayerFaction[i][_AuthorCraft]=0;
		        PlayerFaction[i][_FactionID]=NONE;
			}
	    }
 	}
	formatex256("UPDATE `"MYSQL_DB_ACCOUNT"` SET  `阵营密匙`='',`阵营阶级`='0',`阵营建筑许可`='0' WHERE  `"MYSQL_DB_ACCOUNT"`.`阵营密匙` ='%s'",Faction[index][_Key]);
	mysql_query(Account@Handle,string256,false);
	
	formatex128("DELETE FROM `"MYSQL_DB_FACTION"` WHERE `"MYSQL_DB_FACTION"`.`密匙`='%s'",Faction[index][_Key]);
	mysql_query(Account@Handle,string128,false);

	Iter_Remove(Faction,index);
	return RETURN_SUCCESS;
}
FUNC::ShowAllFactionZoneForPlayer(playerid)
{
	foreach(new i:Faction)if(RealPlayer(playerid))ShowZoneForPlayer(playerid,Faction[i][_Zoneid],0xC0C0C0C8,ZCOLOR_NUMBER,ZCOLOR_BORDER);
	return 1;
}
FUNC::ShowFactionZoneForAll(index)
{
    if(Iter_Contains(Faction,index))
    {
		foreach(new i:Player)
		{
		    if(RealPlayer(i))ShowZoneForPlayer(i,Faction[index][_Zoneid],0xC0C0C0C8,ZCOLOR_NUMBER,ZCOLOR_BORDER);
		}
	}
	return 1;
}
FUNC::HideFactionZoneForPlayer(playerid)
{
	foreach(new i:Faction)if(RealPlayer(playerid))HideZoneForPlayer(playerid,Faction[i][_Zoneid]);
	return 1;
}
FUNC::LoadFactions()//读取阵营
{
    RestFactions();
	formatex128("SELECT * FROM `"MYSQL_DB_FACTION"`");
    mysql_tquery(Account@Handle,string128, "OnFactionsLoad");
	return 1;
}
FUNC::OnFactionsLoad()
{
    forex(i,cache_num_rows())
	{
	    if(i<MAX_FACTIONS)
	    {
            cache_get_field_content(i,"密匙",Faction[i][_Key],Account@Handle,37);
            cache_get_field_content(i,"创建者密匙",Faction[i][_OwnerKey],Account@Handle,37);
            cache_get_field_content(i,"名称",Faction[i][_Name],Account@Handle,24);
	    	Faction[i][_Level]=cache_get_field_content_int(i,"等级",Account@Handle);
	    	cache_get_field_content(i,"无线电频段",Faction[i][_Wireless],Account@Handle,8);
	    	Faction[i][_WirelessOpen]=cache_get_field_content_int(i,"无线电开放",Account@Handle);
			Faction[i][_x]=cache_get_field_content_float(i,"X坐标",Account@Handle);
			Faction[i][_y]=cache_get_field_content_float(i,"Y坐标",Account@Handle);
			Faction[i][_z]=cache_get_field_content_float(i,"Z坐标",Account@Handle);
            cache_get_field_content(i,"阶级0名称",FactionRank[i][0][_RankName],Account@Handle,24);
            cache_get_field_content(i,"阶级1名称",FactionRank[i][1][_RankName],Account@Handle,24);
            cache_get_field_content(i,"阶级2名称",FactionRank[i][2][_RankName],Account@Handle,24);
            cache_get_field_content(i,"阶级3名称",FactionRank[i][3][_RankName],Account@Handle,24);
            cache_get_field_content(i,"阶级4名称",FactionRank[i][4][_RankName],Account@Handle,24);
			Iter_Add(Faction,i);
			printf("阵营密匙-[%s][%s]",Faction[i][_Key],Faction[i][_Name]);
		}
		else
		{
		    printf("阵营溢出");
			break;
		}
	}
	if(Iter_Count(Faction)>0)
	{
	    foreach(new i:Faction)
		{
 			formatex128("SELECT `阵营密匙` FROM `"MYSQL_DB_ACCOUNT"` WHERE `阵营密匙` = '%s' LIMIT 1",Faction[i][_Key]);
			mysql_query(Account@Handle,string128,true);
			if(cache_get_row_count(Account@Handle)>0)CreateFactionModel(i);
			else
			{
				formatex128("DELETE FROM `"MYSQL_DB_FACTION"` WHERE `"MYSQL_DB_FACTION"`.`密匙`='%s'",Faction[i][_Key]);
				mysql_query(Account@Handle,string128,false);
				printf("发现阵营密匙-[%s][%s]无人,自动删除",Faction[i][_Key],Faction[i][_Name]);
    			new	cur = i;
   				Iter_SafeRemove(Faction,cur,i);
	    	}
        }
	}
	return 1;
}
FUNC::RestFactions()
{
   	Iter_Clear(Faction);
	return 1;
}
FUNC::CreateFactionsWall(index,model,Float:minX,Float:minY,Float:maxX,Float:maxY,Float:posZ)
{
	new pointdistance[4];
	pointdistance[0]=floatround(GetDistanceBetweenPoints2D(minX,minY,minX,maxY));
	pointdistance[1]=floatround(GetDistanceBetweenPoints2D(minX,minY,maxX,minY));
	pointdistance[2]=floatround(GetDistanceBetweenPoints2D(maxX,minY,maxX,maxY));
	pointdistance[3]=floatround(GetDistanceBetweenPoints2D(maxX,maxY,minX,maxY));
	new amouts[4];
	amouts[0]=floatround(pointdistance[0]/13,floatround_ceil);
	amouts[1]=floatround(pointdistance[1]/13,floatround_ceil);
	amouts[2]=floatround(pointdistance[2]/13,floatround_ceil);
	amouts[3]=floatround(pointdistance[3]/13,floatround_ceil);
	if(amouts[0]>=MAX_WALL||amouts[1]>=MAX_WALL||amouts[2]>=MAX_WALL||amouts[3]>=MAX_WALL)return 0;
	new Rates=0;
	for(new i=0;i<=amouts[0];i++)
	{
	    forex(s,10)
	    {
	        if(Rates<MAX_WALL)
	        {
				Faction[index][Wall0][Rates]=CreateDynamicObject(model,minX,minY+(((maxY-minY)/amouts[0])*i),posZ-50.0+(s*9.5),90.0000,90.0000,0.0000,0,0,-1,200.0,200.0);
		        SetDynamicObjectMaterialText(Faction[index][Wall0][Rates],0, "sgsdrgesrge",  OBJECT_MATERIAL_SIZE_512x512,"Arial",100, 1, 0xFFFFFFFF, 0x0000FFC8, 1);
		        //SetDynamicObjectMaterialText(STREAMER_TAG_OBJECT:objectid, materialindex, const text[], materialsize = OBJECT_MATERIAL_SIZE_256x128, const fontface[] = "Arial", fontsize = 24, bold = 1, fontcolor = 0xFFFFFFFF, backcolor = 0, textalignment = 0);
				//SetDynamicObjectMaterial(Faction[index][Wall0][Rates],0,19604,"ballyswater","waterclear256");
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
				Faction[index][Wall1][Rates]=CreateDynamicObject(model,minX+(((maxX-minX)/amouts[1])*i),minY,posZ-50.0+(s*9.5),90.0000,180.0000,0.0000,0,0,-1,200.0,200.0);
	        	SetDynamicObjectMaterialText(Faction[index][Wall1][Rates],0, "sgsdrgesrge",  OBJECT_MATERIAL_SIZE_512x512,"Arial",100, 1, 0xFFFFFFFF, 0x0000FFC8, 1);
				//SetDynamicObjectMaterial(Faction[index][Wall1][Rates],0,19604,"ballyswater","waterclear256");
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
				Faction[index][Wall2][Rates]=CreateDynamicObject(model,maxX,minY+(((maxY-minY)/amouts[2])*i),posZ-50.0+(s*9.5),90.0000,270.0000,0.0000,0,0,-1,200.0,200.0);
		        SetDynamicObjectMaterialText(Faction[index][Wall2][Rates], 0,"sgsdrgesrge",  OBJECT_MATERIAL_SIZE_512x512,"Arial",100, 1, 0xFFFFFFFF, 0x0000FFC8, 1);
				//SetDynamicObjectMaterial(Faction[index][Wall2][Rates],0,19604,"ballyswater","waterclear256");
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
				Faction[index][Wall3][Rates]=CreateDynamicObject(model,maxX-(((maxX-minX)/amouts[3])*i),maxY,posZ-50.0+(s*9.5),90.0000,360.0000,0.0000,0,0,-1,200.0,200.0);
				SetDynamicObjectMaterialText(Faction[index][Wall3][Rates], 0,"sgsdrgesrge",  OBJECT_MATERIAL_SIZE_512x512,"Arial",200, 1, 0xFFFFFFFF, 0x0000FFC8, 1);
//				SetDynamicObjectMaterial(Faction[index][Wall3][Rates],0,19604,"ballyswater","waterclear256");
	            Rates++;
            }
		}
	}
	return 1;
}
FUNC::GetFactionNumberOfPeople(FactionKey[])
{
	formatex128("SELECT `名字` FROM `"MYSQL_DB_ACCOUNT"` WHERE `阵营密匙` = '%s'",FactionKey);
	mysql_query(Account@Handle,string128);
	return cache_get_row_count(Account@Handle);
}
stock ShowPlayerFaction(playerid,pager)
{
    DialogBoxID[playerid]=1;
   	new	Project_ID[MAX_PLAYER_INV_SLOTS],Top_Info[MAX_PLAYER_INV_SLOTS],Current_TopLine=Iter_Count(Faction);
	foreach(new i:Faction)
    {
        HighestTopList(i,Faction[i][_Level],Project_ID, Top_Info, Current_TopLine);
    }
    forex(i,Current_TopLine)
	{
		DialogBox[playerid][DialogBoxID[playerid]]=Project_ID[i];
		format(DialogBoxKey[playerid][DialogBoxID[playerid]],UUID_LEN,Faction[Project_ID[i]][_Key]);
		DialogBoxID[playerid]++;
	}
    new BodyStr[1024],TempStr[64],end=0,index;
//    if(pager>floatround((DialogBoxID[playerid]-1)/float(MAX_BOX_LIST),floatround_ceil))pager=floatround((DialogBoxID[playerid]-1)/float(MAX_BOX_LIST),floatround_ceil);
    if(pager<1)pager=1;
    DialogPage[playerid]=pager;
    pager=(pager-1)*MAX_BOX_LIST;
    if(pager==0)pager=1;else pager++;
	format(BodyStr,sizeof(BodyStr), "阵营名称\t首领\t阵营等级\t人数\n");
	strcat(BodyStr,"\t上一页\n");
	loop(i,pager,pager+MAX_BOX_LIST)
	{
		index=DialogBox[playerid][i];
		if(i<DialogBoxID[playerid])
		{
			format(TempStr,sizeof(TempStr),"%s\t%s\t%i\t%i\n",Faction[index][_Name],GetPlayerMySqlNameFromKey(Faction[index][_OwnerKey]),Faction[index][_Level],GetFactionNumberOfPeople(Faction[index][_Key]));
        }
		if(i>=DialogBoxID[playerid])
		{
			end=1;
			break;
		}
		else strcat(BodyStr,TempStr);
	}
	if(!end)strcat(BodyStr, "\t下一页\n");
    return BodyStr;
}
FUNC::SendPlayerJoinFactionMail(playerid,index)
{
	formatex128("SELECT `阵营阶级`,`密匙` FROM `"MYSQL_DB_ACCOUNT"` WHERE `阵营密匙` = '%s'",Faction[index][_Key]);
	mysql_query(Account@Handle,string128);
	new SendOkRate=cache_get_row_count(Account@Handle);
	new SendAmount=cache_get_row_count(Account@Handle);
	new ReciverKey[3][37];
	forex(i,cache_get_row_count(Account@Handle))
	{
	    if(cache_get_field_content_int(i,"阵营阶级",Account@Handle)>=4)
	    {
	        cache_get_field_content(i,"密匙",ReciverKey[i],Account@Handle,37);
	    }
	}
	
	new ExtraData[128];
	format(ExtraData,sizeof(ExtraData),"%s,%s",Faction[index][_Key],Account[playerid][_Key]);
	forex(i,SendAmount)
	{
        new ReceiveID=GetPlayerIDByKey(ReciverKey[i]);
		if(ReceiveID==NONE)
		{
			if(SendGameMailToOffLPlayer(Account[playerid][_Key],ReciverKey[i],GAMEMAIL_TYPE_FACTION_REQ,"",0,"",ExtraData,SERVER_RUNTIMES)!=RETURN_SUCCESS)
			{
				SendOkRate--;
			}
		}
		else
		{
			if(SendGameMailToOnlPlayer(playerid,ReceiveID,GAMEMAIL_TYPE_FACTION_REQ,"",0,"",ExtraData,SERVER_RUNTIMES)!=RETURN_SUCCESS)
			{
			    SendOkRate--;
			}
		}
	}
    return SendOkRate;
}
FUNC::Faction_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case _SPD_FACTION_CREATE_NAME:
        {
            if(!response)return true;
 			new FactionID=GetPlayerFactionID(playerid);
            if(FactionID==NONE)
            {
                if(strlen(inputtext)<=0||strlen(inputtext)>12)return SPD(playerid,_SPD_FACTION_CREATE_NAME,DIALOG_STYLE_INPUT,"创建阵营","请输入阵营名称[最多6个汉字,12个英文字母]","确定","返回");
                CreateFactionData(playerid,inputtext);
           	}
           	return true;
        }
        case _SPD_FACTION_LIST:
        {
            if(!response)return true;
			new pager=(DialogPage[playerid]-1)*MAX_BOX_LIST;
			if(pager==0)pager = 1;
			else pager++;
			switch(listitem)
			{
			    case 0:
			  	{
			    	DialogPage[playerid]--;
			    	if(DialogPage[playerid]<1)DialogPage[playerid]=1;
			    	formatex64("阵营列表[共计%i个]",Iter_Count(Faction));
			    	SPD(playerid,_SPD_FACTION_LIST,DIALOG_STYLE_TABLIST_HEADERS,string64,ShowPlayerFaction(playerid,DialogPage[playerid]),"确定","取消");
				}
				case MAX_BOX_LIST+1:
				{
		    		DialogPage[playerid]++;
		    		formatex64("阵营列表[共计%i个]",Iter_Count(Faction));
					SPD(playerid,_SPD_FACTION_LIST,DIALOG_STYLE_TABLIST_HEADERS,string64,ShowPlayerFaction(playerid,DialogPage[playerid]),"确定","取消");
			    }
				default:
				{
					new index=DialogBox[playerid][pager+listitem-1];
					formatex128("是否申请加入阵营 %s [等级%i]",Faction[index][_Name],Faction[index][_Level]);
					SPD(playerid,_SPD_FACTION_JOIN_INFO,DIALOG_STYLE_MSGBOX,"申请加入",string128,"申请","取消");
                    formatex64("%i,%s,%i",index,DialogBoxKey[playerid][pager+listitem-1],pager+listitem-1);
					SetPVarString(playerid,"_Faction_Join_Info",string64);
				}
			}
			return true;
        }
        case _SPD_FACTION_JOIN_INFO:
        {
            if(!response)return true;
            new FactionID=GetPlayerFactionID(playerid);
            if(FactionID==NONE)
            {
                new VarString[64];
 				GetPVarString(playerid,"_Faction_Join_Info",VarString,64);
                if(VerifyPlayerFactionJoinPVarData(playerid,VarString)==true)
                {
                    new BoxKey[37],Listid;
    				sscanf(VarString, "p<,>is[37]i",FactionID,BoxKey,Listid);
					if(SendPlayerJoinFactionMail(playerid,FactionID)==0)
					{
					    SCM(playerid,-1,"发送申请请求失败,可能该阵营首领邮箱已满");
					}
					else
					{
					    SCM(playerid,-1,"发送申请请求成功,请耐心等待对方回应,对方同意后会以邮件形式通知你!");
					}
                }
            }
            else SCM(playerid,-1,"你已经加入阵营了");
            return true;
        }
		case _SPD_FACTION_TIP:
		{
		    if(!response)return true;
	        switch(listitem)
           	{
				case 0:
				{
                    new FactionID=GetPlayerFactionID(playerid);
                    if(FactionID==NONE)
                    {
                    	SPD(playerid,_SPD_FACTION_CREATE_NAME,DIALOG_STYLE_INPUT,"创建阵营","请输入阵营名称[最多6个汉字,12个英文字母]","确定","返回");
                   	}
				}
				case 1:
				{
				    formatex64("阵营列表[共计%i个]",Iter_Count(Faction));
				    SPD(playerid,_SPD_FACTION_LIST,DIALOG_STYLE_TABLIST_HEADERS,string64,ShowPlayerFaction(playerid,1),"选择","取消");
				}
			}
			return true;
		}
		case _SPD_FACTION_INV:
		{
            if(!response)return true;
			new FactionID=GetPlayerFactionID(playerid);
		    if(FactionID==NONE)return true;            
			new pager=(DialogPage[playerid]-1)*MAX_BOX_LIST;
			if(pager==0)pager = 1;
			else pager++;
			switch(listitem)
			{
			    case 0:
			  	{
			    	DialogPage[playerid]--;
			    	if(DialogPage[playerid]<1)DialogPage[playerid]=1;
			    	SPD(playerid,_SPD_FACTION_INV,DIALOG_STYLE_TABLIST_HEADERS,"邀请成员",ShowPlayerNoFactionPlayers(playerid,DialogPage[playerid]),"确定","取消");
				}
				case MAX_BOX_LIST+1:
				{
		    		DialogPage[playerid]++;
					SPD(playerid,_SPD_FACTION_INV,DIALOG_STYLE_TABLIST_HEADERS,"邀请成员",ShowPlayerNoFactionPlayers(playerid,DialogPage[playerid]),"确定","取消");
			    }
				default:
				{
					new index=DialogBox[playerid][pager+listitem-1];
					if(!RealPlayer(index))return SCM(playerid,-1,"对方可能已经下线了");
					new AccountFactionID=GetPlayerFactionID(index);
					if(AccountFactionID!=NONE)return SCM(playerid,-1,"对方可能已经加入阵营或其他阵营了");
					new ExtraData[128];
					format(ExtraData,sizeof(ExtraData),"%s,%s",Faction[FactionID][_Key],Account[playerid][_Key]);
					SendMailToPlayer(Account[playerid][_Key],Account[index][_Key],GAMEMAIL_TYPE_FACTION_INV,"",0,"null",ExtraData,SERVER_RUNTIMES);	
				}
			}
			return true;	
		}
		case _SPD_FACTION_MANAGE_MEMBERS:
		{
			if(!response)return true;
		    new FactionID=GetPlayerFactionID(playerid);
		    if(FactionID==NONE)return true;
		    if(PlayerFaction[playerid][_Rank]<3)return SCM(playerid,-1,"你的阶级不够");
			new pager=(DialogPage[playerid]-1)*MAX_BOX_LIST;
			if(pager==0)pager = 1;
			else pager++;
			switch(listitem)
			{
			    case 0:
			  	{
			    	DialogPage[playerid]--;
			    	if(DialogPage[playerid]<1)DialogPage[playerid]=1;
			    	formatex64("成员管理[ %i 人]",GetFactionNumberOfPeople(Faction[FactionID][_Key]));
			    	SPD(playerid,_SPD_FACTION_INV,DIALOG_STYLE_TABLIST_HEADERS,string64,ShowFactionMembersList(playerid,DialogPage[playerid]),"确定","取消");
				}
				case MAX_BOX_LIST+1:
				{
		    		DialogPage[playerid]++;
		    		formatex64("成员管理[ %i 人]",GetFactionNumberOfPeople(Faction[FactionID][_Key]));
					SPD(playerid,_SPD_FACTION_INV,DIALOG_STYLE_TABLIST_HEADERS,string64,ShowFactionMembersList(playerid,DialogPage[playerid]),"确定","取消");
			    }
				default:
				{
					new index=DialogBox[playerid][pager+listitem-1];

				}
			}
		    return true;				
		}
		case _SPD_FACTION_MANAGE:
		{
		    if(!response)return true;
		    new FactionID=GetPlayerFactionID(playerid);
		    if(FactionID==NONE)return true;
		    if(PlayerFaction[playerid][_Rank]<3)return SCM(playerid,-1,"你的阶级不够");
	        switch(listitem)
           	{
				case 0:
				{
					if(GetFactionNumberOfPeople(Faction[FactionID][_Key])>=(Faction[FactionID][_Level]+1)*5)
					{
						formatex64("你的阵营等级不足,目前阵营最多只允许 %i 人",(Faction[FactionID][_Level]+1)*5);	
						return SCM(playerid,-1,string64);
					}
					SPD(playerid,_SPD_FACTION_INV,DIALOG_STYLE_TABLIST_HEADERS,"邀请成员",ShowPlayerNoFactionPlayers(playerid,1),"邀请","取消");
				}
				case 1:
				{
					formatex64("成员管理[ %i 人]",GetFactionNumberOfPeople(Faction[FactionID][_Key]));
					SPD(playerid,_SPD_FACTION_MANAGE_MEMBERS,DIALOG_STYLE_TABLIST_HEADERS,string64,ShowFactionMembersList(playerid,FactionID,1),"确定","取消");
				}
				case 2:
				{
				}
				case 3:
				{
				    
				}
				case 4:
				{
				    if(isequal(Faction[FactionID][_OwnerKey],Account[playerid][_Key],false))
				    {
				    
				    }
				    else
				    {
				        SCM(playerid,-1,"你不是创建者,不能解散阵营");
				    }
				}
           	}
           	return true;
		}
		case _SPD_FACTION_SET:
		{
		    if(!response)return true;
		    new FactionID=GetPlayerFactionID(playerid);
		    if(FactionID==NONE)return true;
	        switch(listitem)
           	{
				case 0:
				{
				    if(PlayerFaction[playerid][_Rank]<3)return SCM(playerid,-1,"你的阶级不够");
				    formatex64("%s",Faction[FactionID][_Name]);
                    SPD(playerid,_SPD_FACTION_MANAGE,DIALOG_STYLE_LIST,string64,FACTION_USE_MANAGE,"确定","取消");
				}
				case 1:
				{
				    SPD(playerid,_SPD_FACTION_INFO,DIALOG_STYLE_MSGBOX,"阵营信息",ShowPlayerFactionInfo(FactionID),"确定","取消");
				}
				case 2:
				{
				    if(isequal(Faction[FactionID][_OwnerKey],Account[playerid][_Key],false))SCM(playerid,-1,"你是阵营创建者,只能解散阵营");
					else
					{
					    RestPlayerFaction(playerid);
					    SCM(playerid,-1,"你成功退出了阵营");
					}
				}
			}
			return true;
		}
	}
	return false;
}
FUNC::bool:VerifyPlayerFactionJoinPVarData(playerid,VarString[])
{
	new FactionID,BoxKey[37],Listid;
    if(sscanf(VarString, "p<,>is[37]i",FactionID,BoxKey,Listid))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#0]","对话框数据验证失败,请重新选择","了解","");
        return false;
	}
	if(!Iter_Contains(Faction,FactionID))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#1]","该数据已失效,请重新选择","了解","");
        return false;
	}
    if(!isequal(Faction[FactionID][_Key],BoxKey,false))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#2]","对话框数据验证失败,请重新选择","了解","");
        return false;
	}
	return true;
}
stock ShowPlayerFactionInfo(index)
{
    new BodyStr[1024],TempStr[64];
    format(TempStr,sizeof(TempStr),"阵营名称:%s\n",Faction[index][_Name]);
	strcat(BodyStr,TempStr);
    format(TempStr,sizeof(TempStr),"创建人:%s\n",GetPlayerMySqlNameFromKey(Faction[index][_OwnerKey]));
	strcat(BodyStr,TempStr);
    format(TempStr,sizeof(TempStr),"帮派等级:%i\n",Faction[index][_Level],GetFactionNumberOfPeople(Faction[index][_Key]));
	strcat(BodyStr,TempStr);
    format(TempStr,sizeof(TempStr),"帮派人数:%i\n",GetFactionNumberOfPeople(Faction[index][_Key]));
	strcat(BodyStr,TempStr);
	strcat(BodyStr,"\n成员名单\n");
	formatex128("SELECT `名字`,`阵营阶级` FROM `"MYSQL_DB_ACCOUNT"` WHERE `阵营密匙` = '%s'ORDER BY `"MYSQL_DB_ACCOUNT"`.`阵营阶级` ASC",Faction[index][_Key]);
	mysql_query(Account@Handle,string128,true);
	new PlayerName[24];
	forex(i,cache_num_rows(Account@Handle))
	{
	    cache_get_field_content(i,"名字",PlayerName,Account@Handle,24);
    	format(TempStr,sizeof(TempStr),"\t%s\t\t%s\n",PlayerName,FactionRank[index][cache_get_field_content_int(i,"阵营阶级",Account@Handle)][_RankName]);
        strcat(BodyStr,TempStr);
	}
	return BodyStr;
}
stock ShowFactionMembersList(playerid,FactionID,pager)
{
    DialogBoxID[playerid]=1;
	formatex128("SELECT `密匙` FROM `"MYSQL_DB_ACCOUNT"` WHERE `阵营密匙` = '%s'ORDER BY `"MYSQL_DB_ACCOUNT"`.`阵营阶级` ASC",Faction[FactionID][_Key]);
	mysql_query(Account@Handle,string128,true);
	new PlayerKey[37];
	forex(i,cache_num_rows(Account@Handle))
	{
		cache_get_field_content(i,"密匙",PlayerKey,Account@Handle,37);	
	    DialogBox[playerid][DialogBoxID[playerid]]=i;
		format(DialogBoxKey[playerid][DialogBoxID[playerid]],UUID_LEN,PlayerKey);
		DialogBoxID[playerid]++;
	}
    new BodyStr[1024],TempStr[64],end=0,index;
    if(pager<1)pager=1;
    DialogPage[playerid]=pager;
    pager=(pager-1)*MAX_BOX_LIST;
    if(pager==0)pager=1;else pager++;
	format(BodyStr,sizeof(BodyStr), "阵营成员\t阶级\t建筑权限\n");
	strcat(BodyStr,"\t上一页\n");
	new PlayerName[24],PlayerFactionLevel,PlayerFactionAllow,Allow[8];
	loop(i,pager,pager+MAX_BOX_LIST)
	{
		index=DialogBox[playerid][i];
		if(i<DialogBoxID[playerid])
		{	
			new PlayerID=GetPlayerIDByKey(DialogBoxKey[playerid][i]);	
			formatex128("SELECT `名字`,`阵营阶级`,`阵营建筑许可` FROM `"MYSQL_DB_ACCOUNT"` WHERE `密匙` = '%s' LIMIT 1",DialogBoxKey[playerid][i]);
			mysql_query(Account@Handle,string128);
			cache_get_field_content(0,"名字",PlayerName,Account@Handle,24);
			PlayerFactionLevel=cache_get_field_content_int(0,"阵营阶级",Account@Handle);
			PlayerFactionAllow=cache_get_field_content_int(0,"阵营建筑许可",Account@Handle);
			if(PlayerFactionAllow>0)format(Allow,sizeof(Allow),"√");
			else format(Allow,sizeof(Allow)," ");
			if(PlayerID==NONE)format(TempStr,sizeof(TempStr),"{408080}%s\t%s\t%s\n",PlayerName,FactionRank[FactionID][PlayerFactionLevel][_RankName],Allow);
			else format(TempStr,sizeof(TempStr),"{FFFFFF}%s\t%s\t%s\n",PlayerName,FactionRank[FactionID][PlayerFactionLevel][_RankName],Allow);
        }
		if(i>=DialogBoxID[playerid])
		{
			end=1;
			break;
		}
		else strcat(BodyStr,TempStr);
	}
	if(!end)strcat(BodyStr, "\t下一页\n");
    return BodyStr;
}
stock ShowPlayerNoFactionPlayers(playerid,pager)
{
    DialogBoxID[playerid]=1;
	foreach(new i:Player)
	{
	    if(RealPlayer(i))
	    {
	    	if(PlayerFaction[i][_FactionID]==NONE)
	    	{
				DialogBox[playerid][DialogBoxID[playerid]]=i;
				format(DialogBoxKey[playerid][DialogBoxID[playerid]],UUID_LEN,Account[i][_Key]);
				DialogBoxID[playerid]++;
			}
		}
	}
    new BodyStr[1024],TempStr[64],end=0,index;
    if(pager<1)pager=1;
    DialogPage[playerid]=pager;
    pager=(pager-1)*MAX_BOX_LIST;
    if(pager==0)pager=1;else pager++;
	format(BodyStr,sizeof(BodyStr), "在线无阵营玩家\n");
	strcat(BodyStr,"\t上一页\n");
	loop(i,pager,pager+MAX_BOX_LIST)
	{
		index=DialogBox[playerid][i];
		if(i<DialogBoxID[playerid])
		{
			format(TempStr,sizeof(TempStr),"%s\n",Account[index][_Name]);
        }
		if(i>=DialogBoxID[playerid])
		{
			end=1;
			break;
		}
		else strcat(BodyStr,TempStr);
	}
	if(!end)strcat(BodyStr, "\t下一页\n");
    return BodyStr;
}
