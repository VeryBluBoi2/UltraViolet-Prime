package com.clip
{
	import com.game.common.App;
	import com.game.common.Setting;
	
	import flash.display.MovieClip;	
	import flash.events.Event;
		
	/**
	 * @author Adhi
	 */
	public class clone extends MovieClip{
		protected var isRunning:Boolean = false;
		protected var destX:int			= 0;
		protected var destY:int			= 0;
		protected var dir:uint			= 0;
		protected var mDir:uint			= 0;
		
		protected var speed:uint		= Setting.gameSpeed;
		protected var turn:int			= 0;
		protected var moveStep:Number	= Setting.cloneMove;
		
		protected var removeCount:int	= -1;
		
		public function initClone(px:int, py:int, pd:int):void {
			if (pd == -1) pd = Setting.DOWN;
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			dir 	= pd;
			x 		= px;
			y 		= py;
			destX 	= x;
			destY 	= y;
			doCekMove();

			removeCount = Setting.removeClone;
		}
		
		protected function onRemoved(e:Event):void {
			uninitClone();
			App.GetInstance().mCloneman.NullifiedClone();
			App.GetInstance().mMap.DoCleanUpClone();
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
		public function uninitClone():void {
		}
		
		public function onTimer():void {
			if (removeCount > 0) {
				removeCount--;
				if (removeCount == 0){
					RemoveClone();
					return;
				}
			}
			DoMove();
		}
		
		public function RemoveClone():void {
			App.GetInstance().mMap.DoRemoveObject(this);
		}
		
		protected function DoMove():void {
			if (App.GetInstance().gameState != Setting.STATE_START) return;
			if (destX != x || destY != y) {
				switch(dir) {
					case Setting.UP:						
						if (currentLabel != "up") gotoAndStop("up");
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
			}else{
				doCekMove();
			}
		}
		
		protected function doCekMove():void {
			var posX:int = Math.floor(this.x / 40);
			var posY:int = Math.floor(this.y / 40);
			
			App.GetInstance().mPlayerMove[posY][posX] = Setting.cloneStep;
			
			switch(dir) {
				case Setting.UP:	cekUp(posX,posY); 	break;
				case Setting.DOWN:	cekDown(posX,posY); break;
				case Setting.LEFT: 	cekLeft(posX,posY); break;
				case Setting.RIGHT: cekRight(posX,posY); break;
			}
		}
		
		protected function changeDirection(): void {
			turn++;
			if (turn >= 4) {
				RemoveClone();
				return;
			}
			dir ++;
			dir %= 4;
			if (dir == mDir) {
				changeDirection();
			}else{
				doCekMove();
			}
		}
		
		protected function cekUp(posX:int,posY:int):void {
			if (posY <= 0) {
				changeDirection();
				return;
			}
			var code:int = parseInt(App.GetInstance().mCodeArray[posY-1][posX]);
			if (isNaN(code)) code = 0;
			if (code == 0) {
				turn = 0;
				dir = Setting.UP;
				mDir = Setting.DOWN;
				destX = posX * 40;
				destY = (posY-1) * 40;
			}else {
				if (code == 5 && turn == 0) App.GetInstance().mMap.PushBox(posX, posY - 1, Setting.UP);
				changeDirection();
			}
		}
		
		protected function cekDown(posX:int,posY:int):void {
			var posX:int = Math.floor(this.x / 40);
			var posY:int = Math.floor(this.y / 40);
			if (posY >= App.GetInstance().mHeight - 1) {
				changeDirection();
				return;
			}
			var code:int = parseInt(App.GetInstance().mCodeArray[posY + 1][posX]);
			if (isNaN(code)) code = 0;
			if (code == 0) {
				turn = 0;
				dir = Setting.DOWN;
				mDir = Setting.UP;
				destX = posX * 40;
				destY = (posY+1) * 40;
			}else {
				if (code == 5 && turn == 0) App.GetInstance().mMap.PushBox(posX, posY + 1, Setting.DOWN);
				changeDirection();
			}
		}
		
		protected function cekLeft(posX:int,posY:int):void {
			var posX:int = Math.floor(this.x / 40);
			var posY:int = Math.floor(this.y / 40);
			if (posX <= 0) {
				changeDirection();
				return;
			}
			var code:int = parseInt(App.GetInstance().mCodeArray[posY][posX-1]);
			if (isNaN(code)) code = 0;
			if (code == 0) {
				turn = 0;
				dir = Setting.LEFT;
				mDir = Setting.RIGHT;
				destX = (posX-1) * 40;
				destY = posY * 40;
			}else {
				if (code == 5 && turn == 0) App.GetInstance().mMap.PushBox(posX - 1, posY, Setting.LEFT);
				changeDirection();
			}
		}
		
		protected function cekRight(posX:int,posY:int):void {
			var posX:int = Math.floor(this.x / 40);
			var posY:int = Math.floor(this.y / 40);
			if (posX >= App.GetInstance().mWidth - 1) {
				changeDirection();
				return;
			}
			var code:int = parseInt(App.GetInstance().mCodeArray[posY][posX+1]);
			if (isNaN(code)) code = 0;
			if (code == 0) {
				turn = 0;
				dir = Setting.RIGHT;
				mDir = Setting.LEFT;
				destX = (posX+1) * 40;
				destY = posY * 40;
			}else {
				if (code == 5 && turn == 0) App.GetInstance().mMap.PushBox(posX + 1, posY, Setting.RIGHT);
				changeDirection();
			}
		}
		
		public function CloneHit(posX:int, posY:int):Boolean {
			var mPosX:int = Math.floor(this.x / 40);
			var mPosY:int = Math.floor(this.y / 40);
			if (mPosX == posX && mPosY == posY) return true;
			return false;
		}
		
	}
	
}