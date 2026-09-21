@IsTest
private class SearchJobsActionTest {
    
    @TestSetup
    static void setup() {
        Job__c j1 = new Job__c(
            Title__c = 'Software Engineer',
            Location__c = 'Seattle, WA',
            Status__c = 'Open',
            Skills_Required__c = 'Apex, Java',
            Minimum_Experience__c = 3,
            Employment_Type__c = 'Full-Time',
            Description__c = 'Great job'
        );
        Job__c j2 = new Job__c(
            Title__c = 'Product Manager',
            Location__c = 'Remote',
            Status__c = 'Closed',
            Skills_Required__c = 'Agile, Scrum',
            Minimum_Experience__c = 5,
            Employment_Type__c = 'Contract',
            Description__c = 'Also great job'
        );
        insert new List<Job__c>{j1, j2};
    }
    
    @IsTest
    static void testSearchJobs_NoFilters() {
        SearchJobsAction.Request req = new SearchJobsAction.Request();
        
        Test.startTest();
        List<SearchJobsAction.JobResult> results = SearchJobsAction.searchJobs(new List<SearchJobsAction.Request>{req});
        Test.stopTest();
        
        System.assertEquals(2, results.size(), 'Should return all jobs when no filters are applied.');
    }

    @IsTest
    static void testSearchJobs_WithFilters() {
        SearchJobsAction.Request req = new SearchJobsAction.Request();
        req.location = 'Seattle';
        req.jobTitle = 'Engineer';
        req.skills = 'Apex';
        req.minimumExperience = 4;
        req.employmentType = 'Full-Time';
        req.status = 'Open';
        
        Test.startTest();
        List<SearchJobsAction.JobResult> results = SearchJobsAction.searchJobs(new List<SearchJobsAction.Request>{req});
        Test.stopTest();
        
        System.assertEquals(1, results.size(), 'Should return only the matching job.');
        System.assertEquals('Software Engineer', results[0].jobTitle);
    }
    
    @IsTest
    static void testSearchJobs_EmptyRequest() {
        Test.startTest();
        List<SearchJobsAction.JobResult> results = SearchJobsAction.searchJobs(new List<SearchJobsAction.Request>());
        Test.stopTest();
        
        System.assertEquals(0, results.size(), 'Should return empty list for empty request.');
    }
}
