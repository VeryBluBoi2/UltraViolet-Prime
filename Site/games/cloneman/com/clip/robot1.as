package com.clip
{
	import com.game.common.App;
	import com.game.common.Setting;
	
	/**
	 * @author Adhi
	 */
	public class robot1 extends enemy {
		protected var shootingCount:int		= 0;
		protected var isMoving:Boolean		= false;
		
		public override function initEnemy(px:int, py:int):void {
			super.initEnemy(px, py);
			dist 		= Setting.robot1Dist;
			moveStep	= Setting.playerMove;
		}
		
		public override function DoPush(pd:int):Boolean {
			if (isMoving) return false;
			
			var posX:int = Math.floor(this.x / 40);
			var posY:int = Math.floor(this.y / 40);
			var code:int = 0;
			switch(pd) {
				case Setting.UP:	code = cekUp(posX, posY, 1); break;
				case Setting.DOWN:	code = cekDown(posX, posY, 1); break;
				case Setting.LEFT:	code = cekLeft(posX, posY, 1); break;
				case Setting.RIGHT:	code = cekRight(posX, posY, 1); break;
			}
			//trace("Do Push "+code);
			if (code > -1) {
				App.GetInstance().mCodeArray[posY][posX] = "0";
				isMoving = true;
				dir = pd;
				destX = x;
				destY = y;
				switch(dir) {
					case Setting.UP:	
						destY = (posY - 1) * 40; 
						App.GetInstance().mCodeArray[posY-1][posX] = "T";
						break;
					case Setting.DOWN:	
						destY = (posY + 1) * 40; 
						App.GetInstance().mCodeArray[posY+1][posX] = "T";
						break;
					case Setting.LEFT:	
						destX = (posX - 1) * 40; 
						App.GetInstance().mCodeArray[posY][posX-1] = "T";
						break;
					case Setting.RIGHT:	
						destX = (posX + 1) * 40;
						App.GetInstance().mCodeArray[posY][posX+1] = "T";
						break;
				}
				return true;
			}else {
				DoDie();
			}
			return false;
		}
		
		public override function DoDie():void {
			super.DoDie();
			var posY:int = Math.floor(y / 40);
			var posX:int = Math.floor(x / 40);
			App.GetInstance().mCodeArray[posY][posX] = "0";
			if (currentLabel != "dead") this.gotoAndStop("dead");
			App.GetInstance().mSound.PlaySound("explode", this.name);
		}
		
		protected override function DoMove():void {
			if (App.GetInstance().gameState != Setting.STATE_START) return;
			
			if (isDead) {
				if (deadCount > 0 ) {
					deadCount--;
					if (deadCount == 0) {
						uninitEnemy();
						App.GetInstance().mMap.DoRemoveObject(this);
					}
				}
				return;
			}

			if (dir != -1){
				if (destX != x || destY != y) {
					switch(dir) {
						case Setting.UP:		this.y -= moveStep; break;
						case Setting.DOWN:		this.y += moveStep; break;
						case Setting.LEFT:		this.x -= moveStep; break;
						case Setting.RIGHT:		this.x += moveStep; break;
					}
				}else {
					dir = -1;
				}
			}else {
				isMoving = false;
				doCekMove();
			}
		}
		
		protected override function doCekMove():void {
			//trace("do cek Move");
			if (shootingCount > 0) {
				shootingCount--;
				if (shootingCount == 0) {
					this.gotoAndStop("idle");
				}
			}else{
				var posX:int = Math.floor(this.x / 40);
				var posY:int = Math.floor(this.y / 40);
				for (var i:int = 0; i < 4; i++) {
					var code:int = -1;
					switch (i) {
						case Setting.UP: 	code = cekUp(posX, posY, dist); break;
						case Setting.DOWN: 	code = cekDown(posX, posY, dist); break;
						case Setting.LEFT:	code = cekLeft(posX, posY, dist); break;
						case Setting.RIGHT:	code = cekRight(posX, posY, dist); break;
					}
					if (code == Setting.playerStep || code == Setting.cloneStep) {
						shootingCount = 30;
						switch(i) {
							case Setting.UP:	this.gotoAndStop("shoot_up"); break;
							case Setting.DOWN:	this.gotoAndStop("shoot_down"); break;
							case Setting.LEFT:	this.gotoAndStop("shoot_left"); break;
							case Setting.RIGHT:	this.gotoAndStop("shoot_right"); break;
						}
						App.GetInstance().mSound.PlaySound("shoot", this.name);
						if (code == Setting.playerStep) {
							App.GetInstance().mCloneman.DoDie();
						}else if (code == Setting.cloneStep) {
							App.GetInstance().mCloneman.removeClone();
						}
					}
					destX = x;
					destY = y;
					dir = -1;
				}
			}
		}
		
		public override function IsHit(posX:int, posY:int, type:String = ""):Boolean {
			//trace("is hit "+type);
			if (type == "s") return false;
			if (isDead) return false;
			var px:int = Math.round(this.x / 40);
			var py:int = Math.round(this.y / 40);
			//trace("is hit "+type);
			return (px == posX && py == posY);
		}
		
	}
	
}