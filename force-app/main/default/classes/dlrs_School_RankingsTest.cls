/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_School_RankingsTest
{
    @IsTest
    private static void testTrigger()
    {
        // Force the dlrs_School_RankingsTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new School_Rankings__c());
    }
}