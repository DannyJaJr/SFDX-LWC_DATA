public class CreateTestData {
    public static void create() {
        List<Contact> contacts = new List<Contact>();
        List<Scholar__c> scholars = new List<Scholar__c>();
        List<AP_Course__c> courses = new List<AP_Course__c>();
        List<SAT_II_Exams__c> exams = new List<SAT_II_Exams__c>();
        
        User owner = [Select Id From User Where IsActive = true Limit 1];
        
        // 1 account
        Account acct = new Account(Name = 'Test');
        insert acct;

        // 10 contacts
        for (Integer i=0; i<10; i++) {
            Contact c = new Contact(LastName = 'Test', Photo_Attachment_Id__c= null);
            contacts.add(c);
        }
        insert contacts;
        
        // add some generic attachments
        List<Attachment> attachments = new List<Attachment>();
        for (Contact c : contacts) {
        	Attachment a = new Attachment(ParentId=c.Id, Name='Test', Body=Blob.valueOf('Junk Data'));
        	attachments.add(a);
        }
        insert attachments;
        
        // add some 'photos'
        attachments.clear();
        for (Contact c : contacts) {
        	Attachment a = new Attachment(ParentId=c.Id, Name='Picture', Body=Blob.valueOf('Junk Data'));
        	attachments.add(a);
        }
        insert attachments;
        
		// link the photos to the contacts
        for (Integer i=0; i < contacts.size(); i++) {
        	Contact c = contacts[i];
        	Attachment a = attachments[i];
        	c.Photo_Attachment_Id__c = a.Id;
        }
        update contacts;
        
        
        // 3 seniors
        for (Integer i=0; i<3; i++) {
            Scholar__c s = new Scholar__c(
                Name = 'Test', 
                Contact__c = contacts[i].Id,
            	Status__c = 'Applied',
            	HS_Year_Applied__c = 'Senior'
            );
            scholars.add(s);
            
            AP_Course__c ap = new AP_Course__c(Course__c = 'Test', Score__c = 5, Contact__c = contacts[i].Id);
            courses.add(ap);
            
            SAT_II_Exams__c sat = new SAT_II_Exams__c(Subject__c = 'Test', Score__c = 5, Contact__c = contacts[i].Id);
            exams.add(sat);
        }

		// 3 juniors
        for (Integer i=3; i<6; i++) {
            Scholar__c s = new Scholar__c(
                Name = 'Test', 
                Contact__c = contacts[i].Id,
            	Status__c = 'Applied',
            	HS_Year_Applied__c = 'Junior'
            );
            scholars.add(s);
            
            AP_Course__c ap = new AP_Course__c(Course__c = 'Test', Score__c = 5, Contact__c = contacts[i].Id);
            courses.add(ap);
            
            SAT_II_Exams__c sat = new SAT_II_Exams__c(Subject__c = 'Test', Score__c = 5, Contact__c = contacts[i].Id);
            exams.add(sat);
        }
        
        insert scholars;
        insert courses;
        insert exams;
        
        List<Scholar_Contact_Map__c> mapping = new List<Scholar_Contact_Map__c>();
        for (Integer i=0; i < scholars.size(); i++) {
        	Scholar__c sch = scholars[i];
        	Contact cont = contacts[i];
        	Scholar_Contact_Map__c m = new Scholar_Contact_Map__c(
        		Scholar__c = sch.Id,
        		Contact__c = cont.Id,
        		Photo_Attachment_Id__c = cont.Photo_Attachment_Id__c
        	);
        	mapping.add(m);
        }
        
        insert mapping;
        
    }
    
    public static List<User> addVoters() {
        // find a system admin
        Profile prof = [Select Id From Profile Where Name = 'System Administrator'];
        User admin = [Select Id From User Where ProfileId = :prof.Id and IsActive = TRUE Limit 1];
        UserRole role = [Select Id From UserRole Order by Id Limit 1];
        List<User> users = new List<User>();
        
        System.runAs(admin) {
	        for (integer i=0; i < 7; i++) {
	            User testUser = new User();
	            testUser.Username= 'testUser' + i + '@somecompany.com';
	            testUser.Email = 'testuser@company.com';
	            testUser.Lastname = 'user' + i;
	            testUser.Firstname = 'test';
	            testUser.Alias = 'test' + i;
	            testUser.CommunityNickname = 'test' + i;
	            testUser.UserRoleId = role.Id;
	            testUser.ProfileId = prof.Id;
	            testUser.TimeZoneSidKey = 'GMT';
	            testUser.LocaleSidKey = 'en_US';
	            testUser.EmailEncodingKey = 'ISO-8859-1';
	            testUser.LanguageLocaleKey = 'en_US';
	            testUser.UserPermissionsMobileUser = false;
	            users.add(testUser);                
	        }
	        
	        insert users;
        }
        
        return users;
    }
}