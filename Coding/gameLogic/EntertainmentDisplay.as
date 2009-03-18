package gameLogic {
	import gameData.*;
	
	/* Encapsulates an entertainment display. */
	public class EntertainmentDisplay extends MoodUnit {
		
		public function EntertainmentDisplay() {
			super(XMLmachineData.getXML("VideoDisplay","name"),
				  Number(XMLmachineData.getXML("VideoDisplay","accuracy","1")), 
				  Number(XMLmachineData.getXML("VideoDisplay","speed","1")), 
				  Number(XMLmachineData.getXML("VideoDisplay","moodChange","1")), 
				  Number(XMLmachineData.getXML("VideoDisplay","price","1")), 
				  Number(XMLmachineData.getXML("VideoDisplay","sellFor","1")), 
				  [] 
				  );
		}
	}
}