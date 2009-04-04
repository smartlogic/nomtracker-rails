package com.hackurday.nomtracker.controller {

	import com.hackurday.nomtracker.model.*;
	import com.hackurday.nomtracker.view.*;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * PrepareActors command.
	 *
	 * @langversion ActionScript 3.0
	 * @author Justin Brown &lt;justin&#64;smartlogicsolutions.com&gt;
	 * @date 04/04/2009
	 * @version 0.1
	 */
	public class PrepareActorsCommand extends SimpleCommand {
	   
		override public function execute(note:INotification):void {
			var app:NomTracker = note.getBody() as NomTracker;
			
			//pmvcgen:register proxies
            
            //pmvcgen:register mediators
            facade.registerMediator( new NTMediator(app) );
		}
		
	}
	
}
