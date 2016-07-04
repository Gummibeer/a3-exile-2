#define TOAST_COLOR_WHITE			[1, 1, 1, 1]
#define TOAST_COLOR_WHITE_CONFIG    {1, 1, 1, 1}

#define TOAST_COLOR_BANDIT		    [1,0.137,0,1]
#define TOAST_COLOR_BANDIT_CONFIG	{1,0.137,0,1}
#define TOAST_COLOR_MILITARY		[0.463,0.29,0.184,1]
#define TOAST_COLOR_MILITARY_CONFIG	{0.463,0.29,0.184,1}
#define TOAST_COLOR_SWAT		    [0.529,0.58,0.647,1]
#define TOAST_COLOR_SWAT_CONFIG	    {0.529,0.58,0.647,1}

class CfgExileToasts
{
	///////////////////////////////////////////////////////////////////////////
	// Default
	///////////////////////////////////////////////////////////////////////////
	class DefaultEmpty
	{
		template = "%1";
		color[] = TOAST_COLOR_WHITE_CONFIG;
	};

	class DefaultTitleOnly
	{
		template = "<t size='22' font='PuristaMedium'>%1</t>";
		color[] = TOAST_COLOR_WHITE_CONFIG;
	};

	class DefaultTitleAndText
	{
		template = "<t size='22' font='PuristaMedium'>%1</t><br/><t color='#ff979ba1' size='19' font='PuristaLight'>%2</t>";
		color[] = TOAST_COLOR_WHITE_CONFIG;
	};

	///////////////////////////////////////////////////////////////////////////
	// Bandit
	///////////////////////////////////////////////////////////////////////////
	class BanditEmpty
	{
		template = "%1";
		color[] = TOAST_COLOR_BANDIT_CONFIG;
	};

	class BanditTitleOnly
	{
		template = "<t size='22' font='PuristaMedium'>%1</t>";
		color[] = TOAST_COLOR_BANDIT_CONFIG;
	};

	class BanditTitleAndText
	{
		template = "<t size='22' font='PuristaMedium'>%1</t><br/><t color='#ff979ba1' size='19' font='PuristaLight'>%2</t>";
		color[] = TOAST_COLOR_BANDIT_CONFIG;
	};

	///////////////////////////////////////////////////////////////////////////
	// Military
	///////////////////////////////////////////////////////////////////////////
	class MilitaryEmpty
	{
		template = "%1";
		color[] = TOAST_COLOR_MILITARY_CONFIG;
	};

	class MilitaryTitleOnly
	{
		template = "<t size='22' font='PuristaMedium'>%1</t>";
		color[] = TOAST_COLOR_MILITARY_CONFIG;
	};

	class MilitaryTitleAndText
	{
		template = "<t size='22' font='PuristaMedium'>%1</t><br/><t color='#ff979ba1' size='19' font='PuristaLight'>%2</t>";
		color[] = TOAST_COLOR_MILITARY_CONFIG;
	};

	///////////////////////////////////////////////////////////////////////////
	// SWAT
	///////////////////////////////////////////////////////////////////////////
	class SwatEmpty
	{
		template = "%1";
		color[] = TOAST_COLOR_SWAT_CONFIG;
	};

	class SwatTitleOnly
	{
		template = "<t size='22' font='PuristaMedium'>%1</t>";
		color[] = TOAST_COLOR_SWAT_CONFIG;
	};

	class SwatTitleAndText
	{
		template = "<t size='22' font='PuristaMedium'>%1</t><br/><t color='#ff979ba1' size='19' font='PuristaLight'>%2</t>";
		color[] = TOAST_COLOR_SWAT_CONFIG;
	};
};