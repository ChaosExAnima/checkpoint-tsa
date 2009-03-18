﻿package gameSound {
 
	import flash.media.Sound;
    import flash.media.SoundChannel;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	
	
	public class SoundObject 
    {
		private var m_parent;
		private var m_snd:Sound;
		private var m_channel:SoundChannel;
		private var m_bLoop:Boolean;
		private var m_nextMusicFilename:String;
		private var m_timer:Timer;
		
		
		public function SoundObject(filename:String, myParent, bLoop:Boolean):void
		{
			m_parent = myParent;
			m_bLoop = bLoop;
			
			var req:URLRequest = new URLRequest(filename);
			m_snd = new Sound(req);
			m_channel = m_snd.play();
			m_channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
		}
		
		public function transitionMusic(filename:String):void
		{
			m_nextMusicFilename = filename;
			
			m_timer = new Timer(200, 100);
			m_timer.addEventListener(TimerEvent.TIMER, fadeOut);
			m_timer.start();
			
		}
		
		private function soundCompleteHandler(e:Event):void 
		{
			if(m_bLoop)
			{
				m_channel = m_snd.play();
				m_channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			}
			else
				m_parent.deleteSound(this);
			
		}
		
		public function setSoundLevel(sndlevel:int)
		{
			var transform:SoundTransform = m_channel.soundTransform;
			transform.volume = sndlevel/100;
			m_channel.soundTransform = transform;
		}
		
		private function fadeOut(event:Event)
		{
			var transform:SoundTransform = m_channel.soundTransform;
			
			if(transform.volume <= 0)
			{
				m_timer.stop();
				
				m_bLoop = true;
			
				var req:URLRequest = new URLRequest(m_nextMusicFilename);
				m_snd = new Sound(req);
				m_channel = m_snd.play();
				m_channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			}
			else
			{
				transform.volume -= 0.015;
				m_channel.soundTransform = transform;
			}
		}
	}
	
}