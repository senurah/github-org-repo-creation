import ballerina/log;
import ballerina/http;

configurable string gitPAT = ?;
configurable string gitORG= ?;
configurable string NAME= ?;

public function main(string orgName, string repoName, string isPublic, string repoDesc, string enableIssues) returns error? {
    do {
        string org = orgName != "" ? orgName : gitORG;
        string repo = repoName !="" ? repoName : NAME;
        boolean isRepoPublic = isPublic == "true"? true: false;
        boolean hasIssues = enableIssues =="true"? true:false;

        string apirUrl = string `https://api.github.com/orgs/${org}/repos`;

        http:Client githubClient = check new(apirUrl);

        map<string> headers = {
            "Authorization": string `token ${gitPAT}`,
            "Accept":"application/vnd.github.v3+json"
        };

        json payload = {
            "name":repo,
            "private": !isRepoPublic,
            "description":repoDesc,
            "has_issues":hasIssues
        };

        http:Response response = check githubClient->post("",payload,headers);

        if(response.statusCode == 201){
            log:printInfo(string `Repository ${repo} created successfully.`);
            json responseBody = check response.getJsonPayload();
            log:printInfo("Details: "+responseBody.toString());
        }else{
            string errorText = check response.getTextPayload();
            log:printError(`Error occured while creating the Repository:${response.statusCode}`);
            log:printError(errorText);
            return error(string `Failed to create the repository : ${response.statusCode}`);
        }


    }on fail error e {
        log:printError("Error occurred", 'error = e);
        return e;
    }
}
