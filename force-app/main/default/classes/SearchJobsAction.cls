public with sharing class SearchJobsAction {

    public class Request {
        @InvocableVariable(label='Location' description='City, state, or location keywords' required=false)
        public String location;

        @InvocableVariable(label='Job Title' description='Job title keywords' required=false)
        public String jobTitle;

        @InvocableVariable(label='Skills' description='Keywords for required skills' required=false)
        public String skills;

        @InvocableVariable(label='Minimum Experience' description='Maximum allowed minimum experience in years' required=false)
        public Decimal minimumExperience;

        @InvocableVariable(label='Employment Type' description='E.g., Full-Time, Part-Time, Contract, Internship' required=false)
        public String employmentType;

        @InvocableVariable(label='Status' description='Job status to filter by (e.g., Open, Closed)' required=false)
        public String status;
    }

    public class JobResult {
        @InvocableVariable(label='Job ID' description='Salesforce Record ID of the Job')
        public String jobId;

        @InvocableVariable(label='Job Number' description='Auto-number identifier (e.g., JOB-00001)')
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

        @InvocableVariable(label='Employment Type' description='Type of employment (e.g., Full-Time)')
        public String employmentType;

        @InvocableVariable(label='Job Description' description='Full description of the Job')
        public String jobDescription;
    }

    @InvocableMethod(label='Search Jobs' description='Search Salesforce Jobs using recruiter-provided criteria such as location, skills, title, and experience.' category='Recruitment')
    public static List<JobResult> searchJobs(List<Request> requests) {

        List<JobResult> results = new List<JobResult>();

        if (requests == null || requests.isEmpty()) {
            return results;
        }

        Request req = requests[0];

        List<String> conditions = new List<String>();

        if (String.isNotBlank(req.location)) {
            conditions.add(
                'Location__c LIKE \'%' +
                String.escapeSingleQuotes(req.location) +
                '%\''
            );
        }

        if (String.isNotBlank(req.jobTitle)) {
            conditions.add(
                'Title__c LIKE \'%' +
                String.escapeSingleQuotes(req.jobTitle) +
                '%\''
            );
        }

        if (req.minimumExperience != null) {
            conditions.add(
                'Minimum_Experience__c <= ' +
                String.valueOf(req.minimumExperience)
            );
        }

        if (String.isNotBlank(req.employmentType)) {
            conditions.add(
                'Employment_Type__c = \'' +
                String.escapeSingleQuotes(req.employmentType) +
                '\''
            );
        }

        if (String.isNotBlank(req.status)) {
            conditions.add(
                'Status__c = \'' +
                String.escapeSingleQuotes(req.status) +
                '\''
            );
        }

        String query =
            'SELECT Id, Name, ' +
            'Title__c, ' +
            'Location__c, ' +
            'Status__c, ' +
            'Skills_Required__c, ' +
            'Minimum_Experience__c, ' +
            'Employment_Type__c, ' +
            'Description__c ' +
            'FROM Job__c';

        if (!conditions.isEmpty()) {
            query += ' WHERE ' + String.join(conditions, ' AND ');
        }

        query += ' ORDER BY CreatedDate DESC LIMIT 50';

        for (Job__c job : Database.query(query)) {
            
            if (String.isNotBlank(req.skills)) {
                if (job.Skills_Required__c == null || !job.Skills_Required__c.containsIgnoreCase(req.skills)) {
                    continue;
                }
            }

            JobResult result = new JobResult();

            result.jobId = job.Id;
            result.jobNumber = job.Name;
            result.jobTitle = job.Title__c;
            result.location = job.Location__c;
            result.status = job.Status__c;
            result.requiredSkills = job.Skills_Required__c;
            result.minimumExperience = job.Minimum_Experience__c;
            result.employmentType = job.Employment_Type__c;
            result.jobDescription = job.Description__c;

            results.add(result);
        }

        return results;
    }
}
