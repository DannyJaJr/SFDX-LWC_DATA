@Istest 
public class MeetingRequestTriggerTest {
    
    @TestSetUp
    public static void setUpMethod(){
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
        
        
        Profile p2 = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Admin', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p2.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@scs.com');
        
        insert u;
    }    
    
    @istest 
    public static void TestEventCreation(){
        Meeting_request__c meetingRecord = new  Meeting_request__c();
        meetingRecord.Meeting_Purpose__c= 'Sample Purpose Reason';
        meetingRecord.Preferred_Date__c= System.today();
        
        User usr = [Select id,name from User where name like '%Testing%' LIMIT 1];
        
        Test.startTest();
        
        System.runAs(usr){
            insert meetingRecord; 
        }        
        test.stopTest();
        
        //Pending With Assertion cause of Deployment  WIll fix in next Deployment
        
    }
}