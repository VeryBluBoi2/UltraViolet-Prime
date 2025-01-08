package com.game.manager
{
	import com.game.common.Setting;
	
	import flash.net.SharedObject;
	
	/**
	 * @author Adhi
	 */
	public class DataManager {
		protected var mSO:SharedObject;
		
		public var puzzleSolved:Array = new Array(50);
		
		public function DataManager():void {
			mSO = SharedObject.getLocal("cloneManSaveData");
			for (var i:int = 1; i <= Setting.maxLevel; i++) {
				puzzleSolved[i] = (mSO.data["solved_" + i] == null)?false:mSO.data["solved_" + i];
				//trace(i+" isSolved? "+puzzleSolved[i]);
			}
		}

		public function SolvedPuzzle(level:int):void {
			mSO.data["solved_" + level] = true;
			puzzleSolved[level] = true;
			SaveData();
		}
		
		public function SaveData():void {
			mSO.flush();
		}
	}
	
}