// Trigger on Meeting Request trigger to Match it With Event Object 
trigger meetingRequesttrigger on Meeting_Request__c (before insert) {
    if(trigger.isInsert && trigger.isBefore){        
      meetingRequesttriggerHandler.onBeforeInsert(Trigger.new);
    }    
}