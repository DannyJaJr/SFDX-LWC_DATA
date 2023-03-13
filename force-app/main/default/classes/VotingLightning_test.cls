@isTest 
public class VotingLightning_test {
    
    @testSetup 
    static void setup() {        
        CreateTestData.create();
        CreateTestData.addVoters();
        
        Id leadRecId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Scholar Applicant').getRecordTypeId();
        Lead ld = new lead();
        ld.lastname ='Test';
        ld.Status='Approved';
        ld.Company='Test Company';        
        insert ld;
        
        Id devRecordTypeId = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get('Round Three').getRecordTypeId();
        Application__c acc = new  Application__c();
        acc.RecordTypeId = devRecordTypeId;
        acc.Applicant_LeadName__c=ld.id;
        insert acc;
        
        Vote__c vote = new Vote__c();
        vote.Application__c= acc.id;
        insert vote;
        
    }
    @isTest 
    public static void testGetVotesJuniors(){
        
        Voting__c settings = new Voting__c();
        settings.Juniors_Enabled__c = true;
        settings.Seniors_Enabled__c = false;
        insert settings;
        
        test.startTest();
           VotingLightningController.VotingWrapper wrap = VotingLightningController.getVotes();
        test.stopTest();
        
        //Asstion Here 
        
    }
    
    @isTest 
    public static void testGetVotesSeniors(){
        
        Voting__c settings = new Voting__c();
        settings.Juniors_Enabled__c = false;
        settings.Seniors_Enabled__c = true;
        insert settings;
        test.startTest();
           VotingLightningController.VotingWrapper wrap = VotingLightningController.getVotes();
        test.stopTest();
        
        //Asstion Here 
    }
    
    @isTest 
    public static void testGetScholarRecord(){
        
        Voting__c settings = new Voting__c();
        settings.Juniors_Enabled__c = false;
        settings.Seniors_Enabled__c = true;
        insert settings;
        
        Application__c sch;
        
        test.startTest();
        
        sch = [select id ,name from Application__c LIMIT 1];
        sch = VotingLightningController.getScholarRecord(sch.id);
       
        test.stopTest();
        //Asstion Here 
    }
    
    @isTest 
    Public static void testgetFieldSetMember(){
        Voting__c settings = new Voting__c();
        settings.Juniors_Enabled__c = false;
        settings.Seniors_Enabled__c = true;
        insert settings;
        test.startTest();
         String voteFieldWrap =VotingLightningController.getFieldSetMember();       
        test.stopTest();
        
         //Asstion Here 
    }
    
}