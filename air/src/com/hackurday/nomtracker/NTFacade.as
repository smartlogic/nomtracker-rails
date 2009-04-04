package com.hackurday.nomtracker {
	
	import com.hackurday.nomtracker.controller.*;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	/**
	 * Application Facade.
	 *
	 * @langversion ActionScript 3.0
	 * @author Justin Brown &lt;justin&#64;smartlogicsolutions.com&gt;
	 * @date 04/04/2009
	 * @version 0.1
	 */
	public class NTFacade extends Facade {
	   
		/* --- Variables --- */
		
		public static const STARTUP:String 						= "startup";
		public static const NAME:String 						= "NTFacade";
		
		public static const LOGOUT:String						= "logout";
		public static const EXIT_APPLICATION:String				= "exitApplication";
		
		/* === Variables === */
		
		/* --vv-- FSM Constants --vv-- */
		
		public static const IDLE:String							= "idle";
		public static const LOADING:String             			= "loading";
		public static const	LOGIN:String						= "login";
		public static const TRY_LOGIN:String					= "tryLogin";
		
		public static const ACTIONS:String 						= NAME + '/actions/';
		public static const ENTER:String						= NAME + '/enter/';
		public static const EXIT:String							= NAME + '/exit/';
		public static const CHANGED:String						= NAME + '/changed/';
		public static const STATES:String						= NAME + '/states/';
		
		public static const ACTION_IDLE:String					= ACTIONS + IDLE;
		public static const ACTION_LOADING:String				= ACTIONS + LOADING;
		public static const ACTION_LOGIN:String 				= ACTIONS + LOGIN;
		public static const ACTION_TRY_LOGIN:String 			= ACTIONS + TRY_LOGIN;
		
		public static const ENTER_IDLE:String					= ENTER + IDLE;
		public static const ENTER_LOADING:String				= ENTER + LOADING;
		public static const ENTER_LOGIN:String 					= ENTER + LOGIN;
		public static const ENTER_TRY_LOGIN:String 				= ENTER + TRY_LOGIN;
		
		public static const EXIT_IDLE:String					= EXIT + IDLE;
		public static const EXIT_LOADING:String					= EXIT + LOADING;
		public static const EXIT_LOGIN:String 					= EXIT + LOGIN;
		public static const EXIT_TRY_LOGIN:String 				= EXIT + TRY_LOGIN;
		
		public static const CHANGED_IDLE:String					= CHANGED + IDLE;
		public static const CHANGED_LOADING:String				= CHANGED + LOADING;
		public static const CHANGED_LOGIN:String 				= CHANGED + LOGIN;
		public static const CHANGED_TRY_LOGIN:String 			= CHANGED + TRY_LOGIN;
		
		public static const STATE_IDLE:String					= STATES + IDLE;
		public static const STATE_LOADING:String				= STATES + LOADING;
		public static const STATE_LOGIN:String 					= STATES + LOGIN;
		public static const STATE_TRY_LOGIN:String 				= STATES + TRY_LOGIN;
		
		
		/* ==^^== FSM Constants ==^^== */
		
		/* --- Functions --- */
		
		public static function getInstance():NTFacade {
			if(instance == null)
				instance = new NTFacade();
			return instance as NTFacade;
		}
		
		/**
		 * Starts up NomTracker.
		 *
		 * @param app reference to the application
		 */
		public function startup(app:NomTracker):void {
			sendNotification(STARTUP, app);
		}
		
		override protected function initializeController():void {
			super.initializeController();
			registerCommand(STARTUP, StartupCommand);
	        registerCommand(EXIT_APPLICATION, ExitApplicationCommand);
			registerCommand(CHANGED_TRY_LOGIN, LoginCommand);
	        registerCommand(LOGOUT, LogoutCommand);
		}
		
		/* === Functions === */
		
	}
	
}
