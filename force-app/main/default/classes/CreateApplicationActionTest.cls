@IsTest
private class CreateApplicationActionTest {

    @TestSetup
    static void setup() {
        Job__c j = new Job__c(
            Title__c = 'Software Engineer',
            Location__c = 'Seattle, WA',
            Status__c = 'Open',
            Minimum_Experience__c = 3
        );
        insert j;
        
        Candidate__c c = new Candidate__c(
            Full_Name__c = 'Jane Doe',
            Email__c = 'jane@example.com'
        );
        insert c;
    }

    @IsTest
    static void testCreateApplication_Success() {
        Job__c j = [SELECT Id FROM Job__c LIMIT 1];
        Candidate__c c = [SELECT Id FROM Candidate__c LIMIT 1];
        
        CreateApplicationAction.Request req = new CreateApplicationAction.Request();
        req.jobId = j.Id;
        req.candidateId = c.Id;
        req.matchScore = 85;
        req.aiSummary = 'Good match';
        req.status = 'Applied';

        Test.startTest();
        List<CreateApplicationAction.Result> results = CreateApplicationAction.createApplication(new List<CreateApplicationAction.Request>{req});
        Test.stopTest();

        System.assertEquals(1, results.size());
        System.assertEquals(true, results[0].isSuccess);
        System.assertNotEquals(null, results[0].applicationId);
        System.assertNotEquals(null, results[0].applicationNumber);
        
        Application__c app = [SELECT Id, Job__c, Candidate__c, Status__c FROM Application__c WHERE Id = :results[0].applicationId];
        System.assertEquals(j.Id, app.Job__c);
        System.assertEquals(c.Id, app.Candidate__c);
        System.assertEquals('Applied', app.Status__c);
    }
    
    @IsTest
    static void testCreateApplication_MissingRequiredFields() {
        Job__c j = [SELECT Id FROM Job__c LIMIT 1];
        Candidate__c c = [SELECT Id FROM Candidate__c LIMIT 1];
        
        CreateApplicationAction.Request req1 = new CreateApplicationAction.Request();
        req1.candidateId = c.Id;
        // Missing Job ID
        
        CreateApplicationAction.Request req2 = new CreateApplicationAction.Request();
        req2.jobId = j.Id;
        // Missing Candidate ID
        
        Test.startTest();
        List<CreateApplicationAction.Result> results1 = CreateApplicationAction.createApplication(new List<CreateApplicationAction.Request>{req1});
        List<CreateApplicationAction.Result> results2 = CreateApplicationAction.createApplication(new List<CreateApplicationAction.Request>{req2});
        Test.stopTest();

        System.assertEquals(false, results1[0].isSuccess);
        System.assertEquals('Job ID is required.', results1[0].message);
        
        System.assertEquals(false, results2[0].isSuccess);
        System.assertEquals('Candidate ID is required.', results2[0].message);
    }
    
    @IsTest
    static void testCreateApplication_EmptyRequest() {
        Test.startTest();
        List<CreateApplicationAction.Result> results = CreateApplicationAction.createApplication(new List<CreateApplicationAction.Request>());
        Test.stopTest();
        
        System.assertEquals(0, results.size());
    }
}
