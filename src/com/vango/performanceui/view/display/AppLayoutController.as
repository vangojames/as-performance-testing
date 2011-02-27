package com.vango.performanceui.view.display
{
	import com.bit101.components.HBox;
	import com.bit101.components.VBox;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	/**
	 * @author James
	 */
	public class AppLayoutController extends Sprite
	{
		//{	Fields
		
		private var _mainContainer:VBox;
		private var _subContainer:HBox;
		private var _resultsAndComparisonContainer:VBox;
		
		private var _testsView:TestsView;
		private var _resultsView:ResultsViewer;
		private var _comparisonView:ComparisonViewer;
		private var _statusView:StatusView;
		
		//}
		
		//{	Constructor
		
		/**
		 * Constructor
		 */
		public function AppLayoutController()
		{
			try
			{
				init();	
			}
			catch(er:Error)
			{
				throw new Error("Error initialising : " + er);	
			}
			
			// listen for stage
			if(stage) onAddedToStage(null);
			else addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		//}
		
		//{	Private Methods
		
		/**
		 * Initialises the class
		*/
		private function init():void
		{
			// create container
			_mainContainer = new VBox(this);
			
			// create sub container
			_subContainer = new HBox(_mainContainer);
			_subContainer.spacing = 0;

			_resultsAndComparisonContainer = new VBox(_subContainer);
			_resultsAndComparisonContainer.spacing = 0;
			
			// add results view
			_resultsView = new ResultsViewer();
			_resultsAndComparisonContainer.addChild(_resultsView);
			
			// add comparisons view
			_comparisonView = new ComparisonViewer();
			_resultsAndComparisonContainer.addChild(_comparisonView);
			
			// add tests view
			_testsView = new TestsView();
			_subContainer.addChild(_testsView);
			
			// add overall progress container
			_statusView = new StatusView();
			_mainContainer.addChild(_statusView);
		}
		
		//}
		
		//{	Handlers
		
		/**
		 * Handles addition to the stage
		 */
		private function onAddedToStage(event:Event):void
		{
			// setup listeners
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			// add enter frame listener for redrawing
			stage.addEventListener(Event.RESIZE, onStageResize);
			onStageResize(null);
		}

		/**
		 * Handles enter frame events
		 */
		private function onStageResize(event:Event):void
		{
			// resize components
			_resultsView.width = stage.stageWidth * 0.7;
			_resultsView.height = (stage.stageHeight - _statusView.height - 8) / 2;
			_comparisonView.width = _resultsView.width;
			_comparisonView.height = _resultsView.height;

			_testsView.width = stage.stageWidth - _resultsView.width;
			_testsView.height = _resultsView.height * 2;
			_statusView.width = stage.stageWidth;

			// redraw containers
			_resultsAndComparisonContainer.draw();
			_subContainer.draw();
			_mainContainer.draw();
		}

		/**
		 * Handles removal from the stage
		 */
		private function onRemovedFromStage(event:Event):void
		{
			// setup listeners
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			// remove enter frame listener
			stage.removeEventListener(Event.RESIZE, onStageResize);
		}
		
		//}
	}
}
