/**
 * This class is a utility class that contains methods for creating subscriptions.
 * It currently has one method to subscribe hiring managers to their related positions.
 */  
public with sharing class SubscriptionsClass { 
	/*
	 * For each jobApp, create a chatter subscription for the hiring manager of the associated position
	 * jobApps - the job applications to which the hiring managers should be subscribed.
	 **/
	public static void HiringManagerSubscribeNewPosition(List <Position__c> positions) {
		System.Debug('HiringManagerSubscribeNewPosition: Entering');
		List <EntitySubscription>subscriptions=new List <EntitySubscription>();
		for(Position__c p:positions) {
				EntitySubscription es=new EntitySubscription();
				es.parentid=p.id;
				es.SubscriberId=p.Hiring_Manager__c;
				subscriptions.add(es);}
		try {
			Database.insert(subscriptions);
		}
		catch (DMLException dmlEx) {
			//if we get an error because this user is already following this object, it's okay.
			if (dmlEx.getDmlType(0) == statusCode.DUPLICATE_VALUE) {
				System.Debug('HiringManagerSubscribeNewPosition: subscription already exists');
			} else {
				//otherwise we have a more serious error that we need to throw.
				throw dmlEx;
			}
		}
	}
}