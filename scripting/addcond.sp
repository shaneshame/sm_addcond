#pragma semicolon 1

#define PLUGIN_AUTHOR "Shane Shame"
#define PLUGIN_VERSION "0.1.0"

#include <sourcemod>
#include <sdktools>
#include <sourcemod>
#include <tf2_stocks>

#undef REQUIRE_PLUGIN

#pragma newdecls required

public Plugin myinfo = {
	name = "sm_addcond",
	author = PLUGIN_AUTHOR,
	description = "Add/Remove conditions to SourceMod targets",
	version = PLUGIN_VERSION,
	url = "https://github.com/shaneshame/sm_addcond"
};

void RegisterCmds() {
  RegAdminCmd("sm_addcond", Command_AddCond, ADMFLAG_BAN, "Add condition to target");
  RegAdminCmd("sm_rmcond", Command_RemoveCond, ADMFLAG_BAN, "Remove condition to target");
  RegAdminCmd("sm_removecond", Command_RemoveCond, ADMFLAG_BAN, "Remove condition to target");
}

public void OnPluginStart() {
	RegisterCmds();
	AutoExecConfig(true);
}

void AddCond(int client, int target, int condition, float duration) {
	TF2_AddCondition(target, view_as<TFCond>(condition), duration, 0);
	LogAction(client, target, "\"%L\" set Condition on \"%L\"", client, target);
}

void RemoveCond(int client, int target, int condition) {
	TF2_RemoveCondition(target, view_as<TFCond>(condition));
	LogAction(client, target, "\"%L\" Removed Condition from \"%L\"", client, target);
}

public Action Command_AddCond(int client, int args) {
	if (args < 3) {
		ReplyToCommand(client, "[SM] Usage: sm_addcond <target> <condition> <duration>");
		return Plugin_Handled;
	}

	char arg1[MAX_NAME_LENGTH];
	char arg2[16];
	char arg3[16];

	GetCmdArg(1, arg1, sizeof(arg1));
	GetCmdArg(2, arg2, sizeof(arg2));
	GetCmdArg(3, arg3, sizeof(arg3));

	char target_name[MAX_TARGET_LENGTH];
	int target_list[MAXPLAYERS];
	int condition = StringToInt(arg2);
	float duration = StringToFloat(arg3);
	bool tn_is_ml;

	int target_count = ProcessTargetString(
		arg1,
		client,
		target_list,
		MAXPLAYERS,
		COMMAND_FILTER_ALIVE,
		target_name,
		sizeof(target_name),
    tn_is_ml
	);

	if (target_count <= 0) {
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}

	for (int i = 0; i < target_count; i++) {
		AddCond(client, target_list[i], condition, duration);
	}

	if (tn_is_ml) {
		ShowActivity2(client, "[SM] ", "Added Condition to target");
	} else {
		ShowActivity2(client, "[SM] ", "Added Condition to target");
	}

  return Plugin_Handled;
}

public Action Command_RemoveCond(int client, int args) {
	if (args < 2) {
		ReplyToCommand(client, "[SM] Usage: sm_rmcond <target> <condition>");
		return Plugin_Handled;
	}

	char arg1[MAX_NAME_LENGTH];
	char arg2[16];

	GetCmdArg(1, arg1, sizeof(arg1));
	GetCmdArg(2, arg2, sizeof(arg2));

	char target_name[MAX_TARGET_LENGTH];
	int target_list[MAXPLAYERS];
	int condition = StringToInt(arg2);
	bool tn_is_ml;

	int target_count = ProcessTargetString(
		arg1,
		client,
		target_list,
		MAXPLAYERS,
		COMMAND_FILTER_ALIVE,
		target_name,
		sizeof(target_name),
    tn_is_ml
	);

	if (target_count <= 0) {
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}

	for (int i = 0; i < target_count; i++) {
		RemoveCond(client, target_list[i], condition);
	}

	if (tn_is_ml) {
		ShowActivity2(client, "[SM] ", "Removed Condition from target");
	} else {
		ShowActivity2(client, "[SM] ", "Removed Condition from target");
	}

  return Plugin_Handled;
}