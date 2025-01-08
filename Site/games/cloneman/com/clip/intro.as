package com.clip
{
	import com.game.common.App;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * @author Adhi
	 */
	public class intro extends MovieClip {
		protected var mTimer:Timer;
		
		public function intro():void {
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected function onAdded(e:Event):void {			
			this["txt_level"].text 	= App.GetInstance().curLevel.toString();
			this["txt_desc"].text 	= App.GetInstance().mLevel.introText[App.GetInstance().curLevel];

			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			this.addEventListener(MouseEvent.CLICK, onClicked);
			
			var timeout:int = 2000;
			if (App.GetInstance().curLevel == 1) {
				var tut1:MovieClip = new tutor1();
				tut1.x = (800 - tut1.width) / 2;
				this["txt_Stage"].y = 20;
				this["txt_level"].y = 20;
				this["txt_desc"].visible = false;
				tut1.y = 100;
				this.addChild(tut1);
			}else if (App.GetInstance().curLevel == 2) {
				var tut2:MovieClip = new tutor2();
				tut2.x = (800 - tut2.width) / 2;
				this["txt_Stage"].y = 20;
				this["txt_level"].y = 20;
				this["txt_desc"].visible = false;
				tut2.y = 100;
				this.addChild(tut2);
			}else if (App.GetInstance().curLevel == 3) {
				var tut3:MovieClip = new tutor3();
				tut3.x = (800 - tut3.width) / 2;
				this["txt_Stage"].y = 20;
				this["txt_level"].y = 20;
				this["txt_desc"].visible = false;
				tut3.y = 100;
				this.addChild(tut3);
			}else if (App.GetInstance().curLevel == 11) {
				var tut4:MovieClip = new tutor4();
				tut4.x = (800 - tut4.width) / 2;
				this["txt_Stage"].y = 20;
				this["txt_level"].y = 20;
				this["txt_desc"].visible = false;
				tut4.y = 100;
				this.addChild(tut4);
			}else if (App.GetInstance().curLevel == 13) {
				var tut5:MovieClip = new tutor5();
				tut5.x = (800 - tut5.width) / 2;
				this["txt_Stage"].y = 20;
				this["txt_level"].y = 20;
				this["txt_desc"].visible = false;
				tut5.y = 100;
				this.addChild(tut5);
			}
			/*else {
				mTimer = new Timer(timeout,1);
				mTimer.addEventListener(TimerEvent.TIMER, onTimer);
				mTimer.start();
			}
			*/
		}
		
		protected function onClicked(e:MouseEvent):void {
			App.GetInstance().mMain.StartStage(this);
		}
		
		protected function onRemoved(e:Event):void {
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			//mTimer.removeEventListener(TimerEvent.TIMER, onTimer);
			this.removeEventListener(MouseEvent.CLICK, onClicked);
		}
		
		protected function onTimer(e:TimerEvent):void {
			App.GetInstance().mMain.StartStage(this);
		}
	}
	
}