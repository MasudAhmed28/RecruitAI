@IsTest
private class CreateCandidateActionTest {

    @IsTest
    static void testCreateCandidate_Success() {
        CreateCandidateAction.Request req = new CreateCandidateAction.Request();
        req.fullName = 'John Doe';
        req.email = 'john.doe@example.com';
        req.phone = '1234567890';
        req.location = 'New York';
        req.skills = 'Apex, LWC';
        req.yearsOfExperience = 4;
        req.currentRole = 'Developer';
        req.education = 'B.S. Computer Science';
        req.certifications = 'Salesforce Developer I';
        req.resumeSummary = 'Strong developer';

        Test.startTest();
        List<CreateCandidateAction.Result> results = CreateCandidateAction.createCandidate(new List<CreateCandidateAction.Request>{req});
        Test.stopTest();

        System.assertEquals(1, results.size());
        System.assertEquals(true, results[0].isSuccess);
        System.assertNotEquals(null, results[0].candidateId);
        System.assertNotEquals(null, results[0].candidateNumber);
        
        Candidate__c c = [SELECT Id, Full_Name__c, Email__c FROM Candidate__c WHERE Id = :results[0].candidateId];
        System.assertEquals('John Doe', c.Full_Name__c);
    }
    
    @IsTest
    static void testCreateCandidate_MissingRequiredFields() {
        CreateCandidateAction.Request req1 = new CreateCandidateAction.Request();
        req1.fullName = ''; // Missing full name
        req1.email = 'john.doe@example.com';
        
        CreateCandidateAction.Request req2 = new CreateCandidateAction.Request();
        req2.fullName = 'John Doe';
        req2.email = ''; // Missing email
        
        Test.startTest();
        List<CreateCandidateAction.Result> results1 = CreateCandidateAction.createCandidate(new List<CreateCandidateAction.Request>{req1});
        List<CreateCandidateAction.Result> results2 = CreateCandidateAction.createCandidate(new List<CreateCandidateAction.Request>{req2});
        Test.stopTest();

        System.assertEquals(false, results1[0].isSuccess);
        System.assertEquals('Candidate Full Name is required.', results1[0].message);
        
        System.assertEquals(false, results2[0].isSuccess);
        System.assertEquals('Candidate Email is required.', results2[0].message);
    }
    
    @IsTest
    static void testCreateCandidate_EmptyRequest() {
        Test.startTest();
        List<CreateCandidateAction.Result> results = CreateCandidateAction.createCandidate(new List<CreateCandidateAction.Request>());
        Test.stopTest();
        
        System.assertEquals(0, results.size());
    }
}
