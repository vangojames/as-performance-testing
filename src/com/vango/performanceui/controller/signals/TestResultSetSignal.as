package com.vango.performanceui.controller.signals
{
	import com.vango.performance.vo.TestResultSet;

	import org.osflash.signals.Signal;

	/**
	 * @author James
	 */
	public class TestResultSetSignal extends Signal
	{
		public function TestResultSetSignal()
		{
			super(TestResultSet);
		}
	}
}
