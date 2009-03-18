package gameUI {
	public interface IMenu {
		// Main interface to all menus.
		// Makes sure menus have an init and cleanUp functions!
		
		function init():void;
		function cleanUp():void;
	}
}