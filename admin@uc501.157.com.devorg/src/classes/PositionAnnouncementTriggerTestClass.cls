/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
/**
 * This class contains unit tests for validating the behavior of the PositionAnnouncementTrigger
 */
@isTest(seealldata=true)
private class PositionAnnouncementTriggerTestClass {
	//verifyPost: Verify that chatter messages are posted when positions have the status Open/Approved
	//TODO: Create the outline for a test method called verifyPost
	//TODO: In the body of verifyPost, put the code you used to test the PositionAnnouncementTrigger
	//TODO:   that is found in the file 5-3.TestPositionAnnouncment.txt
	 static testmethod void verifyPost() {	
		List<Position__c> openApprovedPositions = new List<Position__c>();
		 
		User hiringManager = [SELECT id, name FROM User u
					Where u.people_manager__c=true LIMIT 1][0];   
		
		Integer startCountFeedPosts =[Select count() From CollaborationGroupFeed where parentId in (select id from CollaborationGroup where name='All Universal Containers')];
		
		System.debug(' Before trigger number of chatter posts for group is: ' + startCountFeedPosts);    
						
		for (Integer i = 1; i <=20; i++) {
			openApprovedPositions.add(new Position__c(name='Test Position '+ i
									, hiring_manager__c=hiringManager.id
									, Job_Description__c='test position'
									, status__c='Open'
									, sub_status__c='Approved'));
		}
		Database.insert(openApprovedPositions);
		
		Integer endCountFeedPosts = [Select c.Name, (Select Id, ParentId, Type, CreatedById, CreatedDate, IsDeleted, SystemModstamp From Feeds) From CollaborationGroup c WHERE name='All Universal Containers'][0].Feeds.size();
		System.debug('After trigger number of chatter posts for group is: ' + endCountFeedPosts);    
		System.assertEquals(startCountFeedPosts + 20, endCountFeedPosts);
	}


	//verifyNotPost: Verify that chatter messages are NOT posted when positions do not have the status Open/Approved
	//TODO: Create the test method called verifyNotPost to fulfull the requirements described in the comment above	
	static testmethod void verifyNotPost() {	
		List<Position__c> openApprovedPositions = new List<Position__c>();
		 
		User hiringManager = [SELECT id, name FROM User u
					Where u.people_manager__c=true LIMIT 1][0];   
		
		Integer startCountFeedPosts =[Select c.Name, (Select Id, ParentId, Type, CreatedById, CreatedDate, IsDeleted, SystemModstamp From Feeds) From CollaborationGroup c WHERE name='All Universal Containers'][0].Feeds.size();
		
		System.debug(' Before trigger number of chatter posts for group is: ' + startCountFeedPosts);    
						
		for (Integer i = 1; i <=20; i++) {
			openApprovedPositions.add(new Position__c(name='Test Position '+ i
									, hiring_manager__c=hiringManager.id
									, Job_Description__c='test position'
									, status__c='Open'
									, sub_status__c='Pending'));
		}
		Database.insert(openApprovedPositions);
		
		Integer endCountFeedPosts = [Select count() From CollaborationGroupFeed where parentId in (select id from CollaborationGroup where name='All Universal Containers')];
		System.debug('After trigger number of chatter posts for group is: ' + endCountFeedPosts);    
		System.assertEquals(startCountFeedPosts, endCountFeedPosts);
	}
}