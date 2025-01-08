package com.clip
{
	import com.clip.enemy;
	import com.game.common.App;
	import com.game.common.Setting;
	import flash.display.MovieClip;
	
	/**
	 * @author Adhi
	 */
	public class robot2 extends enemy {
		protected var foundCount:Number = 0;
		protected var SURPRISECOUNT:Number = 4;
		
		public override function initEnemy(px:int, py:int):void {
			super.initEnemy(px, py);
			dist = Setting.enemy1Dist;
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

			if (foundCount > 0) {
				foundCount--;
				return;
			}
			/*
			doCheckHit();
			
			if (destX != x || destY != y) {
				switch(dir) {
					case Setting.UP:						
						if (currentLabel != "up") 	gotoAndStop("up");
						this.y -= moveStep; 
					break;
					case Setting.DOWN:
						if (currentLabel != "down") gotoAndStop("down");
						this.y += moveStep; 
					break;
					case Setting.LEFT:	
						if (currentLabel != "left") gotoAndStop("left");
						this.x -= moveStep; 
					break;
					case Setting.RIGHT:
						if (currentLabel != "right") gotoAndStop("right");
						this.x += moveStep;
					break;
				}
			}else {
				doCekMove();
			}
			*/
		}
		
		protected function doCheckHit():void {
			var posX:int = Math.round(this.x / 40);
			var posY:int = Math.round(this.y / 40);

			if (App.GetInstance().mMap.CheckHitPlayerAndClone(posX, posY)) {
				x = posX * 40;
				y = posY * 40;
				changeDirection(posX,posY);
			}
			/*
			if (App.GetInstance().mMap.CheckHitTrap(posX, posY)) {
				//trace("check hit trap hit "+this.name);
				DoDie();
				return;
			}
			*/
		}
		
		public override function DoDie():void {
			super.DoDie();
			if (currentLabel != "dead") this.gotoAndStop("dead");
			App.GetInstance().mSound.PlaySound("explode", this.name);
		}
		
		protected override function doCekMove():void {
			var posX:int = Math.floor(this.x / 40);
			var posY:int = Math.floor(this.y / 40);

			if (dir != -1) {
				changeDirection(posX,posY);
			}else {
				var tmpDir = dir;
				var tmpDX = destX;
				var tmpDY = destY;
				for (var pdir:int = 0; pdir < 4; pdir++) {
					var found = -1;
					switch(pdir) {
						case Setting.UP:	found = cekUp(posX, posY, dist);
						break;
						case Setting.DOWN:	found = cekDown(posX, posY, dist);
						break;
						case Setting.LEFT: 	found = cekLeft(posX, posY, dist);
						break;
						case Setting.RIGHT: found = cekRight(posX, posY, dist);
						break;
					}
					if (found > 0) {
						if (found == Setting.playerStep || found == Setting.cloneStep) {
							var surp:MovieClip = new surprise();
							surp.x = this.x;
							surp.y = this.y;
							App.GetInstance().mMap.DoAddObject(surp);
							//start aftering
							foundCount = SURPRISECOUNT;
							break;
						}else {
							dir = tmpDir;
							destX = tmpDX;
							destY = tmpDY;
						}
					}
				}
			}
		}

		protected override function changeDirection(posX:int,posY:int): void {			
			dir = -1;
			var upVal:int 		= cekUp(posX, posY, 1);
			var downVal:int 	= cekDown(posX, posY, 1);
			var leftVal:int 	= cekLeft(posX, posY, 1);
			var rightVal:int 	= cekRight(posX, posY, 1);
			var curMaxVal:int	= upVal;
			
			dir = Setting.UP;
			if (downVal > curMaxVal) {
				dir = Setting.DOWN;
				curMaxVal = downVal;
			}
			if (leftVal > curMaxVal) {
				dir = Setting.LEFT;
				curMaxVal = leftVal;
			}
			if (rightVal > curMaxVal) {
				dir = Setting.RIGHT;
				curMaxVal = rightVal;
			}
			
			destX = x;
			destY = y;
			
			if (curMaxVal <= 0) dir = -1;
			switch(dir) {
				case Setting.RIGHT:		destX = this.x + 40; break;
				case Setting.LEFT:		destX = this.x - 40; break;	
				case Setting.UP:		destY = this.y - 40; break;
				case Setting.DOWN:		destY = this.y + 40; break;
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