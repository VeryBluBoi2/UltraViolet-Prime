package com.clip
{
	import com.game.common.App;
	import com.clip.mapObject
	/**
	 * @author Adhi
	 */
	public class door extends mapObject	{
		protected var isUnlocked = false;
		
		public override function PushMe(posX:int, posY:int):Boolean {
			if (isUnlocked) return false;
			if (!App.GetInstance().mCloneman.HasKey()) return false;
			var px:int = Math.floor(this.x / 40);
			var py:int = Math.floor(this.y / 40);
			//trace("push wall " + px + "," + py + " " + posX + "," + posY);
			return (posX == px && posY == py);
		}
		
		public override function PushBox(pd:int):void {
			isUnlocked = true;
			var px:int = Math.floor(this.x / 40);
			var py:int = Math.floor(this.y / 40);
			App.GetInstance().mCloneman.UseKey();
			App.GetInstance().mCodeArray[py][px] = 0;
			App.GetInstance().mMap.DoRemoveGround(this);
			App.GetInstance().mSound.PlaySound("getKey", this.name);
		}
		
	}
	
}