#define MAX_PLAYERS	(4)
#include <a_samp>
#include <times>
#include <textdrawstream>
#include <colandreas>
#include <mapandreas>
#include <sscanf2>
#include <foreach>
#include <streamer>
#include <pawn.CMD>
#include <uuid>
#include <a_mysql>
#include <a_zone>
#include <FCNPC>
#include <3DTryg>
#include <attach>
#include <Pawn.RakNet>
//#include <AC>
#include <GPS>
#include <profiler>
#define MAX_BOX_ITEMS 500

#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))
#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

#define NULL_MODEL 16678
#define FUNC::%1(%3) forward %1(%3);  public %1(%3)
#define NONE  -1
#define forex(%0,%1) for(new %0 = 0; %0 < %1; %0++)
#define loop(%0,%1,%2) for(new %0 = %1; %0 < %2; %0++)
#define Hooks CallRemoteFunction
#define Timer: _@timer_
#define SPD ShowPlayerDialog
stock SPD_Close(playerid)
{
	SPD(playerid,-1,DIALOG_STYLE_MSGBOX," ", " ", " ", "");
	return 1;
}
enum//对话框
{
    _SPD_ERROR,
    
    _SPD_REGISTER,
    _SPD_LOGIN,

    _SPD_BAG_INFO,
    _SPD_BAG_USE,
    _SPD_BAG_USE_QUICKUSE,
    _SPD_BAG_USE_BOMB,
    _SPD_BAG_DROP_AMOUNT,
    _SPD_BAG_DROP_TIP,
    _SPD_BAG_PUT_AMOUNT,
    _SPD_BAG_PUT_TIP,
    _SPD_NEAR_STRONGBOX,

    _SPD_NEAR_PICKUP_INFO,
    _SPD_NEAR_PICKUP_AMOUNT,
    
    _SPD_GM_ADD_PICKUP,
    _SPD_GM_ADD_VEH,
    
    _SPD_PRIVATEDOMAIN_CREATE,
    _SPD_PRIVATEDOMAIN_ENTER,
    
    _SPD_ZOMBIEBAG_INFO,
    
    _SPD_MY_WIRELESS,
    _SPD_NEAR_WIRELESS,
    _SPD_NEAR_WIRELESS_ADD,
    
    _SPD_GPS_USE,
    _SPD_GPS_REUSE,
    
    _SPD_CRAFTBULID_USE,
    _SPD_CRAFTBULID_MOVE,
    _SPD_CRAFTBULID_MOVE_SPEED,
    _SPD_CRAFTBULID_MOVE_DELAY,
    _SPD_CRAFTBULID_MOVE_DISTANCE,
    _SPD_CRAFTBULID_MARK_NAME,
    
    _SPD_STORESELL_TIP,
    _SPD_STORESELL_AMOUNT,
    
    _SPD_PLAYERSELL_TIP,
    _SPD_PLAYERSELL_AMOUNT,
    
    _SPD_STRONGBOX_CAP,
    _SPD_STRONGBOX_USE,
    _SPD_STRONGBOX_PUTAMOUNT,
    _SPD_STRONGBOX_DROPAMOUNT,
    
    _SPD_FACTION_TIP,
    _SPD_FACTION_SET,
    _SPD_FACTION_MANAGE,
    _SPD_FACTION_MANAGE_MEMBERS,
    _SPD_FACTION_INFO,
    _SPD_FACTION_CREATE_NAME,
    _SPD_FACTION_LIST,
    _SPD_FACTION_JOIN_INFO,
    _SPD_FACTION_INV,   
    _SPD_FACTION_INV_INFO,

    _SPD_GAMEMAIL_SEND,
    _SPD_GAMEMAIL_SEND_NAME,
    _SPD_GAMEMAIL_SEND_CONTENT,
    _SPD_GAMEMAIL_SEND_CASH,
    _SPD_GAMEMAIL_SEND_ITEM,
    _SPD_GAMEMAIL_SEND_ITEM_AMOUNT,
    _SPD_GAMEMAIL_PANEL,
    _SPD_GAMEMAIL_LIST,
    _SPD_GAMEMAIL_INFO,
    _SPD_GAMEMAIL_SET
}
#define PLAYER_BAG_USE_PANEL "使用物品\n快捷设置\n存入保险箱\n抛弃物品"
#define PLAYER_BAG_USE_PANEL_QUICKUSE "ALT+Y\nALT+N\nALT+H"
#define CRAFTBULID_USE_PANEL "编辑位置\n移动设置\n仓库功能\n标记命名\n销毁建筑"
#define CRAFTBULID_MOVE_PANEL "编辑移动\n移动速度\n移动延时\n移动范围\n取消移动"
#define STRONGBOX_USE_PANEL "放入背包\n销毁物品"
#define FACTION_INFO_PANEL "创建阵营\n加入阵营[ %i 个]"
#define FACTION_USE_PANEL "阵营管理\n阵营信息\n退出阵营"
#define FACTION_USE_MANAGE "邀请成员\n成员管理\n阶级名称\n营地设置\n解散阵营"
#define GAMEMAIL_PANEL "写邮件\n邮件箱[%i未读]"
#define GAMEMAIL_SEND_PANEL "内容编辑\n%s\n金币附件\n%i\n道具附件\n%s"
#define GAMEMAIL_USE_PANEL "回复邮件\n提取附件\n删除邮件\n清空邮件"

new string2048[2048];
#define formatex2048( string2048="";format(string2048,sizeof(string2048),
new string1024[1024];
#define formatex1024( string1024="";format(string1024,sizeof(string1024),
new string512[512];
#define formatex512( string512="";format(string512,sizeof(string512),
new string256[256];
#define formatex256( string256="";format(string256,sizeof(string256),
new string128[128];
#define formatex128( string128="";format(string128,sizeof(string128),
new string80[80];
#define formatex80( string80="";format(string80,sizeof(string80),
new string64[64];
#define formatex64( string64="";format(string64,sizeof(string64),
new string32[32];
#define formatex32( string32="";format(string32,sizeof(string32),

new Float:PlayerPos[MAX_PLAYERS][4];
new PlayerInterior[MAX_PLAYERS];
new PlayerWorld[MAX_PLAYERS];
new PlayerOldWorld[MAX_PLAYERS];
FUNC::GetPosData(playerid)
{
	if(IsPlayerInAnyVehicle(playerid))
	{
	    new vehicleid=GetPlayerVehicleID(playerid);
		GetVehiclePos(vehicleid,PlayerPos[playerid][0],PlayerPos[playerid][1],PlayerPos[playerid][2]);
		GetVehicleZAngle(vehicleid,PlayerPos[playerid][3]);
	}
	else
	{
		GetPlayerPos(playerid,PlayerPos[playerid][0],PlayerPos[playerid][1],PlayerPos[playerid][2]);
		GetPlayerFacingAngle(playerid,PlayerPos[playerid][3]);
	}
	PlayerInterior[playerid]=GetPlayerInterior(playerid);
	PlayerWorld[playerid]=GetPlayerVirtualWorld(playerid);
    OnPlayerVirtualWorldChange(playerid, PlayerWorld[playerid],PlayerOldWorld[playerid]);
    PlayerOldWorld[playerid]=PlayerWorld[playerid];
	return 1;
}

new HideAllMap;

#define SCM SendClientMessage

#define MAX_BOX_LIST 15//动态对话框列数
#define MAX_DIALOG_BOX_ITEMS 1000
new DialogPage[MAX_PLAYERS];
new DialogBox[MAX_PLAYERS][MAX_DIALOG_BOX_ITEMS];
new DialogBoxKey[MAX_PLAYERS][MAX_DIALOG_BOX_ITEMS][UUID_LEN];
new DialogBoxID[MAX_PLAYERS];

new bool:DialogBoxInvSelect[MAX_PLAYERS][MAX_DIALOG_BOX_ITEMS];
new DialogBoxInvAmount[MAX_PLAYERS][MAX_DIALOG_BOX_ITEMS];
////////////////////////用户
new GameMailTypeName[][16] =
{
    {"[玩家邮件]"},
    {"[系统邮件]"},
    {"[帮派邮件]"},
    {"[好友邮件]"},
    {"[帮派请求]"},
    {"[好友请求]"},
    {"[帮派邀请]"}
};
enum
{
    GAMEMAIL_TYPE_PLAYER,
    GAMEMAIL_TYPE_SYSTEM,
    GAMEMAIL_TYPE_FACTION,
	GAMEMAIL_TYPE_FRIEND,
    GAMEMAIL_TYPE_FACTION_REQ,
	GAMEMAIL_TYPE_FRIEND_REQ,
    GAMEMAIL_TYPE_FACTION_INV
}
#define MAX_PLAYER_GAMEMAILS 100
enum PlayerGameMail_InFo
{
    _Key[37],
    _SenderKey[37],
    _ReceiverKey[37],
	_Type,
    _Content[256],
    _ItemData[512],
    _Cash,
   	_ExtraData[128],
    _Readed,
    _SendTime[32],
    _GameTime
};
new PlayerGameMail[MAX_PLAYERS][MAX_PLAYER_GAMEMAILS][PlayerGameMail_InFo];
new Iterator:PlayerGameMail[MAX_PLAYERS]<MAX_PLAYER_GAMEMAILS>;
#define MAX_PLAYER_SENDGAMEMAIL_ITEMS 5
/**************************************/
new NewMailType[MAX_PLAYERS];
new NewMailCash[MAX_PLAYERS];
new NewMailContent[MAX_PLAYERS][256];
new NewMailReceiverKey[MAX_PLAYERS][37];
enum NewMailItem_InFo
{
    _InvKey[37],
    _Amount,
    Float:_Durable,
    _ItemID,
    bool:_Used
};
new NewMailItem[MAX_PLAYERS][MAX_PLAYER_SENDGAMEMAIL_ITEMS][NewMailItem_InFo];
////////////////////////用户
enum Account_InFo
{
	_Index,
	_Key[64],
	_Name[24],
	_Password[64],
	_Skin,
	_Cash,
	_Level,
	_Exp,
	_SpawnTown,
	Float:_OfflineX,
	Float:_OfflineY,
	Float:_OfflineZ,
	Float:_OfflineA,
	_OfflineInt,
	
	bool:_Login,
	bool:_Register,
	bool:_Spawn,
	
	Float:_Stamina,
	Float:_Hunger,
	Float:_Dry,
	_Infection
};
new Account[MAX_PLAYERS][Account_InFo];
#define DEFAULT_MAX_HUNGER 	100.0
#define DEFAULT_MAX_DRY 	100.0
#define DEFAULT_MAX_HP 		100.0
#define DEFAULT_MAX_STAMINA 100.0
#define SUB_HUNGER 			0.5
#define SUB_DRY 			1.0
#define SUB_STAMINA 		2.0
////////////////////////耐力
////////////////////////加成系统
new AdditionKey[][16] = 
{
    {"MAXHP"},
    {"EXP"},
    {"DEFENS"},
    {"ATTACK"},
    {"DODGE"},
    {"STAMINA"},
    {"WEIGHT"},
    {"HUNGER"},
    {"DRY"}
};
new AdditionName[][16] =
{
    {"血量加成"},
    {"经验加成"},
    {"防御加成"},
    {"攻击加成"},
    {"躲闪加成"},
    {"耐力加成"},
    {"负重加成"},
    {"饥饿加成"},
    {"口渴加成"}
};
enum Addition_InFo
{
	Float:_Hp,//血
	Float:_Exp,//经验
	Float:_Defens,//防御
	Float:_Attack,//攻击
	Float:_Dodge,//躲闪
	Float:_Stamina,//耐力
	Float:_Weight,//负重
	Float:_Hunger,//饥饿
	Float:_Dry//口渴
};
new Addition[MAX_PLAYERS][Addition_InFo];
////////////////////////背包
#define PLAYER_PRIAMRY_CAPACITY 50.0
enum
{
    RETURN_ERROR,
	RETURN_SUCCESS
}
#define MAX_PLAYER_INV_SLOTS 100
enum PlayerInv_InFo
{
	_AccountKey[37],
	_InvKey[37],
	_ItemKey[37],
	_Amounts,
	Float:_Durable,
	_GetTime,
	_QuickShow,
	_ItemID
};
new PlayerInv[MAX_PLAYERS][MAX_PLAYER_INV_SLOTS][PlayerInv_InFo];
new Iterator:PlayerInv[MAX_PLAYERS]<MAX_PLAYER_INV_SLOTS>;

new Timer:PlayerUseItem[MAX_PLAYERS]={NONE, ...};
new PlayerUseItemTimeCount[MAX_PLAYERS]={0, ...};
new PlayerUseItemTimeTotal[MAX_PLAYERS]={0, ...};
new Timer:PlayerUseItemAnim[MAX_PLAYERS]={NONE, ...};
////////////////////////装备/饰品
#define MAX_PLAYER_EQUIPS 6
enum PlayerEquip_InFo
{
    _AccountKey[37],
	_EquipKey[37],
	_ItemKey[37],
	Float:_Durable,
	_GetTime,
	_ItemID
};
new PlayerEquip[MAX_PLAYERS][MAX_PLAYER_EQUIPS][PlayerEquip_InFo];
new Iterator:PlayerEquip[MAX_PLAYERS]<MAX_PLAYER_EQUIPS>;
#define PlayerEquipItem(%0,%1) PlayerEquip[%0][%1][_ItemID]

////////////////////////武器
#define MAX_PLAYER_WEAPONS 5
enum PlayerWeapon_InFo
{
    _AccountKey[37],
	_WeaponKey[37],
	_ItemKey[37],
	Float:_Durable,
	_GetTime,
	_ItemID
};
new PlayerWeapon[MAX_PLAYERS][MAX_PLAYER_WEAPONS][PlayerWeapon_InFo];
new Iterator:PlayerWeapon[MAX_PLAYERS]<MAX_PLAYER_WEAPONS>;
/***********************************************/

////////////////////////皮肤
enum Skin_Info
{
    _SkinID
}
/*new MaleSkin[][Skin_Info]={20050,20051,20052,20053,20054,20055};
new FaMaleSkin[][Skin_Info]={20100,20101,20102,20103,20104};*/
new MaleSkin[][Skin_Info]=
{
	20050,20051,20052,20053,20054,20055,20056,20057,20058,20059,
	20060,20061,20062,20063,20064,20065,20066,20067,20068,20069,
	20070,20071,20072
};
new FaMaleSkin[][Skin_Info]=
{
	20050,20051,20052,20053,20054,20055,20056,20057,20058,20059,
	20060,20061,20062,20063,20064,20065,20066,20067,20068,20069,
	20070,20071,20072
};
#define PLAYER_SELECTSKIN_WORLD 5000
////////////////////////安全区雾区
enum SafeZone_Info
{
    _sName[32],
    Float:_sX,
    Float:_sY,
    Float:_sZ,
    Float:_sA,    
    //_sModelID,
	//_sShapeID,
	_sAreaID
}
new SafeZone[][SafeZone_Info] =
{
    {"吉维尼镇",237.0368,-156.3033,0.0,0.0},
    {"伊亚镇",1298.1633,269.4067,0.0,0.0},
    {"纳罗拉镇",2316.6289,39.7144,0.0,0.0},
    {"科尔马镇",-141.7784,1123.4459,0.0,0.0},
    {"格塔里亚镇",-2144.6907,-2406.3621,0.0,0.0},
    {"旧金山市",85.0, -2773.0, 2952.0, -970.0},
    {"拉斯维加斯市",871.6, 627.0, 2911.6, 2887.0},
    {"洛杉矶市",-2984.0, -430.0, -1073.0, 1444.0}
};
new FightingStyle[] =
{
	FIGHT_STYLE_BOXING,
	FIGHT_STYLE_KUNGFU,
	FIGHT_STYLE_KNEEHEAD,
	FIGHT_STYLE_GRABKICK,
	FIGHT_STYLE_ELBOW
};
////////////////////////系统商店
#define MAX_STORES 50
#define MAX_STORE_SELLS 9
enum Stores_Info
{
	_Key[37],
	_Name[64],
	_MapModel,
	Float:_Pos[4],
	Float:_Rot[3],
	_AcotrSkin,
	_Model,
	
	_Mapid,
    Text3D:_Textid,
	_Acotrid,
	_Areaid,
	_BoothObjid,
	_ItemObjid[MAX_STORE_SELLS]
}
new Stores[MAX_STORES][Stores_Info];
new Iterator:Stores<MAX_STORES>;
new PlayerStoreDalay[MAX_PLAYERS];
enum StoreSells_Info
{
	_Key[37],
	_StoreKey[37],
	_ItemKey[37],
	_Amount,
	Float:_Durable,
	_Price,
	_ItemID
}
new StoreSells[MAX_STORES][MAX_STORE_SELLS][StoreSells_Info];
new Iterator:StoreSells[MAX_STORES]<MAX_STORE_SELLS>;
////////////////////////僵尸系统
enum
{
    ZOMBIE_STATE_NONE,
    ZOMBIE_STATE_NORMAL,
    ZOMBIE_STATE_FOLLOW,
	ZOMBIE_STATE_ATTACK,
	ZOMBIE_STATE_EAT,
	ZOMBIE_STATE_RUNAWAY,
	ZOMBIE_STATE_DEATH,
	ZOMBIE_STATE_SLEEP
}
#define MAX_ZOMBIES 2
#define ZOMBIE_DEATH_WORLD 1000
enum Zombies_Info
{
	_zKey[37],
	Float:_zSpawn[4],
	bool:_zExecute,
	Float:_zLookrange,
	bool:_zAniming,
	_zSkin,
	_zState,
	_zNpcid,
	_zTarget,
	_zAreaID,
	_zPAreaID,
	_zWalktick,
	Float:_zHp,
	Float:_zMHp,
	Bar3D:_zHpText,
	_zAlertPlayerid,
	bool:_zAngry,
	_zAlertDelay,
	bool:_zRunAway,
	_zRunAwayDelay,
	
	_zAttackVeh,
	_zAttackVehDalay,
	
	_zActorID,
	Timer:_zActorTimer
	

}
new Zombies[MAX_ZOMBIES][Zombies_Info];
#define ZOMBIES_ALERT_RANGE 80
new Iterator:Zombies<MAX_ZOMBIES>;

#define MAX_ZOMBIES_BAG_SLOTS 20
enum ZombieBag_InFo
{
	_ZombieKey[37],
	_ZombieBagKey[37],
	_ItemKey[37],
	_Amounts,
	Float:_Durable,
	_ItemID
};
new ZombieBag[MAX_ZOMBIES][MAX_ZOMBIES_BAG_SLOTS][ZombieBag_InFo];
new Iterator:ZombieBag[MAX_ZOMBIES]<MAX_ZOMBIES_BAG_SLOTS>;


enum GetOutZombiesKeys_Info
{
    _GetOutValue,
    _GetOutUnPressKey[16],
    _GetOutPressdKey[16],
    _GetOutKeyName[32],
    _GetOutKeyUl
}
new GetOutZombiesKeys[][GetOutZombiesKeys_Info] =
{
	{-128,"~r~W","~b~W","{00FF80}W键{FFFFFF}",0},
	{128,"~w~S","~b~S","{00FF80}S键{FFFFFF}",0},
	{-128,"~y~A","~b~A","{00FF80}A键{FFFFFF}",1},
	{128,"~p~D","~b~D","{00FF80}D键{FFFFFF}",1}
};
enum CheatNames_Info
{
    _Chinese[64],
    _English[64]
}
new CheatNames[][CheatNames_Info] =
{
	{"破空(步行)","AirBreak(on foot)"},//0
	{"破空(载具)","AirBreak(in vehicle)"},//1
	{"非法传送(步行)","teleport hack(onfoot)"},//2
	{"非法传送(载具1)","teleport hack (in vehicle)"},//3
	{"非法传送(载具2)","teleport hack (into/between vehicles)"},//4
	{"非法传送(载具3)","teleport hack (vehicle to player)"},//5
    {"非法传送(拾取点)","teleport hack (pickups)"},//6
    {"飞天(步行)","FlyHack (onfoot)"},//7
    {"飞天(载具)","FlyHack (in vehicle)"},//8
    {"超速(步行)","SpeedHack (onfoot)"},//9
    {"超速(载具)","SpeedHack (in vehicle)"},//10
    {"非法血量(载具)","Health hack (in vehicle)"},//11
	{"非法血量(载具)","Health hack (onfoot)"},//12
	{"非法护甲(载具)","Armour hack"},//13
	{"非法金钱","Money hack"},//14
	{"非法武器","Weapon hack"},//15
	{"子弹自增","Ammo hack (add)"},//16
	{"无限子弹","Ammo hack (infinite)"},//17
	{"特殊动作","Special actions hack"},//18
	{"无敌模式1[步行]","GodMode from bullets (onfoot)"},//19
	{"无敌模式2[载具]","GodMode from bullets (in vehicle)"},//20
	{"无敌模式3","Invisible hack"},//21
	{"同步欺骗","lagcomp-spoof"},//22
	{"非法改装","Tuning hack"},//23
	{"跑酷模式","Parkour mod"},//24
	{"快速射击","Rapid fire"},//25
	{"虚假出生","FakeSpawn"},//26
	{"虚假死亡","FakeKill"},//28
	{"Pro Aim","Pro Aim"},//29
	{"CJ跑","CJ run"},//30
	{"非法汽车射击","CarShot"},//31
	{"非法抢车","CarJack"},//32
	{"非法解除冻结","UnFreeze"},//33
	{"幽灵模式","AFK Ghost"},//34
	{"Full Aiming","Full Aiming"},//35
	{"虚假NPC","Fake NPC"},//36
	{"重复链接","Reconnect"},//37
	{"超高延迟","High ping"},//38
	{"对话框作弊","Dialog hack"},//39
	{"多开","Protection from the sandbox"},//40
	{"错误游戏版本","Protection against an invalid version"},//41
	{"非法超管登录","Anti-Rcon hack"},//42
	{"崩溃器1","Tuning crasher"},//43
	{"崩溃器2","Invalid seat crasher"},//44
	{"崩溃器3","Dialog crasher"},//45
	{"崩溃器4","Attached object crasher"},//46
	{"崩溃器5","Weapon Crasher"},//47
	{"洪链洪水攻击","Flood protection connects to one slot"},//48
	{"回调洪水攻击","flood callback functions"},//49
	{"座位洪水攻击","flood change seat"},//50
	{"Ddos","Ddos"},//51
	{"NOP's","NOP's"}//52
};
enum PlayerZombies_Info
{
	bool:_PzCatch,
	_PzEscape,
	_PzNeedPressKey,
	_PzAlertZombieDelay,
}
new PlayerZombies[MAX_PLAYERS][PlayerZombies_Info];



////////////////////////个人领地
enum
{
    PLAYER_DOMAIN_NONE,//无领地
    PLAYER_DOMAIN_OTHER,//其他人领地
    PLAYER_DOMAIN_FACTION_FORBID,//帮派禁止领地
    PLAYER_DOMAIN_FACTION_OTHER,//帮派成员禁止领地
    PLAYER_DOMAIN_OWNER,//自己领地
    PLAYER_DOMAIN_FACTION_ALLOW//帮派允许领地
}
#define PRIVATEDOMAIN_LIMIT 1000000
#define MAX_PRIVATEDOMAIN 5000
#define MAX_WALL 100
enum PrivateDomain_InFo
{
	_Index,
	_Key[37],
	_OwnerKey[37],
	_Name[24],
	Float:_OutX,
	Float:_OutY,
	Float:_OutZ,
	_Level,
	_Weather,
	_Time,
	_ProtectTime,

	_Out_Cp,
	Text3D:_Out_3Dtext,
	_Out_Area,
	Text3D:_In_3Dtext,
	_In_Area,
	
	Wall0[MAX_WALL],
    Wall1[MAX_WALL],
    Wall2[MAX_WALL],
    Wall3[MAX_WALL]
};
new PrivateDomain[MAX_PRIVATEDOMAIN][PrivateDomain_InFo];
new Iterator:PrivateDomain<MAX_PRIVATEDOMAIN>;
enum DomainEdit_Info
{
    _Dalay
}
new DomainEdit[MAX_PLAYERS][DomainEdit_Info];
////////////////////////
enum DomainEnter_InFo
{
	bool:_Move,
	_EditID
}
new DomainEnter[MAX_PLAYERS][DomainEnter_InFo];
/////////////////////////////////阵营
enum Faction_InFo
{
	_Key[37],
	_OwnerKey[37],
	_Name[24],
	_Wireless[8],
	_WirelessOpen,
	_Level,
	Float:_x,
	Float:_y,
	Float:_z,
	
	Text3D:_3Dtext,
	_Zoneid,
	_Areaid,
	_WirelessAreaid,
	_WirelessDC,
	Wall0[MAX_WALL],
    Wall1[MAX_WALL],
    Wall2[MAX_WALL],
    Wall3[MAX_WALL]
}
#define MAX_FACTIONS 100
new Faction[MAX_FACTIONS][Faction_InFo];
new Iterator:Faction<MAX_FACTIONS>;
#define MAX_FACTIONS_RANK 5
enum FactionRank_InFo
{
	_RankName[24]
}
new FactionRank[MAX_FACTIONS][MAX_FACTIONS_RANK][FactionRank_InFo];
enum PlayerFaction_InFo
{
	_FactionKey[37],
	_Rank,
	_AuthorCraft,
	_FactionID
}
new PlayerFaction[MAX_PLAYERS][PlayerFaction_InFo];

#define MAX_PLAYER_WIRELESS MAX_FACTIONS
enum PlayerWireless_InFo
{
    _AccountKey[37],
	_WirelessKey[37],
	_WirelessChannel[8],
	_WirelessUsed,
	_CreateTime[40],
	_FactionID
};
new PlayerWireless[MAX_PLAYERS][MAX_PLAYER_WIRELESS][PlayerWireless_InFo];
new Iterator:PlayerWireless[MAX_PLAYERS]<MAX_PLAYER_WIRELESS>;
/////////////////////////拾取物
enum PickUp_InFo
{
	_Key[37],
	_ItemKey[37],
	_Amounts,
	Float:_Durable,
	Float:_X,
	Float:_Y,
	Float:_Z,
	Float:_RX,
	Float:_RY,
	Float:_RZ,
	_Interior,
	_World,
	_Saveit,
	_ItemID,
	_ObjectIndex,
	Text3D:_3DtextID,
	_AreaID
}
#define MAX_PICKUP 5000
new PickUp[MAX_PICKUP][PickUp_InFo];
new Iterator:PickUp<MAX_PICKUP>;
enum PlayerPickUp_Info
{
    _Dalay
}
new PlayerPickUp[MAX_PLAYERS][PlayerPickUp_Info];

enum PickUpSpawn_InFo
{
	Float:_X,
	Float:_Y,
	Float:_Z,
	Float:_RX,
	Float:_RY,
	Float:_RZ,
	_ItemKey[37],
	_Amount
}
#define MAX_PICKUP_SPAWNS 1000
new PickUpSpawn[MAX_PICKUP_SPAWNS][PickUpSpawn_InFo];
new Iterator:PickUpSpawn<MAX_PICKUP_SPAWNS>;
////////////////////////采集系统
enum Collect_InFo
{
	_Key[37],
	_Type,
	_Model,
	Float:_Hp,
	Float:_MaxHp,
	Float:_X,
	Float:_Y,
	Float:_Z,
	Float:_RX,
	Float:_RY,
	Float:_RZ,
	_ObjectIndex,
	Text3D:_3DtextID,
	Bar3D:_HpText,
	_AreaID,
	_HitDalay
}
#define MAX_COLLECT 100
new Collect[MAX_COLLECT][Collect_InFo];
new Iterator:Collect<MAX_COLLECT>;

enum CollectSpawn_InFo
{
	Float:_X,
	Float:_Y,
	Float:_Z,
	Float:_RX,
	Float:_RY,
	Float:_RZ,
	_Type
}
#define MAX_COLLECT_SPAWNS 1000
new CollectSpawn[MAX_COLLECT_SPAWNS][CollectSpawn_InFo];
new Iterator:CollectSpawn<MAX_COLLECT_SPAWNS>;

enum
{
    COLLECT_TREE,
	COLLECT_STONE
};
enum PlayerCollect_Info
{
    _Dalay
}
new PlayerCollect[MAX_PLAYERS][PlayerCollect_Info];
////////////////////////汽车合成系统
enum VehicleWreckage_InFo
{
	_Key[37],
	_CraftVehKey[37],
	_CraftVehID,
	Float:_X,
	Float:_Y,
	Float:_Z,
	Float:_RX,
	Float:_RY,
	Float:_RZ,
	_ObjectIndex,
	Text3D:_3DtextID,
	_AreaID,
	_SpawnKey
}
#define MAX_VEHWRE 1000
new VehicleWreckage[MAX_VEHWRE][VehicleWreckage_InFo];
new Iterator:VehicleWreckage<MAX_VEHWRE>;
enum VehicleWreckageSpawn_InFo
{
	_Key,
	Float:_X,
	Float:_Y,
	Float:_Z,
	Float:_RX,
	Float:_RY,
	Float:_RZ,
	_CraftVehKey[37]
}
#define MAX_VEHWRE_SPAWNS 1000
new VehicleWreckageSpawn[MAX_VEHWRE_SPAWNS][VehicleWreckageSpawn_InFo];
new Iterator:VehicleWreckageSpawn<MAX_VEHWRE_SPAWNS>;

enum CraftVehicleList_Info
{
    _Key[37],
	_VehicleModel,
	_Model,
	_NeedThing[512]
}
#define MAX_CRAFTVEHICLE_LIST 100
new CraftVehicleList[MAX_CRAFTVEHICLE_LIST][CraftVehicleList_Info];
new Iterator:CraftVehicleList<MAX_CRAFTVEHICLE_LIST>;

enum Veh_Info
{
    _Key[37],
    _CraftVehKey[37],
	Float:_X,
	Float:_Y,
	Float:_Z,
	Float:_Rot,
	_Color[2],
	_Siren,
	_Plate[32],
	Float:_Hp,
	Float:_Fuel,
	
	bool:_Temp,
	
	Text3D:_3DtextID,
	_CraftVehID,
	_VehID,
	_AreaID,
	Timer:_Delete
}
new Veh[MAX_VEHICLES][Veh_Info];
new Iterator:Veh<MAX_VEHICLES>;
////////////////////////建造系统
enum
{
    CRAFT_TPYE_HOUSE,//房子
    CRAFT_TPYE_FENCE,//围墙
    CRAFT_TPYE_DOOR,//门
    CRAFT_TPYE_STARIS,//楼梯
    CRAFT_TPYE_COFFER,//保险箱
    CRAFT_TPYE_OTHER//其他
}
enum CraftItem_Info
{
    _Type,
    _Key[37],
	_PrivateAllow,
	_ModelID,
	_Level,
	_NeedThing[512],
	_Capacity
}
#define MAX_CRAFTITEMS 1000
new CraftItem[MAX_CRAFTITEMS][CraftItem_Info];
new Iterator:CraftItem<MAX_CRAFTITEMS>;

new CraftItemEx[][CraftItem_Info] =
{
	{CRAFT_TPYE_HOUSE,"B000_000",1,2669,0,"A008_002,1000&A008_003,200"},
	{CRAFT_TPYE_HOUSE,"B000_001",1,3626,0,"A008_002,1000&A008_003,500"},
	{CRAFT_TPYE_HOUSE,"B000_003",1,3415,0,"A008_000,1000&A008_001,100"},
	{CRAFT_TPYE_HOUSE,"B000_004",1,19909,0,""},
	{CRAFT_TPYE_HOUSE,"B000_005",1,19907,0,""},
	{CRAFT_TPYE_HOUSE,"B000_006",1,11502,0,""},
	{CRAFT_TPYE_HOUSE,"B000_007",1,19486,0,""},
	{CRAFT_TPYE_HOUSE,"B000_008",1,19905,0,""},
	{CRAFT_TPYE_HOUSE,"B000_009",1,967,0,""},
	{CRAFT_TPYE_HOUSE,"B000_010",1,11492,0,""},
	{CRAFT_TPYE_HOUSE,"B000_011",1,18259,0,""},
	{CRAFT_TPYE_HOUSE,"B000_012",1,19321,0,""},

	{CRAFT_TPYE_FENCE,"B001_000",1,970,0,"A008_003,50"},
	{CRAFT_TPYE_FENCE,"B001_001",1,3850,0,"A008_002,100&A008_003,50"},
	{CRAFT_TPYE_FENCE,"B001_002",1,1468,0,""},
	{CRAFT_TPYE_FENCE,"B001_003",1,1412,0,""},
	{CRAFT_TPYE_FENCE,"B001_004",1,19868,0,""},
	{CRAFT_TPYE_FENCE,"B001_005",1,983,0,""},
	{CRAFT_TPYE_FENCE,"B001_006",1,8674,0,""},
	{CRAFT_TPYE_FENCE,"B001_007",1,987,0,""},
	{CRAFT_TPYE_FENCE,"B001_008",1,7657,0,""},
	{CRAFT_TPYE_FENCE,"B001_009",1,8229,0,""},
	{CRAFT_TPYE_FENCE,"B001_010",1,1446,0,""},
	{CRAFT_TPYE_FENCE,"B001_011",1,19865,0,""},
	{CRAFT_TPYE_FENCE,"B001_012",1,1408,0,""},
	{CRAFT_TPYE_FENCE,"B001_013",1,19641,0,""},

	{CRAFT_TPYE_STARIS,"B002_000",1,10244,0,"A008_000,200&A008_001,100|008_002,50"},
	{CRAFT_TPYE_STARIS,"B002_001",1,5820,0,"A008_001,200&A008_002,70"},
	{CRAFT_TPYE_STARIS,"B002_002",1,8572,0,""},
	{CRAFT_TPYE_STARIS,"B002_003",1,8615,0,""},
	{CRAFT_TPYE_STARIS,"B002_004",1,5130,0,""},
	{CRAFT_TPYE_STARIS,"B002_005",1,3361,0,""},
	{CRAFT_TPYE_STARIS,"B002_006",1,11472,0,""},
	{CRAFT_TPYE_STARIS,"B002_007",1,7096,0,""},


	{CRAFT_TPYE_DOOR,"B003_000",1,2949,0,"A008_002,150&A008_003,70"},
	{CRAFT_TPYE_DOOR,"B003_001",1,19858,0,"A008_000,200&A008_001,70"},
	{CRAFT_TPYE_DOOR,"B003_002",1,4798,0,""},
	{CRAFT_TPYE_DOOR,"B003_003",1,7707,0,""},
	{CRAFT_TPYE_DOOR,"B003_004",1,7709,0,""},
	{CRAFT_TPYE_DOOR,"B003_005",1,10149,0,""},
	{CRAFT_TPYE_DOOR,"B003_006",1,13188,0,""},
	{CRAFT_TPYE_DOOR,"B003_007",1,1508,0,""},
	{CRAFT_TPYE_DOOR,"B003_008",1,2909,0,""},
	{CRAFT_TPYE_DOOR,"B003_009",1,2990,0,""},
	{CRAFT_TPYE_DOOR,"B003_010",1,980,0,""},
	{CRAFT_TPYE_DOOR,"B003_011",1,985,0,""},

	{CRAFT_TPYE_COFFER,"B004_000",1,2977,0,"A008_002,200&A008_003,100"},
	{CRAFT_TPYE_COFFER,"B004_001",1,964,1,""},
	{CRAFT_TPYE_COFFER,"B004_002",1,2972,1,""},
	{CRAFT_TPYE_COFFER,"B004_003",1,3798,1,""},
	{CRAFT_TPYE_COFFER,"B004_004",1,944,1,""},
	{CRAFT_TPYE_COFFER,"B004_005",1,3066,1,""}

};


#define MAX_CRAFTBULIDS MAX_CA_OBJECTS-1000
enum CraftBulid_InFo
{
    _Key[37],
    _CreaterKey[37],
	_CraftItemKey[37],
    _CName[16],
	_CraftWorld,
	Float:_Chp,
	Float:_Cmhp,
	Float:_Cx,
	Float:_Cy,
	Float:_Cz,
	Float:_Crx,
	Float:_Cry,
	Float:_Crz,
	_Cmove,
	_CDelaymove,
	Float:_Cmx,
	Float:_Cmy,
	Float:_Cmz,
	Float:_Cmrx,
	Float:_Cmry,
	Float:_Cmrz,
	Float:_Cspeed,
	Float:_Cmdistance,
	_CcapacityLevel,
	_CobjectIndex,
	Text3D:_C3dtext,
	_CareaID,
	_CfindareaID,
	_CMoveAreaID,
	_CraftItemID,
	_CraftMoveIng,
	Timer:_DelayMove
}
new CraftBulid[MAX_CRAFTBULIDS][CraftBulid_InFo];
new Iterator:CraftBulid<MAX_CRAFTBULIDS>;
////////////////////////
#define MAX_CRAFTBULID_INV_THINGS 2000//建筑箱子容纳
enum CraftBulidInv_InFo
{
    _Key[37],
    _CraftBulidKey[37],
	_ItemKey[37],
	_Amounts,
	Float:_Durable,
	_GetTime,
	_ItemID
}
new CraftBulidInv[MAX_CRAFTBULID_INV_THINGS][CraftBulidInv_InFo];
new Iterator:CraftBulidInv<MAX_CRAFTBULID_INV_THINGS>;
new PlayerStrongBoxDalay[MAX_PLAYERS];
////////////////////////
/********************************************************************/
/********************************************************************/
new VehName[212][] = {
	"Landstalker","Bravura","Buffalo","Linerunner","Pereniel","Sentinel","Dumper","Firetruck","Trashmaster","Stretch","Manana","Infernus",
	"Voodoo","Pony","Mule","Cheetah","Ambulance","Leviathan","Moonbeam","Esperanto","Taxi","Washington","Bobcat","Mr Whoopee","BF Injection",
	"Hunter","Premier","Enforcer","Securicar","Banshee","Predator","Bus","Rhino","Barracks","Hotknife","Trailer","Previon","Coach","Cabbie",
	"Stallion","Rumpo","RC Bandit","Romero","Packer","Monster","Admiral","Squalo","Seasparrow","Pizzaboy","Tram","Trailer","Turismo","Speeder",
	"Reefer","Tropic","Flatbed","Yankee","Caddy","Solair","Berkley's RC Van","Skimmer","PCJ-600","Faggio","Freeway","RC Baron","RC Raider",
	"Glendale","Oceanic","Sanchez","Sparrow","Patriot","Quad","Coastguard","Dinghy","Hermes","Sabre","Rustler","ZR3 50","Walton","Regina",
	"Comet","BMX","Burrito","Camper","Marquis","Baggage","Dozer","Maverick","News Chopper","Rancher","FBI Rancher","Virgo","Greenwood",
	"Jetmax","Hotring","Sandking","Blista Compact","Police Maverick","Boxville","Benson","Mesa","RC Goblin","Hotring Racer A","Hotring Racer B",
	"Bloodring Banger","Rancher","Super GT","Elegant","Journey","Bike","Mountain Bike","Beagle","Cropdust","Stunt","Tanker","RoadTrain",
	"Nebula","Majestic","Buccaneer","Shamal","Hydra","FCR-900","NRG-500","HPV1000","Cement Truck","Tow Truck","Fortune","Cadrona","FBI Truck",
	"Willard","Forklift","Tractor","Combine","Feltzer","Remington","Slamvan","Blade","Freight","Streak","Vortex","Vincent","Bullet","Clover",
	"Sadler","Firetruck","Hustler","Intruder","Primo","Cargobob","Tampa","Sunrise","Merit","Utility","Nevada","Yosemite","Windsor","Monster A",
	"Monster B","Uranus","Jester","Sultan","Stratum","Elegy","Raindance","RC Tiger","Flash","Tahoma","Savanna","Bandito","Freight","Trailer",
	"Kart","Mower","Duneride","Sweeper","Broadway","Tornado","AT-400","DFT-30","Huntley","Stafford","BF-400","Newsvan","Tug","Trailer A","Emperor",
	"Wayfarer","Euros","Hotdog","Club","Trailer B","Trailer C","Andromada","Dodo","RC Cam","Launch","Police Car (LSPD)","Police Car (SFPD)",
	"Police Car (LVPD)","Police Ranger","Picador","S.W.A.T. Van","Alpha","Phoenix","Glendale","Sadler","Luggage Trailer A","Luggage Trailer B",
	"Stair Trailer","Boxville","Farm Plow","Utility Trailer"
};
stock TurnPlayerFaceToPos(playerid, Float:x, Float:y, Float:z)
{
	#pragma unused z
    new Float:angle;
    angle = 180.0-atan2(PlayerPos[playerid][0]-x,PlayerPos[playerid][1]-y);
    SetPlayerFacingAngle(playerid, angle);
    return 1;
}
FUNC::ToggleVehicleEngine(vehicle,enginestate)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicle, engine, lights, alarm, doors, bonnet, boot, objective);
   	SetVehicleParamsEx(vehicle, enginestate, lights, alarm, doors, bonnet, boot, objective);
	return 1;
}
stock strcount(const string[], const sub[], bool:ignorecase = false, bool:count_overlapped = false) {
	new
		increment = count_overlapped ? 1 : strlen(sub),
		pos = -increment,
		count = 0
	;


	while (-1 != (pos = strfind(string, sub, ignorecase, pos + increment)))
		count++;

	return count;
}
FUNC::CheckPlayerNameForRP(const PlayerName[])
{
    if(strlen(PlayerName)<6)return 0;
    if(strcount(PlayerName,"_")!=1)return 0;
    new underscorecount, expectinguppercase = 1;
    for (new i = 0, j = strlen(PlayerName); i < j; i++)
    {
        if (expectinguppercase == 1)
        {
            if (PlayerName[i] < 'A' || PlayerName[i] > 'Z') return 0;
            expectinguppercase = 0;
            continue;
        }
        switch (PlayerName[i])
        {
            case '_':
            {
                if (underscorecount == 1) return 0;
                else
                {
                    underscorecount = 1;
                    expectinguppercase = 1;
                }
                continue;
            }
            case 'A' .. 'Z': continue;
            case 'a' .. 'z': continue;
            default: return 0;
        }
    }
    return 1;
}
stock bool:isLetter(character[])
{
	return (character[0] >=65 && character[0] !=91 && character[0] !=92&& character[0] !=93&& character[0] !=94 && character[0] !=95 && character[0] !=96 && character[0] <=122);
}
stock bool:isDigit(character[])
{
	return (character[0] >=48 && character[0] <=57);
}
stock toUpperCase(string[])
{
	new str[2],concat[256];
	for(new i=0;i<strlen(string);i++)
	{
		if(string[i] >=97 && string[i] <=122) string[i]-=32;
  		format(str,sizeof(str),"%c",string[i]);
		strcat(concat,str);
	}
	return concat;
}
stock CheckFactionName(FactionNames[])
{
    if(strlen(FactionNames)<3||strlen(FactionNames)>=12)return 0;
	for(new i=0;i<strlen(FactionNames);i++)if(!isLetter(FactionNames[i]))return 0;
    return 1;
}
stock GetPlayerNameEx(playerid,name[],len)
{
	new ret=GetPlayerName(playerid,name,len);
	for(new i=0;name[i]!=0;i++)if(name[i]<0)name[i]+=256;
	return ret;
}
stock bool:isequal(const str1[], const str2[], bool:ignorecase = false)
{
    new c1 = (str1[0] > 255) ? str1{0} : str1[0],
        c2 = (str2[0] > 255) ? str2{0} : str2[0];
    if (!c1 != !c2)return false;
    return !strcmp(str1, str2, ignorecase);
}
Randoms(min, max)
{
	if(min == max)return min;
	if(min > max)return min;
	new a = random(max - min) + min;
	return a;
}
Float:RandFloat(Float:max)
{
	new tmp = random(floatround(max*1000));
	new Float:result = floatdiv(float(tmp),1000.0);
	return Float:result;
}
stock SetPlayerPosEx(playerid,Float:x,Float:y,Float:z,Float:a,interior,world,dalay=0,Float:rand=0.0,bool:andveh=true)
{
	SetPlayerFacingAngle(playerid,a);
	SetPlayerInterior(playerid,interior);
	SetPlayerVirtualWorld(playerid,world);
	if(rand!=0.0)
	{
	    x=floatadd(x,rand);
	    y=floatadd(y,rand);
	    z=floatadd(z,rand);
	}
	if(IsPlayerInAnyVehicle(playerid)&&!GetPlayerVehicleSeat(playerid)&&interior==0)
	{
		if(andveh==true)
		{
			new vehicleid=GetPlayerVehicleID(playerid);
	     	SetPlayerPos(playerid,x,y,z);
    	 	SetVehicleVirtualWorld(vehicleid,world);
         	LinkVehicleToInterior(vehicleid,interior);
		 	SetVehiclePos(vehicleid,x,y,z+1.5);
		 	SetVehicleZAngle(vehicleid,a);
    		PutPlayerInVehicle(playerid,vehicleid,0);
		}
		else RemovePlayerFromVehicle(playerid);
	}
	else SetPlayerPos(playerid,x,y,z);
	SetCameraBehindPlayer(playerid);
	if(dalay>0)
	{
	    TogglePlayerControllable(playerid,0);
    	SetTimerEx("FreePlayer",dalay,false,"i",playerid);
	}
    return 1;
}
FUNC::FreePlayer(playerid,Float:x,Float:y,Float:z,interior,world)return TogglePlayerControllable(playerid,1);
stock GetRandomXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
    new Float:a;
    GetPlayerPos(playerid, x, y, a);
    GetPlayerFacingAngle(playerid, a);
    if (GetPlayerVehicleID(playerid))
    {
		GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
    }
    x += (distance * floatsin(-a, degrees))+RandFloat(distance);
    y += (distance * floatcos(-a, degrees))+RandFloat(distance);
}
stock GetAngleDistancePoint(Float:angle,Float:distance,&Float:x,&Float:y)
{
	angle=CompRotationFloat(angle);
	new Float:tmpa=angle;
	while(tmpa>=90)tmpa=tmpa-90;
	new Float:d1=floatsin(tmpa,degrees)*distance;
	new Float:d2=floatcos(tmpa,degrees)*distance;
	if(0<=angle<90)
	{
		x=x-d1;
		y=y+d2;
	}
	if(90<=angle<180)
	{
		x=x-d2;
		y=y-d1;
	}
	if(180<=angle<270)
	{
		x=x+d1;
		y=y-d2;
	}
	if(270<=angle<360)
	{
		x=x+d2;
		y=y+d1;
	}
}
stock HighestTopList(const playerid, const Value, Player_ID[], Top_Score[], Loop) 	//	 Created by Phento
{
	new
		t = 0,
		p = Loop-1;
	while(t <= p) {
		if(Value >= Top_Score[t]) {
			if(Top_Score[t+1] <= 0) p = t+1;
			while(p > t) { Top_Score[p] = Top_Score[p - 1]; Player_ID[p] = Player_ID[p - 1]; p--; }
			Top_Score[t] = Value; Player_ID[t] = playerid;
			break;
		} t++; }
	return 1;
}
stock HighestTopListFloat(const playerid, const Float:Values, Player_ID[], Float:Top_Score[], Loop)
{
	new
	    t = 0,
		p = Loop-1;
	while(t < p) {
	    if(Values >= Top_Score[t]) {
			while(p > t) { Top_Score[p] = Top_Score[p - 1]; Player_ID[p] = Player_ID[p - 1]; p--; }
			Top_Score[t] = Values; Player_ID[t] = playerid;
			break;
		} t++; }
	return 1;
}
stock StrtokPack1(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= '&'))
	{
		index++;
	}
	new offset = index;
	new result[24];
	while ((index < length) && (string[index] > '&') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	if(strlen(result)<=0)
	{
	    result="-1";
	}
	return result;
}
stock StrtokPack2(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ','))
	{
		index++;
	}
	new offset = index;
	new result[24];
	while ((index < length) && (string[index] > ',') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	if(strlen(result)<=0)
	{
	    result="-1";
	}
	return result;
}
stock UpdateStreamer(Float:x, Float:y, Float:z,worldid=-1,interiorid=-1,type=-1)
{
	foreach(new i:Player)
	{
	    if(RealPlayer(i))
	    {
	    	if(IsPlayerInRangeOfPoint(i,500.0,x,y,z))Streamer_UpdateEx(i,x,y,z,worldid,interiorid,type);
	    }
	}
	return 1;
}
FUNC::GetZoneCenterPoint(Float:MinX,Float:MinY,Float:MaxX,Float:MaxY,&Float:X,&Float:Y)
{
	new Float:Long,Float:Wide;
	Long=floatsub(MaxX,MinX);
	Wide=floatsub(MaxY,MinY);
  	X=(Long/2)+MinX;
  	Y=(Wide/2)+MinY;
}
stock Float:PosFacingPos(Float:pX, Float:pY, Float:pZ, Float:pAng,Float:X, Float:Y, Float:Z)//POS位置玩家是否面对另外POS位置玩家
{
	new Float:ang,Float:lastang;
	if( Y > pY ) ang = (-acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);
	else if( Y < pY && X < pX ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 450.0);
	else if( Y < pY ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);
	if(X > pX)ang = (floatabs(floatabs(ang) + 180.0));
	else ang = (floatabs(ang) - 180.0);
	lastang=floatsub(ang,pAng);
	return lastang;
}
stock Float:PointAngle(Float:carangle, Float:xa, Float:ya, Float:xb, Float:yb) // Don't know the owner.
{
	new Float:xc, Float:yc;
	new Float:angle;
	xc = floatabs(floatsub(xa,xb));
	yc = floatabs(floatsub(ya,yb));
	if (yc == 0.0 || xc == 0.0)
	{
		if(yc == 0 && xc > 0) angle = 0.0;
		else if(yc == 0 && xc < 0) angle = 180.0;
		else if(yc > 0 && xc == 0) angle = 90.0;
		else if(yc < 0 && xc == 0) angle = 270.0;
		else if(yc == 0 && xc == 0) angle = 0.0;
	}
	else
	{
		angle = atan(xc/yc);
		if(xb > xa && yb <= ya) angle += 90.0;
		else if(xb <= xa && yb < ya) angle = floatsub(90.0, angle);
		else if(xb < xa && yb >= ya) angle -= 90.0;
		else if(xb >= xa && yb > ya) angle = floatsub(270.0, angle);
	}
	return floatadd(angle, -carangle);
}
Float:GetSpeed(playerid)
{
	new Float:x, Float:y, Float:z;
	GetPlayerVelocity(playerid, x, y, z);
	return floatabs(floatsqroot(floatpower(x, 2) + floatpower(y, 2)))*181.5;
}
FUNC::bool:IsPlayerCrouching(playerid)
{
    new animlib[32];
	new animname[32];
    GetAnimationName(GetPlayerAnimationIndex(playerid),animlib,32,animname,32);
    return (!strcmp(animname,"WEAPON_CROUCH",false)||!strcmp(animname,"GUNCROUCHFWD",false)||!strcmp(animname,"GUNCROUCHBWD",false)||!strcmp(animlib,"PYTHON",false));
}
Float:fclamp(Float:value, Float:min, Float:max)
{
	if(value < min || value > max)
	{
	    if(value < min) return min;
	    if(value > max) return max;
	}
	return value;
}
PreloadAnimLib(playerid, animlib[])
{
	ApplyAnimation(playerid,animlib,"null",0.0,0,0,0,0,0);
}
stock PreloadPlayerAnims(playerid)
{
    ApplyAnimation(playerid,"PED","BIKE_fallR",0.0,0,0,0,0,0);
	PreloadAnimLib(playerid, "PED");
	PreloadAnimLib(playerid, "AIRPORT");
	PreloadAnimLib(playerid, "ATTRACTORS");
	PreloadAnimLib(playerid, "BAR");
	PreloadAnimLib(playerid, "BASEBALL");
	PreloadAnimLib(playerid, "BD_FIRE");
	PreloadAnimLib(playerid, "BEACH");
	PreloadAnimLib(playerid, "BENCHPRESS");
	PreloadAnimLib(playerid, "BF_INJECTION");
	PreloadAnimLib(playerid, "BIKED");
	PreloadAnimLib(playerid, "BIKEH");
	PreloadAnimLib(playerid, "BIKELEAP");
	PreloadAnimLib(playerid, "BIKES");
	PreloadAnimLib(playerid, "BIKEV");
	PreloadAnimLib(playerid, "BIKE_DBZ");
	PreloadAnimLib(playerid, "BMX");
	PreloadAnimLib(playerid, "BOMBER");
	PreloadAnimLib(playerid, "BOX");
	PreloadAnimLib(playerid, "BSKTBALL");
	PreloadAnimLib(playerid, "BUDDY");
	PreloadAnimLib(playerid, "BUS");
	PreloadAnimLib(playerid, "CAMERA");
	PreloadAnimLib(playerid, "CAR");
	PreloadAnimLib(playerid, "CARRY");
	PreloadAnimLib(playerid, "CAR_CHAT");
	PreloadAnimLib(playerid, "CASINO");
	PreloadAnimLib(playerid, "CHAINSAW");
	PreloadAnimLib(playerid, "CHOPPA");
	PreloadAnimLib(playerid, "CLOTHES");
	PreloadAnimLib(playerid, "COACH");
	PreloadAnimLib(playerid, "COLT45");
	PreloadAnimLib(playerid, "COP_AMBIENT");
	PreloadAnimLib(playerid, "COP_DVBYZ");
	PreloadAnimLib(playerid, "CRACK");
	PreloadAnimLib(playerid, "CRIB");
	PreloadAnimLib(playerid, "DAM_JUMP");
	PreloadAnimLib(playerid, "DANCING");
	PreloadAnimLib(playerid, "DEALER");
	PreloadAnimLib(playerid, "DILDO");
	PreloadAnimLib(playerid, "DODGE");
	PreloadAnimLib(playerid, "DOZER");
	PreloadAnimLib(playerid, "DRIVEBYS");
	PreloadAnimLib(playerid, "FAT");
	PreloadAnimLib(playerid, "FIGHT_B");
	PreloadAnimLib(playerid, "FIGHT_C");
	PreloadAnimLib(playerid, "FIGHT_D");
	PreloadAnimLib(playerid, "FIGHT_E");
	PreloadAnimLib(playerid, "FINALE");
	PreloadAnimLib(playerid, "FINALE2");
	PreloadAnimLib(playerid, "FLAME");
	PreloadAnimLib(playerid, "FLOWERS");
	PreloadAnimLib(playerid, "FOOD");
	PreloadAnimLib(playerid, "FREEWEIGHTS");
	PreloadAnimLib(playerid, "GANGS");
	PreloadAnimLib(playerid, "GHANDS");
	PreloadAnimLib(playerid, "GHETTO_DB");
	PreloadAnimLib(playerid, "GOGGLES");
	PreloadAnimLib(playerid, "GRAFFITI");
	PreloadAnimLib(playerid, "GRAVEYARD");
	PreloadAnimLib(playerid, "GRENADE");
	PreloadAnimLib(playerid, "GYMNASIUM");
	PreloadAnimLib(playerid, "HAIRCUTS");
	PreloadAnimLib(playerid, "HEIST9");
	PreloadAnimLib(playerid, "INT_HOUSE");
	PreloadAnimLib(playerid, "INT_OFFICE");
	PreloadAnimLib(playerid, "INT_SHOP");
	PreloadAnimLib(playerid, "JST_BUISNESS");
	PreloadAnimLib(playerid, "KART");
	PreloadAnimLib(playerid, "KISSING");
	PreloadAnimLib(playerid, "KNIFE");
	PreloadAnimLib(playerid, "LAPDAN1");
	PreloadAnimLib(playerid, "LAPDAN2");
	PreloadAnimLib(playerid, "LAPDAN3");
	PreloadAnimLib(playerid, "LOWRIDER");
	PreloadAnimLib(playerid, "MD_CHASE");
	PreloadAnimLib(playerid, "MD_END");
	PreloadAnimLib(playerid, "MEDIC");
	PreloadAnimLib(playerid, "MISC");
	PreloadAnimLib(playerid, "MTB");
	PreloadAnimLib(playerid, "MUSCULAR");
	PreloadAnimLib(playerid, "NEVADA");
	PreloadAnimLib(playerid, "ON_LOOKERS");
	PreloadAnimLib(playerid, "OTB");
	PreloadAnimLib(playerid, "PARACHUTE");
	PreloadAnimLib(playerid, "PARK");
	PreloadAnimLib(playerid, "PAULNMAC");
	PreloadAnimLib(playerid, "PED");
	PreloadAnimLib(playerid, "PLAYER_DVBYS");
	PreloadAnimLib(playerid, "PLAYIDLES");
	PreloadAnimLib(playerid, "POLICE");
	PreloadAnimLib(playerid, "POOL");
	PreloadAnimLib(playerid, "POOR");
	PreloadAnimLib(playerid, "PYTHON");
	PreloadAnimLib(playerid, "QUAD");
	PreloadAnimLib(playerid, "QUAD_DBZ");
	PreloadAnimLib(playerid, "RAPPING");
	PreloadAnimLib(playerid, "RIFLE");
	PreloadAnimLib(playerid, "RIOT");
	PreloadAnimLib(playerid, "ROB_BANK");
	PreloadAnimLib(playerid, "ROCKET");
	PreloadAnimLib(playerid, "RUSTLER");
	PreloadAnimLib(playerid, "RYDER");
	PreloadAnimLib(playerid, "SCRATCHING");
	PreloadAnimLib(playerid, "SHAMAL");
	PreloadAnimLib(playerid, "SHOP");
	PreloadAnimLib(playerid, "SHOTGUN");
	PreloadAnimLib(playerid, "SILENCED");
	PreloadAnimLib(playerid, "SKATE");
	PreloadAnimLib(playerid, "SMOKING");
	PreloadAnimLib(playerid, "SNIPER");
	PreloadAnimLib(playerid, "SPRAYCAN");
	PreloadAnimLib(playerid, "STRIP");
	PreloadAnimLib(playerid, "SUNBATHE");
	PreloadAnimLib(playerid, "SWAT");
	PreloadAnimLib(playerid, "SWEET");
	PreloadAnimLib(playerid, "SWIM");
	PreloadAnimLib(playerid, "SWORD");
	PreloadAnimLib(playerid, "TANK");
	PreloadAnimLib(playerid, "TATTOOS");
	PreloadAnimLib(playerid, "TEC");
	PreloadAnimLib(playerid, "TRAIN");
	PreloadAnimLib(playerid, "TRUCK");
	PreloadAnimLib(playerid, "UZI");
	PreloadAnimLib(playerid, "VAN");
	PreloadAnimLib(playerid, "VENDING");
	PreloadAnimLib(playerid, "VORTEX");
	PreloadAnimLib(playerid, "WAYFARER");
	PreloadAnimLib(playerid, "WEAPONS");
	PreloadAnimLib(playerid, "WUZI");
	PreloadAnimLib(playerid, "WOP");
	PreloadAnimLib(playerid, "GFUNK");
	PreloadAnimLib(playerid, "RUNNINGMAN");
}
new bool:IsDebug[MAX_PLAYERS]= {false, ...};
FUNC::Debug(playerid,error[])
{
	if(playerid!=NONE)
	{
	    if(IsDebug[playerid]==true)SCM(playerid,-1,error);
	}
	printf(error);
	return 1;
}
FUNC::SendMsgToAllPlayers(Color,Msg[])
{
    foreach(new playerid:Player)
    {
		if(playerid==INVALID_PLAYER_ID)continue;
    	if(!IsPlayerConnected(playerid))continue;
    	if(IsPlayerNPC(playerid))continue;
        SCM(playerid,Color,Msg);
    }
	return 1;
}

CMD:bug(playerid)
{
	if(IsDebug[playerid]==true)
	{
		IsDebug[playerid]=false;
		SCM(playerid,-1,"调试信息关闭了");
	}
	else
	{
	    IsDebug[playerid]=true;
	    SCM(playerid,-1,"调试信息开启了");
	}
	return 1;
}
/********************************************************************/
enum
{
    ITEM_TYPE_NONE,
	ITEM_TYPE_WEAPON,//武器类
	ITEM_TYPE_MEDICAL,//医疗类
	ITEM_TYPE_FOOD,//食品类
	ITEM_TYPE_EQUIP,//装备类
	ITEM_TYPE_VEHICLETACKLE,//汽车用品类
	ITEM_TYPE_COMMU,//通信类
	ITEM_TYPE_CRAFT,//制作类
	ITEM_TYPE_BOMB,//爆炸类
	ITEM_TYPE_ANTIBIOTIC//抗生素类
}
enum ItemAttachPos_Info
{
	_Model,
	_Bone,
	Float:_fOffsetX,
	Float:_fOffsetY,
	Float:_fOffsetZ,
	Float:_fRotX,
	Float:_fRotY,
	Float:_fRotZ,
	Float:_fScaleX,
	Float:_fScaleY,
	Float:_fScaleZ,
	_Animlib[24],
	_Animname[24],
	_AnimTime
}
new ItemAttachPos[][ItemAttachPos_Info] =
{
	{-2300, 1, 0.081000, -0.072999, -0.007999, 0.000000, 87.800041, 179.200027, 0.831999, 1.322000, 0.833000,"","",0},//1级背包
	{-2301, 1, 0.081000, -0.072999, -0.007999, 0.000000, 87.800041, 179.200027, 0.831999, 1.322000, 0.833000,"","",0},//2级背包
	{-2302, 1, 0.081000, -0.072999, -0.007999, 0.000000, 87.800041, 179.200027, 0.831999, 1.322000, 0.833000,"","",0},//3级背包
	{-2303, 1, 0.081000, -0.072999, -0.007999, 0.000000, 87.800041, 179.200027, 0.831999, 1.322000, 0.833000,"","",0},//4级背包

	{-2100, 6, 0.078999, 0.053999, -0.057999, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000,"FOOD", "EAT_BURGER",2000},//止痛片
	{-2101, 6, 0.110999, 0.114000, -0.004000, 0.000000, -77.300003, 0.000000, 0.689000, 0.489999, 0.757999,"CASINO", "DEALONE",2000},//绷带
	{-2102, 6, 0.098999, 0.045999, 0.026000, 0.000000, 89.100013, 0.000000, 1.000000, 1.000000, 1.000000,"BIKE_DBZ", "PASS_DRIVEBY_LHS",2000},//肾上腺素
	{-2104, 6, 0.045999, 0.086999, 0.000000, 0.000000, -86.099922, 0.000000, 1.000000, 1.000000, 1.000000,"COP_AMBIENT", "COPBROWSE_IN",2000},//急救包
	{-2103, 6, 0.488999, -0.118999, 0.030000, 0.000000, -99.500022, -13.599996, 1.000000, 1.000000, 1.000000,"COP_AMBIENT", "COPBROWSE_LOOP",2000},//大药箱

	{-2010, 6, 0.096000, 0.061999, -0.071999, 0.000000, 0.000000, 0.000000, 0.805000, 0.849999, 0.859000,"BAR", "DNK_STNDM_LOOP",0},//饮料

	{-2500, 1, 0.077000, 0.054000, -0.010000, 1.500000, -2.499998, 0.000000, 1.003000, 1.289999, 1.086000,"","",0},//一级防弹衣
	{-2501, 1, 0.077000, 0.054000, -0.010000, 1.500000, -2.499998, 0.000000, 1.003000, 1.289999, 1.086000,"","",0},//二级防弹衣
	{-2502, 1, 0.077000, 0.054000, -0.010000, 1.500000, -2.499998, 0.000000, 1.003000, 1.289999, 1.086000,"","",0},//三级防弹衣
	{-2503, 1, 0.077000, 0.054000, -0.010000, 1.500000, -2.499998, 0.000000, 1.003000, 1.289999, 1.086000,"","",0},//四级防弹衣

	{-2400, 2, 0.086999, 0.015000, -0.002999, 0.000000, 91.899993, 174.699905, 1.128000, 1.136000, 0.949000,"","",0},//一级头盔
	{-2401, 2, 0.086999, 0.015000, -0.002999, 0.000000, 91.899993, 174.699905, 1.128000, 1.136000, 0.949000,"","",0},//二级头盔
	{-2402, 2, 0.086999, 0.015000, -0.002999, 0.000000, 91.899993, 174.699905, 1.128000, 1.136000, 0.949000,"","",0},//三级头盔
	{-2403, 2, 0.086999, 0.015000, -0.002999, 0.000000, 91.899993, 174.699905, 1.128000, 1.136000, 0.949000,"","",0},//四级头盔

	{-2601, 2, -0.257000, 0.009999, -0.022999, -7.000000, 85.399993, 177.499984, 1.361000, 1.000000, 1.000000,"","",0},//防毒面罩 1级
	{-2600, 2, -0.091999, 0.003000, -0.009999, 0.000000, 86.599983, 176.400024, 1.057000, 1.044000, 1.000000,"","",0},//防毒面罩 1-1级
	{-2602, 2, -0.019000, 0.101000, -0.012000, 0.000000, 89.999984, 177.000030, 1.000000, 1.092000, 1.000000,"","",0},//防毒面罩2级
	{-2603, 2, 0.028000, 0.031999, -0.007999, 2.999986, 85.799865, 177.400207, 1.000000, 1.206000, 0.968000,"","",0},//防毒面罩3级

	{-2021, 6, 0.083999, 0.067999, 0.017999, 12.600004, 71.500015, 76.699928, 1.000000, 1.000000, 1.000000,"FOOD", "EAT_BURGER",2000},//苹果2
	{-2022, 6, 0.078999, 0.059000, 0.027999, -37.300010, -146.499938, -134.599929, 1.000000, 1.000000, 1.000000,"FOOD", "EAT_BURGER",2000},//苹果
	{18636, 2, 0.130000, 0.039999, -0.000999, 1.400000, 86.900001, 87.099983, 1.133999, 1.125000, 1.154999,"","",0},//游戏自带 警察棒球帽
	{18961, 2, 0.112999, 0.032999, -0.008000, -4.099999, 91.799995, 92.399955, 1.229000, 1.158000, 1.084000,"","",0},//游戏自带 普通帽子
	{19160, 2, 0.065999, -0.003000, 0.000000, 0.000000, 0.000000, -9.899998, 1.125000, 1.166999, 1.256000,"","",0},//游戏自带 工人帽
	{19161, 2, 0.065999, 0.001999, 0.000000, 0.000000, -1.799998, -10.200001, 1.103000, 1.200000, 1.275999,"","",0},//游戏自带 警察棒球帽2
	{19162, 2, 0.067999, 0.000000, 0.000000, 0.000000, 0.000000, -6.999999, 1.172000, 1.169999, 1.252000,"","",0},//游戏自带 警察棒球帽3
	{18946, 2, 0.160000, -0.001999, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.111999, 1.079999,"","",0},//游戏自带 灰色绅士帽
	{18947, 2, 0.151999, -0.008000, -0.003000, 0.000000, 0.000000, 0.000000, 1.033000, 1.077000, 1.071000,"","",0},//游戏自带 黑色绅士帽
	{19099, 2, 0.155000, 0.005000, -0.008000, 0.000000, 0.000000, 0.000000, 1.000000, 1.259000, 1.217000,"","",0},//游戏自带 警用牛仔帽1
	{19100, 2, 0.155000, 0.005000, -0.008000, 0.000000, 0.000000, 0.000000, 1.000000, 1.259000, 1.217000,"","",0},//游戏自带 警用牛仔帽2
	{18968, 2, 0.127999, 0.009999, -0.006000, 0.000000, 92.299972, 92.399971, 1.042000, 1.095000, 1.088000,"","",0},//游戏自带 Nike渔夫帽
	{18959, 2, 0.095999, -0.028000, -0.008000, -77.700073, 124.100090, 5.399917, 1.142000, 1.242000, 1.457000,"","",0},//游戏自带 陆军棒球帽
	{19520, 2, 0.141999, 0.003000, -0.003000, 0.000000, 0.000000, 0.000000, 1.649999, 1.432000, 1.372999,"","",0},//游戏自带 警官帽
	{19521, 2, 0.141999, 0.003000, -0.003000, 0.000000, 0.000000, 0.000000, 1.649999, 1.432000, 1.372999,"","",0},//游戏自带 警官帽2
	{18954, 2, 0.110000, 0.027000, -0.004000, 0.000000, -2.899999, 0.000000, 1.391000, 1.161000, 1.191000,"","",0},//游戏自带 军绿毛线帽
	{18953, 2, 0.110000, 0.027000, -0.004000, 0.000000, -2.899999, 0.000000, 1.391000, 1.161000, 1.191000,"","",0},//游戏自带 黑色毛线帽
	{19554, 2, 0.141999, 0.000000, -0.000999, 0.000000, 0.000000, 0.000000, 1.000000, 1.420999, 1.340000,"","",0},//自带 雪地帽1
	{19022, 2, 0.087999, 0.036000, -0.005000, 2.700000, 86.600044, 88.499900, 1.177999, 1.133000, 1.000000,"","",0},//自带 警察眼镜
	{19033, 2, 0.102999, 0.037000, -0.004000, -0.600000, 87.599983, 91.899955, 1.149999, 1.150000, 1.067999,"","",0},//黑墨镜
	{18964, 2, 0.119999, 0.011000, -0.022000, 0.000000, 132.399948, 0.000000, 1.000000, 1.615000, 1.000000,"","",0},//雪地帽2
	{19921, 6, 0.081000, 0.028000, 0.015000, 97.199943, -1.000004, -80.100028, 1.000000, 1.000000, 1.000000,"","",0},//工具箱
	{19579, 6, 0.059000, 0.107000, -0.043999, 9.499997, 0.000000, -93.400016, 0.547999, 0.856000, 0.862000,"FOOD", "EAT_BURGER",2000},//面包
	{19582, 6, 0.057999, 0.102000, 0.000000, 0.000000, 121.300041, 83.100067, 1.000000, 1.000000, 1.000000,"FOOD", "EAT_BURGER",2000},//肉
	{19571, 6, 0.086999, 0.087999, 0.078000, 178.000030, -13.500001, 79.599945, 0.341999, 1.000000, 0.351999,"FOOD", "EAT_BURGER",2000},//披萨
	{19570, 6, 0.075999, 0.064000, -0.048999, 0.500000, 0.000000, 0.000000, 0.544999, 0.694000, 0.523999,"BAR", "DNK_STNDF_LOOP",2000},//过期牛奶
	{18875, 4, 0.058999, 0.000000, -0.050999, -167.099960, 8.099981, 88.500000, 1.000000, 1.000000, 1.000000,"","",0},//对讲机
	{19821, 6, 0.073999, 0.052999, -0.070999, 0.000000, 0.000000, 0.000000, 0.529000, 0.509999, 0.437000,"BAR", "DNK_STNDF_LOOP",3000},//威士忌
	{19824, 6, 0.085999, 0.057999, -0.075999, 0.000000, 0.000000, 0.000000, 0.723000, 0.554999, 0.534999,"BAR", "DNK_STNDF_LOOP",3000},//伏特加
	{1098, 6, 0.213000, 0.050999, 0.019000, 10.599995, -1.699995, -173.500015, 0.747000, 0.393000, 0.329000,"","",0},//轮胎
	{19917, 6, 0.396999, 0.026000, 0.077999, 7.799998, -98.600006, -92.299980, 0.309000, 0.277000, 0.400999,"","",0},//引擎
	{19896, 5, 0.096999, 0.040999, -0.026000, 88.499984, -119.699996, 5.699999, 1.000000, 1.000000, 1.000000,"LOWRIDER", "M_SMKLEAN_LOOP",10000},//香烟
	{1650, 6, 0.123000, 0.015999, 0.054000, 6.900000, -97.900001, 0.000000, 1.000000, 1.000000, 1.000000,"","",0},//空汽油
	{-2024, 6, 0.296000, 0.022000, 0.078999, 0.000000, -103.299964, 173.700042, 1.000000, 1.000000, 1.000000,"","",0},//MOD 满汽油
	
	{1636, 6, -0.010000, -0.001999, 0.280000, 90.899971, -15.500003, 0.000000, 1.000000, 1.000000, 1.000000,"BOMBER","BOM_Plant_Crouch_In",3000},//鱼雷
	{364, 6, 0.125999, -0.067000, 0.083999, 0.000000, -101.599998, 0.000000, 1.000000, 1.000000, 1.000000,"BOMBER","BOM_Plant_Crouch_In",3000},//雷管

    {18875, 7, 0.000000, -0.053000, 0.317000, 21.299919, -15.500042, -0.700022, 1.000000, 1.000000, 1.000000,"","",0}//导航/对讲机
};
enum Item_Info
{
    _Model,//模型
	_Key[37],//唯一码
	_Type,//类型
	_Name[32],//名称
	_NameTXD[64],//Txd名称
	
	_WeaponTXD[64],//Txd名称
	_WeaponID,//武器ID
	_WeaponDressSlot,//武器空槽

	_EquipDressSlot,//装备空槽
	_EquipBone,//装备部位

	_Durable,//耐久

	_BuffTime,//BUFF持续时间
	Float:_BuffEffect,//BUFF效果

	Float:_Weight,//重量

	_Overlap,//是否允许重叠
	Float:_ExplosionSize,//爆炸范围
	_AdditionData[256],
	_Description[128],
	
	_SellPrice,//出售价格
	
	_AttachPosID//使用系统坐标
}
#define MAX_ITEMS 100
new Item[MAX_ITEMS][Item_Info];
new Iterator:Item<MAX_ITEMS>;
new ItemEx[][Item_Info] =
{
	{-2100,"A000_000",ITEM_TYPE_MEDICAL,"止痛片","mdl-2000:Health_Painkillers","",NONE,NONE,NONE,NONE,0,1,1.0,1.0,1},
	{-2101,"A000_001",ITEM_TYPE_MEDICAL,"绷带","mdl-2000:Health_Bandage","",NONE,NONE,NONE,NONE,0,1,1.0,2.0,1},
	{-2102,"A000_002",ITEM_TYPE_MEDICAL,"肾上腺素","mdl-2000:Health_Firstaidneedle","",NONE,NONE,NONE,NONE,0,1,1.0,3.0,1},
	{-2103,"A000_003",ITEM_TYPE_MEDICAL,"急救包","mdl-2000:Health_FirstaidkitBox","",NONE,NONE,NONE,NONE,0,1,1.0,4.0,1},
	{-2104,"A000_004",ITEM_TYPE_MEDICAL,"急救箱","mdl-2000:Health_Firstaidkit","",NONE,NONE,NONE,NONE,0,1,1.0,5.0,1},

	{19579,"A001_001",ITEM_TYPE_FOOD,"面包","mdl-2007:manyoutong","",NONE,NONE,NONE,NONE,0,1,1.0,5.0,1},
	{19582,"A001_002",ITEM_TYPE_FOOD,"肉","mdl-2007:rou","",NONE,NONE,NONE,NONE,0,1,1.0,5.0,1},
	{19571,"A001_004",ITEM_TYPE_FOOD,"披萨","mdl-2007:pisa","",NONE,NONE,NONE,NONE,0,1,1.0,5.0,1},
	{19570,"A001_005",ITEM_TYPE_FOOD,"过期牛奶","mdl-2007:niunai","",NONE,NONE,NONE,NONE,0,1,1.0,5.0,1},
	{19821,"A001_006",ITEM_TYPE_FOOD,"威士忌","mdl-2007:weishiji","",NONE,NONE,NONE,NONE,0,1,1.0,5.0,1},
	{19824,"A001_007",ITEM_TYPE_FOOD,"伏特加","mdl-2007:futejia","",NONE,NONE,NONE,NONE,0,1,1.0,5.0,1},
	{19896,"A001_008",ITEM_TYPE_FOOD,"香烟","mdl-2007:xiangyan","",NONE,NONE,NONE,NONE,0,1,1.0,5.0,1},


	{-2400,"A002_000",ITEM_TYPE_EQUIP,"伊万头盔","mdl-2004:toukui0","",NONE,NONE,0,2,1,NONE,0.1,10.0,0},
	{-2401,"A002_001",ITEM_TYPE_EQUIP,"特尔头盔","mdl-2004:toukui1","",NONE,NONE,0,2,1,NONE,0.2,10.0,0},
	{-2402,"A002_002",ITEM_TYPE_EQUIP,"萨雷头盔","mdl-2004:toukui2","",NONE,NONE,0,2,1,NONE,0.3,10.0,0},
	{-2403,"A002_003",ITEM_TYPE_EQUIP,"福斯头盔","mdl-2004:toukui3","",NONE,NONE,0,2,1,NONE,0.3,10.0,0},
	{18636,"A002_004",ITEM_TYPE_EQUIP,"警察棒球帽","mdl-2004:toukui13","",NONE,NONE,0,2,1,NONE,0.3,10.0,0},
	{18961,"A002_005",ITEM_TYPE_EQUIP,"普通帽子","mdl-2004:toukui14","",NONE,NONE,0,2,1,NONE,0.3,10.0,0},
	{19160,"A002_006",ITEM_TYPE_EQUIP,"工人帽","mdl-2004:toukui15","",NONE,NONE,0,2,1,NONE,0.3,10.0,0},
	{19161,"A002_007",ITEM_TYPE_EQUIP,"警察棒球帽2","mdl-2004:toukui16","",NONE,NONE,0,2,1,NONE,0.3,10.0,0},
	{19162,"A002_008",ITEM_TYPE_EQUIP,"警察棒球帽3","mdl-2004:toukui17","",NONE,NONE,0,2,1,NONE,0.3,10.0,0},
	{18946,"A002_009",ITEM_TYPE_EQUIP,"灰色绅士帽","mdl-2004:toukui18","",NONE,NONE,0,2,1,NONE,0.3,10.0,0},
	{18947,"A002_010",ITEM_TYPE_EQUIP,"黑色绅士帽","mdl-2004:toukui19","",NONE,NONE,0,2,1,NONE,0.3,10.0,0},
	{19099,"A002_011",ITEM_TYPE_EQUIP,"警用牛仔帽","mdl-2004:toukui20","",NONE,NONE,0,2,1,NONE,0.3,10.0,0},
	{19100,"A002_012",ITEM_TYPE_EQUIP,"警用牛仔帽","mdl-2004:toukui21","",NONE,NONE,0,2,1,NONE,0.3,10.0,0},
	{18968,"A002_013",ITEM_TYPE_EQUIP,"Nike蓝白渔夫帽","mdl-2004:toukui22","",NONE,NONE,0,2,1,NONE,0.3,10.0,0},
	{18959,"A002_014",ITEM_TYPE_EQUIP,"陆军迷彩帽","mdl-2004:toukui23","",NONE,NONE,0,2,1,NONE,0.3,10.0,0},
	{19520,"A002_015",ITEM_TYPE_EQUIP,"警官帽","mdl-2004:toukui24","",NONE,NONE,0,2,1,NONE,0.3,10.0,0},
	{19521,"A002_016",ITEM_TYPE_EQUIP,"警官帽2","mdl-2004:toukui25","",NONE,NONE,0,2,1,NONE,0.3,10.0,0},
	{18954,"A002_017",ITEM_TYPE_EQUIP,"军绿毛线帽","mdl-2004:toukui26","",NONE,NONE,0,2,1,NONE,0.3,10.0,0},
	{18953,"A002_018",ITEM_TYPE_EQUIP,"黑色毛线帽","mdl-2004:toukui27","",NONE,NONE,0,2,1,NONE,0.3,10.0,0},
	{19554,"A002_019",ITEM_TYPE_EQUIP,"雪地帽1","mdl-2004:toukui28","",NONE,NONE,0,2,1,NONE,0.3,10.0,0},
	{18964,"A002_020",ITEM_TYPE_EQUIP,"雪地帽2","mdl-2004:toukui29","",NONE,NONE,0,2,1,NONE,0.3,10.0,0},

	{19022,"A011_000",ITEM_TYPE_EQUIP,"警察眼镜","mdl-2007:yanjing0","",NONE,NONE,4,2,1,NONE,0.3,10.0,0},
	{19033,"A011_001",ITEM_TYPE_EQUIP,"黑墨镜","mdl-2007:yanjing1","",NONE,NONE,4,2,1,NONE,0.3,10.0,0},


	{-2500,"A003_000",ITEM_TYPE_EQUIP,"伊万防弹衣","mdl-2007:fdy0","",NONE,NONE,1,1,1,NONE,20.0,5.0,0},
	{-2501,"A003_001",ITEM_TYPE_EQUIP,"特尔防弹衣","mdl-2007:fdy1","",NONE,NONE,1,1,1,NONE,40.0,10.0,0},
	{-2502,"A003_002",ITEM_TYPE_EQUIP,"萨雷防弹衣","mdl-2007:fdy2","",NONE,NONE,1,1,1,NONE,60.0,5.0,0},
	{-2503,"A003_003",ITEM_TYPE_EQUIP,"福斯防弹衣","mdl-2007:fdy3","",NONE,NONE,1,1,1,NONE,60.0,5.0,0},

	{-2600,"A004_000",ITEM_TYPE_EQUIP,"伊万防毒面具","mdl-2004:fdmj0","",NONE,NONE,5,2,1,NONE,20.0,5.0,0},
	{-2601,"A004_001",ITEM_TYPE_EQUIP,"特尔防毒面具","mdl-2004:fdmj1","",NONE,NONE,5,2,1,NONE,40.0,10.0,0},
	{-2602,"A004_002",ITEM_TYPE_EQUIP,"萨雷防毒面具","mdl-2004:fdmj2","",NONE,NONE,5,2,1,NONE,60.0,5.0,0},
	{-2603,"A004_003",ITEM_TYPE_EQUIP,"福斯防毒面具","mdl-2004:fdmj3","",NONE,NONE,5,2,1,NONE,80.0,10.0,0},

	{-2300,"A005_000",ITEM_TYPE_EQUIP,"伊万背包","mdl-2007:bag0","",NONE,NONE,2,1,1,NONE,20.0,5.0,0},
	{-2301,"A005_001",ITEM_TYPE_EQUIP,"特尔背包","mdl-2007:bag1","",NONE,NONE,2,1,1,NONE,40.0,10.0,0},
	{-2302,"A005_002",ITEM_TYPE_EQUIP,"萨雷背包","mdl-2007:bag2","",NONE,NONE,2,1,1,NONE,60.0,5.0,0},
	{-2303,"A005_003",ITEM_TYPE_EQUIP,"福斯背包","mdl-2007:bag3","",NONE,NONE,2,1,1,NONE,80.0,10.0,0},


    {356,"A006_000",ITEM_TYPE_WEAPON,"M4卡宾枪","mdl-2007:WEAPON_M4","",WEAPON_M4,1,NONE,NONE,1,NONE,0.0,4.0,0},
    {358,"A006_001",ITEM_TYPE_WEAPON,"狙击枪","mdl-2007:WEAPON_SNIPER","",WEAPON_SNIPER,0,NONE,NONE,1,NONE,0.0,4.0,0},
    {357,"A006_002",ITEM_TYPE_WEAPON,"来复枪","mdl-2007:WEAPON_RIFLE","",WEAPON_RIFLE,0,NONE,NONE,1,NONE,0.0,4.0,0},
    {355,"A006_003",ITEM_TYPE_WEAPON,"AK-47","mdl-2007:WEAPON_AK47","",WEAPON_AK47,1,NONE,NONE,1,NONE,0.0,4.0,0},
    {351,"A006_004",ITEM_TYPE_WEAPON,"战斗霰弹枪","mdl-2007:WEAPON_SHOTGSPA","",WEAPON_SHOTGSPA,2,NONE,NONE,1,NONE,0.0,4.0,0},
    {350,"A006_005",ITEM_TYPE_WEAPON,"短管霰弹枪","mdl-2007:WEAPON_SAWEDOFF","",WEAPON_SAWEDOFF,2,NONE,NONE,1,NONE,0.0,4.0,0},
    {349,"A006_006",ITEM_TYPE_WEAPON,"霰弹枪","mdl-2007:WEAPON_SHOTGUN","",WEAPON_SHOTGUN,2,NONE,NONE,1,NONE,0.0,4.0,0},
    {372,"A006_007",ITEM_TYPE_WEAPON,"TEC-9","mdl-2007:WEAPON_TEC9","",WEAPON_TEC9,2,NONE,NONE,1,NONE,0.0,4.0,0},
    {353,"A006_008",ITEM_TYPE_WEAPON,"SMG冲锋枪","mdl-2007:WEAPON_MP5","",WEAPON_MP5,2,NONE,NONE,1,NONE,0.0,4.0,0},
    {352,"A006_009",ITEM_TYPE_WEAPON,"微型冲锋枪","mdl-2007:WEAPON_UZI","",WEAPON_UZI,2,NONE,NONE,1,NONE,0.0,4.0,0},
    {346,"A006_010",ITEM_TYPE_WEAPON,"Colt45手枪","mdl-2007:WEAPON_COLT45","",WEAPON_COLT45,2,NONE,NONE,1,NONE,0.0,4.0,0},
    {347,"A006_011",ITEM_TYPE_WEAPON,"消音9mm手枪","mdl-2007:WEAPON_SILENCED","",WEAPON_SILENCED,3,NONE,NONE,1,NONE,0.0,4.0,0},
    {348,"A006_012",ITEM_TYPE_WEAPON,"沙漠之鹰","mdl-2007:WEAPON_DEAGLE","",WEAPON_DEAGLE,3,NONE,NONE,1,NONE,0.0,4.0,0},
    {339,"A006_013",ITEM_TYPE_WEAPON,"武士刀","mdl-2007:WEAPON_KATANA","",WEAPON_KATANA,4,NONE,NONE,1,NONE,0.0,4.0,0},
    {336,"A006_014",ITEM_TYPE_WEAPON,"棒球棍","mdl-2007:WEAPON_BAT","",WEAPON_BAT,4,NONE,NONE,1,NONE,0.0,4.0,0},
    {333,"A006_015",ITEM_TYPE_WEAPON,"高尔夫球杆","mdl-2007:WEAPON_GOLFCLUB","",WEAPON_GOLFCLUB,4,NONE,NONE,1,NONE,0.0,4.0,0},

	{1098,"A007_000",ITEM_TYPE_VEHICLETACKLE,"轮胎","mdl-2007:luntai","",NONE,NONE,NONE,NONE,0,NONE,0.0,4.0,1},
	{19917,"A007_001",ITEM_TYPE_VEHICLETACKLE,"引擎","mdl-2007:yinqing","",NONE,NONE,NONE,NONE,0,NONE,0.0,4.0,1},
	{19921,"A007_002",ITEM_TYPE_VEHICLETACKLE,"工具箱","mdl-2007:gongjuxiang","",NONE,NONE,NONE,NONE,0,NONE,0.0,4.0,1},
	{-2700,"A007_003",ITEM_TYPE_VEHICLETACKLE,"空油桶","mdl-2007:kongyoutong","",NONE,NONE,NONE,NONE,0,NONE,0.0,4.0,1},
	{-2700,"A007_004",ITEM_TYPE_VEHICLETACKLE,"满油桶","mdl-2007:manyoutong","",NONE,NONE,NONE,NONE,0,NONE,0.0,4.0,1},

    {843,"A008_000",ITEM_TYPE_CRAFT,"木头","mdl-2004:wood","",NONE,NONE,NONE,NONE,0,NONE,0.0,0.001,1},
    {1453,"A008_001",ITEM_TYPE_CRAFT,"木心","mdl-2004:woodenheart","",NONE,NONE,NONE,NONE,0,NONE,0.0,0.001,1},
    {2936,"A008_002",ITEM_TYPE_CRAFT,"石头","mdl-2004:stone","",NONE,NONE,NONE,NONE,0,NONE,0.0,0.001,1},
    {3930,"A008_003",ITEM_TYPE_CRAFT,"铁矿","mdl-2004:iron","",NONE,NONE,NONE,NONE,0,NONE,0.0,0.001,1},
    
	{18875,"A009_000",ITEM_TYPE_COMMU,"北斗导航","mdl-2007:daohang","",NONE,NONE,NONE,NONE,0,NONE,0.0,4.0,1},
	{18875,"A009_001",ITEM_TYPE_COMMU,"对讲机","mdl-2007:duijiangji","",NONE,NONE,NONE,NONE,0,NONE,0.0,4.0,1},


	{18876,"A010_000",ITEM_TYPE_CRAFT,"晶石","mdl-2007:jingshi","",NONE,NONE,NONE,NONE,0,NONE,0.0,4.0,1},

	{1636,"A011_000",ITEM_TYPE_BOMB,"鱼雷","","",18683,NONE,NONE,NONE,0,NONE,82.0,5.0,1,50.0}

};
enum SeverState_InFo
{
	bool:_ServerRun,
	_RunTimes
}
new SeverState[SeverState_InFo];
#define SERVER_RUNTIMES SeverState[_RunTimes]
///////////////////////////////////////////////////////////
#include <wc>
///////////////////////////////////////////////////////////
#include Tree\ColMap.pwn
#include Tree\PlayerZone.pwn
#include Tree\Gps.pwn
#include Tree\3DtextBar.pwn
#include Tree\ObjectLoad.pwn

#include Tree\Mysql.pwn

#include Tree\ServerSet.pwn
#include Tree\Administrator.pwn
#include Tree\Log.pwn

#include Tree\StaticList.pwn


#include Tree\Textdraw\Speedo.pwn
#include Tree\Textdraw\PersonState.pwn
#include Tree\Textdraw\Inventory.pwn
#include Tree\Textdraw\Come.pwn
#include Tree\Textdraw\CraftDraw.pwn
#include Tree\Textdraw\WeaponHud.pwn
#include Tree\Textdraw\PlayerInfo.pwn
#include Tree\Textdraw\QuickUse.pwn
#include Tree\Textdraw\StoreUI.pwn
#include Tree\Textdraw\StrongBox.pwn
#include Tree\Textdraw\Textdraw.pwn

#include Tree\Account\AInventory.pwn
#include Tree\Account\AEquip.pwn
#include Tree\Account\AWeapon.pwn
#include Tree\Account\Account.pwn

#include Tree\Craft\Craft.pwn

#include Tree\PickUp\PickUp.pwn
#include Tree\PickUp\Collection.pwn

#include Tree\Domain\Private\Private.pwn
#include Tree\Domain\Domain.pwn

#include Tree\Faction\Faction.pwn

#include Tree\Vehicle\Vehicle.pwn

#include Tree\Bomb\Bomb.pwn

#include Tree\Addition\Addition.pwn

#include Tree\Zombie\AI.pwn
#include Tree\Wireless\Wireless.pwn

#include Tree\Store\Store.pwn

#include Tree\Mail\GameMail.pwn
///////////////////////////////////////////////////////////
main()
{

	print("\n----------------------------------");
	print(" Blank Gamemode by your name here");
	print("----------------------------------\n");
}

FUNC::ArtConfigInit()
{
	AddSimpleModel(-1,4315, -2000, "Zone1.dff", "GameText.txd");
    AddSimpleModel(-1,19379, -2001, "object.dff", "textdraw0.txd");
    AddSimpleModel(-1,19379, -2002, "object.dff", "textdraw1.txd");
    AddSimpleModel(-1,19379, -2003, "object.dff", "textdraw2.txd");
    AddSimpleModel(-1,19379, -2004, "object.dff", "ItemName1.txd");
    AddSimpleModel(-1,19379, -2005, "object.dff", "Weapon.txd");
    AddSimpleModel(-1,19379, -2006, "object.dff", "NavigationBar.txd");
    AddSimpleModel(-1,19379, -2007, "object.dff", "ItemName2.txd");
    AddSimpleModel(-1,19379, -2008, "object.dff", "GameText2.txd");
    
    AddSimpleModel(-1,19379, -2100, "/Medical/Medical1.dff", "/Medical/Medical1.txd");
    AddSimpleModel(-1,19379, -2101, "/Medical/Medical2.dff", "/Medical/Medical2.txd");
    AddSimpleModel(-1,19379, -2102, "/Medical/Medical3.dff", "/Medical/Medical3.txd");
    AddSimpleModel(-1,19379, -2103, "/Medical/Medical4.dff", "/Medical/Medical4.txd");
    AddSimpleModel(-1,19379, -2104, "/Medical/Medical5.dff", "/Medical/Medical5.txd");

    AddSimpleModel(-1,19379, -2200, "/Food/Drink1.dff", "/Food/Drink1.txd");
    AddSimpleModel(-1,19379, -2201, "/Food/pingguo1.dff", "/Food/pingguo1.txd");
    AddSimpleModel(-1,19379, -2202, "/Food/pingguo2.dff", "/Food/pingguo2.txd");

    AddSimpleModel(-1,19379, -2300, "/Equip/Slot1/beibao1.dff", "/Equip/Slot1/beibao1.txd");
    AddSimpleModel(-1,19379, -2301, "/Equip/Slot1/beibao2.dff", "/Equip/Slot1/beibao2.txd");
    AddSimpleModel(-1,19379, -2302, "/Equip/Slot1/beibao3.dff", "/Equip/Slot1/beibao3.txd");
    AddSimpleModel(-1,19379, -2303, "/Equip/Slot1/beibao4.dff", "/Equip/Slot1/beibao4.txd");

    AddSimpleModel(-1,19379, -2400, "/Equip/Slot0/toukui1.dff", "/Equip/Slot0/toukui1.txd");
    AddSimpleModel(-1,19379, -2401, "/Equip/Slot0/toukui2.dff", "/Equip/Slot0/toukui2.txd");
    AddSimpleModel(-1,19379, -2402, "/Equip/Slot0/toukui3.dff", "/Equip/Slot0/toukui3.txd");
    AddSimpleModel(-1,19379, -2403, "/Equip/Slot0/toukui4.dff", "/Equip/Slot0/toukui4.txd");

    AddSimpleModel(-1,19379, -2500, "/Equip/Slot5/fdy1.dff", "/Equip/Slot5/fdy1.txd");
    AddSimpleModel(-1,19379, -2501, "/Equip/Slot5/fdy2.dff", "/Equip/Slot5/fdy2.txd");
    AddSimpleModel(-1,19379, -2502, "/Equip/Slot5/fdy3.dff", "/Equip/Slot5/fdy3.txd");
    AddSimpleModel(-1,19379, -2503, "/Equip/Slot5/fdy4.dff", "/Equip/Slot5/fdy4.txd");

    AddSimpleModel(-1,19379, -2600, "/Equip/Slot4/fdmj1.dff", "/Equip/Slot4/fdmj1.txd");
    AddSimpleModel(-1,19379, -2601, "/Equip/Slot4/fdmj2.dff", "/Equip/Slot4/fdmj2.txd");
    AddSimpleModel(-1,19379, -2602, "/Equip/Slot4/fdmj3.dff", "/Equip/Slot4/fdmj3.txd");
    AddSimpleModel(-1,19379, -2603, "/Equip/Slot4/fdmj4.dff", "/Equip/Slot4/fdmj4.txd");
    
    AddSimpleModel(-1,19379, -2700, "/Vehicle/qiyou.dff", "/Vehicle/qiyou.txd");
    
    AddSimpleModel(-1,19379, -25000, "/Game/la_fuckcar1.dff", "/Game/lafuckar.txd");
    AddSimpleModel(-1,19379, -25001, "/Game/la_fuckcar2.dff", "/Game/lafuckar.txd");

	AddCharModel(0, 20001, "/Zombie/Zombie1.dff", "/Zombie/Zombie1.txd");
	AddCharModel(0, 20002, "/Zombie/Zombie2.dff", "/Zombie/Zombie2.txd");
	AddCharModel(0, 20003, "/Zombie/Zombie3.dff", "/Zombie/Zombie3.txd");
	AddCharModel(0, 20004, "/Zombie/Zombie4.dff", "/Zombie/Zombie4.txd");
	AddCharModel(0, 20005, "/Zombie/Zombie5.dff", "/Zombie/Zombie5.txd");
	AddCharModel(0, 20006, "/Zombie/Zombie6.dff", "/Zombie/Zombie6.txd");
	AddCharModel(0, 20007, "/Zombie/Zombie7.dff", "/Zombie/Zombie7.txd");
	AddCharModel(0, 20008, "/Zombie/Zombie8.dff", "/Zombie/Zombie8.txd");
	AddCharModel(0, 20009, "/Zombie/Zombie9.dff", "/Zombie/Zombie9.txd");
	AddCharModel(0, 20010, "/Zombie/Zombie10.dff", "/Zombie/Zombie10.txd");
	AddCharModel(0, 20011, "/Zombie/Zombie11.dff", "/Zombie/Zombie11.txd");
	AddCharModel(0, 20012, "/Zombie/Zombie12.dff", "/Zombie/Zombie12.txd");
	AddCharModel(0, 20013, "/Zombie/Zombie13.dff", "/Zombie/Zombie13.txd");
	AddCharModel(0, 20014, "/Zombie/Zombie14.dff", "/Zombie/Zombie14.txd");
	AddCharModel(0, 20015, "/Zombie/Zombie15.dff", "/Zombie/Zombie15.txd");

    loop(i,1,33)
    {
        new d@0,d@1[64],d@2[64];
        d@0=20049+i;
        format(d@1,64,"/Skin/Male%i.dff",i);
        format(d@2,64,"/Skin/Male%i.txd",i);
		AddCharModel(0,d@0, d@1,d@2);
	}

/*	AddCharModel(305, 20052, "/Skin/Male3.dff", "/Skin/Male3.txd");
	AddCharModel(305, 20053, "/Skin/Male4.dff", "/Skin/Male4.txd");
	AddCharModel(305, 20054, "/Skin/Male5.dff", "/Skin/Male5.txd");
	AddCharModel(305, 20055, "/Skin/Male6.dff", "/Skin/Male6.txd");
	AddCharModel(305, 20100, "/Skin/Famale1.dff", "/Skin/Famale1.txd");
	AddCharModel(305, 20101, "/Skin/Famale2.dff", "/Skin/Famale2.txd");
	AddCharModel(305, 20102, "/Skin/Famale3.dff", "/Skin/Famale3.txd");
	AddCharModel(305, 20103, "/Skin/Famale4.dff", "/Skin/Famale4.txd");
	AddCharModel(305, 20104, "/Skin/Famale5.dff", "/Skin/Famale5.txd");*/
	return 1;
}

public OnGameModeInit()
{
	SeverState[_ServerRun]=false;
	SeverState[_RunTimes]=0;

    SetDisableSyncBugs(true);
	SetDamageFeed(false);
	SetDamageSounds(0, 0);
	SetCbugAllowed(false);
	SetCustomVendingMachines(false);
	SetVehicleUnoccupiedDamage(true);
	SetVehiclePassengerDamage(true);
	
    EnableVehicleFriendlyFire();
    DisableInteriorEnterExits();
 	EnableStuntBonusForAll(0);
    ManualVehicleEngineAndLights();
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);
	ShowNameTags(1);
	
	HideAllMap=CreateZone(-3500.0,-3500.0,3500.0,3500.0);
	
    Iter_Init(PlayerInv);
    Iter_Init(PlayerEquip);
    Iter_Init(PlayerWeapon);
    Iter_Init(ZombieBag);
    Iter_Init(PlayerGangZoneData);
    Iter_Init(StoreSells);
    Iter_Init(PlayerGameMail);

	//LimitPlayerMarkerRadius(99999999999999.0);
	
	Tryg3D::SafeMapAndreasInit(MAP_ANDREAS_MODE_FULL);
	Tryg3D::SafeColAndreasInit();
	FCNPC_SetUpdateRate(70);
	FCNPC_SetTickRate(10);
	FCNPC_UseMoveMode(FCNPC_MOVE_PATHFINDING_RAYCAST, true);
	
    ArtConfigInit();
	loop(i,0,5)
	{
		//SafeZone[i][_sModelID]=CreateDynamicObject(-2000,SafeZone[i][_sX],SafeZone[i][_sY],-10.0,0.0,0.0,0.0,0,-1,.streamdistance =1000.0);
        SafeZone[i][_sAreaID]=CreateDynamicCircle(SafeZone[i][_sX],SafeZone[i][_sY],200.0,0,-1);
	}
	loop(i,5,sizeof(SafeZone))
	{
		//SafeZone[i][_sModelID]=INVALID_STREAMER_ID;
        SafeZone[i][_sAreaID]=CreateDynamicRectangle(SafeZone[i][_sX],SafeZone[i][_sY],SafeZone[i][_sZ],SafeZone[i][_sA],0,-1);
	}	
	CreateZombie();
	printf("FCNPC_GetUpdateRate:%i",FCNPC_GetUpdateRate());
	printf("FCNPC_GetTickRate:%i",FCNPC_GetTickRate());
	
	SetTimer("ZombieUpdate",250,true);
	SetTimer("GameUpdate_100MS",100,true);
	SetTimer("GameUpdate_1SEC",1000,true);
	SetTimer("GameUpdate_5SEC",5000,true);
	SetTimer("GameUpdate_30SEC",30000,true);
	
	CreateGrass();
	
	TD_OnGameModeInit();
	
	LoadObjectMapFromFile();
	
	MySql_OnGameModeInit();
	
	Domain_OnGameModeInit();

    Gps_OnGameModeInit();
    
    ClearFactionAreaObjs();
	SeverState[_ServerRun]=true;
/*	new Float:Gpos_X=0.0,Float:Gpos_Y=0.0,Float:Gpos_Z=0.0;
	forex(i,MAX_PICKUP-10)
	{
		GetPickUpSpawnPos(Gpos_X,Gpos_Y,Gpos_Z);
		CreatePickUpData(Item[random(sizeof(Item))][_Key],1,100,Gpos_X,Gpos_Y,Gpos_Z+0.2,0.0,0.0,0.0);
	}*/
	
/*	new Float:Gpos_X=0.0,Float:Gpos_Y=0.0,Float:Gpos_Z=0.0;
	forex(i,MAX_PICKUP-MAX_PICKUP_SPAWNS)
	{
		GetPickUpSpawnPos(Gpos_X,Gpos_Y,Gpos_Z);
		CreatePickUpData(Item[Iter_Random(Item)][_Key],1,100,Gpos_X,Gpos_Y,Gpos_Z+0.2,0.0,0.0,0.0,0,0,0,false);
	}*/
	

/*	new canvas[VirtualCanvas], Float:x, Float:y;
	CreateVirtualCanvas(-3000.0, 3000.0, -3000.0, 3000.0, 600, 600, canvas);
    GetVirtualCanvasPos(canvas, 465.3, 125.0, x, y);
	printf("Canvas:%f %f", x, y); // 0, 0, centre of map*/
	return 1;
}
stock DalayKick(playerid,times=100)
{
    SetTimerEx("Kicked",times,false,"i",playerid);
    return 1;
}
FUNC::Kicked(playerid)
{
    /*new ip_address[16];
    GetPlayerIp(playerid,ip_address,sizeof(ip_address));
    if(strcmp(ip_address,"127.0.0.1",true))
	{*/
	if(!IsPlayerNPC(playerid))Kick(playerid);
	//}
	return 1;
}
FUNC::GameUpdate_30SEC()
{
 	for(new i=1,j=GetVehiclePoolSize();i<=j;i++)SaveVehDate(i);
	foreach(new i:Player)
	{
	    if(RealPlayer(i))
	    {
			if(Account[i][_Hunger]>0.0)
			{
	        	Account[i][_Hunger]=floatsub(Account[i][_Hunger],SUB_HUNGER);
	        	if(Account[i][_Hunger]<0.0)Account[i][_Hunger]=0.0;
	        	UpdatePlayerHungerBar(i,Account[i][_Hunger]);
	        	formatex128("UPDATE `"MYSQL_DB_ACCOUNT"` SET  `饥饿`='%f' WHERE  `"MYSQL_DB_ACCOUNT"`.`密匙` ='%s'",Account[i][_Hunger],Account[i][_Key]);
				mysql_query(Account@Handle,string128,false);
	        }
	        if(Account[i][_Dry]>0.0)
	        {
	            Account[i][_Dry]=floatsub(Account[i][_Dry],SUB_DRY);
	            if(Account[i][_Dry]<0.0)Account[i][_Dry]=0.0;
	            UpdatePlayerDryBar(i,Account[i][_Dry]);
	        	formatex128("UPDATE `"MYSQL_DB_ACCOUNT"` SET  `口渴`='%f' WHERE  `"MYSQL_DB_ACCOUNT"`.`密匙` ='%s'",Account[i][_Dry],Account[i][_Key]);
				mysql_query(Account@Handle,string128,false);
	        }
	    }
	}
	return 1;
}
FUNC::GameUpdate_5SEC()
{
    ServerSet_SaveServerRunTime();
	return 1;
}
FUNC::OnPlayerOutOfStamina(playerid)
{
    ApplyAnimation(playerid,"PED","IDLE_TIRED",4.1,0,0,0,0,4000,1);
	return 1;
}
FUNC::GameUpdate_1SEC()
{
	foreach(new i:Player)
	{
	    if(RealPlayer(i))
	    {
	        new Float:gSpeed=GetSpeed(i);
	        if(gSpeed>18.0&&gSpeed<22.0)
	        {
	           	if(Account[i][_Stamina]>0.0)
	           	{
	            	Account[i][_Stamina]=floatsub(Account[i][_Stamina],SUB_STAMINA);
	            	if(Account[i][_Stamina]<0.0)Account[i][_Stamina]=0.0;
	            	UpdatePlayerStaminaBar(i,Account[i][_Stamina]);
	            }
	        }
	        else if(gSpeed>22.0)
	        {
	        	if(Account[i][_Stamina]>0.0)
	           	{
	            	Account[i][_Stamina]=floatsub(Account[i][_Stamina],SUB_STAMINA*2.0);
	            	if(Account[i][_Stamina]<0.0)Account[i][_Stamina]=0.0;
	            	UpdatePlayerStaminaBar(i,Account[i][_Stamina]);
	            }
	        }
	        else
	        {
	        	if(Account[i][_Stamina]<floatadd(DEFAULT_MAX_STAMINA,Addition[i][_Stamina]))
	           	{
	            	Account[i][_Stamina]=floatadd(Account[i][_Stamina],SUB_STAMINA*1.5);
	            	if(Account[i][_Stamina]>floatadd(DEFAULT_MAX_STAMINA,Addition[i][_Stamina]))Account[i][_Stamina]=floatadd(DEFAULT_MAX_STAMINA,Addition[i][_Stamina]);
                    UpdatePlayerStaminaBar(i,Account[i][_Stamina]);
				}
	        }
		    if(Account[i][_Stamina]==0.0)
		    {
		        OnPlayerOutOfStamina(i);
		        //Account[i][_Stamina]=1.0;
		    }
		    if(Account[i][_Infection]==1)
		    {
		        if(Account[i][_Spawn]==true)
		        {
		            DamagePlayer(i,1.0,i,WEAPON_UNKNOWN,BODY_PART_UNKNOWN);
		        	FlashPlayerInfection(i);
		        }
		    }
		}
	}
	return 1;
}
FUNC::GameUpdate_100MS()
{
	foreach(new i:Player)
	{
	    if(RealPlayer(i))
	    {
	        SpeedoUpdate(i);
	    }
	}
 	for(new i=1,j=GetVehiclePoolSize();i<=j;i++)
    {
        FuleUpdate(i);
    }
	return 1;
}
public OnPlayerSpawn(playerid)
{
    if(IsPlayerNPC(playerid))return 1;
    
    SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_SNIPERRIFLE, 999);
    
    PreloadPlayerAnims(playerid);
    
    SetPlayerVirtualWorld(playerid,0);
    
	if(Account[playerid][_Login]==false)//如果未登录
	{
	    if(Account[playerid][_Skin]==NONE)//发现未选择角色
		{
		    SetPlayerVirtualWorld(playerid,PLAYER_SELECTSKIN_WORLD+playerid);
		    new Float:SpawnZ;
		    CA_FindZ_For2DCoord(SafeZone[Account[playerid][_SpawnTown]][_sX],SafeZone[Account[playerid][_SpawnTown]][_sY],SpawnZ);
			new Float:xyz[2][2];
			xyz[0][0]=xyz[0][1]=SafeZone[Account[playerid][_SpawnTown]][_sX];
			xyz[1][0]=xyz[1][1]=SafeZone[Account[playerid][_SpawnTown]][_sY];
			GetPointInFrontOfPlayer(playerid,xyz[0][0], xyz[1][0],3.0);
			SetPlayerCameraPos(playerid,xyz[0][0], xyz[1][0],SpawnZ+1.0);
			SetPlayerCameraLookAt(playerid,xyz[0][1], xyz[1][1], SpawnZ+1.0,CAMERA_CUT);
			TogglePlayerControllable(playerid,1);
			ShowPlayerSkinSelectTextDraw(playerid,0,2);
			SelectTextDrawEx(playerid,0x408080C8);
		}
		else//出生成功
		{
			SetPlayerSkin(playerid,Account[playerid][_Skin]);
		    SetPlayerVirtualWorld(playerid,0);
            //CancelSelectTextDrawEx(playerid);
			Account[playerid][_Login]=true;
			Account[playerid][_Spawn]=true;
			ShowZoneForPlayer(playerid,HideAllMap,255);
			ShowAllFactionZoneForPlayer(playerid);
			ShowPlayerPresonStateTextDraw(playerid);
   			ShowPlayerQuickUseTextDraw(playerid);
			GivePlayerDressWeapon(playerid);
			GivePlayerDressEquip(playerid);
			CancelSelectTextDrawEx(playerid);
			formatex128("%s {00FF80}登陆了游戏,出生在了 {C0C0C0}%s.",Account[playerid][_Name],SafeZone[Account[playerid][_SpawnTown]][_sName]);
			SendMsgToAllPlayers(-1,string128);
			if(GetPlayerAdminLevelByKey(Account[playerid][_Key])>=1)
			{
				SCM(playerid,-1,"GM指令:/go 传送 /let 拉 /gov传送车");
				SCM(playerid,-1,"GM指令:/store 创建商店 /dstore 删除商店 /addsell增加商店商品");
                SCM(playerid,-1,"GM指令:/addfa 创建阵营 /delfa 删除阵营");
			}
		}
	}
	else//已登录重新出生后
	{
	    SetPlayerSkin(playerid,Account[playerid][_Skin]);
	    SetPlayerVirtualWorld(playerid,0);
	    Account[playerid][_Spawn]=true;
	    ShowZoneForPlayer(playerid,HideAllMap,255);
	    ShowAllFactionZoneForPlayer(playerid);
	    ShowPlayerQuickUseTextDraw(playerid);
		GivePlayerDressWeapon(playerid);
		GivePlayerDressEquip(playerid);
		CancelSelectTextDrawEx(playerid);
		if(Account[playerid][_Infection]==1)StopPlayerInfection(playerid);
		if(GetPlayerAdminLevelByKey(Account[playerid][_Key])>=1)
		{
			SCM(playerid,-1,"GM指令:/go 传送 /let 拉 /gov传送车");
			SCM(playerid,-1,"GM指令:/store 创建商店 /dstore 删除商店 /addsell增加商店商品");
            SCM(playerid,-1,"GM指令:/addfa 创建阵营 /delfa 删除阵营");
		}
	}
	return 1;
}
public OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid)
{
    if(!RealPlayer(playerid))return 1;
   	forex(i,sizeof(SafeZone))
	{
	    if(areaid==SafeZone[i][_sAreaID])
	    {
	        //formatex64("你进入了 %s ",SafeZone[i][_sName]);
	        //SetPlayerWeather(playerid, 1);
	        //SetPlayerTime(playerid,8,0);
	        //SCM(playerid,-1,string64);
	        break;
	    }
	}
	foreach(new i:PickUp)
	{
		if(IsPlayerInDynamicArea(playerid,PickUp[i][_AreaID]))
		{
		    ShowPlayerMsgTipsTextDraw(playerid,2000);
		    break;
		}
	}
	foreach(new i:VehicleWreckage)
	{
		if(IsPlayerInDynamicArea(playerid,VehicleWreckage[i][_AreaID]))
		{
		    ShowCarCraftThings(playerid,i);
		    break;
		}
	}
	foreach(new i:Zombies)
	{
		if(IsPlayerInDynamicArea(playerid,Zombies[i][_zPAreaID]))
		{
		    if(Zombies[i][_zState]==ZOMBIE_STATE_DEATH)
		    {
				if(Iter_Count(ZombieBag[i])>0)
				{
				    ShowPlayerMsgTipsTextDraw(playerid,2000);
				    break;
				}
			}
		}
	}
	foreach(new i:CraftBulid)
	{
	    if(IsPlayerInDynamicArea(playerid,CraftBulid[i][_CMoveAreaID]))
	    {
	        if(CraftBulid[i][_Cmove]==1)
	        {
				OnPlayerEnterCraftBulidMoveArea(playerid,i);
				break;
	        }
	    }
	}
	foreach(new i:Stores)
	{
	    if(IsPlayerInDynamicArea(playerid,Stores[i][_Areaid]))
	    {
			OnPlayerEnterStoreArea(playerid,i);
			break;
	    }
	}
	return 1;
}


public OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA:areaid)
{
    if(!RealPlayer(playerid))return 1;
    if(CarCraftTextDrawShow[playerid]==true)
	{
		HideCarCraftThings(playerid);
		CancelSelectTextDrawEx(playerid);
    }
    if(Domain_OnPlayerLeaveDynamicArea(playerid,areaid))return 1;
   	forex(i,sizeof(SafeZone))
	{
	    if(areaid==SafeZone[i][_sAreaID])
	    {
	        //formatex64("你离开了 %s ",SafeZone[i][_sName]);
	        //SetPlayerWeather(playerid, 9);
	        //SetPlayerTime(playerid,6,0);
	        //SCM(playerid,-1,string64);
	        return 1;
	    }
	}
	return 1;
}
public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    if(IsPlayerNPC(playerid))return 1;
	if(Account[playerid][_Login]==false)
	{
		printf("OnPlayerRequestClass1");
		TD_OnPlayerRequestClass(playerid);
		SetPlayerWeather(playerid, 0);
	    SetPlayerTime(playerid,5,0);
	    return 1;
    }
	else
	{
	    printf("OnPlayerRequestClass2");
 	    new Float:SpawnZ;
		CA_FindZ_For2DCoord(SafeZone[Account[playerid][_SpawnTown]][_sX],SafeZone[Account[playerid][_SpawnTown]][_sY],SpawnZ);
		SetSpawnInfo(playerid,NO_TEAM,Account[playerid][_Skin],SafeZone[Account[playerid][_SpawnTown]][_sX],SafeZone[Account[playerid][_SpawnTown]][_sY],SpawnZ+0.5,0.0,0,0,0,0,0,0);
	    return SpawnPlayer(playerid);
			//TogglePlayerSpectating(playerid,1);
		//TogglePlayerSpectating(playerid,0);
	}
	//return 0;
}
CMD:de(playerid, params[])
{
    DamagePlayer(playerid,999);
	return 1;
}
public OnPlayerConnect(playerid)
{
    if(IsPlayerNPC(playerid))return 1;

    
	forex(i,10)if(IsPlayerAttachedObjectSlotUsed(playerid,i))RemovePlayerAttachedObject(playerid,i);
	
    SetPVarInt(playerid, "selecttextdraw_active", 0);
    
    IsDebug[playerid]=false;
    
    Account[playerid][_Login]=false;
    Account[playerid][_Register]=false;
    Account[playerid][_Spawn]=false;
    Account[playerid][_Stamina]=100.0;
    Account[playerid][_Hunger]=100.0;
    Account[playerid][_Dry]=100.0;

    
    PlayerOldWorld[playerid]=NONE;

    RestPlayerEquip(playerid);
    RestPlayerInventory(playerid);
    RestPlayerWeapon(playerid);
    RestPlayerWireless(playerid);

	Timer:PlayerUseItem[playerid]=NONE;
	PlayerUseItemTimeCount[playerid]=0;
	PlayerUseItemTimeTotal[playerid]=0;
	Timer:PlayerUseItemAnim[playerid]=NONE;
    
	TD_OnPlayerConnect(playerid);
	
	Zombie_OnPlayerConnect(playerid);
	ObjectLoad_OnPlayerConnect(playerid);
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
    if(IsPlayerNPC(playerid))return 1;
    
    IsDebug[playerid]=false;
    
    TD_OnPlayerDisconnect(playerid);
    
    Zombie_OnPlayerDisconnect(playerid, reason);
    Dom_OnPlayerDisconnect(playerid);
    Gps_OnPlayerDisconnect(playerid, reason);

    if(RealPlayer(playerid))
    {
     	SavePlayerWeaponDurable(playerid);
    }
    
    Account[playerid][_Login]=false;
    Account[playerid][_Register]=false;
    Account[playerid][_Spawn]=false;
    
    RestPlayerEquip(playerid);
    RestPlayerInventory(playerid);
    RestPlayerWeapon(playerid);
    RestPlayerWireless(playerid);

	Timer:PlayerUseItem[playerid]=NONE;
	PlayerUseItemTimeCount[playerid]=0;
	PlayerUseItemTimeTotal[playerid]=0;
	Timer:PlayerUseItemAnim[playerid]=NONE;
    
    forex(i,10)if(IsPlayerAttachedObjectSlotUsed(playerid,i))RemovePlayerAttachedObject(playerid,i);
    SetPVarInt(playerid, "selecttextdraw_active", 0);
    
    PlayerGangZoneDataRest(playerid);
	return 1;
}
public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    Gps_OnPlayerClickMap(playerid, fX, fY, fZ);
    return 1;
}

/*CMD:go(playerid, params[])
{
	SetPlayerPosFindZ(playerid,49.9614,-27.5690,3.0);
	new vid=CreateVehicle(568,49.9614,-27.5690,3.0,0.0,-1,-1,999999);
	return 1;
}*/
CMD:vw(playerid, params[])
{
	new vw;
    if(sscanf(params, "i",vw))return SCM(playerid,-1,"/vw ");
	SetPlayerVirtualWorld(playerid, vw);
	return 1;
}
CMD:pos(playerid, params[])
{
	new Float:xyz[3];
    if(sscanf(params, "p<,>fff",xyz[0],xyz[1],xyz[2]))return SCM(playerid,-1,"/pos x,y,z");
	SetPlayerPos(playerid,xyz[0],xyz[1],xyz[2]);
	return 1;
}
public OnPlayerDeath(playerid, killerid, reason)
{
    printf("OnPlayerDeath %i,%i,%i",playerid, killerid, reason);
    new Float:SpawnZ;
	CA_FindZ_For2DCoord(SafeZone[Account[playerid][_SpawnTown]][_sX],SafeZone[Account[playerid][_SpawnTown]][_sY],SpawnZ);
    SetSpawnInfo(playerid,NO_TEAM,Account[playerid][_Skin],SafeZone[Account[playerid][_SpawnTown]][_sX],SafeZone[Account[playerid][_SpawnTown]][_sY],SpawnZ+0.5,0.0,0,0,0,0,0,0);
    Account[playerid][_Spawn]=false;
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	if(RealPlayer(playerid))
	{
	    if(strlen(text)>0)
	    {
		    formatex256("[%i]%s{FFFFFF}:%s",playerid,Account[playerid][_Name],text);
		    SendMsgToAllPlayers(0xC0C0C0C8,string256);
		    InsertChatLog(Account[playerid][_Key],Account[playerid][_Name],text);
	    }
	}
	return 0;
}
public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
	if(result!=1)
	{
	    formatex64("该指令无效[/%s]",cmd);
       	SCM(playerid,-1,string64);
	}
	return 1;
}
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
    GobalVehicleEngine[vehicleid]=false;
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(IsPlayerNPC(playerid))return 1;
    if(TD_OnPlayerStateChange(playerid, newstate, oldstate))return 1;
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
    printf("OnPlayerRequestSpawn");
	//if(Account[playerid][_Login]==false)return 0;
	return 0;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    TD_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    Dom_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    Collect_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    PickUp_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    Zombie_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    Store_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    //StrBox_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}
public OnPlayerUpdate(playerid)
{
    if(IsPlayerNPC(playerid))return 1;
    //printf("AnimationIndex:%i",GetPlayerAnimationIndex(playerid));
    //printf("Collision:%i   Surface:%i",GetPlayerCollisionFlags(playerid),CA_IsPlayerOnSurface(playerid,3.0));
	/*new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
    switch(GetPointCollisionFlags(X, Y, Z,0))
    {
        case POSITION_FLAG_WORLD:printf("POSITION_FLAG_WORLD");
        case POSITION_FLAG_INTERIOR:printf("POSITION_FLAG_INTERIOR");
        case POSITION_FLAG_AIR:printf("POSITION_FLAG_AIR");
        case POSITION_FLAG_GROUND:printf("POSITION_FLAG_GROUND");
        case POSITION_FLAG_WATER:printf("POSITION_FLAG_WATER");
        case POSITION_FLAG_UNDERWATER:printf("POSITION_FLAG_UNDERWATER");
        case POSITION_FLAG_UNDERGROUND:printf("POSITION_FLAG_UNDERGROUND");
    }*/
    if(RealPlayer(playerid))
    {
        Weapon_OnPlayerUpdate(playerid);
	    new OPU_Keys,OPU_Ud,OPU_Lr;
	    GetPlayerKeys(playerid,OPU_Keys,OPU_Ud,OPU_Lr);
/*	    printf("GetPlayerKeys(playerid,%i,%i,%i);",OPU_Keys,OPU_Ud,OPU_Lr);*/
	    if(OPU_Keys==0&&OPU_Ud==0&&OPU_Lr==0)
	    {

	    }
	    else
	    {
	        Zombie_OnPlayerPressGetOutKey(playerid,OPU_Keys,OPU_Ud,OPU_Lr);
	    }
    }
	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	printf("OnPlayerWeaponShot");
    if(RealPlayer(playerid))
    {
        Weapon_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, fX, fY, fZ);
    	Zombie_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, fX, fY, fZ);
	}
	return 1;
}
public FCNPC_OnTakeDamage(npcid, issuerid, Float:amount, weaponid, bodypart)
{
    Zombie_OnTakeDamage(npcid, issuerid, amount, weaponid, bodypart);
	return 1;
}
public FCNPC_OnReachDestination(npcid)
{
	Zombie_OnReachDestination(npcid);
	return 1;
}
public FCNPC_OnUpdate(npcid)
{
	Zombie_OnUpdate(npcid);
	return 1;
}
public FCNPC_OnSpawn(npcid)
{
    Zombie_OnSpawn(npcid);
	return 1;
}
public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(Account_OnDialogResponse(playerid, dialogid, response, listitem, inputtext))return 1;
    if(Faction_OnDialogResponse(playerid, dialogid, response, listitem, inputtext))return 1;
    if(GameMail_OnDialogResponse(playerid, dialogid, response, listitem, inputtext))return 1;
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
FUNC::OnPlayerVirtualWorldChange(playerid, NewWorld,OldWorld)
{
    if(NewWorld!=OldWorld)
    {
        if(DomainEnter[playerid][_EditID]!=NONE)
        {
	        new VarString[64];
	 		GetPVarString(playerid,"_Select_BulidID_Info",VarString,64);
	 		if(VerifyBuildPVarData(playerid,VarString)==true)
	        {
		        new ObjectIndex,BulidID,CraftBulidKey[37],objectidEx;
				sscanf(VarString, "p<,>iis[37]i",ObjectIndex,BulidID,CraftBulidKey,objectidEx);
				CA_SetObjectPos_DC(ObjectIndex,CraftBulid[BulidID][_Cx],CraftBulid[BulidID][_Cy],CraftBulid[BulidID][_Cz]);
				CA_SetObjectRot_DC(ObjectIndex,CraftBulid[BulidID][_Crx],CraftBulid[BulidID][_Cry],CraftBulid[BulidID][_Crz]);
                UpdateCraftBulidText(BulidID);
				CancelEdit(playerid);
	        }
	        DomainEnter[playerid][_EditID]=NONE;
	        DomainEnter[playerid][_Move]=false;
        }
        if(NewWorld==0)ShowAllFactionZoneForPlayer(playerid);
        else HideFactionZoneForPlayer(playerid);
        
    }
	return 1;
}
FUNC::ClearChat(playerid)
{
	forex(i,30)SCM(playerid,-1, " ");
	return 1;
}
FUNC::RealPlayer(playerid)//是否是真正玩家
{
	if(playerid==INVALID_PLAYER_ID)return 0;
    if(!IsPlayerConnected(playerid))return 0;
    if(IsPlayerNPC(playerid))return 0;
    if(playerid>=MAX_PLAYERS||playerid<0)return 0;
    if(Account[playerid][_Login]==false)return 0;
	return 1;
}
/*FUNC::OnCheatDetected(playerid, ip_address[], type, code)
{
    if(IsPlayerNPC(playerid))return 1;
    if(type) BlockIpAddress(ip_address, 0);
    else
    {
        switch(code)
        {
            case 0:
            {
                if(DomainEnter[playerid][_EditID]!=NONE)return 1;
            }
            case 9:
            {
                if(GetPlayerInDomainState(playerid)!=PLAYER_DOMAIN_NONE)return 1;
                if(DomainEnter[playerid][_EditID]!=NONE)return 1;
                //if(DomainEnter[playerid][_EditID]!=NONE)
            }
            case 5, 6, 11, 22: return 1;
            case 14:
            {
                new a = AntiCheatGetMoney(playerid);
                ResetPlayerMoney(playerid);
                GivePlayerMoney(playerid, a);
                return 1;
            }
            case 32:
            {
                new Float:x, Float:y, Float:z;
                AntiCheatGetPos(playerid, x, y, z);
                SetPlayerPos(playerid, x, y, z);
                return 1;
            }
            case 40: SCM(playerid, -1, MAX_CONNECTS_MSG);
            case 41: SCM(playerid, -1, UNKNOWN_CLIENT_MSG);
            default:
            {
                if(code>=0&&code<sizeof(CheatNames))
                {
	                formatex80("%s 可能作弊了[%s]",Account[playerid][_Name],CheatNames[code][_Chinese]);
	                SendMsgToAllPlayers(0xFF8000C8,string80);
	                InsertCheatLog(Account[playerid][_Key],Account[playerid][_Name],string80);
	                Debug(-1,string80);
                }
                else
				{
				    formatex80(KICK_MSG, code);
                	SCM(playerid,-1,string80);
                	Debug(-1,string80);
				}
             }
        }
        AntiCheatKickWithDesync(playerid, code);
    }
    return 1;
} */

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(clickedid == Text:INVALID_TEXT_DRAW)
	{
		formatex64("GetPVarInt:%i",GetPVarInt(playerid, "selecttextdraw_active"));
		Debug(playerid,string64);
	    if(GetPVarInt(playerid, "selecttextdraw_active")==1)
	    {
	        SetPVarInt(playerid, "selecttextdraw_active", 0);
	        return 1;
	    }
	    else
	    {
	        new DrawShow=false;
	        if(InventoryTextDrawShow[playerid]==true)
	        {
	            HidePlayerInventoryTextDraw(playerid);
	            CancelSelectTextDrawEx(playerid);
	            DrawShow=true;
	            //return 1;
	        }
	        if(NavigationBarShow[playerid]==true)
	        {
	            HidePlayerNavigationBarTextDraw(playerid);
	            CancelSelectTextDrawEx(playerid);
	            DrawShow=true;
	            //return 1;
	        }
	        if(CraftTextDrawShow[playerid]==true)
	        {
	            HideCraftTextDrawForPlayer(playerid);
	            CancelSelectTextDrawEx(playerid);
	            DrawShow=true;
	            //return 1;
	        }
	        if(PlayerInfoTextDrawShow[playerid]==true)
	        {
	            HidePlayerInfoTextDraw(playerid);
	            CancelSelectTextDrawEx(playerid);
	            DrawShow=true;
	            //return 1;
	        }
	        if(PlayerZombieBagTextDrawShow[playerid]==true)
	        {
	            HidePlayerZombieBagTextDraw(playerid);
	            CancelSelectTextDrawEx(playerid);
	            DrawShow=true;
	            //return 1;
	        }
	        if(CarCraftTextDrawShow[playerid]==true)
	        {
	            HideCarCraftThings(playerid);
	            CancelSelectTextDrawEx(playerid);
	            DrawShow=true;
	            //return 1;
	        }
	        if(StoreTextDrawShow[playerid]==true)
	        {
	            HidePlayerStoreTextDraw(playerid);
	            CancelSelectTextDrawEx(playerid);
	            DrawShow=true;
	            //return 1;
	        }
	        if(StrongBoxTextDrawShow[playerid]==true)
	        {
	            HidePlayerStrongBoxTextDraw(playerid);
	            CancelSelectTextDrawEx(playerid);
	            DrawShow=true;
	            //return 1;
	        }
	    	if(DrawShow==false)SelectTextDrawEx(playerid,0x408080C8);
	    	return 1;
	    }
	}
    
    if(TD_OnPlayerClickTD(playerid, clickedid))return 1;
    return 1;
}
public OnPlayerShootDynamicObject(playerid, weaponid, STREAMER_TAG_OBJECT:objectid, Float:x, Float:y, Float:z)
{
    if(Collect_OnShootDynamicObject(playerid, weaponid, objectid, x, y, z))return 1;
    if(Craft_OnShootDynamicObject(playerid, weaponid, objectid, x, y, z))return 1;
	return 1;
}
public OnPlayerEnterDynamicCP(playerid, STREAMER_TAG_CP:checkpointid)
{
 //   if(Domain_OnPlayerEnterDynamicCP(playerid,checkpointid))return 1;
	return 1;
}
public OnPlayerPickUpDynamicPickup(playerid, STREAMER_TAG_PICKUP:pickupid)
{
    if(Domain_OnPlayerPickDynamicPick(playerid,pickupid))return 1;
	return 1;
}
public OnPlayerDamage(&playerid, &Float:amount, &issuerid, &weapon, &bodypart)
{
	printf("OnPlayerDamage1:%f",amount);
	new Dodge=floatround(floatmul(Addition[playerid][_Dodge],100));
	if(Dodge>0)
	{
		if(random(100-Dodge)==0)amount=0.0;
	}
	new Defens=floatround(floatmul(Addition[playerid][_Defens],100));
	if(Defens>0&&amount>=0.0)
	{
	    amount-=floatmul(amount,Addition[playerid][_Defens]);
	}
	if(RealPlayer(issuerid))
	{
	    new Attack=floatround(floatmul(Addition[issuerid][_Attack],100));
	    if(Attack>0&&amount>=0.0)
	    {
	    	amount+=floatmul(amount,Addition[issuerid][_Attack]);
	    }
	}
	printf("OnPlayerDamage2:%f",amount);
    return 1;
}
public OnPlayerDamageDone(playerid, Float:amount, issuerid, weapon, bodypart)
{
    new Float:Healthex;
	GetPlayerHealth(playerid,Healthex);
	if(Healthex<=0)UpdatePlayerHpBar(playerid,0);
    printf("OnPlayerDamageDone %i,%f,%i,%i,%i  当前血量:%f",playerid,amount,issuerid,weapon,bodypart,Healthex);
    return 1;
}
/*public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	if(RealPlayer(playerid))
	{
	    new Float:PlayerHP;
		GetPlayerHealth(playerid,PlayerHP);
		if(IsPlayerNPC(issuerid))
		{
		    SetPlayerHealthEx(playerid,PlayerHP);
		    printf("OnPlayerTakeDamage");
		}
	}
    return 1;
}*/

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    if(TD_OnPlayerClickPlayerTD(playerid, playertextid))return 1;
    return 1;
}
FUNC::SelectTextDrawEx(playerid,hovercolor)
{
    SetPVarInt(playerid, "selecttextdraw_active", 0);
    SelectTextDraw(playerid,hovercolor);
    return 1;
}
FUNC::CancelSelectTextDrawEx(playerid)
{
	SetPVarInt(playerid, "selecttextdraw_active", 1);
	CancelSelectTextDraw(playerid);
    return 1;
}
FUNC::Main_OnVehicleSpawn(vehicleid)
{
    printf("Main_OnVehicleSpawn");
    if(GobalVehicleEngine[vehicleid]==true)ToggleVehicleEngine(vehicleid,1);
    else ToggleVehicleEngine(vehicleid,0);
	return 1;
}
FUNC::Main_OnVehicleDeath(vehicleid, killerid)
{
    printf("Main_OnVehicleDeath1");
    new vehid=GetVehIDByVehicleID(vehicleid);
	if(vehid!=NONE)
	{
	    if(Veh[vehid][Timer:_Delete]!=NONE)KillTimer(Veh[vehid][Timer:_Delete]);
	    Veh[vehid][Timer:_Delete]=NONE;
	    Veh[vehid][Timer:_Delete]=SetTimerEx("DestoryVeh",2000,false,"i",vehid);
	    printf("Main_OnVehicleDeath2");
	}
	return 1;
}
CMD:skin(playerid)
{
    HidePlayerInventoryTextDraw(playerid);
    HidePlayerInfoTextDraw(playerid);
    HidePlayerQuickUseTextDraw(playerid);
    HidePlayerNavigationBarTextDraw(playerid);
    SetPlayerVirtualWorld(playerid,PLAYER_SELECTSKIN_WORLD+playerid);
    new Float:SpawnZ;
    CA_FindZ_For2DCoord(SafeZone[Account[playerid][_SpawnTown]][_sX],SafeZone[Account[playerid][_SpawnTown]][_sY],SpawnZ);
	new Float:xyz[2][2];
	xyz[0][0]=xyz[0][1]=SafeZone[Account[playerid][_SpawnTown]][_sX];
	xyz[1][0]=xyz[1][1]=SafeZone[Account[playerid][_SpawnTown]][_sY];
	SetPlayerPos(playerid,SafeZone[Account[playerid][_SpawnTown]][_sX],SafeZone[Account[playerid][_SpawnTown]][_sY],SpawnZ+0.5);
	SetPlayerFacingAngle(playerid,0.0);
	GetPointInFront2D(SafeZone[Account[playerid][_SpawnTown]][_sX],SafeZone[Account[playerid][_SpawnTown]][_sY],0.0,3.0,xyz[0][0], xyz[1][0]);
	SetPlayerCameraPos(playerid,xyz[0][0], xyz[1][0],SpawnZ+1.0);
	SetPlayerCameraLookAt(playerid,xyz[0][1], xyz[1][1], SpawnZ+1.0,CAMERA_CUT);
	TogglePlayerControllable(playerid,1);
	ShowPlayerSkinSelectTextDraw(playerid,0,2);
	SelectTextDrawEx(playerid,0x408080C8);
	return 1;
}
//			SetPlayerAttachedObject(i,9,19134,1,0.0,0.0,1.399998,0.000000,90.0,rot+180,1.000000,1.000000,1.000000);

/*#define LIMIT_NODES 500
new
	Float:p@x,
	Float:p@y,
	Float:p@z;
CMD:position(playerid) {

	GetPlayerPos(playerid, p@x, p@y, p@z);

    new str[75];
    format(str, sizeof str, "The end position is here: %f %f %f", p@x, p@y, p@z);
    SendClientMessage(playerid, -1, str);

	return 1;
}
CMD:pathfinder(playerid, params[])
{
	if (sscanf(params, "f", Float:params[0]))
	    return SendClientMessage(playerid, -1, "/pathfinder <stepsize>");

	new
		Float:x,
		Float:y,
		Float:z,
		tick = GetTickCount()
		;

	GetPlayerPos(playerid, x, y, z);

    new cyPath[LIMIT_NODES];

    new countNodes = CY_FindPath(x, y, z, p@x, p@y, p@z, cyPath, .step_size = Float: params[0]);

    if (countNodes)
	{
        new id;
        while (cyPath[id]) {
            CY_GetNodePosition(cyPath[id], x, y, z);

            CreateDynamicObject(19135, x, y, z, 0.0, 0.0, 0.0);
            CreateDynamicMapIcon(x, y, z, 0, 0xFF0000FF);
            id++;
        }
    }
    new str[75];
    SendClientMessage(playerid, -1, "----------------------------------------------------------");
    format(str, sizeof str, "%s: {FFFFFF} Nodes: %d", countNodes ? ("{00AA00}SUCCESS") : ("{FF0000}ERROR"), countNodes);
    SendClientMessage(playerid, -1, str);
    format(str, sizeof str, "Start: %f %f %f", x, y, z);
    SendClientMessage(playerid, -1, str);
    format(str, sizeof str, "End: %f %f %f", p@x, p@y, p@z);
    SendClientMessage(playerid, -1, str);
    format(str, sizeof str, "Time: %dms", GetTickCount() - tick);
    SendClientMessage(playerid, -1, str);
    SendClientMessage(playerid, -1, "----------------------------------------------------------");

	return 1;
}*/
