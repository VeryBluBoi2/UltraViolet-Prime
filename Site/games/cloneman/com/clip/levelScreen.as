package com.clip
{
	import com.game.common.App;
	import com.game.common.Setting;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import fl.containers.ScrollPane;
	/**
	 * @author Adhi
	 */
	public class levelScreen extends MovieClip 
	{
		public function levelScreen():void {
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected function onAdded(e:Event):void {
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			for (var i:int = 0; i < Setting.maxLevel; i ++) {
				var newButton:MovieClip = new levelSelection();
				newButton.x = 10 + (i % 3) * 200;
				newButton.y = 5 + Math.floor(i / 3) * 120;
				newButton.name = "btn_level_" + (i + 1);
				newButton["txt_level"].text = "Puzzle " + (i + 1);
				newButton["txt_desc"].text = App.GetInstance().mLevel.introText[i + 1];
				newButton["mcSolved"].visible = App.GetInstance().mData.puzzleSolved[i + 1];
				newButton.addEventListener(MouseEvent.CLICK, onClicked);
				this["mcContent"].addChild(newButton);
			}
			this["mcScroll"].source = this["mcContent"];
			this["mcScroll"].refreshPane();
			this["btn_back"].addEventListener(MouseEvent.CLICK, onBack);
		}
		
		protected function onRemoved(e:Event):void {
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			this["btn_back"].removeEventListener(MouseEvent.CLICK, onBack);
		}

		protected function onClicked(e:MouseEvent):void {
			App.GetInstance().mSound.PlaySound("sendClone", this.name);
			var level:int = parseInt(e.currentTarget.name.split("_")[2]);
			App.GetInstance().mMain.EnterStage(level);
		}
		
		protected function onBack(e:MouseEvent):void {
			App.GetInstance().mSound.PlaySound("sendClone", this.name);
			App.GetInstance().mMain.ReturnToTitle(this);
		}
	}
	
}