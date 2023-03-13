public with sharing class VotingSetupController {
	
	public Boolean votingEnabled {get; set;}
	public String votingFor {get; set;}
	public Integer juniorCount {get; set;}
	public Integer seniorCount {get; set;}
	public String classyear {get;set;}
	
	private Map<Id, Voter> voters;
	private Voting__c settings;
	
	private final String votingForJuniors = 'Voting for junior year applicants is enabled';
	private final String votingForSeniors = 'Voting for senior year applicants is enabled';
	private final String votingDisabled = 'Voting is currently disabled';
		
	public VotingSetupController() {
		settings = Voting__c.getOrgDefaults();
		
		if (settings.Seniors_Enabled__c) {
			votingFor = votingForSeniors;
			classyear = 'Senior';
			votingEnabled = true;
		} else if (settings.Juniors_Enabled__c) {
			votingFor = votingForJuniors;
			classyear = 'Junior';
			votingEnabled = true;
		} else {
			votingFor = votingDisabled;
			votingEnabled = false;		
		}

        seniorCount = [Select count() From Scholar__c Where Status__c = 'Applied' and HS_Year_Applied__c = 'Senior'];
		juniorCount = [Select count() From Scholar__c Where Status__c = 'Applied' and HS_Year_Applied__c = 'Junior'];

		createVoterList(); 
		
		if (votingEnabled) {
			getVoteCount();
		}
	}
	
	// set up voting for the selected voters
	public PageReference enableVoting() {
		List<Vote__c> votes = new List<Vote__c>();
		List<Id> voterIds = getVoters();
		System.debug('Setting up voting records for ' + classyear + ' class for ' + voterIds.size());

        List<Scholar__c> applicants = [Select Id, (Select OwnerId From Votes__r) 
		                               From Scholar__c 
		                               Where Status__c = 'Applied' 
		                               and HS_Year_Applied__c = :classyear];
				
		System.debug('Selected ' + applicants.size() + ' scholars');
        
        for (Scholar__c s : applicants) {
			// get voters who have already been set up for this application
			Set<Id> existing = new Set<Id>();

            if (s.votes__r.size() > 0) {
				for (Vote__c vote : s.votes__r) existing.add(vote.OwnerId);
			}
			
			for (Id vid : voterIds) {
				if (existing.size() == 0 || !existing.contains(vid)) {
                    Voter v = voters.get(vid);
                    System.debug('Adding vote for ' + v.userinfo.Name);
					votes.add(new Vote__c(Scholar__c = s.Id, OwnerId = vid));
                }
			}
		}
		
		insert votes;
		
		// set the flags
		if (classyear == 'Senior') {
			votingFor = votingForSeniors;
			votingEnabled = true;
			settings.Seniors_Enabled__c = true;
		} else if (classyear == 'Junior') {
			votingFor = votingForJuniors;
			votingEnabled = true;
			settings.Juniors_Enabled__c = true;
		}

		update settings;

		getVoteCount();
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Voting has been enabled for ' + classyear.toLowerCase() + 's.'));
		return null;
	}
	
	public PageReference disableVoting() {
		votingFor = votingDisabled;
		votingEnabled = false;
		settings.Seniors_Enabled__c = false;
		settings.Juniors_Enabled__c = false;
		update settings;
		
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Voting has been disabled.'));
		return null;
	}
	
	public PageReference tally() {
		// get the current applicant records
		List<Scholar__c> applicants = [Select Id, Votes_Score__c, Votes_Requested__c, Votes_Cast__c, 
	                                          Contact__r.Name, HS_Year_Applied__c,
	                                          (Select Score__c From Votes__r)
		                               From Scholar__c 
		                               Where Status__c = 'Applied'];
		
		// count the votes
		for (Scholar__c scholar : applicants) {
			scholar.Votes_Requested__c = scholar.Votes__r.size();
			Integer votes_cast = 0;
			Double score = 0.00;
			for (Vote__c vote : scholar.Votes__r) {
				if (vote.Score__c != null) {
					votes_cast = votes_cast + 1;
					score = score + vote.Score__c;
				}
			}
			
			scholar.Votes_Cast__c = votes_cast;
			scholar.Votes_Score__c = score;
		} 
		
		update applicants;
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Votes for the current applicants have been tallyed.'));
		
		return null;
	}
	
	public PageReference exit() {
		return new PageReference('/');
	}
	
	// set the voting status for each active voter, reflecting the number of votes requested and provided
	public void setVoterStatus(List<Vote__c> votes) {
		resetVoteCount();
        
        for (Vote__c vote : votes) {
			if (voters.containsKey(vote.OwnerId)) {
				Voter v = voters.get(vote.OwnerId);
				v.requested = v.requested + 1;
				if (vote.Score__c != null) v.votes = v.votes + 1;
			} else {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'A voting record has been found for a user that is not currently eligible for voting'));
			}
		}
	}

	// returns the list of potential voters
	public List<Voter> getVoterList() {
		List<Voter> result = voters.values();
        result.sort();
        return result;
	}
    
    private void resetVoteCount() {
        for (Voter v : voters.values()) {
            v.requested = 0;
            v.votes = 0;
        }
    }
	
	private void getVoteCount() {
		String who = 'Senior';
		if (votingFor == votingForJuniors) {
			who = 'Junior';
		}

		setVoterStatus([Select v.OwnerId, v.Score__c, v.Scholar__c, v.Id 
		                From Vote__c v 
		                Where v.Scholar__r.HS_Year_Applied__c = :who
	                    And v.Scholar__r.Status__c = 'Applied']);
	}

	// returns a list of the selected user ids
	private List<Id> getVoters() {
		List<Id> ids = new List<Id>();
		
		for (Voter v : voters.values()) {
			if (v.selected) {
				ids.add(v.userinfo.Id);
                System.debug(v.userinfo.Name + ' is a voter');
			}
		}
		
		return ids;
	}
	
	// get active users with selected license types as potential voters
	private void createVoterList() {
		List<UserLicense> licenses = [Select Id From UserLicense Where LicenseDefinitionKey in ('FDC_ONE','SFDC','SSP','POWER_SSP')];
		 List<Profile> profiles = new  List<Profile>();
		if (!Test.IsRunningTest())
		    profiles = [Select Id From Profile Where UserLicenseId in :licenses];
		else
		    profiles = [Select Id From Profile where Name = 'System Administrator'];
		List<User> users  = [Select Id, Name, Lastname, UserType, ProfileId From User Where IsActive = TRUE and ProfileId in :profiles Order by LastName];
		voters = new Map<Id,Voter>();
		
		for (User u : users) {
			voters.put(u.Id, new Voter(u));
		}
	}
	
	// wrapper class for voters and potential voters
	public class Voter implements Comparable {
		public User userinfo {get; set;}
		public Integer requested {get;set;}
		public Integer votes {get;set;}
        public Boolean selected {get; set;}
		
		public voter(User u) {
			System.debug('Adding voter for >>>>' + u.Name);
            userinfo = u;
			selected = false;
			requested = 0;
			votes = 0;
		}
        
		public Integer pctComplete {
			get { 
				if (requested > 0) {
					return Math.round(votes/requested) * 100; 
				} else {
					return 0;
				}
			}
		}
        
        public Integer compareTo(Object sobj) {
            Voter v = (Voter) sobj;
            if (v.userinfo.Id == userinfo.Id) return 0;
            if (v.userinfo.LastName < userinfo.LastName) return 1;
            return -1;
        }
	}
}