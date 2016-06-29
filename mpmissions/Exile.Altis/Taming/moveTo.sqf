_caller= _this select 0;
_action = _this select 2;
_caller removeAction _action;

BURK_dog_movingToPos = false;
BURK_dogFollowing = false;
BURK_dogSeeking = false;
BURK_dog playMove "Dog_Sprint";

[] call BURK_dogMoveToPos;

