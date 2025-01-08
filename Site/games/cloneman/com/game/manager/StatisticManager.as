package com.game.manager
{

	import com.game.common.App;
	import com.game.common.Setting;
	/**
	 * @author Adhi
	 */
	public class StatisticManager {
		public function submitCompletedStatistic():void {
			var totalComplete:int = 0;
			for (var i:int = 1; i <= Setting.maxLevel; i++) {
				if (App.GetInstance().mData.puzzleSolved[i]) totalComplete++;
			}
			if (totalComplete >= 20)
				App.GetInstance().kongregate.stats.submit("Completed 20 puzzles", 1);
			if (totalComplete >= 10)
				App.GetInstance().kongregate.stats.submit("Completed 10 puzzles", 1);
			if (totalComplete > 0)
				App.GetInstance().kongregate.stats.submit("Completed a puzzle", 1);		
		}
		
		public function submitFastestTime(level:int,time:Number):void {
			App.GetInstance().kongregate.stats.submit("Fastest solver puzzle "+level, time);
		}
	}
	
}