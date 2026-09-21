public with sharing class GetJobDetailsAction {

    public class Request {
        @InvocableVariable(label='Job Number' description='The exact Job Number (e.g., JOB-00001)' required=true)
        public String jobNumber;
    }

    public class Result {
        @InvocableVariable(label='Job ID' description='Salesforce Record ID of the Job')
        public String jobId;

        @InvocableVariable(label='Job Number' description='Auto-number identifier')
        public String jobNumber;

        @InvocableVariable(label='Job Title' description='Title of the Job')
        public String jobTitle;

        @InvocableVariable(label='Location' description='Job location')
        public String location;

        @InvocableVariable(label='Status' description='Current status of the Job')
        public String status;

        @InvocableVariable(label='Required Skills' description='Skills required for the Job')
        public String requiredSkills;

        @InvocableVariable(label='Minimum Experience' description='Minimum years of experience required')
        public Decimal minimumExperience;

        @InvocableVariable(label='Employment Type' description='Type of employment')
        public String employmentType;

        @InvocableVariable(label='Job Description' description='Full description of the Job')
        public String jobDescription;

        @InvocableVariable(label='Message' description='Status or error message')
        public String message;
    }

    @InvocableMethod(label='Get Job Details' description='Retrieve a Salesforce Job using its exact Job Number to get its full description and requirements.' category='Recruitment')
    public static List<Result> getJobDetails(List<Request> requests) {

        List<Result> results = new List<Result>();

        if (requests == null || requests.isEmpty()) {
            return results;
        }

        Request req = requests[0];
        Result result = new Result();

        if (String.isBlank(req.jobNumber)) {
            result.message = 'Job Number is required.';
            results.add(result);
            return results;
        }

        List<Job__c> jobs = [
            SELECT
                Id,
                Name,
                Title__c,
                Location__c,
                Status__c,
                Skills_Required__c,
                Minimum_Experience__c,
                Employment_Type__c,
                Description__c
            FROM Job__c
            WHERE Name = :req.jobNumber
            LIMIT 1
        ];

        if (jobs.isEmpty()) {
            result.message =
                'No Job was found with Job Number ' +
                req.jobNumber + '.';

            results.add(result);
            return results;
        }

        Job__c job = jobs[0];

        result.jobId = job.Id;
        result.jobNumber = job.Name;
        result.jobTitle = job.Title__c;
        result.location = job.Location__c;
        result.status = job.Status__c;
        result.requiredSkills = job.Skills_Required__c;
        result.minimumExperience = job.Minimum_Experience__c;
        result.employmentType = job.Employment_Type__c;
        result.jobDescription = job.Description__c;
        result.message = 'Job retrieved successfully.';

        results.add(result);

        return results;
    }
}
