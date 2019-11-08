FUNC::GetPlayerAdminLevelByKey(AccountKey[])
{
	formatex128("SELECT `����ȼ�` FROM `"MYSQL_SERVER_ADMIN"` WHERE `����ܳ�` = '%s' LIMIT 1",AccountKey);
	mysql_query(Server@Handle,string128,true);
	new AdminLevel=0;
	if(cache_get_row_count(Server@Handle)>0)AdminLevel=cache_get_field_content_int(0,"����ȼ�",Server@Handle);
	return AdminLevel;
}
CMD:go(playerid, params[])
{
    if(!RealPlayer(playerid))return SCM(playerid,-1,"��û�е�¼");
    if(GetPlayerAdminLevelByKey(Account[playerid][_Key])<1)return SCM(playerid,-1,"�㲻�ǹ���Ա1��������");
    new pid;
	if(sscanf(params, "i",pid))return SCM(playerid,-1,"/go ���ID");
    if(!RealPlayer(pid))return SCM(playerid,-1,"ID������");
    if(GetPlayerAdminLevelByKey(Account[playerid][_Key])<GetPlayerAdminLevelByKey(Account[pid][_Key]))return SCM(playerid,-1,"�㲻�ܲ�������Ȩ�������������");
	SetPlayerPosEx(playerid,PlayerPos[pid][0],PlayerPos[pid][1],PlayerPos[pid][2],PlayerPos[pid][3],PlayerInterior[pid],PlayerWorld[pid],2,1.0,true);
	formatex80("%s ���͵��������",Account[playerid][_Name]);
    SCM(playerid,-1,string80);
	return 1;
}
CMD:let(playerid, params[])
{
    if(!RealPlayer(playerid))return SCM(playerid,-1,"��û�е�¼");
    if(GetPlayerAdminLevelByKey(Account[playerid][_Key])<1)return SCM(playerid,-1,"�㲻�ǹ���Ա1��������");
    new pid;
	if(sscanf(params, "i",pid))return SCM(playerid,-1,"/let ���ID");
    if(!RealPlayer(pid))return SCM(playerid,-1,"ID������");
    if(GetPlayerAdminLevelByKey(Account[playerid][_Key])<GetPlayerAdminLevelByKey(Account[pid][_Key]))return SCM(playerid,-1,"�㲻�ܲ�������Ȩ�������������");
	SetPlayerPosEx(pid,PlayerPos[playerid][0],PlayerPos[playerid][1],PlayerPos[playerid][2],PlayerPos[playerid][3],PlayerInterior[playerid],PlayerWorld[playerid],2,1.0,true);
	formatex80("%s ���㴫�͵������",Account[playerid][_Name]);
    SCM(playerid,-1,string80);
	return 1;
}
CMD:gov(playerid, params[])
{
    if(!RealPlayer(playerid))return SCM(playerid,-1,"��û�е�¼");
    if(GetPlayerAdminLevelByKey(Account[playerid][_Key])<1)return SCM(playerid,-1,"�㲻�ǹ���Ա1��������");
    new vid;
	if(sscanf(params, "i",vid))return SCM(playerid,-1,"/gov ����ID");
    if(!IsValidVehicle(vid))return SCM(playerid,-1,"ID������");
    new Float:x,Float:y,Float:z,Float:a;
    GetVehiclePos(vid,x,y,z);
	GetVehicleZAngle(vid,a);
    SetPlayerPosEx(playerid,x,y,z,a,0,GetVehicleVirtualWorld(vid),2,1.0,true);
	return 1;
}
CMD:store(playerid, params[])
{
    if(!RealPlayer(playerid))return SCM(playerid,-1,"��û�е�¼");
    if(GetPlayerAdminLevelByKey(Account[playerid][_Key])<1)return SCM(playerid,-1,"�㲻�ǹ���Ա1��������");
	new mid,aid,names[64],mapmodel;
    if(sscanf(params, "iis[64]i",mid,aid,names,mapmodel))return SendClientMessage(playerid,-1,"�÷�:/Store ģ��ID NPCģ�� ���� ��ͼͼ��");
    new Float:posex[4];
    GetPlayerPos(playerid,posex[0],posex[1],posex[2]);
    GetPlayerFacingAngle(playerid,posex[3]);
    CreateStore(playerid,mid,aid,names,mapmodel,posex[0],posex[1],posex[2],posex[3]);
    SetPlayerPos(playerid,posex[0],posex[1],posex[2]+2.5);
	return 1;
}
CMD:dstore(playerid, params[])
{
    if(!RealPlayer(playerid))return SCM(playerid,-1,"��û�е�¼");
    if(GetPlayerAdminLevelByKey(Account[playerid][_Key])<1)return SCM(playerid,-1,"�㲻�ǹ���Ա1��������");
	new storeid;
    if(sscanf(params, "i",storeid))return SendClientMessage(playerid,-1,"�÷�:/dstore id");
    DestoryStore(storeid);
    return 1;
}
CMD:addsell(playerid, params[])
{
    if(!RealPlayer(playerid))return SCM(playerid,-1,"��û�е�¼");
    if(GetPlayerAdminLevelByKey(Account[playerid][_Key])<1)return SCM(playerid,-1,"�㲻�ǹ���Ա1��������");
	new Storeid,ItemKey[37],Amounts,Price,Float:Durable;
    if(sscanf(params, "is[37]iif",Storeid,ItemKey,Amounts,Price,Durable))return SendClientMessage(playerid,-1,"�÷�:/addsell �̵�id ������ ���� �۸� �;�");
    AddStoreSellToStore(playerid,Storeid,ItemKey,Amounts,Price,Durable);
    return 1;
}
CMD:addfa(playerid, params[])
{
    if(!RealPlayer(playerid))return SCM(playerid,-1,"��û�е�¼");
    if(GetPlayerAdminLevelByKey(Account[playerid][_Key])<1)return SCM(playerid,-1,"�㲻�ǹ���Ա1��������");
	new ownerkey[24];
    if(sscanf(params, "s[24]",ownerkey))return SendClientMessage(playerid,-1,"�÷�:/addfa ��Ӫ����");
    CreateFactionData(playerid,ownerkey);
	return 1;
}
CMD:delfa(playerid, params[])
{
    if(!RealPlayer(playerid))return SCM(playerid,-1,"��û�е�¼");
    if(GetPlayerAdminLevelByKey(Account[playerid][_Key])<1)return SCM(playerid,-1,"�㲻�ǹ���Ա1��������");
	new ownerkey;
    if(sscanf(params, "i",ownerkey))return SendClientMessage(playerid,-1,"�÷�:/delfa ��ӪID");
	DestoryFaction(ownerkey);
	return 1;
}
