package com.vango.performanceui.controller.commands
{
	import com.vango.performanceui.model.proxies.TestBedProxy;

	import org.robotlegs.mvcs.SignalCommand;

	/**
	 * @author James
	 */
	public class ShowTestResultsCommand extends SignalCommand
	{
		//{	Properties
		
		[Inject]
		public var id:int;
		[Inject]
		public var testBedProxy:TestBedProxy;
		
		//}
		
		//{	Public Methods
		
		/**
		 * Executes the command
		 */
		override public function execute():void
		{
			testBedProxy.setActiveTestResult(id);
		}
		
		//}
	}
}
