FUNC::LoadPlayerWireless(playerid)//读取玩家无线电
{
	formatex128("SELECT * FROM `"MYSQL_DB_PLAYERWIRELESS"` WHERE `归属密匙`='%s'",Account[playerid][_Key]);
	mysql_query(Account@Handle,string128,true);
    forex(i,cache_num_rows())
	{
	    if(i<MAX_PLAYER_WIRELESS)
	    {
	        cache_get_field_content(i,"无线电密匙",PlayerWireless[playerid][i][_WirelessKey],Account@Handle,37);
	        cache_get_field_content(i,"无线电频段",PlayerWireless[playerid][i][_WirelessChannel],Account@Handle,8);
            new FactionID=GetWirelessChannelKeyID(PlayerWireless[playerid][i][_WirelessChannel]);
	        if(FactionID==NONE)
	        {
	            cache_get_field_content(i,"归属密匙",PlayerWireless[playerid][i][_AccountKey],Account@Handle,37);
		    	PlayerWireless[playerid][i][_WirelessUsed]=cache_get_field_content_int(i,"使用",Account@Handle);
				cache_get_field_content(i,"添加时间",PlayerWireless[playerid][i][_CreateTime],Account@Handle,37);
                PlayerWireless[playerid][i][_FactionID]=FactionID;
				Iter_Add(PlayerWireless[playerid],i);
				printf("%s 无线电,无线电密匙-[%s] ",Account[playerid][_Name],PlayerWireless[playerid][i][_WirelessKey]);
			}
			else
			{
	    	    formatex128("DELETE FROM `"MYSQL_DB_PLAYERWIRELESS"` WHERE `"MYSQL_DB_PLAYERWIRELESS"`.`无线电密匙` ='%s'",PlayerWireless[playerid][i][_WirelessKey]);
				mysql_query(Account@Handle,string128,false);
				printf("%s 无线电列表,无线电密匙-[%s][%s] 失效,已删除",Account[playerid][_Name],PlayerWireless[playerid][i][_WirelessKey],PlayerWireless[playerid][i][_WirelessChannel]);
			}
		}
		else
		{
		    printf("%s 无线电列表溢出",Account[playerid][_Name]);
			break;
		}
	}
	return 1;
}
FUNC::IsPlayerHaveWirelessChannel(playerid,Channel[])
{
	foreach(new i:PlayerWireless[playerid])
	{
		if(isequal(PlayerWireless[playerid][i][_WirelessChannel],Channel,false))return 1;
	}
	return 0;
}
FUNC::AddWirelessToPlayer(playerid,WirelessChannel[])//添加频段
{
	if(Iter_Count(PlayerWireless[playerid])>=MAX_PLAYER_WIRELESS)
	{
	    formatex80("%i-awtp error0",playerid);
        Debug(playerid,string80);
		return RETURN_ERROR;
    }
   	new i=Iter_Free(PlayerWireless[playerid]);
   	format(PlayerWireless[playerid][i][_AccountKey],UUID_LEN,Account[playerid][_Key]);
   	UUID(PlayerWireless[playerid][i][_WirelessKey], UUID_LEN);
	format(PlayerWireless[playerid][i][_WirelessChannel],8,WirelessChannel);
    PlayerWireless[playerid][i][_WirelessUsed]=1;
    format(PlayerWireless[playerid][i][_CreateTime],40,PrintDate());
    formatex512("INSERT INTO `"MYSQL_DB_PLAYERWIRELESS"`(`归属密匙`,`无线电密匙`,`无线电频段`,`使用`,`添加时间`) VALUES ('%s','%s','%s','%i','%s')",PlayerWireless[playerid][i][_AccountKey],PlayerWireless[playerid][i][_WirelessKey],PlayerWireless[playerid][i][_WirelessChannel],PlayerWireless[playerid][i][_WirelessUsed],PlayerWireless[playerid][i][_CreateTime]);
   	mysql_query(Account@Handle,string512,true);
    Iter_Add(PlayerWireless[playerid],i);
	return RETURN_SUCCESS;
}
FUNC::RestPlayerWireless(playerid)
{
   	Iter_Clear(PlayerWireless[playerid]);
	return 1;
}
stock ShowPlayerWireless(playerid,pager)
{
    DialogBoxID[playerid]=1;
   	new	Project_ID[MAX_PLAYER_INV_SLOTS],Top_Info[MAX_PLAYER_INV_SLOTS],Current_TopLine=Iter_Count(PlayerWireless[playerid]);
	foreach(new i:PlayerWireless[playerid])
    {
        HighestTopList(i,PlayerWireless[playerid][i][_WirelessUsed],Project_ID, Top_Info, Current_TopLine);
    }
    forex(i,Current_TopLine)
	{
		DialogBox[playerid][DialogBoxID[playerid]]=Project_ID[i];
		format(DialogBoxKey[playerid][DialogBoxID[playerid]],UUID_LEN,PlayerWireless[playerid][Project_ID[i]][_WirelessKey]);
		DialogBoxID[playerid]++;
	}
    new BodyStr[1024],TempStr[64],end=0,index;
    if(pager<1)pager=1;
//    if(pager>floatround((DialogBoxID[playerid]-1)/float(MAX_BOX_LIST),floatround_ceil))pager=floatround((DialogBoxID[playerid]-1)/float(MAX_BOX_LIST),floatround_ceil);
    DialogPage[playerid]=pager;
    pager=(pager-1)*MAX_BOX_LIST;
    if(pager==0)pager=1;else pager++;
	format(BodyStr,sizeof(BodyStr), "无线电频段\t归属阵营\t监听使用\t添加时间\n");
	strcat(BodyStr,"\t上一页\n");
	loop(i,pager,pager+MAX_BOX_LIST)
	{
		index=DialogBox[playerid][i];
		if(i<DialogBoxID[playerid])
		{
			if(PlayerWireless[playerid][index][_WirelessUsed]==1)format(TempStr,sizeof(TempStr),"%s Mhz\t%s\t√\t%s\n",PlayerWireless[playerid][index][_WirelessChannel],Faction[PlayerWireless[playerid][index][_FactionID]][_Name],PlayerWireless[playerid][index][_CreateTime]);
			else format(TempStr,sizeof(TempStr),"%s Mhz\t%s\t \t%s\n",PlayerWireless[playerid][index][_WirelessChannel],Faction[PlayerWireless[playerid][index][_FactionID]][_Name],PlayerWireless[playerid][index][_CreateTime]);
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
stock ShowPlayerNearWireless(playerid,pager)
{
    DialogBoxID[playerid]=1;
   	new	Project_ID[MAX_PLAYER_INV_SLOTS],Float:Top_Info[MAX_PLAYER_INV_SLOTS],Current_TopLine=Iter_Count(Faction);
	new Float:WireStrength[MAX_FACTIONS];
	foreach(new i:Faction)
    {
	    WireStrength[i]=floatmul(floatdiv(GetDistanceBetweenPoints2D(PlayerPos[playerid][0],PlayerPos[playerid][1],Faction[i][_x],Faction[i][_y]),floatmul(1000.0,Faction[i][_Level]+1)),100);
		WireStrength[i]=floatsub(100.0,WireStrength[i]);
		if(WireStrength[i]>100.0)WireStrength[i]=100.0;
		if(WireStrength[i]<0.0)WireStrength[i]=0.0;
    }
	foreach(new i:Faction)
    {
        HighestTopListFloat(i,WireStrength[i],Project_ID, Top_Info, Current_TopLine);
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
	format(BodyStr,sizeof(BodyStr), "无线电频段\t归属阵营\t开放使用\t信号强度\n");
	strcat(BodyStr,"\t上一页\n");
	loop(i,pager,pager+MAX_BOX_LIST)
	{
		index=DialogBox[playerid][i];
		if(i<DialogBoxID[playerid])
		{
			if(Faction[index][_WirelessOpen]==1)format(TempStr,sizeof(TempStr),"%s Mhz\t%s\t√\t%0.1f%%\n",Faction[index][_Wireless],Faction[index][_Name],WireStrength[index]);
			else format(TempStr,sizeof(TempStr),"%s Mhz\t%s\t \t%0.1f%%\n",Faction[index][_Wireless],Faction[index][_Name],WireStrength[index]);
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
FUNC::bool:VerifyWirelessPVarData(playerid,VarString[])
{
	new WirelessID,WirelessKey[37];
    if(sscanf(VarString, "p<,>is[37]",WirelessID,WirelessKey))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#0]","对话框数据验证失败,请重新选择","了解","");
        return false;
	}
	if(!Iter_Contains(PlayerWireless[playerid],WirelessID))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#1]","该频段已失效,请重新选择","了解","");
        return false;
	}
    if(!isequal(PlayerWireless[playerid][WirelessID][_WirelessKey],WirelessKey,false))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#2]","对话框数据验证失败,请重新选择","了解","");
        return false;
	}
	return true;
}
FUNC::bool:VerifyNearWirelessPVarData(playerid,VarString[])
{
	new FactionID,FactionKey[37];
    if(sscanf(VarString, "p<,>is[37]",FactionID,FactionKey))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#0]","对话框数据验证失败,请重新选择","了解","");
        return false;
	}
	if(!Iter_Contains(Faction,FactionID))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#1]","该阵营频段已失效,请重新选择","了解","");
        return false;
	}
    if(!isequal(Faction[FactionID][_Key],FactionKey,false))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#2]","对话框数据验证失败,请重新选择","了解","");
        return false;
	}
	return true;
}
CMD:ws(playerid, params[])
{
	SPD(playerid,_SPD_MY_WIRELESS,DIALOG_STYLE_TABLIST_HEADERS,"无线电笔记",ShowPlayerWireless(playerid,1),"选择","取消");
	return 1;
}
CMD:wn(playerid, params[])
{
	SPD(playerid,_SPD_NEAR_WIRELESS,DIALOG_STYLE_TABLIST_HEADERS,"附近无线电信号",ShowPlayerNearWireless(playerid,1),"选择","取消");
	return 1;
}
