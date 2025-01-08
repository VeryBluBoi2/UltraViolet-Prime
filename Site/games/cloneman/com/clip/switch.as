package com.clip
{
	import com.clip.mapObject;
	import com.clip.trap2;
	/**
	 * @author Adhi
	 */
	public class switch extends mapObject {
		protected var activateCount:int = -1;
		protected var isActivated:Boolean = false;
		
		public override function PushMe(posX:int, posY:int):Boolean {
			if (isActivated) return false;
			var px:int = Math.floor(this.x / 40);
			var py:int = Math.floor(this.y / 40);
			return (posX == px && posY == py);
		}
		
		public function PushBox(pd:int):void {
			isActivated = true;
			activateCount = 3;
		}
		
		public override function onTimer():void {
			if (activateCount > 0) {
				activateCount--;
				if (activateCount == 0) {
					isActivated = false;
				}
			}
		}
		
	}
	
}