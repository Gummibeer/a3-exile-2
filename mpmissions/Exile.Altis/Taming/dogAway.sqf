titleText ["Your dog will be hidden in 5 seconds","PLAIN DOWN"];

uiSleep 5;

deleteVehicle BURK_dog;

JohnOplayerHasDog = false;
BURK_dogFollowing = false;
BURK_dogSeeking = false;
BURK_dog_movingToPos = false;