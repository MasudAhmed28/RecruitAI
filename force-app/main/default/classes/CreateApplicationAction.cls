public with sharing class CreateApplicationAction {

    public class Request {

        @InvocableVariable(label='Candidate ID' description='Salesforce Record ID of the Candidate' required=true)
        public String candidateId;

        @InvocableVariable(label='Job ID' description='Salesforce Record ID of the Job' required=true)
        public String jobId;

        @InvocableVariable(label='Match Score' description='AI generated match score out of 100' required=false)
        public Decimal matchScore;

        @InvocableVariable(label='AI Summary' description='AI reasoning for the match score' required=false)
        public String aiSummary;

        @InvocableVariable(label='Recruiter Notes' description='Additional notes from the recruiter' required=false)
        public String recruiterNotes;

        @InvocableVariable(label='Status' description='Application status (e.g., Applied, Shortlisted)' required=false)
        public String status;
    }

    public class Result {

        @InvocableVariable(label='Application ID' description='Salesforce Record ID of the created Application')
        public String applicationId;

        @InvocableVariable(label='Application Number' description='Auto-number identifier (e.g., APP-00001)')
        public String applicationNumber;

        @InvocableVariable(label='Is Success' description='True if the application was created successfully')
        public Boolean isSuccess;

        @InvocableVariable(label='Message' description='Status or error message')
        public String message;
    }

    @InvocableMethod(label='Create Application' description='Create an Application linking a Candidate to a Job.' category='Recruitment')
    public static List<Result> createApplication(
        List<Request> requests
    ) {

        List<Result> results = new List<Result>();

        if (requests == null || requests.isEmpty()) {
            return results;
        }

        Request req = requests[0];
        Result result = new Result();

        if (String.isBlank(req.candidateId)) {
            result.isSuccess = false;
            result.message = 'Candidate ID is required.';
            results.add(result);
            return results;
        }

        if (String.isBlank(req.jobId)) {
            result.isSuccess = false;
            result.message = 'Job ID is required.';
            results.add(result);
            return results;
        }

        try {

            Application__c application =
                new Application__c();

            application.Candidate__c = req.candidateId;
            application.Job__c = req.jobId;
            application.Match_Score__c = req.matchScore;
            application.AI_Summary__c = req.aiSummary;
            application.Recruiter_Notes__c = req.recruiterNotes;

            if (String.isNotBlank(req.status)) {
                application.Status__c = req.status;
            } else {
                application.Status__c = 'Applied';
            }

            application.Applied_Date__c = Date.today();

            insert application;

            Application__c createApplication=[SELECT Id,Name FROM Application__c WHERE Id=:application.Id LIMIT 1];

            result.isSuccess = true;
            result.applicationId = createApplication.Id;
            result.applicationNumber = createApplication.Name;
            result.message =
                'Application created successfully.';

        } catch (DmlException e) {

            result.isSuccess = false;
            result.message = e.getDmlMessage(0);
        }

        results.add(result);

        return results;
    }
}
