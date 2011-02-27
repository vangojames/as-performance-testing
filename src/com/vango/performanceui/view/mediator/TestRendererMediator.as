package com.vango.performanceui.view.mediator
{
	import com.vango.performance.vo.TestComparisonSet;
	import com.vango.performance.vo.TestResultSet;
	import com.vango.performanceui.controller.signals.AddComparisonSignal;
	import com.vango.performanceui.controller.signals.ComparisonsUpdatedSignal;
	import com.vango.performanceui.controller.signals.RemoveComparisonSignal;
	import com.vango.performanceui.controller.signals.ShowTestResultsSignal;
	import com.vango.performanceui.controller.signals.TestProgressSignal;
	import com.vango.performanceui.controller.signals.TestResultSetSignal;
	import com.vango.performanceui.view.display.TestRenderer;

	import org.robotlegs.mvcs.Mediator;


	/**
	 * @author James
	 */
	public class TestRendererMediator extends Mediator
	{
		//{	Properties
		
		[Inject]
		public var testProgressSignal:TestProgressSignal;
		[Inject]
		public var showTestResultsSignal:ShowTestResultsSignal;
		[Inject]
		public var testResultsSetSignal:TestResultSetSignal;
		[Inject]
		public var addComparisonSignal:AddComparisonSignal;
		[Inject]
		public var removeComparisonSignal:RemoveComparisonSignal;
		[Inject]
		public var comparisonUpdateSignal:ComparisonsUpdatedSignal;
		
		//}
		
		//{	Fields
		
		/**
		 * The typed view component
		 */
		private function get testRenderer():TestRenderer
		{
			return viewComponent as TestRenderer;
		}
		
		//}
		
		//{	Public Methods
		
		/**
		 * Called on mediator registration
		 */
		override public function onRegister():void
		{
			testRenderer.selectTestSignal.add(onViewSelect);
			testRenderer.compareSelectSignal.add(onCompareSelect);
			testProgressSignal.add(onTestProgress);
			testResultsSetSignal.add(onTestResultsSet);
			comparisonUpdateSignal.add(onComparisonUpdate);
		}
		
		//}
		
		//{	Handlers
		
		/**
		 * Handles test progress
		 */
		private function onTestProgress(id:int, progress:Number):void
		{
			if(testRenderer.id == id) testRenderer.setProgress(progress);
		}
		
		/**
		 * Handles view select
		 */
		private function onViewSelect():void
		{
			showTestResultsSignal.dispatch(testRenderer.id);
		}
		
		/**
		 * Handles compare select
		 */
		private function onCompareSelect(selected:Boolean):void
		{
			var index:int = testRenderer.id;
			if (selected) addComparisonSignal.dispatch(index);
			else removeComparisonSignal.dispatch(index);
		}
		
		/**
		 * Handles test results being set
		 */
		private function onTestResultsSet(resultSet:TestResultSet):void
		{
			if (resultSet.testId == testRenderer.id) testRenderer.select();
			else testRenderer.deselect();
		}
		
		/**
		 * Handles comparison updates
		 */
		private function onComparisonUpdate(compareSet:TestComparisonSet):void
		{
			var cs:Array = compareSet.tests;
			var isComparing:Boolean = false;
			for each(var testSet:TestResultSet in cs)
				if (testSet.testId == testRenderer.id) isComparing = true;
			testRenderer.isComparing = isComparing;
		}
		
		//}
	}
}
