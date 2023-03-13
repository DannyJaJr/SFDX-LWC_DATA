/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_Transcript_CoursesTest
{
    @IsTest
    private static void testTrigger()
    {
        // Force the dlrs_Transcript_CoursesTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new Transcript_Courses__c());
    }
}