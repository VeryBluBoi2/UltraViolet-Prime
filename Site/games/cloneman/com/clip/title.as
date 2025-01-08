package com.clip
{	
	import com.game.common.App;
	import com.game.common.Setting;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * @author Adhi
	 */
	public class title extends MovieClip{
		public function title():void {
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
		protected function onAdded(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			this["btn_start"].addEventListener(MouseEvent.CLICK, onStartClick);
			this["btn_credit"].addEventListener(MouseEvent.CLICK, onCreditClick);
			this["btn_option"].addEventListener(MouseEvent.CLICK, onOptionClick);
		}
		
		protected function onRemoved(e:Event):void {
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			this["btn_start"].removeEventListener(MouseEvent.CLICK, onStartClick);
			this["btn_credit"].removeEventListener(MouseEvent.CLICK, onCreditClick);
			this["btn_option"].addEventListener(MouseEvent.CLICK, onOptionClick);
		}
		
		protected function onStartClick(e:MouseEvent):void {
			App.GetInstance().mSound.PlaySound("sendClone", this.name);
			/* speeding purpose
			App.GetInstance().mMain.EnterStage(Setting.defaultLevel);
			//*/
			//*
			App.GetInstance().mMain.CreateLevelScreen();
			//*/
		}
		
		protected function onCreditClick(e:MouseEvent):void {
			App.GetInstance().mSound.PlaySound("sendClone", this.name);
			App.GetInstance().mMain.CreateCreditScreen();
		}
		
		protected function onOptionClick(e:MouseEvent):void {
			App.GetInstance().mMain.CreateOptionScreen();
		}
		
	}
	
}