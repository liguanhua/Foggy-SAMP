FUNC::SendMailToPlayer(SenderKey[],ReceiverKey[],Type,Content[],Cash,Itemdata[],ExtraData[],GameTime)
{
    new ReceiveID=GetPlayerIDByKey(ReceiverKey);
    new SenderID=GetPlayerIDByKey(SenderKey);
   	if(SenderID==NONE)format(SenderKey,UUID_LEN,"null");
	if(ReceiveID==NONE)return SendGameMailToOffLPlayer(SenderKey,ReceiverKey,Type,Content,Cash,Itemdata,ExtraData,GameTime);
	else return SendGameMailToOnlPlayer(SenderID,ReceiveID,Type,Content,Cash,Itemdata,ExtraData,GameTime);
}
FUNC::SendGameMailToOnlPlayer(SenderID,ReceiverID,Type,Content[],Cash,Itemdata[],ExtraData[],GameTime)//发送邮件给在线玩家
{
    if(Iter_Count(PlayerGameMail[ReceiverID])>=MAX_PLAYER_GAMEMAILS)
	{
	    formatex80("%i-sgmyonp error0",SenderID);
        Debug(SenderID,string80);
		return RETURN_ERROR;
    }
    
    new i=Iter_Free(PlayerGameMail[ReceiverID]);
    UUID(PlayerGameMail[ReceiverID][i][_Key], UUID_LEN);
    PlayerGameMail[ReceiverID][i][_Type]=Type;
    if(SenderID==NONE)format(PlayerGameMail[ReceiverID][i][_SenderKey],UUID_LEN,"null");
    else format(PlayerGameMail[ReceiverID][i][_SenderKey],UUID_LEN,Account[SenderID][_Key]);
    format(PlayerGameMail[ReceiverID][i][_ReceiverKey],UUID_LEN,Account[ReceiverID][_Key]);
    format(PlayerGameMail[ReceiverID][i][_Content],256,Content);
    format(PlayerGameMail[ReceiverID][i][_SendTime],32,PrintDate());
    format(PlayerGameMail[ReceiverID][i][_ExtraData],128,ExtraData);
    PlayerGameMail[ReceiverID][i][_Cash]=Cash;
    format(PlayerGameMail[ReceiverID][i][_ItemData],512,Itemdata);
	PlayerGameMail[ReceiverID][i][_Readed]=0;
	PlayerGameMail[ReceiverID][i][_GameTime]=GameTime;
	Iter_Add(PlayerGameMail[ReceiverID],i);

	new MailKey[37],SenderKey[37],ReceiverKey[37];
	format(MailKey,37,PlayerGameMail[ReceiverID][i][_Key]);
	format(SenderKey,37,PlayerGameMail[ReceiverID][i][_SenderKey]);
	format(ReceiverKey,37,PlayerGameMail[ReceiverID][i][_ReceiverKey]);

	formatex2048(\
	"INSERT INTO `"MYSQL_DB_PLAYERGAMEMAIL"` (\
	`邮件密匙`,`发件人密匙`,`收件人密匙`,`类型`,`内容`,\
	`金币`,`道具数据`,`额外数据`,`发送时间`,`系统时间`) VALUES \
	('%s','%s','%s','%i','%s','%i','%s','%s','%s','%i')",\
	MailKey,\
	SenderKey,\
	ReceiverKey,\
	Type,\
	Content,\
	Cash,\
	PlayerGameMail[ReceiverID][i][_ItemData],\
	ExtraData,\
	PlayerGameMail[ReceiverID][i][_SendTime],\
	GameTime);
	mysql_query(Account@Handle,string2048);
    return RETURN_SUCCESS;
}
FUNC::SendGameMailToOffLPlayer(SenderKey[],ReceiverKey[],Type,Content[],Cash,Itemdata[],ExtraData[],GameTime)//发送邮件给离线玩家
{
	if(!IsPlayerKeyFexist(ReceiverKey))
	{
	    formatex80("%s-sgmtofflp error0",SenderKey);
        Debug(NONE,string80);
		return RETURN_ERROR;
    }
	if(GetOfflinePlayerKeyMailAmout(ReceiverKey)>=MAX_PLAYER_GAMEMAILS)
	{
	    formatex80("%s-sgmtofflp error1",SenderKey);
        Debug(NONE,string80);
		return RETURN_ERROR;
    }
    new MailKey[37];
    UUID(MailKey, UUID_LEN);
    formatex2048("INSERT INTO `"MYSQL_DB_PLAYERGAMEMAIL"`(`邮件密匙`,`发件人密匙`,`收件人密匙`,`类型`,`内容`,`金币`,`道具数据`,`额外数据`,`发送时间`,`系统时间`)\
	VALUES ('%s','%s','%s','%i','%s','%i','%s','%s','%s','%i')",MailKey,SenderKey,ReceiverKey,Type,Content,Cash,Itemdata,ExtraData,PrintDate(),GameTime);
	mysql_query(Account@Handle,string2048,false);
    return RETURN_SUCCESS;
}
FUNC::GetOfflinePlayerKeyMailAmout(Key[])//获取不在线人员邮件数量
{
	formatex128("SELECT * FROM `"MYSQL_DB_PLAYERGAMEMAIL"` WHERE `收件人密匙`='%s'",Key);
	mysql_query(Account@Handle,string128);
	return cache_num_rows(Account@Handle);
}


FUNC::PlayerGameMailRest(playerid)//清空玩家邮件数据
{
   	Iter_Clear(PlayerGameMail[playerid]);
	return 1;
}
FUNC::LoadPlayerGameMails(playerid)//加载玩家邮件数据
{
    PlayerGameMailRest(playerid);
	formatex128("SELECT * FROM `"MYSQL_DB_PLAYERGAMEMAIL"` WHERE `收件人密匙`='%s' ORDER BY `"MYSQL_DB_PLAYERGAMEMAIL"`.`系统时间` ASC",Account[playerid][_Key]);
    mysql_tquery(Account@Handle,string128, "OnPlayerGameMailsLoad", "i",playerid);
}
FUNC::OnPlayerGameMailsLoad(playerid)//加载玩家邮件数据
{
    forex(i,cache_num_rows())
	{
	    if(i<MAX_PLAYER_GAMEMAILS)
	    {
			cache_get_field_content(i,"邮件密匙",PlayerGameMail[playerid][i][_Key],Account@Handle,37);
			cache_get_field_content(i,"发件人密匙",PlayerGameMail[playerid][i][_SenderKey],Account@Handle,37);
			cache_get_field_content(i,"收件人密匙",PlayerGameMail[playerid][i][_ReceiverKey],Account@Handle,37);
            PlayerGameMail[playerid][i][_Type]=cache_get_field_content_int(i,"类型",Account@Handle);
            cache_get_field_content(i,"内容",PlayerGameMail[playerid][i][_Content],Account@Handle,256);
            cache_get_field_content(i,"道具数据",PlayerGameMail[playerid][i][_ItemData],Account@Handle,512);
	        PlayerGameMail[playerid][i][_Cash]=cache_get_field_content_int(i,"金币",Account@Handle);
	        cache_get_field_content(i,"额外数据",PlayerGameMail[playerid][i][_ExtraData],Account@Handle,128);
            cache_get_field_content(i,"发送时间",PlayerGameMail[playerid][i][_SendTime],Account@Handle,32);
			PlayerGameMail[playerid][i][_Readed]=cache_get_field_content_int(i,"已读",Account@Handle);
			PlayerGameMail[playerid][i][_GameTime]=cache_get_field_content_int(i,"系统时间",Account@Handle);
			Iter_Add(PlayerGameMail[playerid],i);
		}
		else
		{
		    printf("%s 的邮箱数据溢出[%i],请修改MAX_PLAYER_GAMEMAILS",Account[playerid][_Name],MAX_PLAYER_GAMEMAILS);
			break;
		}
	}
	return 1;
}
stock ShowPlayerGameMails(playerid,pager)//输出玩家邮件列表
{
    DialogBoxID[playerid]=1;
   	new	Project_ID[MAX_PLAYER_GAMEMAILS],Top_Info[MAX_PLAYER_GAMEMAILS],Current_TopLine=Iter_Count(PlayerGameMail[playerid]);
	foreach(new i:PlayerGameMail[playerid])
    {
        HighestTopList(i,PlayerGameMail[playerid][i][_GameTime],Project_ID, Top_Info, Current_TopLine);
    }
    forex(i,Current_TopLine)
	{
		DialogBox[playerid][DialogBoxID[playerid]]=Project_ID[i];
		format(DialogBoxKey[playerid][DialogBoxID[playerid]],UUID_LEN,PlayerGameMail[playerid][Project_ID[i]][_Key]);
		DialogBoxID[playerid]++;
	}
    new BodyStr[1024],TempStr[128],end=0,index;
    if(pager<1)pager=1;
    //if(pager>floatround((DialogBoxID[playerid]-1)/float(MAX_BOX_LIST),floatround_ceil))pager=floatround((DialogBoxID[playerid]-1)/float(MAX_BOX_LIST),floatround_ceil);
    DialogPage[playerid]=pager;
    pager=(pager-1)*MAX_BOX_LIST;
    if(pager==0)pager=1;else pager++;
	format(BodyStr,sizeof(BodyStr), "邮件类型\t发送者\t附件\t发送时间\n");
	strcat(BodyStr,"\t上一页\n");
	loop(i,pager,pager+MAX_BOX_LIST)
	{
		if(i<DialogBoxID[playerid])
		{
		    index=DialogBox[playerid][i];
			format(TempStr,sizeof(TempStr),"%s\n",ReturnPlayerGameMailListStr(playerid,index));
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
FUNC::GetPlayerUnReadGameMails(playerid)//获取玩家未读消息数量
{
	new amount=0;
	foreach(new i:PlayerGameMail[playerid])
	{
	    if(PlayerGameMail[playerid][i][_Readed]==0)amount++;
	}
	return amount;
}
stock ReturnPlayerGameMailListStr(playerid,index)//返回玩家邮件单条新信息
{
	new BodyStr[128],TempStr[64];
	switch(PlayerGameMail[playerid][index][_Type])
	{
    	case GAMEMAIL_TYPE_SYSTEM:
    	{
    	    format(TempStr,sizeof(TempStr),"%s\t系统\t",GameMailTypeName[PlayerGameMail[playerid][index][_Type]]);
    	}
    	default:
    	{
    	    format(TempStr,sizeof(TempStr),"%s\t%s\t",GameMailTypeName[PlayerGameMail[playerid][index][_Type]],GetPlayerMySqlNameFromKey(PlayerGameMail[playerid][index][_SenderKey]));
    	}
	}
	strcat(BodyStr,TempStr);
	if(PlayerGameMail[playerid][index][_Cash]>0||strlen(PlayerGameMail[playerid][index][_ItemData])>3)
	{
	    strcat(BodyStr,"有\t");
	}
	else
	{
	    strcat(BodyStr,"无\t");
	}
	format(TempStr,sizeof(TempStr),"%s",PlayerGameMail[playerid][index][_SendTime]);
    strcat(BodyStr,TempStr);
    return BodyStr;
}
stock ShowPlayerGameMailInfo(playerid,index)//输出玩家邮件内容
{
    new BodyStr[2048],TempStr[128];

	switch(PlayerGameMail[playerid][index][_Type])
	{
		case GAMEMAIL_TYPE_FACTION_REQ:
		{
		    new SenderKey[37],FactionKey[37];
    		sscanf(PlayerGameMail[playerid][index][_ExtraData], "p<,>s[37]s[37]",SenderKey,FactionKey);
			format(TempStr,sizeof(TempStr),"%s 请求加入你的阵营\n是否同意?\n",GetPlayerMySqlNameFromKey(SenderKey));
			strcat(BodyStr,TempStr);
		}
		case GAMEMAIL_TYPE_FRIEND_REQ:
		{
			//format(TempStr,sizeof(TempStr),"%s 请求加你为好友\n是否同意?\n",GetPlayerMySqlNameFromKey(SenderKey));
			//strcat(BodyStr,TempStr);
		}
		case GAMEMAIL_TYPE_FACTION_INV:
		{
			new SenderKey[37],FactionKey[37];
    		sscanf(PlayerGameMail[playerid][index][_ExtraData], "p<,>s[37]s[37]",SenderKey,FactionKey);
			format(TempStr,sizeof(TempStr),"%s 邀请你加入他的阵营 %s\n是否同意?\n",GetPlayerMySqlNameFromKey(SenderKey),GetFactionFromKey(FactionKey));
			strcat(BodyStr,TempStr);
		}
		default:
		{
		    if(strlen(PlayerGameMail[playerid][index][_Content])>1)
		    {
			 	format(TempStr,sizeof(TempStr),"内容:\n%s\n",PlayerGameMail[playerid][index][_Content]);
			    strcat(BodyStr,TempStr);
			}
			else strcat(BodyStr,"\n");
		}
	}

	if(PlayerGameMail[playerid][index][_Cash]>0||strlen(PlayerGameMail[playerid][index][_ItemData])>3)
	{
	    strcat(BodyStr,"\n附件:\n");
	    if(PlayerGameMail[playerid][index][_Cash]>0)
	    {
			formatex32("金币:%i\n",PlayerGameMail[playerid][index][_Cash]);
    		strcat(BodyStr,string32);
	    }
	    if(strlen(PlayerGameMail[playerid][index][_ItemData])>3)
	    {
			formatex512("%s\n",ReturnGameMailItemDataStr(PlayerGameMail[playerid][index][_ItemData]));
    		strcat(BodyStr,string512);
    	}
	}
 	format(TempStr,sizeof(TempStr),"\n%s",PlayerGameMail[playerid][index][_SendTime]);
    strcat(BodyStr,TempStr);
    
 	format(TempStr,sizeof(TempStr),"发件人:%s",GetPlayerMySqlNameFromKey(PlayerGameMail[playerid][index][_SenderKey]));

	switch(PlayerGameMail[playerid][index][_Type])
	{
    	case GAMEMAIL_TYPE_FACTION_REQ,GAMEMAIL_TYPE_FRIEND_REQ,GAMEMAIL_TYPE_FACTION_INV:SPD(playerid,_SPD_GAMEMAIL_INFO,DIALOG_STYLE_MSGBOX,TempStr,BodyStr,"同意","返回");
        default:SPD(playerid,_SPD_GAMEMAIL_INFO,DIALOG_STYLE_MSGBOX,TempStr,BodyStr,"操作","返回");
	}
	
	if(PlayerGameMail[playerid][index][_Readed]==0)
	{
	    PlayerGameMail[playerid][index][_Readed]=1;
		formatex128("UPDATE `"MYSQL_DB_PLAYERGAMEMAIL"` SET `已读`=1 WHERE  `"MYSQL_DB_PLAYERGAMEMAIL"`.`邮件密匙` ='%s'",PlayerGameMail[playerid][index][_Key]);
		mysql_query(Account@Handle,string128,false);
	}
    return 1;
}

stock ReturnGameMailItemDataStr(itemdata[])//输出邮件内附件内容
{
	new index1=0,ThingKey[MAX_PLAYER_SENDGAMEMAIL_ITEMS][37],ThingAmount[MAX_PLAYER_SENDGAMEMAIL_ITEMS]=0,Float:ThingDurable[MAX_PLAYER_SENDGAMEMAIL_ITEMS]=0.0,Things[MAX_PLAYER_SENDGAMEMAIL_ITEMS];
	forex(i,MAX_PLAYER_SENDGAMEMAIL_ITEMS)Things[i]=NONE;
	new BodyStr[512],TempStr[64];
    forex(i,MAX_PLAYER_SENDGAMEMAIL_ITEMS)
    {
        format(BodyStr,512,StrtokPack1(itemdata,index1));
    	if(strval(string512)!=-1)
    	{
    	    new index2=0;
    	    format(ThingKey[i],37,StrtokPack2(BodyStr,index2));
    	    ThingAmount[i]=strval(StrtokPack2(BodyStr,index2));
    	    ThingDurable[i]=strval(StrtokPack2(BodyStr,index2));
    	    Things[i]=GetItemIDByItemKey(ThingKey[i]);
    	}
    }
    format(BodyStr,512,"");
    forex(i,MAX_PLAYER_SENDGAMEMAIL_ITEMS)
    {
		if(Things[i]!=NONE&&ThingAmount[i]>0)
		{
		    if(Item[Things[i]][_Durable]==0)
		    {
		        format(TempStr,sizeof(TempStr),"%s 数量:%i\n",Item[Things[i]][_Name],ThingAmount[i]);
	    		strcat(BodyStr,TempStr);
		    }
		    else
		    {
	 			format(TempStr,sizeof(TempStr),"%s 数量:%i 耐久:%0.1f\n",Item[Things[i]][_Name],ThingAmount[i],ThingDurable[i]);
	    		strcat(BodyStr,TempStr);
    		}
		}
    }
    return BodyStr;
}

FUNC::ExtractGameMailAttachment(playerid,index,itemdata[])//提取邮件内附件内容
{
	if(PlayerGameMail[playerid][index][_Cash]>0)
	{
		formatex128("UPDATE `"MYSQL_DB_PLAYERGAMEMAIL"` SET `金币`=0 WHERE  `"MYSQL_DB_PLAYERGAMEMAIL"`.`邮件密匙` ='%s'",PlayerGameMail[playerid][index][_Key]);
		mysql_query(Account@Handle,string128,false);
		new MailCash=PlayerGameMail[playerid][index][_Cash];
		Account[playerid][_Cash]+=MailCash;
	    PlayerGameMail[playerid][index][_Cash]=0;
	    formatex128("UPDATE `"MYSQL_DB_ACCOUNT"` SET  `金钱`='%i' WHERE  `"MYSQL_DB_ACCOUNT"`.`密匙` ='%s'",Account[playerid][_Cash],Account[playerid][_Key]);
		mysql_query(Account@Handle,string128,false);
        formatex64("$%i 提取成功",MailCash);
		SCM(playerid,-1,string64);
	}
	if(strlen(PlayerGameMail[playerid][index][_ItemData])>3)
	{
		new index1=0,ThingKey[MAX_PLAYER_SENDGAMEMAIL_ITEMS][37],ThingAmount[MAX_PLAYER_SENDGAMEMAIL_ITEMS]=0,Float:ThingDurable[MAX_PLAYER_SENDGAMEMAIL_ITEMS]=0.0,Things[MAX_PLAYER_SENDGAMEMAIL_ITEMS];
		forex(i,MAX_PLAYER_SENDGAMEMAIL_ITEMS)Things[i]=NONE;
		new BodyStr[512];
	    forex(i,MAX_PLAYER_SENDGAMEMAIL_ITEMS)
	    {
	        format(BodyStr,512,StrtokPack1(itemdata,index1));
	    	if(strval(string512)!=-1)
	    	{
	    	    new index2=0;
	    	    format(ThingKey[i],37,StrtokPack2(BodyStr,index2));
	    	    ThingAmount[i]=strval(StrtokPack2(BodyStr,index2));
	    	    ThingDurable[i]=strval(StrtokPack2(BodyStr,index2));
	    	    Things[i]=GetItemIDByItemKey(ThingKey[i]);
	    	}
	    }
	    format(BodyStr,512,"");
	    new UnExtractBodyStr[512],UnExtractTempStr[64];
	    format(UnExtractBodyStr,512,"");
	    format(UnExtractTempStr,64,"");
	    forex(i,MAX_PLAYER_SENDGAMEMAIL_ITEMS)
	    {
			if(Things[i]!=NONE&&ThingAmount[i]>0)
			{
                if(AddItemToPlayerInv(playerid,ThingKey[i],ThingAmount[i],ThingDurable[i],SERVER_RUNTIMES,true)==RETURN_SUCCESS)
                {
                    formatex64("道具 %s %i个 耐久:%0.1f 提取成功",Item[Things[i]][_Name],ThingAmount[i],ThingDurable[i]);
					SCM(playerid,-1,string64);
                }
                else
                {
                    format(UnExtractTempStr,64,"%s,%i,%0.1f&",ThingKey[i],ThingAmount[i],ThingDurable[i]);
                    strcat(UnExtractBodyStr,UnExtractTempStr);
                    formatex128("道具 %s %i个 耐久:%0.1f 提取失败[原因:背包已满或超重]",Item[Things[i]][_Name],ThingAmount[i],ThingDurable[i]);
					SCM(playerid,-1,string128);
                }
			}
	    }
	    format(PlayerGameMail[playerid][index][_ItemData],512,UnExtractBodyStr);
	    printf("%s",UnExtractBodyStr);
		formatex512("UPDATE `"MYSQL_DB_PLAYERGAMEMAIL"` SET `道具数据`='%s' WHERE  `"MYSQL_DB_PLAYERGAMEMAIL"`.`邮件密匙` ='%s'",UnExtractBodyStr,PlayerGameMail[playerid][index][_Key]);
		mysql_query(Account@Handle,string512,false);
	}
	return 1;
}


CMD:sm(playerid, params[])
{
    new Content[256],Cash,Itemdata[512];
	if(sscanf(params, "p<,>s[256]is[512]",Content,Cash,Itemdata))return SCM(playerid,-1,"/sm 内容 钱 道具数据");
    SendMailToPlayer(Account[playerid][_Key],Account[playerid][_Key],GAMEMAIL_TYPE_PLAYER,Content,Cash,Itemdata,"-1",SERVER_RUNTIMES);
//    SendGameMailToOnlPlayer(Account[SenderID][_Key],Account[SenderID][_Key],GAMEMAIL_TYPE_PLAYER,Content,Cash,Itemdata,"-1",SERVER_RUNTIMES);
	return 1;
}
CMD:mail(playerid, params[])
{
	formatex64(GAMEMAIL_PANEL,GetPlayerUnReadGameMails(playerid));
	SPD(playerid,_SPD_GAMEMAIL_PANEL,DIALOG_STYLE_LIST,"邮箱系统",string64,"选择","取消");
	return 1;
}
//forex(i,MAX_PLAYER_SENDGAMEMAIL_ITEMS)NewMailItem[playerid][i][_Used]=false;
//NewMailCash[playerid]=0;
//format(NewMailContent[playerid],256,"");

stock ShowPlayerGameMailCreate(playerid)//输出玩家新建邮件信息
{
    new BodyStr[1024],TempStr[128];
	format(TempStr,sizeof(TempStr),"◆操作完毕,发送邮件◆\n");//0行
    strcat(BodyStr,TempStr);
    if(strlen(NewMailReceiverKey[playerid])>3)
    {
		format(TempStr,sizeof(TempStr),"收件人:%s\n",GetPlayerMySqlNameFromKey(NewMailReceiverKey[playerid]));
	}
	else
	{
		format(TempStr,sizeof(TempStr),"收件人:\n");
	}
    strcat(BodyStr,TempStr);//1行
    strcat(BodyStr,"↓内容编辑↓\n");//2行
    if(strlen(NewMailContent[playerid])>32)
    {
	    new ContentEx[64];
	    strmid(ContentEx,NewMailContent[playerid], 0, 32);
	    format(TempStr,sizeof(TempStr),"%s...\n",ContentEx);
    }
    else
	{
	    if(strlen(NewMailContent[playerid])<1)format(TempStr,sizeof(TempStr),"未编辑\n");
		else format(TempStr,sizeof(TempStr),"%s\n",NewMailContent[playerid]);
    }
    strcat(BodyStr,TempStr);//3行
    format(TempStr,sizeof(TempStr),"金币附件:$%i\n",NewMailCash[playerid]);
    strcat(BodyStr,TempStr);//5行
    strcat(BodyStr,"↓道具附件↓\n");//6行
    new Rate=0;
    forex(i,MAX_PLAYER_SENDGAMEMAIL_ITEMS)
    {
        if(NewMailItem[playerid][i][_Used]==true)
        {
	 		format(TempStr,sizeof(TempStr),"　%s 数量:%i 耐久:%0.1f\n",Item[NewMailItem[playerid][i][_ItemID]][_Name],NewMailItem[playerid][i][_Amount],NewMailItem[playerid][i][_Durable]);
            strcat(BodyStr,TempStr);
			Rate++;
		}
	}
    if(Rate==0)strcat(BodyStr, "→添加道具");
    else strcat(BodyStr, "→清除道具");
    return BodyStr;
}

FUNC::GameMail_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case _SPD_GAMEMAIL_SEND_NAME://设置接收者
        {
            if(!response)
			{
			    formatex64("发送邮件 类型:%s",GameMailTypeName[NewMailType[playerid]]);
				return SPD(playerid,_SPD_GAMEMAIL_SEND,DIALOG_STYLE_LIST,string64,ShowPlayerGameMailCreate(playerid),"确定","取消");
            }
            if(strlen(inputtext)<1||strlen(inputtext)>32)return SPD(playerid,_SPD_GAMEMAIL_SEND_NAME,DIALOG_STYLE_INPUT,"接收者","字符输入错误\n请重新输入接收者的名字或ID","确定","取消");
			if(isDigit(inputtext))
			{
			    if(!RealPlayer(strval(inputtext)))return SPD(playerid,_SPD_GAMEMAIL_SEND_NAME,DIALOG_STYLE_INPUT,"接收者","该ID当前不在线\n请重新输入接收者的名字或ID","确定","取消");
                format(NewMailReceiverKey[playerid],UUID_LEN,Account[strval(inputtext)][_Key]);
                formatex64("发送邮件 类型:%s",GameMailTypeName[NewMailType[playerid]]);
                SPD(playerid,_SPD_GAMEMAIL_SEND,DIALOG_STYLE_LIST,string64,ShowPlayerGameMailCreate(playerid),"确定","取消");
                return true;
			}
			else
			{
			    new PlayerKey[37];
			    format(PlayerKey,UUID_LEN,GetPlayerMySqlKeyFromName(inputtext));
			    if(isequal(PlayerKey,"null",false))return SPD(playerid,_SPD_GAMEMAIL_SEND_NAME,DIALOG_STYLE_INPUT,"接收者","没有搜索到,该名字可能没有注册\n请重新输入接收者的名字或ID","确定","取消");
			    else
			    {
			        format(NewMailReceiverKey[playerid],UUID_LEN,PlayerKey);
			        formatex64("发送邮件 类型:%s",GameMailTypeName[NewMailType[playerid]]);
			        SPD(playerid,_SPD_GAMEMAIL_SEND,DIALOG_STYLE_LIST,string64,ShowPlayerGameMailCreate(playerid),"确定","取消");
                    return true;
				}
			}
        }
        case _SPD_GAMEMAIL_SEND_CONTENT://设置文字内容
        {
            if(!response)
			{
			    formatex64("发送邮件 类型:%s",GameMailTypeName[NewMailType[playerid]]);
				return SPD(playerid,_SPD_GAMEMAIL_SEND,DIALOG_STYLE_LIST,string64,ShowPlayerGameMailCreate(playerid),"确定","取消");
			}
		    if(strlen(inputtext)<0||strlen(inputtext)>128)return SPD(playerid,_SPD_GAMEMAIL_SEND_CONTENT,DIALOG_STYLE_INPUT,"发送内容","字符数量过大或过小\n请输入发送内容最大64个汉字或128个字符","确定","取消");
	        format(NewMailContent[playerid],256,inputtext);
	        formatex64("发送邮件 类型:%s",GameMailTypeName[NewMailType[playerid]]);
	        SPD(playerid,_SPD_GAMEMAIL_SEND,DIALOG_STYLE_LIST,string64,ShowPlayerGameMailCreate(playerid),"确定","取消");
            return true;
        }
        case _SPD_GAMEMAIL_SEND_CASH://设置金币附件
        {
            if(!response)
			{
			    formatex64("发送邮件 类型:%s",GameMailTypeName[NewMailType[playerid]]);
				return SPD(playerid,_SPD_GAMEMAIL_SEND,DIALOG_STYLE_LIST,string64,ShowPlayerGameMailCreate(playerid),"确定","取消");
			}
			if(strval(inputtext)<0||strval(inputtext)>Account[playerid][_Cash])
			{
				formatex128("你输入的数量超出你当前拥有的\n你当前有$%i金币\n请输入发送的金币数量",Account[playerid][_Cash]);
				return SPD(playerid,_SPD_GAMEMAIL_SEND_CASH,DIALOG_STYLE_INPUT,"金币附件",string128,"确定","取消");
			}
			else
			{
			    NewMailCash[playerid]=strval(inputtext);
			    formatex64("发送邮件 类型:%s",GameMailTypeName[NewMailType[playerid]]);
				SPD(playerid,_SPD_GAMEMAIL_SEND,DIALOG_STYLE_LIST,string64,ShowPlayerGameMailCreate(playerid),"确定","取消");
            	return true;
			}
        }
        case _SPD_GAMEMAIL_SEND://邮件编辑主界面
        {
            if(!response)return true;
            if(listitem<=5)
            {
	            switch(listitem)
	            {
	                case 0:
	                {
               	 		if(SendGameMail(playerid)==true)
                        {
                            SCM(playerid,-1,"邮件发送成功");
                            RestPlayerTempMailData(playerid);
                        }
                        else
                        {
  		 					formatex64("发送邮件 类型:%s",GameMailTypeName[NewMailType[playerid]]);
	                    	SPD(playerid,_SPD_GAMEMAIL_SEND,DIALOG_STYLE_LIST,string64,ShowPlayerGameMailCreate(playerid),"确定","取消");
                        }
	                }
	                case 1:
	                {
	                    SPD(playerid,_SPD_GAMEMAIL_SEND_NAME,DIALOG_STYLE_INPUT,"接收者","请输入接收者的名字或ID","确定","取消");
	                }
	                case 2:
	                {
	                    formatex64("发送邮件 类型:%s",GameMailTypeName[NewMailType[playerid]]);
	                    SPD(playerid,_SPD_GAMEMAIL_SEND,DIALOG_STYLE_LIST,string64,ShowPlayerGameMailCreate(playerid),"确定","取消");
	                }
	                case 3:
	                {
						SPD(playerid,_SPD_GAMEMAIL_SEND_CONTENT,DIALOG_STYLE_INPUT,"邮件内容","请输入发送内容最大64个汉字或128个字符","确定","取消");
	                }
	                case 4:
	                {
	                    formatex128("你当前有$%i金币\n请输入发送的金币数量",Account[playerid][_Cash]);
						SPD(playerid,_SPD_GAMEMAIL_SEND_CASH,DIALOG_STYLE_INPUT,"金币附件",string128,"确定","取消");
	                }
	                case 5:
	                {
	                    formatex64("发送邮件 类型:%s",GameMailTypeName[NewMailType[playerid]]);
	                    SPD(playerid,_SPD_GAMEMAIL_SEND,DIALOG_STYLE_LIST,string64,ShowPlayerGameMailCreate(playerid),"确定","取消");
	                }
	            }
			}
			else
			{
			    new Rate=1;
			    forex(i,MAX_PLAYER_SENDGAMEMAIL_ITEMS)
			    {
			        if(NewMailItem[playerid][i][_Used]==true)Rate++;
				}
				if(listitem==5+Rate)
				{
					if(Rate==1)
					{
					    forex(s,MAX_DIALOG_BOX_ITEMS)
					    {
					    	DialogBoxInvSelect[playerid][s]=false;
                            DialogBoxInvAmount[playerid][s]=0;
						}
						SPD(playerid,_SPD_GAMEMAIL_SEND_ITEM,DIALOG_STYLE_TABLIST_HEADERS,"选择背包内道具[可多选]",ShowPlayerInventoryList(playerid,1),"选择","取消");
					}
					else
					{
					    forex(i,MAX_PLAYER_SENDGAMEMAIL_ITEMS)NewMailItem[playerid][i][_Used]=false;
					    formatex64("发送邮件 类型:%s",GameMailTypeName[NewMailType[playerid]]);
						SPD(playerid,_SPD_GAMEMAIL_SEND,DIALOG_STYLE_LIST,string64,ShowPlayerGameMailCreate(playerid),"确定","取消");
					}
				}
			}
			return true;
        }
        case _SPD_GAMEMAIL_SEND_ITEM://邮件背包附件添加界面
        {
            if(!response)return true;
			new pager=(DialogPage[playerid]-1)*MAX_BOX_LIST;
			if(pager==0)pager = 1;
			else pager++;
			switch(listitem)
			{
			    case 0:
			    {
			        new Rate=0;
			        forex(i,MAX_DIALOG_BOX_ITEMS)
					{
						if(DialogBoxInvSelect[playerid][i]==true)
						{
						    formatex64("%i,%s,%i",DialogBox[playerid][i],DialogBoxKey[playerid][i],0);
						    if(VerifyPlayerGameMailInvPVarData(playerid,string64))
						    {
						        format(NewMailItem[playerid][Rate][_InvKey],37,PlayerInv[playerid][DialogBox[playerid][i]][_InvKey]);
							    NewMailItem[playerid][Rate][_Amount]=DialogBoxInvAmount[playerid][i];
							    NewMailItem[playerid][Rate][_Durable]=PlayerInv[playerid][DialogBox[playerid][i]][_Durable];
							    NewMailItem[playerid][Rate][_ItemID]=PlayerInv[playerid][DialogBox[playerid][i]][_ItemID];
							    NewMailItem[playerid][Rate][_Used]=true;
							    Rate++;
						    }
      					}
                    }
                    forex(i,MAX_DIALOG_BOX_ITEMS)
					{
						DialogBoxInvSelect[playerid][i]=false;
						DialogBoxInvAmount[playerid][i]=0;
					}
                    formatex64("发送邮件 类型:%s",GameMailTypeName[NewMailType[playerid]]);
                    SPD(playerid,_SPD_GAMEMAIL_SEND,DIALOG_STYLE_LIST,string64,ShowPlayerGameMailCreate(playerid),"确定","取消");
			    }
			    case 1:
			  	{
			    	DialogPage[playerid]--;
			    	if(DialogPage[playerid]<1)DialogPage[playerid]=1;
			    	SPD(playerid,_SPD_GAMEMAIL_SEND_ITEM,DIALOG_STYLE_TABLIST_HEADERS,"选择背包内道具[可多选]",ShowPlayerInventoryList(playerid,DialogPage[playerid]),"选择","取消");
				}
				case MAX_BOX_LIST+1:
				{
		    		DialogPage[playerid]++;
		    		SPD(playerid,_SPD_GAMEMAIL_SEND_ITEM,DIALOG_STYLE_TABLIST_HEADERS,"选择背包内道具[可多选]",ShowPlayerInventoryList(playerid,DialogPage[playerid]),"选择","取消");
			    }
				default:
				{
					new index=DialogBox[playerid][pager+listitem-2];
                    if(DialogBoxInvSelect[playerid][pager+listitem-2]==true)
                    {
                        DialogBoxInvSelect[playerid][pager+listitem-2]=false;
                        DialogBoxInvAmount[playerid][pager+listitem-2]=0;
                        SPD(playerid,_SPD_GAMEMAIL_SEND_ITEM,DIALOG_STYLE_TABLIST_HEADERS,"选择背包内道具[可多选]",ShowPlayerInventoryList(playerid,DialogPage[playerid]),"选择","取消");
                    }
                    else
                    {
						if(GetPlayerInvBoxSelectAmount(playerid)>=MAX_PLAYER_SENDGAMEMAIL_ITEMS)
						{
		                	SPD(playerid,_SPD_GAMEMAIL_SEND_ITEM,DIALOG_STYLE_TABLIST_HEADERS,"选择背包内道具[最多5个]",ShowPlayerInventoryList(playerid,DialogPage[playerid]),"选择","取消");
						}
						else
						{
							if(PlayerInv[playerid][index][_Amounts]>1)
							{
		                    	formatex128("你当前有%i个%s\n请输入寄送该道具的数量",PlayerInv[playerid][index][_Amounts],Item[PlayerInv[playerid][index][_ItemID]][_Name]);
								SPD(playerid,_SPD_GAMEMAIL_SEND_ITEM_AMOUNT,DIALOG_STYLE_INPUT,"道具数量设置",string128,"确定","取消");
	                 			formatex64("%i,%s,%i",index,DialogBoxKey[playerid][pager+listitem-2],pager+listitem-2);
								printf("%s",string64);
								SetPVarString(playerid,"_MailInv_Click_Info",string64);
							}
							else
							{
							    DialogBoxInvSelect[playerid][pager+listitem-2]=true;
	    						DialogBoxInvAmount[playerid][pager+listitem-2]=1;
	   							SPD(playerid,_SPD_GAMEMAIL_SEND_ITEM,DIALOG_STYLE_TABLIST_HEADERS,"选择背包内道具[可多选]",ShowPlayerInventoryList(playerid,DialogPage[playerid]),"选择","取消");
	           				}
           				}
					}
				}
			}
			return true;
        }
        case _SPD_GAMEMAIL_SEND_ITEM_AMOUNT://设置背包附件数量
        {
            if(!response)return SPD(playerid,_SPD_GAMEMAIL_SEND_ITEM,DIALOG_STYLE_TABLIST_HEADERS,"选择背包内道具[可多选]",ShowPlayerInventoryList(playerid,DialogPage[playerid]),"选择","取消");
            else
            {
                new VarString[64];
 				GetPVarString(playerid,"_MailInv_Click_Info",VarString,64);
                if(VerifyPlayerGameMailInvPVarData(playerid,VarString)==true)
                {
                    new InvID,BoxKey[37],Listid;
    				sscanf(VarString, "p<,>is[37]i",InvID,BoxKey,Listid);
                    if(strval(inputtext)<1||strval(inputtext)>PlayerInv[playerid][InvID][_Amounts])
                    {
                        formatex128("你当前有%i个%s\n请输入寄送该道具的数量",PlayerInv[playerid][InvID][_Amounts],Item[PlayerInv[playerid][InvID][_ItemID]][_Name]);
						SPD(playerid,_SPD_GAMEMAIL_SEND_ITEM_AMOUNT,DIALOG_STYLE_INPUT,"道具数量设置",string128,"确定","取消");
					}
					else
					{
					    DialogBoxInvSelect[playerid][Listid]=true;
   						DialogBoxInvAmount[playerid][Listid]=strval(inputtext);
   						SPD(playerid,_SPD_GAMEMAIL_SEND_ITEM,DIALOG_STYLE_TABLIST_HEADERS,"选择背包内道具[可多选]",ShowPlayerInventoryList(playerid,DialogPage[playerid]),"选择","取消");
					}
                }
                //else SPD(playerid,_SPD_GAMEMAIL_SEND_ITEM,DIALOG_STYLE_TABLIST_HEADERS,"选择背包内道具[可多选]",ShowPlayerInventoryList(playerid,1),"选择","取消");
            }
            return true;
        }
        case _SPD_GAMEMAIL_PANEL://邮箱主界面
        {
            if(!response)return true;
            switch(listitem)
			{
				case 0:
  				{
  				    RestPlayerTempMailData(playerid);
					formatex64("发送邮件 类型:%s",GameMailTypeName[NewMailType[playerid]]);
  				    SPD(playerid,_SPD_GAMEMAIL_SEND,DIALOG_STYLE_LIST,string64,ShowPlayerGameMailCreate(playerid),"确定","取消");
				}
				case 1:
  				{
		    		formatex64("邮件箱[共计%i封 %i未读]",Iter_Count(PlayerGameMail[playerid]),GetPlayerUnReadGameMails(playerid));
					SPD(playerid,_SPD_GAMEMAIL_LIST,DIALOG_STYLE_TABLIST_HEADERS,string64,ShowPlayerGameMails(playerid,1),"打开","取消");
  				}
            }
        }
        case _SPD_GAMEMAIL_SET://邮件操作主界面
        {
            if(!response)return true;
			new VarString[64];
 			GetPVarString(playerid,"_Select_GameMail_Info",VarString,64);
			if(VerifyPlayerGameMailPVarData(playerid,string64)==true)
            {
                new index,indexKey[37];
    			sscanf(VarString, "p<,>is[37]",index,indexKey);
                switch(listitem)
				{
			    	case 0:
			  		{
                        RestPlayerTempMailData(playerid);
                        format(NewMailReceiverKey[playerid],37,PlayerGameMail[playerid][index][_SenderKey]);
						formatex64("发送邮件 类型:%s",GameMailTypeName[NewMailType[playerid]]);
  				    	SPD(playerid,_SPD_GAMEMAIL_SEND,DIALOG_STYLE_LIST,string64,ShowPlayerGameMailCreate(playerid),"确定","取消");
			  		}
			    	case 1:
			  		{
			  		    ExtractGameMailAttachment(playerid,index,PlayerGameMail[playerid][index][_ItemData]);
			  		}
			    	case 2:
			  		{
						formatex128("DELETE FROM `"MYSQL_DB_PLAYERGAMEMAIL"` WHERE `邮件密匙` = '%s'",PlayerGameMail[playerid][index][_Key]);
						mysql_query(Account@Handle,string128,false);
					    Iter_Remove(PlayerGameMail[playerid],index);
			  		}
			    	case 3:
			  		{
						formatex128("DELETE FROM `"MYSQL_DB_PLAYERGAMEMAIL"` WHERE `收件人密匙` = '%s'",PlayerGameMail[playerid][index][_ReceiverKey]);
						mysql_query(Account@Handle,string128,false);
					    Iter_Clear(PlayerGameMail[playerid]);
			  		}
				}
            }
        }
        case _SPD_GAMEMAIL_INFO://邮件内容展示
        {
            if(!response)return true;
			new VarString[64];
 			GetPVarString(playerid,"_Select_GameMail_Info",VarString,64);
			if(VerifyPlayerGameMailPVarData(playerid,string64)==true)
            {
                new index,indexKey[37];
    			sscanf(VarString, "p<,>is[37]",index,indexKey);
    			PlayerGameMailTypeProcess(playerid,index);
           	}
           	return true;
        }
        case _SPD_GAMEMAIL_LIST://邮件列表
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
			    	formatex64("邮件箱[共计%i封 %i未读]",Iter_Count(PlayerGameMail[playerid]),GetPlayerUnReadGameMails(playerid));
			    	SPD(playerid,_SPD_GAMEMAIL_LIST,DIALOG_STYLE_TABLIST_HEADERS,string64,ShowPlayerGameMails(playerid,DialogPage[playerid]),"打开","取消");
				}
				case MAX_BOX_LIST+1:
				{
		    		DialogPage[playerid]++;
		    		formatex64("邮件箱[共计%i封 %i未读]",Iter_Count(PlayerGameMail[playerid]),GetPlayerUnReadGameMails(playerid));
					SPD(playerid,_SPD_GAMEMAIL_LIST,DIALOG_STYLE_TABLIST_HEADERS,string64,ShowPlayerGameMails(playerid,DialogPage[playerid]),"打开","取消");
			    }
				default:
				{
					new index=DialogBox[playerid][pager+listitem-1];
                    formatex64("%i,%s",index,DialogBoxKey[playerid][pager+listitem-1]);
                    if(VerifyPlayerGameMailPVarData(playerid,string64)==true)
                    {
                        ShowPlayerGameMailInfo(playerid,index);
                        SetPVarString(playerid,"_Select_GameMail_Info",string64);
                   	}
				}
			}
			return true;
        }
    }
    return false;
}
FUNC::PlayerGameMailTypeProcess(playerid,index)
{
	switch(PlayerGameMail[playerid][index][_Type])
	{
		case GAMEMAIL_TYPE_FACTION_REQ:
		{
			new SenderKey[37],FactionKey[37];
    		sscanf(PlayerGameMail[playerid][index][_ExtraData], "p<,>s[37]s[37]",SenderKey,FactionKey);
    		new FactionID=GetPlayerFactionID(playerid);
            if(FactionID==NONE)
            {
				formatex128("DELETE FROM `"MYSQL_DB_PLAYERGAMEMAIL"` WHERE `邮件密匙` = '%s'",PlayerGameMail[playerid][index][_Key]);
				mysql_query(Account@Handle,string128,false);
			    Iter_Remove(PlayerGameMail[playerid],index);
			    return SCM(playerid,-1,"你已经不在阵营里了,该条邮件自动失效!");
            }
			if(!Iter_Contains(Faction,FactionID))
			{
				formatex128("DELETE FROM `"MYSQL_DB_PLAYERGAMEMAIL"` WHERE `邮件密匙` = '%s'",PlayerGameMail[playerid][index][_Key]);
				mysql_query(Account@Handle,string128,false);
			    Iter_Remove(PlayerGameMail[playerid],index);
			    return SCM(playerid,-1,"该阵营失效了,该条邮件自动失效!");
			}
            if(!isequal(Faction[FactionID][_Key],FactionKey,false))
            {
				formatex128("DELETE FROM `"MYSQL_DB_PLAYERGAMEMAIL"` WHERE `邮件密匙` = '%s'",PlayerGameMail[playerid][index][_Key]);
				mysql_query(Account@Handle,string128,false);
			    Iter_Remove(PlayerGameMail[playerid],index);
			    return SCM(playerid,-1,"你已经更换阵营了,该条邮件自动失效!");
            }
            if(!isequal(GetPlayerMySqlFactionFromKey(SenderKey),"null",false))
            {
				formatex128("DELETE FROM `"MYSQL_DB_PLAYERGAMEMAIL"` WHERE `邮件密匙` = '%s'",PlayerGameMail[playerid][index][_Key]);
				mysql_query(Account@Handle,string128,false);
			    Iter_Remove(PlayerGameMail[playerid],index);
		    	formatex64("%s 已经有阵营了,该条邮件自动失效!",GetPlayerMySqlNameFromKey(SenderKey));
			    return SCM(playerid,-1,string64);
            }
            formatex64("%s 批准你加入 %s 阵营了!",Account[playerid][_Name],Faction[FactionID][_Name]);
            SendMailToPlayer("null",PlayerGameMail[playerid][index][_SenderKey],GAMEMAIL_TYPE_SYSTEM,string64,0,"","",SERVER_RUNTIMES);
			formatex128("DELETE FROM `"MYSQL_DB_PLAYERGAMEMAIL"` WHERE `邮件密匙` = '%s'",PlayerGameMail[playerid][index][_Key]);
			mysql_query(Account@Handle,string128,false);
		    Iter_Remove(PlayerGameMail[playerid],index);
		    formatex64("你批准 %s 加入阵营了!",GetPlayerMySqlNameFromKey(SenderKey));
		    SCM(playerid,-1,string64);
		    return 1;
		}
		case GAMEMAIL_TYPE_FRIEND_REQ:
		{

		}
		case GAMEMAIL_TYPE_FACTION_INV:
		{
			new SenderKey[37],FactionKey[37];
    		sscanf(PlayerGameMail[playerid][index][_ExtraData], "p<,>s[37]s[37]",SenderKey,FactionKey);
  			new FactionID=GetPlayerFactionID(playerid);
            if(FactionID!=NONE)
            {
				formatex128("DELETE FROM `"MYSQL_DB_PLAYERGAMEMAIL"` WHERE `邮件密匙` = '%s'",PlayerGameMail[playerid][index][_Key]);
				mysql_query(Account@Handle,string128,false);
			    Iter_Remove(PlayerGameMail[playerid],index);
			    return SCM(playerid,-1,"你已经加入阵营或其他阵营了");
            }
            new JoinFactionID=GetFactionIDKey(FactionKey);
            if(JoinFactionID==NONE)
            {
				formatex128("DELETE FROM `"MYSQL_DB_PLAYERGAMEMAIL"` WHERE `邮件密匙` = '%s'",PlayerGameMail[playerid][index][_Key]);
				mysql_query(Account@Handle,string128,false);
			    Iter_Remove(PlayerGameMail[playerid],index);
			    return SCM(playerid,-1,"该阵营失效了,无法加入");            	
            }
            if(GetFactionNumberOfPeople(Faction[JoinFactionID][_Key])>=(Faction[JoinFactionID][_Level]+1)*5) 
            {
				formatex128("DELETE FROM `"MYSQL_DB_PLAYERGAMEMAIL"` WHERE `邮件密匙` = '%s'",PlayerGameMail[playerid][index][_Key]);
				mysql_query(Account@Handle,string128,false);
			    Iter_Remove(PlayerGameMail[playerid],index);
			    return SCM(playerid,-1,"该阵营已达到人数上限,无法加入");              	
            } 	
            SetPlayerToFaction(playerid,FactionKey,JoinFactionID,0,0);
            formatex64("你成功加入了阵营%s",Faction[JoinFactionID][_Name]);
            SCM(playerid,-1,string64);     
		}
		default:SPD(playerid,_SPD_GAMEMAIL_SET,DIALOG_STYLE_LIST,"邮件操作",GAMEMAIL_USE_PANEL,"确定","取消");
	}
	return 1;
}
FUNC::bool:VerifyPlayerGameMailPVarData(playerid,VarString[])//验证邮件数据
{
	new GameMailID,GameMailKey[37];
    if(sscanf(VarString, "p<,>is[37]",GameMailID,GameMailKey))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#0]","对话框数据验证失败,请重新选择","了解","");
        return false;
	}
	if(!Iter_Contains(PlayerGameMail[playerid],GameMailID))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#1]","该数据已失效,请重新选择","了解","");
        return false;
	}
    if(!isequal(PlayerGameMail[playerid][GameMailID][_Key],GameMailKey,false))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#2]","对话框数据验证失败,请重新选择","了解","");
        return false;
	}
	return true;
}
FUNC::bool:VerifyPlayerGameMailInvPVarData(playerid,VarString[])//验证邮件背包数据
{
	new InvID,BoxKey[37],Listid;
    if(sscanf(VarString, "p<,>is[37]i",InvID,BoxKey,Listid))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#0]","对话框数据验证失败,请重新选择","了解","");
        return false;
	}
	if(!Iter_Contains(PlayerInv[playerid],InvID))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#1]","该数据已失效,请重新选择","了解","");
        return false;
	}
	printf("%s %s",PlayerInv[playerid][InvID][_InvKey],BoxKey);
    if(!isequal(PlayerInv[playerid][InvID][_InvKey],BoxKey,false))
	{
		SPD(playerid,_SPD_ERROR,DIALOG_STYLE_MSGBOX,"错误[#2]","对话框数据验证失败,请重新选择","了解","");
        return false;
	}
	return true;
}
/*			  		    forex(i,MAX_DIALOG_BOX_ITEMS)
					    {
					        if(DialogBoxInvSelect[playerid][i]==true)
					        {
					        	if(VerifyPlayerGameMailItemData(playerid,i))
					        	{

					        	}
							}
						}*/
FUNC::bool:SendGameMail(playerid)//编辑邮件完成发送邮件步骤
{
    if(strlen(NewMailReceiverKey[playerid])<1)
	{
	    SCM(playerid,-1,"你还没有填写收件人");
		return false;
	}
    if(NewMailCash[playerid]>Account[playerid][_Cash])
	{
	    SCM(playerid,-1,"你还没有那么多金币");
		return false;
	}
	else
	{
	    Account[playerid][_Cash]-=NewMailCash[playerid];
	    UpdateAccountCash(playerid,Account[playerid][_Cash]);
	}
	new BodyStr[512],TempStr[64];
    format(BodyStr,512,"");
    format(TempStr,64,"");
	forex(i,MAX_PLAYER_SENDGAMEMAIL_ITEMS)
    {
        if(NewMailItem[playerid][i][_Used]==true)
        {
        	if(VerifyPlayerGameMailItemData(playerid,i))
        	{
				format(TempStr,64,"%s,%i,%0.1f&",Item[NewMailItem[playerid][i][_ItemID]][_Key],NewMailItem[playerid][i][_Amount],NewMailItem[playerid][i][_Durable]);
                strcat(BodyStr,TempStr);
                DeleteAmountForInvByInvKey(playerid,NewMailItem[playerid][i][_InvKey],NewMailItem[playerid][i][_Amount]);
        	}
        	else
        	{
        	    formatex64("%s 发送失败",Item[NewMailItem[playerid][i][_ItemID]][_Name]);
        	    SCM(playerid,-1,string64);
        	}
		}
	}
	if(SendMailToPlayer(Account[playerid][_Key],NewMailReceiverKey[playerid],NewMailType[playerid],NewMailContent[playerid],NewMailCash[playerid],BodyStr,"-1",SERVER_RUNTIMES)!=RETURN_SUCCESS)
	{
	    SCM(playerid,-1,"投递失败,对方邮箱已满");
	    return false;
	}
/*    new ReceiveID=GetPlayerIDByKey(NewMailReceiverKey[playerid]);
	if(ReceiveID==NONE)
	{
		if(SendGameMailToOffLPlayer(Account[playerid][_Key],NewMailReceiverKey[playerid],NewMailType[playerid],NewMailContent[playerid],NewMailCash[playerid],BodyStr,"-1",SERVER_RUNTIMES)!=RETURN_SUCCESS)
		{
		    SCM(playerid,-1,"投递失败,对方邮箱已满");
		    return false;
		}
	}
	else
	{
		if(SendGameMailToOnlPlayer(playerid,ReceiveID,NewMailType[playerid],NewMailContent[playerid],NewMailCash[playerid],BodyStr,"-1",SERVER_RUNTIMES)!=RETURN_SUCCESS)
		{
		    SCM(playerid,-1,"投递失败,对方邮箱已满");
      		return false;
		}
	}*/
	return true;
}
FUNC::RestPlayerTempMailData(playerid)
{
	forex(i,MAX_PLAYER_SENDGAMEMAIL_ITEMS)NewMailItem[playerid][i][_Used]=false;
	NewMailType[playerid]=GAMEMAIL_TYPE_PLAYER;
	NewMailCash[playerid]=0;
	format(NewMailContent[playerid],256,"");
	format(NewMailReceiverKey[playerid],37,"");
	forex(i,MAX_DIALOG_BOX_ITEMS)
	{
		DialogBoxInvSelect[playerid][i]=false;
		DialogBoxInvAmount[playerid][i]=0;
	}
	return 1;
}
FUNC::bool:VerifyPlayerGameMailItemData(playerid,index)//验证临时编辑邮件状态数据
{
	if(NewMailItem[playerid][index][_Used]==false)return false;
	new InvID=GetPlayerInvIDByInvKey(playerid,NewMailItem[playerid][index][_InvKey]);
	if(InvID==NONE)return false;
	if(PlayerInv[playerid][InvID][_Amounts]<NewMailItem[playerid][index][_Amount])return false;
	if(PlayerInv[playerid][InvID][_Durable]<NewMailItem[playerid][index][_Durable])return false;
	return true;
}
