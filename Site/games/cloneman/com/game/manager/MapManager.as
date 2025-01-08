package com.game.manager
{
	import com.game.common.App;
	import com.game.common.Setting;

	import com.clip.box1;
	import com.clip.box2;
	import com.clip.cloneman;
	import com.clip.enemy;
	import com.clip.enemy1;
	import com.clip.moveableBox;
	import com.clip.box_pos;
	import com.clip.trap1;
	import com.clip.finish;
	import com.clip.door;
	import com.clip.key;
	import com.clip.switchWall;
	import com.clip.trap2;
	import com.clip.robot1;
	import com.clip.robot2;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * @author ACL
	 */
	public class MapManager{
		
		protected var cGround:MovieClip;
		protected var cObject:MovieClip;
		protected var cStage:MovieClip;
		
		protected var cTimer:Timer;
		protected var enemyArr:Array;
		protected var objectArr:Array;
		
		protected var updateMapCount:int = -1;
		
		protected var MAPCOUNT:int = 10;
		
		public function startUpdater():void {
			cTimer = new Timer(Setting.gameSpeed);
			cTimer.addEventListener(TimerEvent.TIMER, onTimer);
			cTimer.start();
			
			updateMapCount = MAPCOUNT;
		}
		
		public function stopUpdater():void {
			cTimer.stop();
			cTimer.removeEventListener(TimerEvent.TIMER, onTimer);
			cTimer = null;
		}
		
		protected function onTimer(e:TimerEvent):void {
			UpdateObject();
		}
		
		protected function UpdateObject():void {
			if (App.GetInstance().mCloneman != null)
				App.GetInstance().mCloneman.onTimer();
				
			for (var e:int = 0; e < enemyArr.length; e++) {
				enemyArr[e].onTimer();
			}
			for (var i:int = 0; i < objectArr.length; i++) {
				objectArr[i].onTimer();
			}
			
			if (updateMapCount > 0) {
				updateMapCount--;
				if (updateMapCount == 0) {
					UpdatePlayerMovement();
					updateMapCount = MAPCOUNT;
				}
			}
		}
		
		protected function getObject(code:String,cRow:int,cCol:int):void {
			switch(code) {
				case "1":
					var sb:box1 = new box1();
					sb.x = cCol * 40;
					sb.y = cRow * 40;
					cGround.addChild(sb);
					break;
				case "2":
					var sb2:box2 = new box2();
					sb2.x = cCol * 40;
					sb2.y = cRow * 40;
					cGround.addChild(sb2);
					break;
				case "3":
					var bx:moveableBox = new moveableBox();
					bx.InitBox(cCol, cRow);
					cGround.addChild(bx);
					objectArr.push(bx);
					break;
				case "4":
					var ndoor:door = new door();
					ndoor.x = cCol * 40;
					ndoor.y = cRow * 40;
					cGround.addChild(ndoor);
					objectArr.push(ndoor);
					break;
				case "5":
					var nswitch:switchWall = new switchWall();
					nswitch.x = cCol * 40;
					nswitch.y = cRow * 40;
					cGround.addChild(nswitch);
					objectArr.push(nswitch);
					break;

				case "P":
					var mc:cloneman = new cloneman();
					mc.initCloneMan();
					mc.x = cCol * 40;
					mc.y = cRow * 40;
					App.GetInstance().mCloneman = mc;
					cObject.addChildAt(mc,0);
					break;
				case "F":
					var fn:MovieClip = new finish();
					fn.x = cCol * 40;
					fn.y = cRow * 40;
					cGround.addChild(fn);
					break;
				case "E":
					var en:enemy = new enemy1();
					en.initEnemy(cCol,cRow);
					cObject.addChild(en);
					enemyArr.push(en);
					break;
				case "T":
					var turret:robot1 = new robot1();
					turret.initEnemy(cCol, cRow);
					cObject.addChild(turret);
					enemyArr.push(turret);
					break;
				case "R":
					var rb:robot2 = new robot2();
					rb.initEnemy(cCol,cRow);
					cObject.addChild(rb);
					enemyArr.push(rb);
					break;
					
				case "t":
					var thorn:trap1 = new trap1();
					thorn.InitTrap(cCol, cRow);
					cGround.addChild(thorn);
					objectArr.push(thorn);
					break;
				case "k":
					var nkey:key = new key();
					nkey.x = cCol * 40;
					nkey.y = cRow * 40;
					cGround.addChild(nkey);
					objectArr.push(nkey);
					break;
				case "s":
					var ntrap2:trap2 = new trap2();
					ntrap2.InitTrap(cCol, cRow);
					cGround.addChild(ntrap2);
					objectArr.push(ntrap2);
					break;
					
			}
		}
		
		public function CreateMap(batchMap:String):MovieClip {
			enemyArr = new Array();
			objectArr = new Array();
			
			var mStage:MovieClip = new MovieClip();
			var mGround:MovieClip = new MovieClip();
			var mObject:MovieClip = new MovieClip();
			mStage.addChild(mGround);
			mStage.addChild(mObject);

			cGround = mGround;
			cObject	= mObject;

			var mapArray:Array 	= batchMap.split("\n");
			var height:int		= mapArray.length;
			var width:int		= mapArray[0].split(",").length;

			App.GetInstance().mCodeArray 	= new Array();
			App.GetInstance().mWidth		= width;
			App.GetInstance().mHeight		= height;
			App.GetInstance().mPlayerMove	= new Array();
			
			for (var i:int = 0; i < height; i++) {
				var mapCode:Array = mapArray[i].split(",");
				var row:Array = new Array();
				App.GetInstance().mCodeArray.push(mapCode);
				
				for (var j:int = 0; j < width; j++) {
					row.push(0);
					var code:String = mapCode[j];
					var ob:DisplayObject = null;

					getObject(code,i,j);

				}
				
				App.GetInstance().mPlayerMove.push(row);
			}
			
			mStage.x -= 2;
			mStage.y = -2;
			
			cStage = mStage;
			
			focusCamera();
			
			return mStage;
		}
		
		public function UpdatePlayerMovement():void {
			for (var i:int = 0; i < App.GetInstance().mHeight; i++) {
				for (var j:int = 0; j < App.GetInstance().mWidth; j++) {
					if (App.GetInstance().mPlayerMove[i][j] != 0) {
						if (App.GetInstance().mPlayerMove[i][j] > 0) {
							App.GetInstance().mPlayerMove[i][j] --;
							if (App.GetInstance().mPlayerMove[i][j] == 0 || App.GetInstance().mPlayerMove[i][j] == 10) {
								App.GetInstance().mPlayerMove[i][j] = 0;
								/*
								var r:MovieClip = MovieClip(cGround.getChildByName("box_" + i + "_" + j));
								if (r != null) {
									cGround.removeChild(r);
								}
								
							}else {
								
								if (cGround.getChildByName("box_" + i + "_" + j) == null) {
									var c:MovieClip = new box_pos();
									c.name = "box_" + i + "_" + j;
									c.x = j * 40;
									c.y = i * 40;
									cGround.addChild(c);
								}*/
							}						
						}else {
							App.GetInstance().mPlayerMove[i][j] = 0;
						}
					}
				}
			}
		}
		
		public function DoAddObject(ob:MovieClip):void {
			cObject.addChild(ob);
		}
		
		public function DoRemoveObject(ob:MovieClip):void {
			try{
			cObject.removeChild(ob);
			}catch (e:Error) { }
		}
		
		public function DoRemoveGround(ob:MovieClip):void {
			try{
			cGround.removeChild(ob);
			}catch (e:Error) { }
		}
		
		public function DoCleanUpClone():void {
			for (var i:int = 0; i < App.GetInstance().mHeight; i++) {
				for (var j:int = 0; j < App.GetInstance().mWidth; j++) {
					if (App.GetInstance().mPlayerMove[i][j] > 10) {
						App.GetInstance().mPlayerMove[i][j] = 0;
						//var r:MovieClip = MovieClip(cGround.getChildByName("box_" + i + "_" + j));
						//if (r != null) cGround.removeChild(r);
					}					
				}
			}
		}
		
		public function DoCleanUpAll():void {
			for (var i:int = 0; i < App.GetInstance().mHeight; i++) {
				for (var j:int = 0; j < App.GetInstance().mWidth; j++) {
					if (App.GetInstance().mPlayerMove[i][j] > 0) {
						App.GetInstance().mPlayerMove[i][j] = 0;
						//var r:MovieClip = MovieClip(cGround.getChildByName("box_" + i + "_" + j));
						//if (r != null) cGround.removeChild(r);
					}					
				}
			}
		}
		
		public function CheckHitPlayerAndClone(posX:int,posY:int):Boolean {
			if (App.GetInstance().mCloneman.PlayerHit(posX,posY)) {
				App.GetInstance().mCloneman.DoDie();
				DoCleanUpAll();
				return true;
			}else if (App.GetInstance().mCloneman.CloneHit(posX, posY)) {
				App.GetInstance().mCloneman.removeClone();
				return true;
			}
			return false;
		}
		
		public function CheckHitWinning(posX:int, posY:int):Boolean {
			if (App.GetInstance().mCodeArray[posY][posX] == "F")
				return true;
			return false;
		}
		
		public function DoEnd():void {
			for (var i:int = 0; i < enemyArr.length; i++) {
				(enemyArr[i] as enemy).uninitEnemy();
			}
		}
		
		public function PushBox(posX:int, posY:int, pd:int):Boolean {
			for (var i:int = 0; i < objectArr.length; i++) {
				if (objectArr[i].PushMe(posX, posY)) {
					objectArr[i].PushBox(pd);
					return true;
				}
			}
			return false;
		}
		
		public function CheckHitTrap(posX:int, posY:int):Boolean {
			//trace("check hit trap " + posX + " " + posY);
			for (var i:int = 0; i < objectArr.length; i++) {
				if (objectArr[i].ActivateMe(posX, posY)) {
					objectArr[i].DoActivate();
					return true;
				}
			}
			return false;
		}
		
		public function ActivateAllTrap():Boolean {
			for (var i:int = 0; i < objectArr.length; i++) {
				if (objectArr[i].DoAutoActivate()) {
					var posX:int = Math.floor(objectArr[i].x / 40);
					var posY:int = Math.floor(objectArr[i].y / 40);
					var type:String = objectArr[i].type;
					for (var j:int = 0; j < enemyArr.length; j++) {
						if (enemyArr[j].IsHit(posX, posY, type))
							enemyArr[j].DoDie();
					}
					if (App.GetInstance().mCloneman.IsHit(posX, posY)) App.GetInstance().mCloneman.DoDie();
				}
			}
			return false;
		}
		
		public function CheckHitItems(posX:int, posY:int):Boolean {
			//trace("check hit items " + posX + " " + posY);
			for (var i:int = 0; i < objectArr.length; i++) {
				if (objectArr[i].HitMe(posX, posY)) {
					objectArr[i].DoGet();
					return true;
				}
			}
			return false;
		}
		
		public function CheckHitEnemy(posY:int, posX:int, pd:int):Boolean {
			//trace("check hit enemy");
			for (var i:int = 0; i < enemyArr.length; i++) {
				if (enemyArr[i].IsHit(posX, posY)) {
					if (enemyArr[i].DoPush(pd)) {
						//trace('return true');
						return true;
					}else {
						//trace('return false');
						return false;
					}
				}
			}
			return false;
		}
		
		public function focusCamera():void {
			if (App.GetInstance().mCloneman == null) return;
			var playerX:int = App.GetInstance().mCloneman.x;
			var playerY:int = App.GetInstance().mCloneman.y;
			var posMapX:int = playerX - 400;
			posMapX = (posMapX < 0)?0:
				(((posMapX + 800) > ((App.GetInstance().mWidth) * 40))?((App.GetInstance().mWidth) * 40) - 800:posMapX);
			var posMapY:int = playerY - 300;
			posMapY = (posMapY < 0)?0:
				(((posMapY + 600) > ((App.GetInstance().mHeight - 1) * 40))?((App.GetInstance().mHeight - 1) * 40) - 600:posMapY);
			cStage.x = (posMapX * -1) -2;
			cStage.y = (posMapY * -1) -2;
		}
		
	}
	
}