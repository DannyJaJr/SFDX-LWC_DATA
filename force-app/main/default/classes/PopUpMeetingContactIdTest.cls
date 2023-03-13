@isTest
public class PopUpMeetingContactIdTest {
 @isTest
    public static void  meetingRequest(){
        
        // Creating a Community user 
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
        
        Meeting_Request__c meetReq = new Meeting_Request__c();
        meetReq.Meeting_Purpose__c='SampleRequest';
        meetReq.Preferred_Date__c=system.today();
        meetReq.Duration__c=30;
        
        insert meetReq;
        system.debug('meetReq.id'+meetReq.Id);
        
        system.runAs(user){
            system.debug('user'+user);
            PopUpMeetingContactId.concatContactId(meetReq.Id);
            system.debug('meetReq.IdifBlock  : '+meetReq.Id);
        }
    }
}