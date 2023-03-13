/*

*/
public with sharing class VotingLightningController {	
    
    public  static String who;
    public static String votingFor;
    public static Boolean votingEnabled ;
    
    
    // field set 
    public static List<Schema.FieldSetMember> fieldsetAcademics = new List<Schema.FieldSetMember>();
    public static List<Schema.FieldSetMember> fieldsetFinance=new List<Schema.FieldSetMember>();
    public static List<Schema.FieldSetMember> fieldsetRecommendation=new List<Schema.FieldSetMember>();
    public static List<Schema.FieldSetMember> fieldsetSocial=new List<Schema.FieldSetMember>();
    public static List<Schema.FieldSetMember> fieldsetReviews=new List<Schema.FieldSetMember>();
    public static List<Schema.FieldSetMember> fieldsetVote=new List<Schema.FieldSetMember>();
    
    Public Static List<fieldDb> academicsList = new List<fieldDb>();
    Public Static List<fieldDb> FinanceList = new List<fieldDb>();
    Public Static List<fieldDb> recommendationList = new List<fieldDb>();
    Public Static List<fieldDb> socialList =new List<fieldDb>();
    Public Static List<fieldDb> reviewsList =new List<fieldDb>();
    Public Static List<fieldDb> voteList =new List<fieldDb>();
    
    @AuraEnabled
    public Static VotingWrapper getVotes(){
        
        setVariables();
        getfieldsSetList();
        Id devRecordTypeId = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get('Round Three').getRecordTypeId();
        VotingWrapper ret = new VotingWrapper();  
        
        ret.openvotes =	[Select id,Application__c,Application__r.Applicant_Full_Name__c,Application__r.City_State__c,Application__r.Personal_Rating__c	 from Vote__c where Vote_Complete__c = false AND Application__r.recordtypeid= : devRecordTypeId AND OwnerId = : UserInfo.getUserId() AND Score__c = Null Order by Application__r.Applicant_Full_Name__c LIMIT 5  ];
        //ret.openvotes =	[Select id,Scholar__c, Score__c,Application__c, Special_Case__c, Comment__c, Scholar__r.Contact__r.Name,Scholar__r.region__c from Vote__c where Scholar__r.HS_Year_Applied__c = :who AND Scholar__r.Status__c = 'Applied' AND OwnerId = : UserInfo.getUserId() AND Score__c = Null Order by Scholar__r.Contact__r.LastName ];
        ret.closedVotes = [Select id,Application__c,Application__r.Applicant_Full_Name__c,Application__r.City_State__c,Application__r.Personal_Rating__c from Vote__c where Vote_Complete__c = true AND Application__r.recordtypeid= : devRecordTypeId AND OwnerId = : UserInfo.getUserId() AND  Application__c != Null Order by Application__r.Applicant_Full_Name__c desc LIMIT 5 ];
        
        ret.votingFor = votingFor;
        ret.academicsList=academicsList;
        ret.FinanceList = FinanceList;
        ret.recommendationList= recommendationList;
        ret.socialList=socialList;
        ret.reviewsList=reviewsList;
        ret.voteList= voteList;
        return ret;    
    }
    
    private Static void setVariables(){
        
        if (Voting__c.getOrgDefaults().Seniors_Enabled__c) {
            votingFor = 'Voting for senior year applicants is enabled';
            votingEnabled = true;
            who = 'Senior';
        } else if (Voting__c.getOrgDefaults().Juniors_Enabled__c) {
            votingFor = 'Voting for junior year applicants is enabled';
            votingEnabled = true;
            who = 'Junior';
        } else {
            votingFor = 'Voting is currently disabled';
        }
        getFields();
    }   
    
    
    public Static void getFields() {
        fieldsetAcademics =  SObjectType.Application__c.FieldSets.Academics.getFields();
        fieldsetFinance=  SObjectType.Application__c.FieldSets.Finance.getFields();
        fieldsetRecommendation = SObjectType.Application__c.FieldSets.Recommendations.getFields();
        fieldsetSocial = SObjectType.Application__c.FieldSets.Social.getFields();
        fieldsetReviews= SObjectType.Application__c.FieldSets.Reviews.getFields();
        fieldsetVote = SObjectType.Application__c.FieldSets.Header.getFields();
    }
    
    public static void getfieldsSetList(){
        
        for(Schema.FieldSetMember f : fieldsetAcademics) {
            academicsList.add(new fieldDb(f.getLabel(),f.getFieldPath()));
        }
        for(Schema.FieldSetMember f : fieldsetFinance) {
            financeList.add(new fieldDb(f.getLabel(),f.getFieldPath()));
        }
        for(Schema.FieldSetMember f : fieldsetRecommendation) {
            recommendationList.add(new fieldDb(f.getLabel(),f.getFieldPath()));
        }
        for(Schema.FieldSetMember f : fieldsetSocial) {
            socialList.add(new fieldDb(f.getLabel(),f.getFieldPath()));
        }
        for(Schema.FieldSetMember f : fieldsetReviews) {
            reviewsList.add(new fieldDb(f.getLabel(),f.getFieldPath()));
        }
        for(Schema.FieldSetMember f : fieldsetVote) {
            voteList.add(new fieldDb(f.getLabel(),f.getFieldPath()));
        }
    }  
    
    
    @AuraEnabled
    public Static Application__c getScholarRecord(String sid) {
        
        setVariables();
        getFields();
        String userid = userinfo.getUserId();
        String query = 'Select ';
        
        for(Schema.FieldSetMember f : fieldsetAcademics) {
            query += f.getFieldPath() + ', ';
        }
        for(Schema.FieldSetMember f : fieldsetFinance) {
            query += f.getFieldPath() + ', ';
        }
        for(Schema.FieldSetMember f : fieldsetRecommendation) {
            query += f.getFieldPath() + ', ';
        }
        for(Schema.FieldSetMember f : fieldsetSocial) {
            query += f.getFieldPath() + ', ';
        }
        for(Schema.FieldSetMember f : fieldsetReviews) {
            query += f.getFieldPath() + ', ';
        }
         for(Schema.FieldSetMember f : fieldsetVote) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id, Name, ';
        query += '(Select Id,Name From Votes__r Where OwnerId = :userId), ';
        query += '(SELECT Id, Description, Subject FROM ActivityHistories ORDER BY ActivityDate ASC NULLS LAST, LastModifiedDate DESC LIMIT 50), ';
        query += '(select id,ContentDocument.title,ContentDocumentId,ContentDocument.LatestPublishedVersionId from ContentDocumentLinks) FROM Application__c Where Id = :sid'; 
        
        return Database.query(query);
    }
    
    @AuraEnabled(cacheable=true)
    public static String getFieldSetMember(){
        
        String objectName ='Vote__C'; 
        String fieldSetName ='voting_fields';
        
        List<FieldSetMemberWrapperClass> wrapperList = new List<FieldSetMemberWrapperClass>();
        Schema.SObjectType sObj = Schema.getGlobalDescribe().get(objectName);
        
        for(Schema.FieldSetMember fieldMember : sObj.getDescribe().fieldSets.getMap().get(fieldSetName).getFields()){
            
            FieldSetMemberWrapperClass wrapper = new FieldSetMemberWrapperClass();
            wrapper.isDBRequired = fieldMember.getDbRequired();
            wrapper.isRequired = fieldMember.getRequired();
            wrapper.fieldType = String.valueOf(fieldMember.getType());
            wrapper.fieldLabel = fieldMember.getLabel();
            wrapper.fieldAPIName = fieldMember.getFieldPath();  
            
            if(String.valueOf(fieldMember.getType()) == 'PICKLIST' || 
               String.valueOf(fieldMember.getType()) == 'MULTIPICKLIST'){
                   wrapper.pickListValues = sObj.getDescribe().fields.getMap().get(fieldMember.getFieldPath())
                       .getDescribe().getPicklistValues();
               }
            
            wrapperList.add(wrapper);
        }
        //System.debug('#### wrapperList '+wrapperList);
        
        return JSON.serialize(wrapperList);
    }
    
    @AuraEnabled
    public static String doUpsertObjects(sObject objectData,String vId){
        objectData.id=vId;
        upsert objectData;
        return JSON.serialize(objectData);
    }
    
    public class VotingWrapper{        
        @AuraEnabled
        public List<Vote__c> openvotes;        
        @AuraEnabled
        public List<Vote__c> closedVotes;        
        @AuraEnabled
        public String votingFor;
        @AuraEnabled
        Public List<fieldDb> academicsList ;
        @AuraEnabled
        Public List<fieldDb> financeList ;
        @AuraEnabled
        Public List<fieldDb> recommendationList ;
        @AuraEnabled
        Public List<fieldDb> socialList ;
        @AuraEnabled
        Public List<fieldDb> reviewsList ;
        @AuraEnabled
        Public List<fieldDb> voteList ;
    }
    
    public class fieldDb{        
        @AuraEnabled 
        public String fieldName;
        @AuraEnabled 
        public String fieldApiName;
        
        public fieldDb(String fieldName,String fieldApiName){
            this.fieldName= fieldName;
            this.fieldApiName= fieldApiName;
        }
    }
    public class FieldSetMemberWrapperClass{
        @AuraEnabled
        public Boolean isDBRequired 					 { get; set; }
        @AuraEnabled
        public Boolean isRequired 						 { get; set; }
        @AuraEnabled
        public String fieldType 						 { get; set; }
        @AuraEnabled
        public String fieldLabel 						 { get; set; }
        @AuraEnabled
        public String fieldAPIName 					     { get; set; }
        @AuraEnabled 
        public List<Schema.PicklistEntry> pickListValues { get; set; }
    }
}