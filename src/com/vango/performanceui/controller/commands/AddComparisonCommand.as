package com.vango.performanceui.controller.commands
{
	import com.vango.performance.vo.TestResultSet;
	import com.vango.performanceui.model.proxies.ComparisonProxy;
	import com.vango.performanceui.model.proxies.TestBedProxy;

	import org.robotlegs.mvcs.SignalCommand;

	/**
	 * @author James
	 */
	public class AddComparisonCommand extends SignalCommand
	{
		//{	Properties
		
		[Inject]
		public var testId:int;
		[Inject]
		public var testBed:TestBedProxy;
		[Inject]
		public var comparisonProxy:ComparisonProxy;
		
		//}
		
		//{	Public Methods
		
		/**
		 * Executes the command
		 */
		override public function execute():void
		{
			var testResultSet:TestResultSet = testBed.getTestResultSet(testId);
			comparisonProxy.addComparison(testResultSet);
		}
		
		//}
	}
}
