package com.hackurday.nomtracker.controller {
	
	import flash.desktop.NativeApplication;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * ExitApplication command.
	 *
	 * @langversion ActionScript 3.0
	 * @author Justin Brown &lt;justin&#64;smartlogicsolutions.com&gt;
	 * @date 04/04/2009
	 * @version 0.1
	 */
	public class ExitApplicationCommand extends SimpleCommand {
	   
		override public function execute(note:INotification):void {
			trace('[ExitApplicationCommand::execute]');
			NativeApplication.nativeApplication.exit();
		}
		
	}
	
}
