package com.vango.performanceui.view.mediator
{
	import com.vango.performance.vo.TestResultSet;
	import com.vango.performanceui.controller.signals.AddComparisonSignal;
	import com.vango.performanceui.controller.signals.RemoveComparisonSignal;
	import com.vango.performanceui.controller.signals.ShowTestResultsSignal;
	import com.vango.performanceui.controller.signals.TestResultSetSignal;
	import com.vango.performanceui.view.display.ComparisonRenderer;

	import org.robotlegs.mvcs.Mediator;


	/**
	 * @author James
	 */
	public class ComparisonRendererMediator extends Mediator
	{
		//{	Properties
		
		[Inject]
		public var showTestResultsSignal:ShowTestResultsSignal;
		[Inject]
		public var testResultsSetSignal:TestResultSetSignal;
		[Inject]
		public var removeComparisonSignal:RemoveComparisonSignal;
		[Inject]
		public var addComparisonSignal:AddComparisonSignal;
		
		//}
		
		//{	Fields
		
		/**
		 * The typed view component
		 */
		private function get comparisonRenderer():ComparisonRenderer
		{
			return viewComponent as ComparisonRenderer;
		}
		
		//}
		
		//{	Public Methods
		
		/**
		 * Called on mediator registration
		 */
		override public function onRegister():void
		{
			comparisonRenderer.selectTestSignal.add(onViewSelect);
			comparisonRenderer.compareSignal.add(onCompareSelect);
			testResultsSetSignal.add(onTestResultsSet);
		}
		
		/**
		 * Called on mediator removed
		 */
		override public function onRemove():void
		{
			comparisonRenderer.selectTestSignal.remove(onViewSelect);
			comparisonRenderer.compareSignal.remove(onCompareSelect);
			testResultsSetSignal.remove(onTestResultsSet);
		}
		
		//}
		
		//{	Handlers
		
		/**
		 * Handles view select
		 */
		private function onViewSelect():void
		{
			showTestResultsSignal.dispatch(comparisonRenderer.id);
		}
		
		/**
		 * Handles comparison select
		 */
		private function onCompareSelect(compare:Boolean):void
		{
			if (compare) addComparisonSignal.dispatch(comparisonRenderer.id);
			else removeComparisonSignal.dispatch(comparisonRenderer.id);
		}
		
		/**
		 * Handles test results being set
		 */
		private function onTestResultsSet(resultSet:TestResultSet):void
		{
			if (resultSet.testId == comparisonRenderer.id) comparisonRenderer.select();
			else comparisonRenderer.deselect();
		}
		
		//}
	}
}
