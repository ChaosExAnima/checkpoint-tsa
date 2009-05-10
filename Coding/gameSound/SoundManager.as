package gameSound {
 
	import gameSound.SoundObject;
	import gameControl.TheGame;
	import flash.net.SharedObject;
	import flash.events.TimerEvent;



	// has an array of SoundObjects plus 1 SoundObject for music
	
	public class SoundManager
    {
		private var m_soundArray:Array = new Array();	
		private var m_music:SoundObject;
		private var m_bMute:Boolean = false;
		private var m_musicLevel:int;
		private var _musicCurrent:String;
		private var _musicWaitNum:int = 0;
		private var _musicWaitMax:int = 10;
		private var _musicOverride:Boolean = false;
		private var _musicTransition:Boolean = false;
		public static const MUSIC_TRACK1:String = "sounds/music/Music_Track1.mp3";
		public static const MUSIC_TRACK2:String = "sounds/music/Music_Track2.mp3";
		public static const MUSIC_TRACK3:String = "sounds/music/Music_Track3.mp3";
		public static const MUSIC_SAD:String = "sounds/music/Music_Sad.mp3";
		public static const MUSIC_HAPPY:String = "sounds/music/Music_Happy.mp3";
		public static const MUSIC_HOTCOLD:String = "sounds/music/Music_HotCold.mp3";
		
		public function SoundManager():void {
			var so:SharedObject = SharedObject.getLocal("mute");
			if(!so.size)
			{
				// trace("create quality");
				so.data.mute = 0;
				m_bMute = 1 == so.data.mute;
			}
			else
			{
				m_bMute = so.data.mute == 1;
			}			
			
			so = SharedObject.getLocal("music");
			if(!so.size)
			{
				// trace("create quality");
				so.data.musicLevel = 75;
				m_musicLevel = 75;
			}
			else
			{
				m_musicLevel = so.data.musicLevel;
			}		
			
			TheGame.getGameTik().addEventListener(TimerEvent.TIMER, musicCheck);
			setMusic(MUSIC_TRACK1, false);
			_musicCurrent = MUSIC_TRACK1;
		}
		
		public function	getMute():Boolean {
			return m_bMute;
		}
		
		public function	toggleMute():Boolean { 
			setMute(!m_bMute); 
			return m_bMute;
		}
		
		public function setMute(bMute:Boolean):void { 
			m_bMute = bMute; 
			var so:SharedObject = SharedObject.getLocal("mute");
			so.data.mute = m_bMute == 1;
		}
		
		
		public function playSound(filename:String, loop:Boolean = false, vol:int = 100):SoundObject
		{
			if(m_bMute) {
				return (null);
			}
			var sound:SoundObject = new SoundObject(filename, this, loop);
			sound.setSoundLevel(vol);
			m_soundArray.push(sound);
			return(sound);
		}
		
		public function setMusic(filename:String, loop=true):void
		{
			if(m_music)
				m_music.transitionMusic(filename);
			else
			{
				m_music = new SoundObject(filename, this, loop, m_musicLevel);
				m_music.setSoundLevel(m_musicLevel);
			}
		}
		
		// volume ranges from 0 (silent) to 100 (full volume)
		public function getMusicVolume():int { 
			return m_musicLevel;
		}
		
		// volume ranges from 0 (silent) to 100 (full volume)
		public function setMusicVolume(sndlevel:int) 
		{
			m_musicLevel = sndlevel;
			m_music.setSoundLevel(sndlevel);
			
			
			var so:SharedObject = SharedObject.getLocal("music");
			so.data.musicLevel = m_musicLevel;
				
		}
		
		
		public function deleteSound(obj:SoundObject)
		{
			var tmpArray:Array = new Array();
			if (obj == m_music) {
				_musicTransition = true;
			} else {
				while(m_soundArray.length)
				{
					var object = m_soundArray.pop();
					if(object != obj)
						tmpArray.push(object);
				}
				
				m_soundArray = tmpArray;
			}
		}
		
		private function musicCheck(e:TimerEvent):void {
			if (!_musicOverride) {
				if (TheGame.getReputation() > 66) {
					if (_musicCurrent != MUSIC_HAPPY) {
						if (_musicWaitNum > _musicWaitMax) {
							setMusic(MUSIC_HAPPY);
							_musicCurrent = MUSIC_HAPPY;
							_musicWaitNum = 0;
						} else {
							_musicWaitNum++;
						}
					}
				} else if (TheGame.getReputation() < 33) {
					if (_musicCurrent != MUSIC_SAD) {
						if (_musicWaitNum > _musicWaitMax) {
							setMusic(MUSIC_SAD);
							_musicCurrent = MUSIC_SAD;
							_musicWaitNum = 0;
						} else {
							_musicWaitNum++;
						}
					}
				} else {
					if (_musicTransition) {
						if (_musicCurrent == MUSIC_TRACK3) {
							setMusic(MUSIC_TRACK1, false);
							_musicCurrent = MUSIC_TRACK1;
						} else if (_musicCurrent == MUSIC_TRACK1) {
							setMusic(MUSIC_TRACK2, false);
							_musicCurrent = MUSIC_TRACK2;
						} else {
							setMusic(MUSIC_TRACK3, false);
							_musicCurrent = MUSIC_TRACK3;
						}
						_musicWaitNum = 0;
					}
				}
			}
		}
	}
	
	
	
}