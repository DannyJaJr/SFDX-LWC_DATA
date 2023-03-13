public class VotingController {
    
    public String votingFor {get; set;}
    public Boolean votingEnabled {get; set;}
    public integer openPages {get; set;}
    public Integer donePages {get; set;}
    public List<Schema.FieldSetMember> fieldset {get; set;}
    public Scholar__c scholar {get; private set;}
    public Vote__c currentVote {get; set;}
    public List<AP_Course__c> apCourses {get; private set;}
    public List<SAT_II_Exams__c> satExams {get; private set;}
    public String sid {get; set;}
    public Boolean hasAttachments {get; private set;}
    public Boolean hasAPScores {get; private set;}
    public Boolean hasSATScores {get; private set;}
    
    private String userId;
    private String userName;
    public String who{get;set;}
    private List<Vote__c> votes;
    private List<Vote__c> pageVotes;
    
    private final String votingForJuniors = 'Voting for junior year applicants is enabled';
    private final String votingForSeniors = 'Voting for senior year applicants is enabled';
    private final String votingDisabled = 'Voting is currently disabled';
    private final Integer recordsPerPage = 5;

    public VotingController() {
        userId = UserInfo.getUserId();
        userName = UserInfo.getName();
        scholar = null;
        currentVote = null;
        votingEnabled = false;
        who = '';
        openPages = 0;
        donePages = 0;
        hasAttachments = false;
        
        if (Voting__c.getOrgDefaults().Seniors_Enabled__c) {
            votingFor = votingForSeniors;
            votingEnabled = true;
            who = 'Senior';
            fieldset = getSeniorFields();
        } else if (Voting__c.getOrgDefaults().Juniors_Enabled__c) {
            votingFor = votingForJuniors;
            votingEnabled = true;
            who = 'Junior';
            fieldset = getJuniorFields();
        } else {
            votingFor = 'Voting is disabled';
        }
    }
/*  
    public ApexPages.StandardSetController openVoteSet {
        get {
            if (openVoteSet == null) {
                openVoteSet = new ApexPages.StandardSetController(
                    Database.getQueryLocator(
                        [Select v.Id, v.Scholar__c, v.Score__c, v.Special_Case__c, v.Comment__c, v.Scholar__r.Contact__r.Name
                         From Vote__c v 
                         Where v.Scholar__r.HS_Year_Applied__c = :who
                         And v.Scholar__r.Status__c = 'Applied'
                         And v.OwnerId = :userId
                         And v.Score__c = Null
                         Order by v.Scholar__r.Contact__r.LastName]));
            } 
            return openVoteSet;
        }
        
        set {
            openVoteSet = value;
        }
    }
*/
/*
    public ApexPages.StandardSetController doneVoteSet {
        get {
            if (doneVoteSet == null) {
                doneVoteSet = new ApexPages.StandardSetController(
                    Database.getQueryLocator(
                        [Select v.Id, v.Scholar__c, v.Score__c, v.Special_Case__c, v.Comment__c, v.Scholar__r.Contact__r.Name
                         From Vote__c v 
                         Where v.Scholar__r.HS_Year_Applied__c = :who
                         And v.Scholar__r.Status__c = 'Applied'
                         And v.OwnerId = :userId
                         And v.Score__c <> Null
                         Order by v.Scholar__r.Contact__r.LastName]));
            }
            return doneVoteSet;
        }
        
        set {
            doneVoteSet = value;
        }
    }
  */  
    public String getCurrentUser() {
        return userName + ' (' + userId + ')';
    }
    
    public List<Vote__c> getOpenVotes() {
        return (List<Vote__c>) [Select id,Scholar__c, Score__c, Special_Case__c, Comment__c, Scholar__r.Contact__r.Name from Vote__c where Scholar__r.HS_Year_Applied__c = :who AND Scholar__r.Status__c = 'Applied' AND OwnerId = :userId AND Score__c = Null Order by Scholar__r.Contact__r.LastName ];
    }

    public List<Vote__c> getDoneVotes() {
        return (List<Vote__c>) [Select id,Scholar__c, Score__c, Special_Case__c, Comment__c, Scholar__r.Contact__r.Name from Vote__c where Scholar__r.HS_Year_Applied__c = :who AND Scholar__r.Status__c = 'Applied' AND OwnerId = :userId AND Score__c != Null Order by Scholar__r.Contact__r.LastName ];
    }

    public PageReference castVote() {
        update currentVote;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Your score has been recorded'));
        scholar = null;
        currentVote = null;
        sid = null;
       // openVoteSet = null;
        //doneVoteSet = null;
        apCourses = null;
        satExams = null;
        hasAttachments = false;
        hasAPScores = false;
        hasSATScores = false;
        
        return null;
    }
    
    public List<Schema.FieldSetMember> getSeniorFields() {
        List<Schema.FieldSetMember> fsms = new List<Schema.FieldSetMember>();
        fsms.addAll(SObjectType.Scholar__c.FieldSets.SeniorsAcademics.getFields());
        fsms.addAll(SObjectType.Scholar__c.FieldSets.SeniorsFinance.getFields());
        fsms.addAll(SObjectType.Scholar__c.FieldSets.SeniorsRecommendation.getFields());
        fsms.addAll(SObjectType.Scholar__c.FieldSets.SeniorsSocial.getFields());
        return fsms;
    }

    public List<Schema.FieldSetMember> getJuniorFields() {
        List<Schema.FieldSetMember> fsms = new List<Schema.FieldSetMember>();
        fsms.addAll(SObjectType.Scholar__c.FieldSets.JuniorsAcademics.getFields());
        fsms.addAll(SObjectType.Scholar__c.FieldSets.JuniorsFinances.getFields());
        fsms.addAll(SObjectType.Scholar__c.FieldSets.JuniorsRecommendation.getFields());
        fsms.addAll(SObjectType.Scholar__c.FieldSets.JuniorsSocial.getFields());
        return fsms;
    }

    public PageReference updateScholar() {
        sid = System.currentPageReference().getParameters().get('sid');
                         
        if (sid != null) {
            scholar = getScholarRecord(sid);
            currentVote = scholar.Votes__r[0];
            System.debug('Attachment count: ' + scholar.ContentDocumentLinks.size());
            apCourses = getCourses(scholar.Contact__c);
            System.debug('Course count: ' + apCourses.size());
            satExams = getExams(scholar.Contact__c);
            System.debug('Exam count: ' + satExams.size());
            
            hasAttachments = scholar.ContentDocumentLinks.size() > 0;
            hasAPScores = apCourses.size() > 0;
            hasSATScores = satExams.size() > 0;
        }
        
        return null;
    }

    private Scholar__c getScholarRecord(String sid) {
        String query = 'Select ';
        for(Schema.FieldSetMember f : fieldset) {
            query += f.getFieldPath() + ', ';
        }
        
        query += 'Id, Name, Contact__c, ';
        query += '(Select v.Id, v.Scholar__c, v.Score__c, v.Special_Case__c, v.Comment__c, v.Scholar__r.Contact__r.Name,v.Scholar__r.Contact__r.Gender__c,v.Scholar__r.C4G_Contact_City_and_State__c,v.Scholar__r.Contact__r.Region__c,v.Scholar__r.Ethnicity_Race_Text__c,v.Scholar__r.Family_Income__c From Votes__r v Where OwnerId = :userId), ';
        query += '(SELECT Id, Description, Subject FROM ActivityHistories ORDER BY ActivityDate ASC NULLS LAST, LastModifiedDate DESC LIMIT 50), ';
        query += '(select id,ContentDocument.title,ContentDocumentId,ContentDocument.LatestPublishedVersionId from ContentDocumentLinks) FROM Scholar__c Where Id = :sid'; 

        return Database.query(query);
    }
        
    private static List<AP_Course__c> getCourses(Id contId) {
        return [Select Id, Course__c, Score__c, Will_Take_E__c From AP_Course__c Where Contact__c = :contId];
    }
    
    private static List<SAT_II_Exams__c> getExams(Id contId) {
        return [Select Id, Subject__c, Score__c From SAT_II_Exams__c Where Contact__c = :contId];
    }

}