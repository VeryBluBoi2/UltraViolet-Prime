package com.game.common
{
	import com.game.manager.InputManager;
	import com.game.manager.MapManager;
	import com.game.manager.SoundManager;
	import com.game.manager.DataManager;
	import com.game.manager.StatisticManager;
	import com.clip.cloneman;
	import com.game.main;
	import com.game.common.Levels;
	
	/**
	 * @author ACL
	 */
	
	public class App {
		private static var app:App;
		
		public var mMain:main;
		public var mInput:InputManager;
		public var mMap:MapManager;
		public var mSound:SoundManager;
		public var mData:DataManager;
		public var mStat:StatisticManager;
		public var mLevel:Levels;
		
		public var gameState:int		= Setting.STATE_LOAD;
		public var curLevel:int			= 0;
		
		public var mCloneman:cloneman;
		public var mCodeArray:Array;
		public var mPlayerMove:Array;
		public var mWidth:Number;
		public var mHeight:Number;
		
		public var useSound:Boolean		= true;
		public var useMusic:Boolean		= true;
		
		
		public var kongregate:*;
		
		public static function GetInstance():App {
			if (app == null) {
				app = new App();
			}
			return app;
		}
		
		public function InitManager():void {
			mInput 	= new InputManager();
			mMap	= new MapManager();
			mLevel	= new Levels();
			mSound 	= new SoundManager();
			mData	= new DataManager();
			mStat	= new StatisticManager();
		}
	}
	
}