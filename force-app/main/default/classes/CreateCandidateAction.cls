public with sharing class CreateCandidateAction {

    public class Request {

        @InvocableVariable(label='Full Name' description='Candidate full name' required=true)
        public String fullName;

        @InvocableVariable(label='Email' description='Candidate email address' required=true)
        public String email;

        @InvocableVariable(label='Phone' description='Candidate phone number' required=false)
        public String phone;

        @InvocableVariable(label='Location' description='Candidate city, state, or location' required=false)
        public String location;

        @InvocableVariable(label='Skills' description='Comma-separated skills extracted from resume' required=false)
        public String skills;

        @InvocableVariable(label='Years of Experience' description='Total years of professional experience' required=false)
        public Decimal yearsOfExperience;

        @InvocableVariable(label='Current Role' description='Current or most recent job title' required=false)
        public String currentRole;

        @InvocableVariable(label='Education' description='Education history' required=false)
        public String education;

        @InvocableVariable(label='Certifications' description='Certifications held by candidate' required=false)
        public String certifications;

        @InvocableVariable(label='Resume Summary' description='AI-generated summary of the resume' required=false)
        public String resumeSummary;
    }

    public class Result {

        @InvocableVariable(label='Candidate ID' description='Salesforce Record ID of the created Candidate')
        public String candidateId;

        @InvocableVariable(label='Candidate Number' description='Auto-number identifier (e.g., CAN-00001)')
        public String candidateNumber;

        @InvocableVariable(label='Is Success' description='True if the candidate was created successfully')
        public Boolean isSuccess;

        @InvocableVariable(label='Message' description='Status or error message')
        public String message;
    }

    @InvocableMethod(label='Create Candidate' description='Create a Candidate record in Salesforce with information extracted from a resume.' category='Recruitment')
    public static List<Result> createCandidate(
        List<Request> requests
    ) {

        List<Result> results = new List<Result>();

        if (requests == null || requests.isEmpty()) {
            return results;
        }

        Request req = requests[0];
        Result result = new Result();

        if (String.isBlank(req.fullName)) {
            result.isSuccess = false;
            result.message = 'Candidate Full Name is required.';
            results.add(result);
            return results;
        }

        if (String.isBlank(req.email)) {
            result.isSuccess = false;
            result.message = 'Candidate Email is required.';
            results.add(result);
            return results;
        }

        Candidate__c candidate = new Candidate__c();
        candidate.Full_Name__c = req.fullName;
        candidate.Email__c = req.email;
        candidate.Phone__c = req.phone;
        candidate.Location__c = req.location;
        candidate.Skills__c = req.skills;
        candidate.Years_of_Experience__c = req.yearsOfExperience;
        candidate.Current_Most_Recent_Role__c = req.currentRole;
        candidate.Education__c = req.education;
        candidate.Certifications__c = req.certifications;
        candidate.Resume_Summary__c = req.resumeSummary;

        try {

            insert candidate;

            Candidate__c createdCandidate = [
                SELECT Id, Name
                FROM Candidate__c
                WHERE Id = :candidate.Id
                LIMIT 1
            ];

            result.isSuccess = true;
            result.candidateId = createdCandidate.Id;
            result.candidateNumber = createdCandidate.Name;
            result.message = 'Candidate created successfully.';

        } catch (DmlException e) {

            result.isSuccess = false;
            result.message = e.getDmlMessage(0);
        }

        results.add(result);

        return results;
    }
}
