/*
	Dog Debugging -- Will show hints in game (for everyone) on what the dog is doing, this is for server owner use only!!! Suggest this is not run on live servers
*/

dogDebug = false; // Set to true to debug the script

// Dog follower
BURK_dogFollowing = true;
BURK_dogSeeking = false;
BURK_dogMoveToPos = false;
JohnOplayerHasDog = true;

BURK_dog playMove "Dog_Run";
Dogfollow = player addAction 
[
	"Dog: Follow", 
	{ 	
		if !(BURK_dogFollowing) then 
		{	
			[] call BURK_dogFollowPlayer;
		};
	}
];

dogseek = player addAction 
[
	"Dog: Seek", 
	{
		if !(BURK_dogSeeking) then
		{	
			titleText ["Your dog will seekout animals..","PLAIN DOWN"];
			[] call BURK_dogSeek;
		}
		else
		{
			titleText ["Your dog is already seeking","PLAIN DOWN"];
		};	
	}
];

dogMove = player addAction ["Dog: Move to","Taiming\moveTo.sqf","",0,false];

Dogpassive = player addAction ["Dog: Aggressive","Taiming\agressive.sqf","",0,false];

Dogstay = player addAction ["Dog: Stay", {BURK_dog playMove "Dog_Stop";}];

Dogrun = player addAction ["Dog: Run", {BURK_dog playMove "Dog_Run";}];
Dogsprint = player addAction ["Dog: Sprint", {BURK_dog playMove "Dog_Sprint";}];


[] call BURK_dogFollowPlayer;