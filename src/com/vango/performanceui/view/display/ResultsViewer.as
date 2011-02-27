package com.vango.performanceui.view.display
{
	import com.bit101.charts.BarChart;
	import com.bit101.charts.Chart;
	import com.bit101.components.HBox;
	import com.bit101.components.Label;
	import com.bit101.components.ScrollPane;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;
	import com.vango.performance.vo.TestResult;
	import com.vango.performance.vo.TestResultSet;

	import flash.display.Sprite;
	import flash.text.TextFormat;

	/**
	 * @author James
	 */
	public class ResultsViewer extends LiquidComponent
	{
		//{	Fields
		
		private var _window:Window;
		private var _contentPanel:ScrollPane;
		private var _mainContainer:VBox;
		private var _contentContainer:Sprite;
		private var _resultsInfoContainer:VBox;

		private var _noResultsLabel:Label;
		private var _nameLabel:Label;
		private var _testCountLabel:Label;
		private var _totalTestTime:Label;
		private var _meanTestTimeLabel:Label;
		private var _standardDeviationLabel:Label;
		private var _timeRangeLabel:Label;
		
		private var _graphLabel:Label;
		private var _graph:Chart;
		
		//}
		
		//{	Constants
		
		// Max number of items to render is set so that 
		// the graph does not crash if there are a million 
		// tests
		private const MAX_DATA_TO_RENDER:int = 10000;
		
		//}
		
		//{	Public Methods
		
		/**
		 * Sets the data for the test results
		 */
		public function setData(data:TestResultSet):void
		{
			_noResultsLabel.visible = false;
			_resultsInfoContainer.visible = true;
			
			// update labels
			_nameLabel.text = data.testName;
			_testCountLabel.text = data.testCount.toString();
			_totalTestTime.text = data.totalDuration.toString() + "ms";
			_meanTestTimeLabel.text = data.meanTestTime.toString() + "ms";
			_standardDeviationLabel.text = data.testDeviation.toString() + "ms";
			_timeRangeLabel.text = data.fastestTime.toString() + "ms - " + data.slowestTime.toString() + "ms";
			
			var dataResults:Array = [];
			for each(var r:TestResult in data.results)
			{
				if (dataResults.length < MAX_DATA_TO_RENDER)
					dataResults.push(r.testDuration);
			}
			_graph.data = dataResults;
			
			doDraw();
		}
		
		//}
		
		//{	Private Methods
		
		/**
		 * Initialises the class
		 */
		override protected function init():void
		{
			// build items
			_window = new Window(this, 0, 0, "Test Results");
			_window.draggable = false;
			_window.shadow = false;
			
			_contentPanel = new ScrollPane(_window.content);
			_contentPanel.dragContent = false;
			_mainContainer = new VBox(_contentPanel.content,0,20);
			_mainContainer.spacing = 5;
			
			_contentContainer = new Sprite();
			_mainContainer.addChild(_contentContainer);

			_noResultsLabel = new Label(_contentContainer,15,0,"No results selected. Once the tests have completed, selected on from the panel on the right to view the results here.");

			// create results info labels and container
			_resultsInfoContainer = new VBox(_contentContainer);
			_resultsInfoContainer.visible = false;
			_nameLabel = new Label();
			_testCountLabel = new Label();
			_totalTestTime = new Label();
			_meanTestTimeLabel = new Label();
			_standardDeviationLabel = new Label();
			_timeRangeLabel = new Label();
			
			// now configure labels
			createLabel("Test name : ", _nameLabel);
			createLabel("Test count : ", _testCountLabel);
			createLabel("Total test time : ", _totalTestTime);
			createLabel("Mean test time : ", _meanTestTimeLabel);
			createLabel("Test deviation : ", _standardDeviationLabel);
			createLabel("Test time range : ", _timeRangeLabel);

			_graphLabel = new Label(_resultsInfoContainer, 15, 0, "Graph showing individual test results (limited to the first " + MAX_DATA_TO_RENDER.toString() + " results).");
			var tf:TextFormat = _graphLabel.textField.defaultTextFormat;
			tf.color = 0x444444;
			tf.align = "center";
			_graphLabel.textField.defaultTextFormat = tf;
			_graphLabel.textField.setTextFormat(tf);
			_graphLabel.textField.autoSize = "none";
			
			_graph = new BarChart(_resultsInfoContainer,0,0,[]);
			_graph.showGrid = true;
			_graph.showScaleLabels = true;
			_graph.autoScale = true;
			
			super.init();
		}
		
		private function createLabel(name:String, value:Label):void
		{
			var container:HBox = new HBox(_resultsInfoContainer, 15, 0);
			var nameLabel:Label = new Label(container, 0, 0, name);
			nameLabel.textField.textColor = 0x0000FF;
			container.addChild(value);
			container.draw();
		}
		
		/**
		 * Draws the components
		 */
		override protected function doDraw():void
		{
			// resize
			_window.width = width;
			_window.height = height;
			_contentPanel.width = width;
			_contentPanel.height = height - _window.titleBar.height;
			_graph.x = 20;
			_graph.width = _contentPanel.width - (2 * _graph.x);
			_graphLabel.width = _contentPanel.width;
			
			// redraw
			_window.draw();			
			_graph.draw();
			_mainContainer.draw();
			_contentPanel.draw();
		}
		
		//}
	}
}
