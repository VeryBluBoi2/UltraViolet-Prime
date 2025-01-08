package com.clip
{
	import com.game.common.App;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * @author Adhi
	 */
	public class creditScreen extends MovieClip 
	{
		public function creditScreen():void {
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected function onAdded(e:Event):void {
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			this["btn_back"].addEventListener(MouseEvent.CLICK, onBack);
		}
		
		protected function onRemoved(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			this["btn_back"].removeEventListener(MouseEvent.CLICK, onBack);
		}
		
		protected function onBack(e:MouseEvent):void {
			App.GetInstance().mMain.ReturnToTitle(this);
		}
	}
	
}