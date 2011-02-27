package com.vango.performanceui.controller.commands
{
	import com.vango.performanceui.model.proxies.ComparisonProxy;

	import org.robotlegs.mvcs.SignalCommand;

	/**
	 * @author James
	 */
	public class RemoveComparisonCommand extends SignalCommand
	{
		//{	Properties
		
		[Inject]
		public var testId:int;
		[Inject]
		public var comparisonProxy:ComparisonProxy;
		
		//}
		
		//{	Public Methods
		
		/**
		 * Executes the command
		 */
		override public function execute():void
		{
			comparisonProxy.removeComparison(testId);
		}
		
		//}
	}
}
