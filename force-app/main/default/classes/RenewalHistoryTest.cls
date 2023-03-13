@istest
public class RenewalHistoryTest {
    
    @TestSetUp
    public static void  setUpMethod(){
        
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
        //Creating Scholar data 
        Scholar__c sch = new Scholar__c();
        sch.Contact__c= con.id;
        insert sch;
        
        //Creating Renewal data 
        Renewal__c renewal = new Renewal__c();
        renewal.Term__c='Fall';
        renewal.Status__c='Funding Approved';
        renewal.Amount__c= 1250;
        renewal.Student__c=con.id;
        renewal.Scholar__c= sch.Id;
        renewal.School_Year__c='2019';
        insert renewal;
    }
    
    
    @istest 
    Public static void getRenewalHistoryTest(){
        
        User usr = [Select id,name,contactid from User where name like '%Testing%' LIMIT 1];
        
        list<RenewalHistoryController.renewal> renew = Null;
        Test.startTest();
        System.runAs(usr){            
            renew=  RenewalHistoryController.getRenewalHistory();
        }        
        Test.stopTest();
        
        System.assertEquals(1, renew.size());
        
        for(RenewalHistoryController.renewal reNewRecord : renew){
            
            System.assertEquals('Fall', reNewRecord.term);
            System.assertEquals('Funding Approved', reNewRecord.status);
            System.assertEquals(1250, reNewRecord.amount);
            
        }
    }
}