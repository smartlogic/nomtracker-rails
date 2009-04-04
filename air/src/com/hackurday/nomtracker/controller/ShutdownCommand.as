package com.hackurday.nomtracker.controller {
	
	import flash.desktop.NativeApplication;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * Shutdown command.
	 *
	 * @langversion ActionScript 3.0
	 * @author Justin Brown &lt;justin&#64;smartlogicsolutions.com&gt;
	 * @date 04/04/2009
	 * @version 0.1
	 */
	public class ShutdownCommand extends SimpleCommand {
	   
	   	override public function execute(note:INotification):void {
			trace('[ShutdownCommand::execute]');
			NativeApplication.nativeApplication.exit();
		}	
		
	}
	
}
