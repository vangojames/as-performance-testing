package com.vango.performanceui.view.mediator
{
	import com.vango.performance.vo.TestResultSet;
	import com.vango.performanceui.controller.signals.TestResultSetSignal;
	import com.vango.performanceui.view.display.ResultsViewer;

	import org.robotlegs.mvcs.Mediator;


	/**
	 * @author James
	 */
	public class ResultsViewerMediator extends Mediator
	{
		//{	Properties
		
		[Inject]
		public var testResultsSetSignal:TestResultSetSignal;
		
		//}
		
		//{	Fields
		
		/**
		 * The typed view component
		 */
		private function get resultsViewer():ResultsViewer
		{
			return viewComponent as ResultsViewer;
		}
		
		//}
		
		//{	Public Methods
		
		/**
		 * Called on mediator registration
		 */
		override public function onRegister():void
		{
			testResultsSetSignal.add(onTestResultsSet);
		}
		
		//}
		
		//{	Handlers
		
		/**
		 * Handles test results being set
		 */
		private function onTestResultsSet(resultSet:TestResultSet):void
		{
			resultsViewer.setData(resultSet);
		}
		
		//}
	}
}
