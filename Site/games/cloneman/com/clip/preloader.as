package com.clip {

	import com.game.common.App;
	
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	
	public class preloader extends MovieClip {		
		var mMove:MovieClip;
		var mLoadInfo:LoaderInfo;
		
		protected var startLoad:int = 240;
		protected var longLoad:int	= 160;
		
		public function preloader() {
			mMove = this["mc"];
		}
		
		public function initLoader(mloader:LoaderInfo):void {
			mLoadInfo = mloader;
			mLoadInfo.addEventListener(ProgressEvent.PROGRESS, onLoading);
			mLoadInfo.addEventListener(Event.COMPLETE, onComplete);
		}
		
		protected function onLoading(evt:ProgressEvent):void {
			var loaded:Number = evt.bytesLoaded / evt.bytesTotal; 
			txt_load.text = (loaded * 100).toFixed(0) + "%";
			mc.x = startLoad + (loaded * longLoad);
		}

		protected function onComplete(event:Event):void { 
			mLoadInfo.removeEventListener(ProgressEvent.PROGRESS, onLoading);
			mLoadInfo.removeEventListener(Event.COMPLETE, onComplete);
			App.GetInstance().mMain.gotoAndStop(2);
		}
	}
	
}
