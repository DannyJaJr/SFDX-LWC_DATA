@istest 
public class ScholarRenewalLinkTest {
   
    @TestSetUp
    public static void  setUpMethod(){
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
    }
    
    @istest
    public static void testconData(){
        
       User usr = [Select id,name from User where name like '%Testing%' LIMIT 1];
         Contact con = new Contact(LastName ='testCon');
        insert con;  
        list<scholar__c> lstScholar = new list<scholar__c>();
        scholar__c objScholar = new scholar__c();
        objScholar.Name='testScholar';
        objScholar.Contact__c=con.id;
        lstScholar.add(objScholar);
        insert lstScholar;
        
        Test.startTest();
        
        System.runAs(usr){
           lstScholar= ScholarRenewalLinkController.Renewallink();
        }
        Test.stopTest();
    }
}