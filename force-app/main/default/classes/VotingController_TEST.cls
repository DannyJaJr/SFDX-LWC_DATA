@isTest
public class VotingController_TEST {
    
    public static List<VotingSetupController.Voter> voters;
    
    public static testmethod void testJuniors() {
        CreateTestData.create();
        CreateTestData.addVoters();
        Voting__c settings = new Voting__c();
        settings.Juniors_Enabled__c = false;
        settings.Seniors_Enabled__c = false;
        insert settings;
        
        voters = new List<VotingSetupController.Voter>();
        
        VotingSetupController setup = new VotingSetupController();
        System.assertEquals(setup.votingEnabled, false);
        System.assertNotEquals(null,setup.votingFor);
        System.assertEquals(3,setup.juniorCount);
        
        List<VotingSetupController.Voter> potential_voters = setup.getVoterList();
        System.assertNotEquals(null, potential_voters);
        System.assert(potential_voters.size() > 3);
        // enable 3 voters
        for (Integer i=0; i<3; i++) {
            VotingSetupController.Voter voter = potential_voters[i];
            voter.selected = true;
            voters.add(voter);
        }
        
        setup.classyear = 'Junior';
        setup.enableVoting();
        testVoting();
        setup.disableVoting();
        setup.tally();        
        
        List<Scholar__c> applicants = [Select Id, Votes_Score__c, Votes_Requested__c, Votes_Cast__c, 
                                       Contact__r.Name, HS_Year_Applied__c,
                                       (Select Score__c From Votes__r)
                                       From Scholar__c 
                                       Where Status__c = 'Applied'
                                       And HS_Year_Applied__c = 'Junior'];
        
        for (Scholar__c scholar : applicants) {
            System.assertEquals(1, scholar.Votes_Cast__c);
            System.assertEquals(1 * 3, scholar.Votes_Score__c);
        }
        
        setup.exit();
    }
    
    public static testmethod void testSeniors() {
        CreateTestData.create();
        CreateTestData.addVoters();
        Voting__c settings = new Voting__c();
        settings.Juniors_Enabled__c = false;
        settings.Seniors_Enabled__c = false;
        insert settings;
        
        voters = new List<VotingSetupController.Voter>();
        
        VotingSetupController setup = new VotingSetupController();
        System.assertEquals(setup.votingEnabled, false);
        System.assertNotEquals(null,setup.votingFor);
        System.assertEquals(3,setup.seniorCount);
        
        List<VotingSetupController.Voter> potential_voters = setup.getVoterList();
        System.assertNotEquals(null, potential_voters);
        System.assert(potential_voters.size() > 3);
        // enable 3 voters
        for (Integer i=0; i<3; i++) {
            VotingSetupController.Voter voter = potential_voters[i];
            voter.selected = true;
            voters.add(voter);
        }
        
        setup.classyear = 'Senior';
        setup.enableVoting();
        testVoting();
        setup.disableVoting();
        setup.tally();        
        
        List<Scholar__c> applicants = [Select Id, Votes_Score__c, Votes_Requested__c, Votes_Cast__c, 
                                       Contact__r.Name, HS_Year_Applied__c,
                                       (Select Score__c From Votes__r)
                                       From Scholar__c 
                                       Where Status__c = 'Applied'
                                       And HS_Year_Applied__c = 'Senior'];
        
        for (Scholar__c scholar : applicants) {
            System.assertEquals(1, scholar.Votes_Cast__c);
            System.assertEquals(1 * 3, scholar.Votes_Score__c);
        }
        
        setup.exit();
    }
    
    private static void testVoting() {        
        Profile adminProfile = [Select Id From Profile Where Name = 'System Administrator'];
        for (VotingSetupController.Voter v : voters) {
            System.debug('>>>>>>>>>>v.userinfo.ProfileId>>>>>>>>>>'+v.userinfo.ProfileId);
            if (v.userinfo.ProfileId == adminProfile.Id) {
                System.runAs(v.UserInfo) {
                    VotingController vc = new VotingController();
                    String current_user = vc.getCurrentUser();
                    System.assertEquals(current_user, v.UserInfo.Name + ' (' + v.UserInfo.Id + ')');
                    
                    List<Vote__c> ovote = vc.getOpenVotes();
                    Integer ovote_start = ovote.size();
                    
                    List<Vote__c> dvote = vc.getDoneVotes();
                    Integer dvote_start = dvote.size();
                    
                    System.assertNotEquals(null,vc.getSeniorFields());
                    System.assertNotEquals(null,vc.getJuniorFields());
                    Integer votes_cast = 0;
                    
                    for (Vote__c current : ovote) {
                        PageReference vc_page = Page.Voting;
                        Test.setCurrentPage(vc_page);
                        ApexPages.currentPage().getParameters().put('sid', current.Scholar__c);
                        vc = new VotingController();
                        vc.updateScholar();
                        System.assertEquals(true, vc.hasAPScores);
                        System.assertEquals(true, vc.hasSATScores);
                        
                        vc.currentVote.Score__c = 3;
                        vc.castVote();
                        votes_cast += 1;
                    }
                    
                    vc = new VotingController();
                    ovote = vc.getOpenVotes();
                    System.assertEquals(ovote_start - votes_cast, ovote.size());
                    dvote = vc.getDoneVotes();
                    System.assertEquals(dvote_start + votes_cast, dvote.size());
                }
                
                break;
            }
        }
    }
}