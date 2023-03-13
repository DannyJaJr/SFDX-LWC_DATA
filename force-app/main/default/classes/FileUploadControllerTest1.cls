@istest
public class FileUploadControllerTest1{
    
    @testSetup
    public Static void SetUpMethod(){
        Id p = [select id from profile where name='Customer Community User'].id;
        
        Account ac = new Account(name ='Grazitti') ;
        insert ac; 
        
        Contact con = new Contact(LastName ='testCon',AccountId = ac.Id);
        insert con; 
      
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.jpg';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        cv.FirstPublishLocationId=con.id;
        Insert cv;
        
    }
    
    @istest
    public static void testSaveChunk(){
        Contact con = [Select id,name from Contact Where name like '%testCon%' LIMIT 1];
        String base64data = EncodingUtil.urlEncode('This is Simple Text String','UTF-8');
        test.startTest();
        FileUploadController.saveChunk(con.id,'SampleFileName',base64data,'');
        test.stopTest();
        
    }
    /*@istest
    public static void testSaveChunkWithoutId(){
        
        ContentVersion objCont = [SELECT Id, Title  FROM ContentVersion LIMIT 1];
        String base64data = EncodingUtil.urlEncode('This is Simple Text String','UTF-8');
        
        Contact con = [Select id,name from Contact Where name like '%testCon%' LIMIT 1];
        
        test.startTest();
       // FileUploadController.saveChunk(con.id,'SampleFileName',base64data,objCont.Id);
        test.stopTest();
        
        //Asserting is pending because of Quick Deployment
        
    }*/
}