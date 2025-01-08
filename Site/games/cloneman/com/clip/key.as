package com.clip
{
	import com.game.common.App;
	import com.clip.mapObject;
	
	/**
	 * @author Adhi
	 */
	public class key extends mapObject {
		protected var taken:Boolean = false;
		
		public override function HitMe(posX:int, posY:int):Boolean {
			if (taken) return false;
			var px:int = Math.floor(this.x / 40);
			var py:int = Math.floor(this.y / 40);
			//trace("HitMe Me " + posX + "," + posY+" "+px+","+py);
			return (posX == px && posY == py);
		}
		
		public override function DoGet():void {
			taken = true;
			App.GetInstance().mCloneman.GetKey();
			App.GetInstance().mMap.DoRemoveGround(this);
			App.GetInstance().mSound.PlaySound("getKey", this.name);
		}
		
	}
	
}