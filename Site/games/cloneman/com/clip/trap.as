package com.clip
{
	import com.game.common.App;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * @author Adhi
	 */
	public class trap extends mapObject	{
		protected var activateCount:int = -1;
		protected var ACTIVATINGDELAY:int = 30;
		public var type:String			= "s";
		
		public function trap():void {
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);		
		}
		
		public function InitTrap(posX:int,posY:int):void {
			this.gotoAndStop("disarm");
			x = posX * 40;
			y = posY * 40;
		}
		
		protected function onRemoved(e:Event):void {
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
		public override function onTimer():void {
			//trace("trap is " + activateCount);
			if (activateCount > 0 && this.currentLabel == "activate") {
				activateCount--;
				if (activateCount == 0) {
					//trace("deactivate");
					this.gotoAndPlay("deactivate");
					playSound();
				}
			}
		}
		
		public override function ActivateMe(posX:int, posY:int):Boolean {
			var px:int = Math.floor(this.x / 40);
			var py:int = Math.floor(this.y / 40);
			//trace(posX + "," + posY + " " + px + "," + py);
			return (posX == px && posY == py);
		}
		
		public override function DoActivate():void {
			if (activateCount <= 0){
				this.gotoAndPlay("activate");
				activateCount = ACTIVATINGDELAY;
				playSound();
			}
		}
		
		protected function playSound():void {
			App.GetInstance().mSound.PlaySound("trapMoving", this.name);
		}
		
	}	
}