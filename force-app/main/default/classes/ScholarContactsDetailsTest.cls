@istest 
public class ScholarContactsDetailsTest {
    
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
        Contact objContact = new Contact(LastName='Test');
        insert objContact;
        User usr = [Select id,name,contactid from User where name like '%Testing%' LIMIT 1];
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.jpg';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        cv.FirstPublishLocationId=usr.contactid;
        Insert cv;
        
        Test.startTest();
        System.runAs(usr){            
            ScholarContactDetailsWrapper objScholar = new ScholarContactDetailsWrapper(objContact,cv.Id);
            objScholar = ScholarContactsDetails.conData();
        }        
        Test.stopTest();
        //system.assertEquals(1, docList.size());
        
    }
}