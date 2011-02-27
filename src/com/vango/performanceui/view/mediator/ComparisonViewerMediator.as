package com.vango.performanceui.view.mediator
{
	import com.vango.performance.vo.TestComparisonSet;
	import com.vango.performance.vo.TestResultSet;
	import com.vango.performanceui.controller.signals.ComparisonsUpdatedSignal;
	import com.vango.performanceui.controller.signals.TestResultSetSignal;
	import com.vango.performanceui.view.display.ComparisonViewer;

	import org.robotlegs.mvcs.Mediator;


	/**
	 * @author James
	 */
	public class ComparisonViewerMediator extends Mediator
	{
		//{	Properties
		
		[Inject]
		public var comparisonsUpdatedSignal:ComparisonsUpdatedSignal;
		[Inject]
		public var testSelectedSignal:TestResultSetSignal;
		
		//}
		
		//{	Fields
		
		/**
		 * The typed view component
		 */
		private function get comparisonsViewer():ComparisonViewer
		{
			return viewComponent as ComparisonViewer;
		}
		
		//}
		
		//{	Public Methods
		
		/**
		 * Called on mediator registration
		 */
		override public function onRegister():void
		{
			comparisonsUpdatedSignal.add(onComparisonUpdate);
			testSelectedSignal.add(onTestSelected);
		}
		
		//}
		
		//{	Handlers
		
		/**
		 * Handles test selection
		 */
		private function onTestSelected(resultSet:TestResultSet):void
		{
			comparisonsViewer.setResult(resultSet.testId);
		}
		
		/**
		 * Handles test results being set
		 */
		private function onComparisonUpdate(comparisonSet:TestComparisonSet):void
		{
			comparisonsViewer.setData(comparisonSet);
		}
		
		//}
	}
}
