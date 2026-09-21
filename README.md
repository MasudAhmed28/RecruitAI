# RCAI — Recruitment AI Platform

RCAI is an AI-powered recruitment platform built on **Salesforce Agentforce**, **Salesforce Prompt Builder**, **Apex**, and the **Model Context Protocol (MCP)**.

It enables recruiters to interact with Salesforce recruitment data through a conversational AI interface such as Claude.

## 🚀 Overview

RCAI connects an external AI assistant with Salesforce Agentforce through MCP.

```text
Claude
  │
  │ OAuth / MCP
  ▼
RCAI MCP Server
  │
  ▼
RCAI Agentforce Agent
  │
  ├── Agentforce Topics
  ├── Apex Actions
  └── Prompt Builder
  │
  ▼
Salesforce
(System of Record)
```

The project demonstrates how **MCP + Agentforce + Generative AI** can provide a conversational interface for Salesforce recruitment workflows.

## 📊 Data Model

RCAI uses three core Salesforce custom objects:

```text
Candidate__c  1 ────────<  Application__c  >──────── 1  Job__c
```

### Job__c

| Field | Description |
|---|---|
| `Name` | Job Number |
| `Job_Title__c` | Job title |
| `Location__c` | Job location |
| `Status__c` | Open / Closed / On Hold |
| `Required_Skills__c` | Required skills |
| `Minimum_Experience__c` | Minimum required experience |
| `Employment_Type__c` | Employment type |
| `Job_Description__c` | Job description |

### Candidate__c

| Field | Description |
|---|---|
| `Name` | Candidate Number |
| `Full_Name__c` | Candidate name |
| `Email__c` | Email address |
| `Phone__c` | Phone number |
| `Location__c` | Candidate location |
| `Skills__c` | Candidate skills |
| `Years_of_Experience__c` | Total experience |
| `Current_Most_Recent_Role__c` | Current/recent role |
| `Education__c` | Education |
| `Certifications__c` | Certifications |
| `Resume_Summary__c` | Resume summary |

### Application__c

| Field | Description |
|---|---|
| `Name` | Application Number |
| `Candidate__c` | Candidate relationship |
| `Job__c` | Job relationship |
| `Match_Score__c` | AI-generated match score |
| `AI_Summary__c` | AI-generated assessment |
| `Recruiter_Notes__c` | Recruiter notes |
| `Status__c` | Application status |
| `Applied_Date__c` | Application date |

Application statuses:

`Applied`, `Under Review`, `Shortlisted`, `Interview`, `Rejected`, `Hired`, `Withdrawn`

## 🤖 Agentforce

```text
RCAI
│
├── Job Search
│   └── Search Jobs
│
├── Job Matching
│   ├── Get Job Details
│   └── Match Resume to Job
│
├── Resume Analysis
│   └── Analyze Candidate Resume
│
├── Candidate Management
│   └── Create Candidate
│
└── Application Management
    ├── Create Candidate
    ├── Get Job Details
    └── Create Application
```

Agentforce handles intent recognition, topic selection, workflow orchestration, and Salesforce action execution.

## ⚡ Apex Actions

RCAI currently uses four primary Apex actions:

- **`SearchJobsAction`** — searches Salesforce Jobs using criteria such as title, location, skills, experience, employment type, and status.
- **`GetJobDetailsAction`** — retrieves a Salesforce Job using its Job Number.
- **`CreateCandidateAction`** — creates a Candidate record from structured candidate information produced by the AI workflow.
- **`CreateApplicationAction`** — creates an Application linking a Salesforce Candidate and Job using their actual Salesforce record IDs.

A Job Number such as `JOB-00001` is resolved to the Salesforce Job record and is never treated as a Salesforce record ID.

## 🧠 AI & Prompt Builder

RCAI uses Salesforce Prompt Builder for AI-driven resume analysis and candidate matching.

### Analyze Candidate Resume

Extracts:

- Full Name
- Email
- Phone
- Location
- Skills
- Years of Experience
- Current / Most Recent Role
- Education
- Certifications
- Projects
- Achievements
- Resume Summary

The workflow uses information explicitly provided in the resume and avoids inventing candidate information.

### Match Resume to Job

Compares a candidate profile against a Job and produces:

- Match Score
- Overall Match
- Key Strengths
- Key Gaps
- Experience Comparison
- Recommendation

```text
Candidate Profile
       +
Job Requirements
       │
       ▼
Prompt Builder
       │
       ▼
Recruiter Assessment
```

## 🔎 Recruitment Workflows

### Search Jobs

```text
Recruiter
   │
   ▼
Search open Software Engineer jobs
   │
   ▼
Job Search Topic
   │
   ▼
SearchJobsAction
   │
   ▼
Salesforce Jobs
```

### Analyze Resume

```text
Resume
   │
   ▼
Analyze Candidate Resume
   │
   ▼
Structured Candidate Profile
```

### Match Candidate to Job

```text
Job Number
    │
    ▼
Get Job Details
    │
    ▼
Salesforce Job
    │
    +
Candidate Profile
    │
    ▼
Match Resume to Job
    │
    ▼
Recruiter Assessment
```

### Create Candidate

```text
Candidate Information
        │
        ▼
CreateCandidateAction
        │
        ▼
Candidate__c
```

### Create Application

```text
Candidate Salesforce ID
          +
Job Salesforce ID
          +
Match Information
          │
          ▼
CreateApplicationAction
          │
          ▼
Application__c
```

## 🔌 MCP Integration

RCAI exposes the Agentforce recruiting experience through Salesforce MCP.

```text
Claude
  │
  │ OAuth
  ▼
Salesforce External Client App
  │
  ▼
Salesforce MCP
  │
  ▼
RCAI Agentforce Agent
  │
  ▼
Salesforce
```

MCP provides a standardized interface for connecting external AI clients with the RCAI Agentforce experience.

## 🔐 OAuth Configuration

An External Client App is used for OAuth authentication.

For a Claude MCP connection, the callback URL can be:

```text
https://claude.ai/api/mcp/auth_callback
```

MCP-related scopes used by the integration include:

```text
mcp_api
refresh_token
offline_access
```

The exact OAuth configuration may vary depending on the external MCP client.

## 🛠️ Setup

### Prerequisites

- Salesforce CLI
- Salesforce VS Code extensions
- Git
- Salesforce Developer Hub access
- Salesforce org with the required Agentforce capabilities

Verify Salesforce CLI:

```bash
sf --version
```

### 1. Authenticate with Dev Hub

```bash
sf org login web -d -a devhub
```

### 2. Create Scratch Org

```bash
sf org create scratch   -f config/project-scratch-def.json   -a rcai-scratch   -d
```

### 3. Deploy Metadata

```bash
sf project deploy start -o rcai-scratch
```

### 4. Assign Permission Set

If configured:

```bash
sf org assign permset   -n RCAI_Admin   -o rcai-scratch
```

### 5. Configure Agentforce

1. Open Salesforce Setup.
2. Open Agentforce.
3. Configure the RCAI agent.
4. Configure topics.
5. Configure Apex actions.
6. Configure Prompt Builder templates.
7. Activate the agent.

### 6. Configure MCP

1. Configure the RCAI MCP server in Salesforce.
2. Activate the server.
3. Configure the External Client App.
4. Configure OAuth.
5. Verify the MCP endpoint.

### 7. Connect Claude

Configure Claude using the Salesforce MCP endpoint and OAuth configuration.

Example:

```text
Search my Salesforce jobs for open Backend Engineer positions.
```

## 💬 Example End-to-End Conversation

```text
Recruiter:
Search my Salesforce jobs for open Software Engineer positions.

RCAI:
Here are the matching open positions...

Recruiter:
Tell me more about JOB-00001.

RCAI:
JOB-00001 is a Backend Software Engineer role...

Recruiter:
Analyze this resume.

RCAI:
Here is the extracted candidate profile...

Recruiter:
Match this candidate against JOB-00001.

RCAI:
Match Score: 80
...

Recruiter:
Create a candidate for this person.

RCAI:
Candidate created successfully: CAN-00005.

Recruiter:
Create an application for this candidate for JOB-00001.

RCAI:
Application created successfully: APP-00001.
```

## 🧰 Technology Stack

| Technology | Purpose |
|---|---|
| Salesforce | System of record |
| Agentforce | AI agent and workflow orchestration |
| Prompt Builder | Resume analysis and matching |
| Apex | Salesforce business actions |
| MCP | External AI ↔ Salesforce communication |
| Claude | External conversational interface |
| OAuth | Authentication |
| Salesforce Custom Objects | Recruitment data model |
| Salesforce DX | Development and deployment |

## 📦 Project Status

### MVP

- [x] Job data model
- [x] Candidate data model
- [x] Application data model
- [x] Job search
- [x] Job detail retrieval
- [x] Resume analysis
- [x] Resume-to-job matching
- [x] Candidate creation
- [x] Application creation
- [x] Agentforce orchestration
- [x] MCP integration
- [x] OAuth authentication
- [x] External AI client integration

## 🛣️ Roadmap

### Candidate Management

- Candidate search
- Candidate updates
- Duplicate detection
- Candidate pipeline management
- Candidate history

### Job Management

- Job creation
- Job updates
- Job closing
- Job requirement extraction

### AI Matching

- Semantic skill matching
- Improved experience matching
- Candidate-to-job matching
- Explainable matching
- Batch candidate matching

### Recruiter Productivity

- Interview preparation
- Interview scheduling
- Candidate summaries
- Recruiter notes
- Follow-up generation
- Candidate communication drafts

### Platform

- Additional MCP-compatible AI clients
- Salesforce managed package
- Customer-specific configuration
- Additional recruitment integrations

## 📁 Project Structure

```text
RCAI/
│
├── force-app/
│   └── main/
│       └── default/
│           ├── classes/
│           ├── objects/
│           ├── permissionsets/
│           └── ...
│
├── config/
│   └── project-scratch-def.json
│
├── scripts/
│
├── sfdx-project.json
├── README.md
└── .gitignore
```

## 🎥 Demo

The complete demo workflow:

```text
Claude
  │
  ├── Search Jobs
  ├── Get Job Details
  ├── Analyze Resume
  ├── Match Candidate
  ├── Create Candidate
  └── Create Application
          │
          ▼
      Salesforce
```

This demonstrates the complete workflow from:

**Job Discovery → Resume Analysis → Candidate Matching → Candidate Creation → Application Creation**

## 🤝 Contributing

Contributions and ideas are welcome.

Potential contribution areas include:

- Agentforce topics
- Apex actions
- Prompt improvements
- MCP integrations
- Salesforce data model improvements
- AI matching improvements
- Recruitment workflows

## 📄 License

This project is currently intended for development and demonstration purposes.

Add an appropriate open-source or commercial license before public distribution.

## 👨‍💻 Author

**Masud Ahmed**

Salesforce Developer | Agentforce | AI | MCP

---

## ⭐ Project Summary

**RCAI is an MCP-powered recruitment AI platform that connects external AI assistants with Salesforce Agentforce to provide conversational job search, resume analysis, candidate matching, candidate creation, and application management.**
