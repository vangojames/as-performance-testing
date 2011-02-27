package com.vango.performanceui.controller.commands
{
	import com.vango.performanceui.view.display.AppLayoutController;

	import org.robotlegs.mvcs.SignalCommand;

	/**
	 * @author James
	 */
	public class StartupCommand extends SignalCommand
	{
		//{	Public Methods
		
		/**
		 * Executes the command
		 */
		override public function execute():void
		{
			// create and add the app layout controller
			var appLayout:AppLayoutController = new AppLayoutController();
			contextView.addChild(appLayout);
		}
		
		//}
	}
}
