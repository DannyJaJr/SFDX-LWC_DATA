/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_caseman_ClientNoteTest
{
    @IsTest
    private static void testTrigger()
    {
        // Force the dlrs_caseman_ClientNoteTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new caseman__ClientNote__c());
    }
}