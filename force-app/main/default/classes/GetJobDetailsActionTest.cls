@IsTest
private class GetJobDetailsActionTest {

    @TestSetup
    static void setup() {
        Job__c j = new Job__c(
            Title__c = 'Software Engineer',
            Location__c = 'Seattle, WA',
            Status__c = 'Open',
            Skills_Required__c = 'Apex, Java',
            Minimum_Experience__c = 3,
            Employment_Type__c = 'Full-Time',
            Description__c = 'Great job'
        );
        insert j;
    }

    @IsTest
    static void testGetJobDetails_Success() {
        Job__c j = [SELECT Id, Name FROM Job__c LIMIT 1];
        
        GetJobDetailsAction.Request req = new GetJobDetailsAction.Request();
        req.jobNumber = j.Name;
        
        Test.startTest();
        List<GetJobDetailsAction.Result> results = GetJobDetailsAction.getJobDetails(new List<GetJobDetailsAction.Request>{req});
        Test.stopTest();
        
        System.assertEquals(1, results.size());
        System.assertEquals(j.Id, results[0].jobId);
        System.assertEquals('Software Engineer', results[0].jobTitle);
    }
    
    @IsTest
    static void testGetJobDetails_NotFound() {
        GetJobDetailsAction.Request req = new GetJobDetailsAction.Request();
        req.jobNumber = 'JOB-99999';
        
        Test.startTest();
        List<GetJobDetailsAction.Result> results = GetJobDetailsAction.getJobDetails(new List<GetJobDetailsAction.Request>{req});
        Test.stopTest();
        
        System.assertEquals(1, results.size());
        System.assertNotEquals(null, results[0].message);
        System.assertEquals(null, results[0].jobId);
    }

    @IsTest
    static void testGetJobDetails_EmptyRequest() {
        Test.startTest();
        List<GetJobDetailsAction.Result> results = GetJobDetailsAction.getJobDetails(new List<GetJobDetailsAction.Request>());
        Test.stopTest();
        
        System.assertEquals(0, results.size());
    }
}
