FUNC::CompositeItemAdditionForPlayer(playerid)
{
	new Float:AdditionEx[9];
	
	AdditionEx[0]=Addition[playerid][_Hp];
	AdditionEx[1]=Addition[playerid][_Exp];
	AdditionEx[2]=Addition[playerid][_Defens];
	AdditionEx[3]=Addition[playerid][_Attack];
	AdditionEx[4]=Addition[playerid][_Dodge];
	AdditionEx[5]=Addition[playerid][_Stamina];
	AdditionEx[6]=Addition[playerid][_Weight];
	AdditionEx[7]=Addition[playerid][_Hunger];
	AdditionEx[8]=Addition[playerid][_Dry];
	
	Addition[playerid][_Hp]=0.0;
	Addition[playerid][_Exp]=0.0;
	Addition[playerid][_Defens]=0.0;
	Addition[playerid][_Attack]=0.0;
	Addition[playerid][_Dodge]=0.0;
	Addition[playerid][_Stamina]=0.0;
	Addition[playerid][_Weight]=0.0;
	Addition[playerid][_Hunger]=0.0;
	Addition[playerid][_Dry]=0.0;

	foreach(new z:PlayerEquip[playerid])
	{
		new index1=0,AdditionKeyName[16],Float:Efficacy=0.0;
	    forex(i,sizeof(AdditionKey))
	    {
	    	formatex256("%s",StrtokPack1(Item[PlayerEquip[playerid][z][_ItemID]][_AdditionData],index1));
	    	if(strval(string256)!=-1)
	    	{
	    	    new index2=0;
	    	    format(AdditionKeyName,sizeof(AdditionKeyName),StrtokPack2(string256,index2));
	    	    Efficacy=floatstr(StrtokPack2(string256,index2));
	    	    forex(s,sizeof(AdditionKey))
	    	    {
	    	        formatex32("%s",AdditionKey[s]);
	    	        if(isequal(AdditionKeyName,string32,false))
					{
						Addition[playerid][Addition_InFo:s]+=Efficacy;
					}
	    	    }
	    	}
	    }
	}
	if(AdditionEx[0]!=Addition[playerid][_Hp])
	{
	    new Float:Healthex;
		GetPlayerHealth(playerid,Healthex);
	    UpdatePlayerHpBar(playerid,Healthex);
	}
	if(AdditionEx[1]!=Addition[playerid][_Exp])
	{
	}
	if(AdditionEx[2]!=Addition[playerid][_Defens])
	{
	}
	if(AdditionEx[3]!=Addition[playerid][_Attack])
	{
	}
	if(AdditionEx[4]!=Addition[playerid][_Dodge])
	{
	}
	if(AdditionEx[5]!=Addition[playerid][_Stamina])
	{
	    //Account[playerid][_Stamina]=floatadd(Account[playerid][_Stamina],Addition[playerid][_Stamina]);
	    UpdatePlayerStaminaBar(playerid,Account[playerid][_Stamina]);
	}
	if(AdditionEx[6]!=Addition[playerid][_Weight])
	{
	    
	}
	if(AdditionEx[7]!=Addition[playerid][_Hunger])
	{
	    UpdatePlayerDryBar(playerid,Account[playerid][_Hunger]);
	}
	if(AdditionEx[8]!=Addition[playerid][_Dry])
	{
	    UpdatePlayerHungerBar(playerid,Account[playerid][_Dry]);
	}
	return 1;
}
FUNC::ShowAdditionInfo(playerid,itemid,dialogid,botton_0[],botton_1[])
{
	new Body[2048],Temp[128],Title[64];
    format(Title,sizeof(Title),"%s[%s]",Item[itemid][_Name],GetItemTypeName(Item[itemid][_Type]));
    format(Temp,sizeof(Temp),"{80FFFF}描述:%s\n\n",Item[itemid][_Description]);
	strcat(Body,Temp);

	new index1=0,AdditionKeyName[16],Float:Efficacy=0.0;
	new Float:AdditionEx[9],Rates=0;
    forex(i,sizeof(AdditionEx))AdditionEx[i]=0.0;
   	formatex256("%s",StrtokPack1(Item[itemid][_AdditionData],index1));
	if(strval(string256)!=-1)
	{
 		new index2=0;
   		format(AdditionKeyName,sizeof(AdditionKeyName),StrtokPack2(string256,index2));
	    Efficacy=floatstr(StrtokPack2(string256,index2));
	    forex(i,sizeof(AdditionKey))
	    {
     		formatex32("%s",AdditionKey[i]);
     		if(isequal(AdditionKeyName,string32,false))
		 	{
				AdditionEx[i]=Efficacy;
				if(AdditionEx[i]>0.0)Rates++;
			}
   		}
  	}
  	if(Rates>0)
  	{
		strcat(Body,"\t{FFFF80}加成功能{80FFFF}\n");
	  	forex(i,sizeof(AdditionKey))
	  	{
	  	    if(AdditionEx[i]!=0.0)
	  	    {
	  			format(Temp,sizeof(Temp),"%s: %0.1f\n",AdditionName[i],AdditionEx[i]);
				strcat(Body,Temp);
				Rates++;
	  	    }
	  	}
  	}
    SPD(playerid,dialogid,DIALOG_STYLE_MSGBOX,Title,Body,botton_0,botton_1);
	return 1;
}
/*enum Addition_InFo
{
	Float:_Hp,//加最大血
	Float:_Exp,//经验
	Float:_Defens,//防御
	Float:_Attack,//攻击
	Float:_Dodge,//躲闪
	Float:_Stamina,//加最大耐力
	Float:_Weight,//加最大负重
	Float:_Hunger,//加最大饥饿
	Float:_Dry//加最大口渴
};
new Addition[MAX_PLAYERS][Addition_InFo];*/
