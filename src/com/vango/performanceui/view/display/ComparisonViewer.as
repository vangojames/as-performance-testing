package com.vango.performanceui.view.display
{
	import com.bit101.components.Label;
	import com.bit101.components.ScrollPane;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;
	import com.vango.performance.vo.TestComparisonSet;
	import com.vango.performance.vo.TestResultSet;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * @author James
	 */
	public class ComparisonViewer extends LiquidComponent
	{
		//{	Fields
		
		private var _window:Window;
		private var _contentPanel:ScrollPane;
		private var _mainContainer:VBox;
		private var _contentContainer:Sprite;
		private var _comparisonsContainer:VBox;

		private var _noResultsLabel:Label;
		private var _comparisonRenderers:Array = [];
		private var _currentResultId:int = -1;
		
		//}
		
		//{	Public Methods
		
		/**
		 * Sets the data for the test results
		 */
		public function setData(data:TestComparisonSet):void
		{
			_noResultsLabel.visible = false;
			_comparisonsContainer.visible = true;
			clearComparisons();
			
			var i:int = 0;
			// run through and add test results
			for each(var testResult:TestResultSet in data.tests)
			{
				var renderer:ComparisonRenderer = new ComparisonRenderer();
				_comparisonRenderers.push(renderer);
				var speedIncrease:Number = 0;
				var isTie:Boolean = false;
				var nextName:String = "";
				if(i < data.tests.length - 1)
				{
					var compareData:TestResultSet = data.tests[i + 1];
					speedIncrease = compareData.meanTestTime - testResult.meanTestTime;
					speedIncrease /= compareData.meanTestTime;
					isTie = compareData.meanTestTime == testResult.meanTestTime;
					nextName = compareData.testName + " (ID " + compareData.testId.toString() + ")"; 
				}
				renderer.isOdd = Boolean((_comparisonRenderers.length & 1) == 1);
				renderer.setData(i + 1, testResult, nextName, speedIncrease, isTie, i == (data.tests.length - 1));
				// select if required
				if (_currentResultId == renderer.id) renderer.select();
				else renderer.deselect();
				_comparisonsContainer.addChild(renderer);
				i++;
			}
			
			doDraw();
		}
		
		/**
		 * Sets the current result id
		 */
		public function setResult(testId:int):void { _currentResultId = testId; }
		
		//}
		
		//{	Private Methods
		
		/**
		 * Initialises the class
		 */
		override protected function init():void
		{
			// build items
			_window = new Window(this, 0, 0, "Test Comparisons");
			_window.draggable = false;
			_window.shadow = false;
			
			_contentPanel = new ScrollPane(_window.content);
			_contentPanel.dragContent = false;
			_mainContainer = new VBox(_contentPanel.content,0,20);
			_mainContainer.spacing = 5;
			
			_contentContainer = new Sprite();
			_mainContainer.addChild(_contentContainer);

			_noResultsLabel = new Label(_contentContainer, 15, 0, "No comparisons selected. Once the tests have completed, check the compare checkbox from the panel on the right to add comparisons.");
			_comparisonsContainer = new VBox(_contentContainer);
			_comparisonsContainer.visible = false;
			
			super.init();
		}
		
		/**
		 * Draws the components
		 */
		override protected function doDraw():void
		{
			for each (var cr:DisplayObject in _comparisonRenderers)
				cr.width = width - 10;
			
			// resize
			_window.width = width;
			_window.height = height;
			_contentPanel.width = width;
			_contentPanel.height = height - _window.titleBar.height;
			
			// redraw
			_window.draw();
			_comparisonsContainer.draw();
			_mainContainer.draw();
			_contentPanel.draw();
		}
		
		/**
		 * Clears the comparisons out of the comparisons container
		 */
		private function clearComparisons():void
		{
			_comparisonRenderers.length = 0;
			while (_comparisonsContainer.numChildren > 0)
				_comparisonsContainer.removeChildAt(0);
		}
		
		//}
	}
}
