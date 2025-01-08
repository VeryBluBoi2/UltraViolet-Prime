package com.game {
	
	import com.game.common.App;
	import com.game.common.Setting;
	import com.game.common.Levels;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import com.clip.title;
	import com.clip.intro;
	import com.clip.resultFail;
	import com.clip.resultWin;
	import com.clip.finishClip;
	import com.clip.levelScreen;
	import com.clip.creditScreen;
	import com.clip.optionClip;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.system.Security;
	
	public class main extends MovieClip {
		protected var timeUse:Number = 0;
		
		public function main() {
			App.GetInstance().mMain = this;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedListener);
			//this["mPreloader"].initLoader(this.root.loaderInfo);
			
			var paramObj:Object = LoaderInfo(this.loaderInfo).parameters;
			var apiPath:String = paramObj.kongregate_api_path || "http://www.kongregate.com/flash/API_AS3_Local.swf";
			
			Security.allowDomain(apiPath);
			
			var request:URLRequest = new URLRequest(apiPath);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadAPIComplete);
			loader.load(request);
			this.addChild(loader);
		}
		
		protected function onAddedListener(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedListener);
			init();
		}
		
		protected function loadAPIComplete(e:Event):void {
			App.GetInstance().kongregate = e.target.content;
			App.GetInstance().kongregate.services.connect();
			
			App.GetInstance().mStat.submitCompletedStatistic();
			
			CreateTitlePage();
		}
		
		protected function init():void {
			App.GetInstance().InitManager();
		}
		
		public function CreateTitlePage():void {
			ClearStage();
			App.GetInstance().curLevel = Setting.defaultLevel;
			App.GetInstance().gameState = Setting.STATE_TITLE;
			var titlePage:title = new title();
			this.addChild(titlePage);
			App.GetInstance().mSound.ClearSound();
			App.GetInstance().mSound.StopMusic();
			App.GetInstance().mSound.PlayMusic("loopFront");
		}
		
		public function CreateLevelScreen():void {
			var level:levelScreen = new levelScreen();
			this.addChild(level);
		}
		
		public function CreateOptionScreen():void {
			var opt:optionClip = new optionClip();
			this.addChild(opt);
		}
		
		public function CreateCreditScreen():void {
			var credit:creditScreen = new creditScreen();
			this.addChild(credit);
		}
		
		public function ReturnToTitle(screen:MovieClip):void {
			this.removeChild(screen);
		}
		
		protected function ClearStage():void {
			while (this.numChildren > 0) {
				this.removeChildAt(0);
			}
		}
				
		public function EnterStage(stage:int):void {
			App.GetInstance().curLevel = stage;
			initLevel();
			App.GetInstance().mSound.PlayMusic("loopGame");
		}
		
		protected function initLevel():void {
			ClearStage();
			
			var batchMap:String = App.GetInstance().mLevel.stageMap[App.GetInstance().curLevel];
			this.addChild(App.GetInstance().mMap.CreateMap(batchMap));
			
			var mIntro:intro = new intro();
			this.addChild(mIntro);
			
			App.GetInstance().mSound.ClearSound();
			App.GetInstance().gameState = Setting.STATE_INTRO;			
		}
		
		public function StartStage(mcIntro:intro = null):void {
			try {
				this.removeChild(mcIntro);
			}catch (e:Error) { }
			
			App.GetInstance().mInput.initKeyboardListener();
			App.GetInstance().mMap.startUpdater();
			
			stage.focus = this;
			
			App.GetInstance().gameState = Setting.STATE_START;			

			timeUse = new Date().time;			
		}
		
		public function ShowResult(result:int):void {
			timeUse = (new Date().time) - timeUse;
			App.GetInstance().gameState = Setting.STATE_RESULT;
			switch(result) {
				case Setting.RESULT_WIN:
					App.GetInstance().mData.SolvedPuzzle(App.GetInstance().curLevel);
					App.GetInstance().mStat.submitCompletedStatistic();
					App.GetInstance().mStat.submitFastestTime(App.GetInstance().curLevel, timeUse);
					this.addChild(new resultWin());
					break;
				case Setting.RESULT_LOSE:
					this.addChild(new resultFail());
					break;
			}
		}
		
		public function EndTheStage():void {
			App.GetInstance().mMap.stopUpdater();
			App.GetInstance().mMap.DoEnd();
			App.GetInstance().mInput.uninitKeyboardListener();
			App.GetInstance().gameState = Setting.STATE_RESULT;
		}
		
		public function NextLevel():void {
			if (App.GetInstance().curLevel < Setting.maxLevel) {
				App.GetInstance().curLevel++;
				initLevel();
			}else {
				//this.addChild(new finishClip());
				CreateTitlePage();
			}
		}
		
		public function RetryLevel():void {
			initLevel();
		}
		
		public function QuitLevel():void {
			CreateTitlePage();
		}
	}
	
}
