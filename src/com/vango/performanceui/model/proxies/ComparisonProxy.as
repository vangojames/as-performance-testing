package com.vango.performanceui.model.proxies
{
	import com.vango.performance.vo.TestComparisonSet;
	import com.vango.performance.vo.TestResultSet;
	import com.vango.performanceui.controller.signals.ComparisonsUpdatedSignal;

	import org.robotlegs.mvcs.Actor;


	/**
	 * @author James
	 */
	public class ComparisonProxy extends Actor
	{
		//{	Properties
		
		[Inject]
		public var comparisonSetUpdateSignal:ComparisonsUpdatedSignal;
		
		//}
		
		//{	Fields
		
		private var _comparisonList:Array = [];
		private var _testComparisonSet:TestComparisonSet = new TestComparisonSet();
		
		//}
		
		//{	Public Methods
		
		/**
		 * Adds a result set for comparing
		 */
		public function addComparison(resultSet:TestResultSet):void
		{
			var i:int = getResultIndex(resultSet.testId);
			// if result already exists then  remove it
			if (i >= 0) _comparisonList.splice(i, 1);
			// now push result set
			_comparisonList.push(resultSet);
			// Update the comparisons
			updateComparisons();
		}
		
		/**
		 * Removes a result set from the comparison list
		 */
		public function removeComparison(resultSetId:int):void
		{
			// get the result set index
			var i:int = getResultIndex(resultSetId);
			// if result exists then  remove it
			if (i >= 0) _comparisonList.splice(i, 1);
			// Update the comparisons
			updateComparisons();
		}
		
		//}
		
		//{	Private Methods
		
		/**
		 * Updates the comparison list
		 */
		private function updateComparisons():void
		{
			// sort comparison list by average time
			_comparisonList.sortOn(["meanTestTime"]);
			// clear comparison set
			_testComparisonSet.clear();
			// run through and add comparisons to set
			var l:int = _comparisonList.length;
			for(var i:int = 0; i < l; i++)
			{
				var r:TestResultSet = _comparisonList[i];
				_testComparisonSet.addComparison(r);
			}
			
			// dispatch update signal
			comparisonSetUpdateSignal.dispatch(_testComparisonSet);
		}
		
		/**
		 * Returns the result index with the specified id
		 */
		private function getResultIndex(id:int):int
		{
			var l:int = _comparisonList.length;
			for (var i:int = 0; i < l; i++)
			{
				if ((_comparisonList[i] as TestResultSet).testId == id)
					return i;
			}
			
			return -1;
		}
		
		//}
	}
}
