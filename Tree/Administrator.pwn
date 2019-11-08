FUNC::GetPlayerAdminLevelByKey(AccountKey[])
{
	formatex128("SELECT `管理等级` FROM `"MYSQL_SERVER_ADMIN"` WHERE `玩家密匙` = '%s' LIMIT 1",AccountKey);
	mysql_query(Server@Handle,string128,true);
	new AdminLevel=0;
	if(cache_get_row_count(Server@Handle)>0)AdminLevel=cache_get_field_content_int(0,"管理等级",Server@Handle);
	return AdminLevel;
}
CMD:go(playerid, params[])
{
    if(!RealPlayer(playerid))return SCM(playerid,-1,"你没有登录");
    if(GetPlayerAdminLevelByKey(Account[playerid][_Key])<1)return SCM(playerid,-1,"你不是管理员1级及以上");
    new pid;
	if(sscanf(params, "i",pid))return SCM(playerid,-1,"/go 玩家ID");
    if(!RealPlayer(pid))return SCM(playerid,-1,"ID不可用");
    if(GetPlayerAdminLevelByKey(Account[playerid][_Key])<GetPlayerAdminLevelByKey(Account[pid][_Key]))return SCM(playerid,-1,"你不能操作管理权限与高于你的玩家");
	SetPlayerPosEx(playerid,PlayerPos[pid][0],PlayerPos[pid][1],PlayerPos[pid][2],PlayerPos[pid][3],PlayerInterior[pid],PlayerWorld[pid],2,1.0,true);
	formatex80("%s 传送到了你身边",Account[playerid][_Name]);
    SCM(playerid,-1,string80);
	return 1;
}
CMD:let(playerid, params[])
{
    if(!RealPlayer(playerid))return SCM(playerid,-1,"你没有登录");
    if(GetPlayerAdminLevelByKey(Account[playerid][_Key])<1)return SCM(playerid,-1,"你不是管理员1级及以上");
    new pid;
	if(sscanf(params, "i",pid))return SCM(playerid,-1,"/let 玩家ID");
    if(!RealPlayer(pid))return SCM(playerid,-1,"ID不可用");
    if(GetPlayerAdminLevelByKey(Account[playerid][_Key])<GetPlayerAdminLevelByKey(Account[pid][_Key]))return SCM(playerid,-1,"你不能操作管理权限与高于你的玩家");
	SetPlayerPosEx(pid,PlayerPos[playerid][0],PlayerPos[playerid][1],PlayerPos[playerid][2],PlayerPos[playerid][3],PlayerInterior[playerid],PlayerWorld[playerid],2,1.0,true);
	formatex80("%s 把你传送到他身边",Account[playerid][_Name]);
    SCM(playerid,-1,string80);
	return 1;
}
CMD:gov(playerid, params[])
{
    if(!RealPlayer(playerid))return SCM(playerid,-1,"你没有登录");
    if(GetPlayerAdminLevelByKey(Account[playerid][_Key])<1)return SCM(playerid,-1,"你不是管理员1级及以上");
    new vid;
	if(sscanf(params, "i",vid))return SCM(playerid,-1,"/gov 汽车ID");
    if(!IsValidVehicle(vid))return SCM(playerid,-1,"ID不可用");
    new Float:x,Float:y,Float:z,Float:a;
    GetVehiclePos(vid,x,y,z);
	GetVehicleZAngle(vid,a);
    SetPlayerPosEx(playerid,x,y,z,a,0,GetVehicleVirtualWorld(vid),2,1.0,true);
	return 1;
}
CMD:store(playerid, params[])
{
    if(!RealPlayer(playerid))return SCM(playerid,-1,"你没有登录");
    if(GetPlayerAdminLevelByKey(Account[playerid][_Key])<1)return SCM(playerid,-1,"你不是管理员1级及以上");
	new mid,aid,names[64],mapmodel;
    if(sscanf(params, "iis[64]i",mid,aid,names,mapmodel))return SendClientMessage(playerid,-1,"用法:/Store 模型ID NPC模型 名称 地图图标");
    new Float:posex[4];
    GetPlayerPos(playerid,posex[0],posex[1],posex[2]);
    GetPlayerFacingAngle(playerid,posex[3]);
    CreateStore(playerid,mid,aid,names,mapmodel,posex[0],posex[1],posex[2],posex[3]);
    SetPlayerPos(playerid,posex[0],posex[1],posex[2]+2.5);
	return 1;
}
CMD:dstore(playerid, params[])
{
    if(!RealPlayer(playerid))return SCM(playerid,-1,"你没有登录");
    if(GetPlayerAdminLevelByKey(Account[playerid][_Key])<1)return SCM(playerid,-1,"你不是管理员1级及以上");
	new storeid;
    if(sscanf(params, "i",storeid))return SendClientMessage(playerid,-1,"用法:/dstore id");
    DestoryStore(storeid);
    return 1;
}
CMD:addsell(playerid, params[])
{
    if(!RealPlayer(playerid))return SCM(playerid,-1,"你没有登录");
    if(GetPlayerAdminLevelByKey(Account[playerid][_Key])<1)return SCM(playerid,-1,"你不是管理员1级及以上");
	new Storeid,ItemKey[37],Amounts,Price,Float:Durable;
    if(sscanf(params, "is[37]iif",Storeid,ItemKey,Amounts,Price,Durable))return SendClientMessage(playerid,-1,"用法:/addsell 商店id 道具码 数量 价格 耐久");
    AddStoreSellToStore(playerid,Storeid,ItemKey,Amounts,Price,Durable);
    return 1;
}
CMD:addfa(playerid, params[])
{
    if(!RealPlayer(playerid))return SCM(playerid,-1,"你没有登录");
    if(GetPlayerAdminLevelByKey(Account[playerid][_Key])<1)return SCM(playerid,-1,"你不是管理员1级及以上");
	new ownerkey[24];
    if(sscanf(params, "s[24]",ownerkey))return SendClientMessage(playerid,-1,"用法:/addfa 阵营名称");
    CreateFactionData(playerid,ownerkey);
	return 1;
}
CMD:delfa(playerid, params[])
{
    if(!RealPlayer(playerid))return SCM(playerid,-1,"你没有登录");
    if(GetPlayerAdminLevelByKey(Account[playerid][_Key])<1)return SCM(playerid,-1,"你不是管理员1级及以上");
	new ownerkey;
    if(sscanf(params, "i",ownerkey))return SendClientMessage(playerid,-1,"用法:/delfa 阵营ID");
	DestoryFaction(ownerkey);
	return 1;
}
