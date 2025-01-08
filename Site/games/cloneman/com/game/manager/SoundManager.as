package com.game.manager
{
	import com.game.common.App;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.getDefinitionByName;
	
	/**
	 * @author Adhi
	 */
	public class SoundManager 
	{
		var allObjectSound:Object = new Object();
		var loopSoundChannel:SoundChannel = new SoundChannel();
		var loopMusic:Sound;
		var curMusic:String;
		var isChanging:Boolean	= false;
		var lastStop:int		= 0;
		
		public function ClearSound():void {
			for (var i:String in allObjectSound) {
				try{
				if (allObjectSound[i] != null){
					allObjectSound[i] = null;
				}
				}catch(e:Error){}
			}
			allObjectSound = new Object();
		}
		
		public function PlayMusic(name:String):void {
			if (curMusic != name) {
				var ClassSoundRef:Class = getDefinitionByName(name) as Class;
				if (curMusic != "" && loopMusic != null) {
					isChanging = true;
					curMusic = name;
					var isFinishedPlaying = (loopSoundChannel.position >= loopMusic.length);
					if (isFinishedPlaying)	LoopingMusic();
				}else {
					loopMusic = new ClassSoundRef;
					curMusic = name;
					LoopingMusic();
				}
			}
		}
		
		public function ToogleMusic():void {
			if (App.GetInstance().useMusic) {
				LoopingMusic();
			}else{
				lastStop = loopSoundChannel.position;
 				loopSoundChannel.stop();
				loopSoundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}
		}
		
		public function ToogleSound():void {
			if (!App.GetInstance().useSound) {
				for (var i:String in allObjectSound) {
					try{
						StopSound(i);
					}catch (e:Error) {
						
					}
				}
			}
		}
		
		protected function LoopingMusic():void {
			if (isChanging) {
				loopSoundChannel.stop();
				loopSoundChannel = new SoundChannel();
				var ClassSoundRef:Class = getDefinitionByName(curMusic) as Class;
				loopMusic = new ClassSoundRef;
			}
			if (App.GetInstance().useMusic){
				loopSoundChannel = loopMusic.play(lastStop);
				lastStop = 0;
				loopSoundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}
			isChanging = false;
		}
		
		protected function onSoundComplete(e:Event):void {
			loopSoundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			LoopingMusic();
		}
		
		public function StopMusic():void {
			curMusic = "";
			loopSoundChannel.stop();
			loopSoundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
		}
		
		public function PlaySound(type:String, who:String):void {
			var ClassSoundRef:Class;
			var sound:Sound;
			if (!App.GetInstance().useSound) return;
			if (allObjectSound[who] != null) {
				if (allObjectSound[who]["curSoundName"] == type) {
					var channel:SoundChannel = allObjectSound[who]["channel"];
					if (channel.position >= allObjectSound[who]["curLength"]) {
						ClassSoundRef = getDefinitionByName(type) as Class;
						sound = new ClassSoundRef;
						allObjectSound[who]["channel"] = sound.play(0);
					}
				}else {
					ClassSoundRef = getDefinitionByName(type) as Class;
					sound = new ClassSoundRef;
					allObjectSound[who]["channel"].stop();
					allObjectSound[who]["channel"] = sound.play(0);
				}
			}else {
				allObjectSound[who] = new Object();				
				ClassSoundRef = getDefinitionByName(type) as Class;
				sound = new ClassSoundRef;
				allObjectSound[who]["channel"] = new SoundChannel();
				allObjectSound[who]["channel"] = sound.play(0);
				allObjectSound[who]["curSoundName"] = type;
				allObjectSound[who]["curLength"] = sound.length;
			}
		}
		
		public function StopSound(who:String):void {
			if (allObjectSound[who] != null) {
				allObjectSound[who]["channel"].stop();
				allObjectSound[who] = null;
			}
		}
		
	}
	
}