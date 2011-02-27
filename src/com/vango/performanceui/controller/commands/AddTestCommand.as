package com.vango.performanceui.controller.commands
{
	import com.vango.performanceui.model.proxies.TestBedProxy;

	import org.robotlegs.mvcs.SignalCommand;

	/**
	 * @author James
	 */
	public class AddTestCommand extends SignalCommand
	{
		//{	Properties
		
		[Inject]
		public var testName:String;
		[Inject]
		public var testClass:Class;
		[Inject]
		public var testCount:int;
		[Inject]
		public var testProxy:TestBedProxy;
		
		//}
		
		//{	Public Methods
		
		/**
		 * Executes the command
		 */
		override public function execute():void
		{
			testProxy.addTest(testName, testClass, testCount);
		}
		
		//}
	}
}
