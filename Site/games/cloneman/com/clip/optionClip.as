package com.clip 
{
	import com.game.common.App;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Adhi
	 */
	public class optionClip extends MovieClip{
		public function optionClip():void {
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected function onAdded(e:Event):void {
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			this["mc_sound"].buttonMode = true;
			this["mc_sound"].addEventListener(MouseEvent.CLICK, onSoundClicked);
			if (App.GetInstance().useSound) {
				this["mc_sound"].gotoAndStop("on");
			}else {
				this["mc_sound"].gotoAndStop("off");
			}
			this["mc_music"].buttonMode = true;
			this["mc_music"].addEventListener(MouseEvent.CLICK, onMusicClicked);
			if (App.GetInstance().useMusic) {
				this["mc_music"].gotoAndStop("on");
			}else {
				this["mc_music"].gotoAndStop("off");
			}
			this["btn_back"].addEventListener(MouseEvent.CLICK, onBack);
		}
		
		protected function onRemoved(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			this["mc_sound"].removeEventListener(MouseEvent.CLICK, onSoundClicked);
			this["mc_music"].removeEventListener(MouseEvent.CLICK, onMusicClicked);
		}
		
		protected function onSoundClicked(e:MouseEvent):void {
			if (App.GetInstance().useSound) {
				App.GetInstance().useSound = false;
				this["mc_sound"].gotoAndPlay("turnoff");
			}else {
				App.GetInstance().useSound = true;
				this["mc_sound"].gotoAndPlay("turnon");
			}
			App.GetInstance().mSound.ToogleSound();
		}
		
		protected function onMusicClicked(e:MouseEvent):void {
			if (App.GetInstance().useMusic) {
				App.GetInstance().useMusic = false;
				this["mc_music"].gotoAndPlay("turnoff");
			}else {
				App.GetInstance().useMusic = true;
				this["mc_music"].gotoAndPlay("turnon");
			}
			App.GetInstance().mSound.ToogleMusic();
		}
		
		protected function onBack(e:MouseEvent):void {
			App.GetInstance().mMain.ReturnToTitle(this);
		}
		
	}
	
}