package com.clip
{
	import com.game.common.App;
	import com.clip.mapObject;

	/**
	 * @author Adhi
	 */
	public class switchWall extends mapObject {
		protected var activateCount:int = -1;
		protected var isActivated:Boolean = false;
		protected var ACTIVATINGDELAY:int = 30;
		
		public override function PushMe(posX:int, posY:int):Boolean {
			if (isActivated) return false;
			var px:int = Math.floor(this.x / 40);
			var py:int = Math.floor(this.y / 40);
			return (posX == px && posY == py);
		}
		
		public override function PushBox(pd:int):void {
			isActivated = true;
			activateCount = ACTIVATINGDELAY;
			App.GetInstance().mMap.ActivateAllTrap();
			App.GetInstance().mSound.PlaySound("trapMoving", "switch");
		}
		
		public override function onTimer():void {
			if (activateCount > 0) {
				activateCount--;
				if (activateCount == 0) {
					isActivated = false;
					App.GetInstance().mSound.PlaySound("trapMoving", "switch");
				}
			}
		}
		
	}
	
}