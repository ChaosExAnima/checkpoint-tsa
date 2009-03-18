package gameSound {
 
	import gameSound.SoundObject;
	import flash.net.SharedObject;



	// has an array of SoundObjects plus 1 SoundObject for music
	
	public class SoundManager
    {
		var m_soundArray:Array = new Array();	
		var m_music:SoundObject;
		var m_bMute:Boolean = false;
		var m_musicLevel:int;
		
		public function SoundManager()
		{
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
			
		}
		
		public function	getMute():Boolean{ return m_bMute;}
		public function	toggleMute():Boolean { setMute(!m_bMute); return m_bMute;}
		public function setMute(bMute:Boolean)
		{ 
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
		
		public function setMusic(filename:String)
		{
			if(m_music)
				m_music.transitionMusic(filename);
			else
			{
				m_music = new SoundObject(filename, this, true);
				m_music.setSoundLevel(m_musicLevel);
			}
		}
		
		// volume ranges from 0 (silent) to 100 (full volume)
		public function getMusicVolume():int { return m_musicLevel;}
		
		// volume ranges from 0 (silent) to 100 (full volume)
		public function setMusicVolume(sndlevel:int) 
		{
			m_musicLevel = sndlevel
			m_music.setSoundLevel(sndlevel);
			
			
			var so:SharedObject = SharedObject.getLocal("music");
			so.data.musicLevel = m_musicLevel;
				
		}
		
		
		public function deleteSound(obj:SoundObject)
		{
			var tmpArray:Array = new Array();
			while(m_soundArray.length)
			{
				var object = m_soundArray.pop();
				if(object != obj)
					tmpArray.push(object);
			}
			
			m_soundArray = tmpArray;
		}
		

	}
	
	
	
}