package com.clip
{	
	import com.game.common.App;
	import com.clip.trap;
	/**
	 * @author Adhi
	 */
	public class trap2 extends trap	{
		
		public override function ActivateMe(posX:int, posY:int):Boolean {
			if (activateCount <= 0) return false;
			//trace("should still active");
			var px:int = Math.floor(this.x / 40);
			var py:int = Math.floor(this.y / 40);
			//trace(posX + "," + posY + " " + px + "," + py);
			return (posX == px && posY == py);
		}
		
		public override function DoActivate():void {
		}
		
		public override function DoAutoActivate():Boolean {
			var px:int = Math.floor(this.x / 40);
			var py:int = Math.floor(this.y / 40);
			var val:int = parseInt(App.GetInstance().mCodeArray[py][px]);
			if (!isNaN(val)) {
				if (val > 0) return false;
			}
			this.gotoAndPlay("activate");
			activateCount = ACTIVATINGDELAY;
			return true;
		}
		
		protected override function playSound():void {
			
		}
		
	}
	
}