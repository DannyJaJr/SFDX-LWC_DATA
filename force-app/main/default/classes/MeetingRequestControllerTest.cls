@istest
public class MeetingRequestControllerTest {
    @istest
    public static void  testMeetingRequest(){
        Id p = [select id from profile where name='Customer Community User'].id;
        
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
        
        Contact con = new Contact(LastName ='testCon',AccountId = ac.Id);
        insert con;  
        
        User user = new User(alias = 'test123', email='test123@noemail.com',
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                             ContactId = con.Id,
                             timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert user;
      
        list<Meeting_Request__c> lstMeeting = new list<Meeting_Request__c>();
        Meeting_Request__c objMeeting = new Meeting_Request__c(Description__c='Hello',Preferred_Date__c=system.today(),Contact__c=user.ContactId);        
        lstMeeting.add(objMeeting);
        Test.startTest();
        system.runAs(user){
        lstMeeting= MeetingRequestController.onInit();
        }
        Test.stopTest();
       // system.assertEquals(1,lstMeeting.size());
    }
    
    
}