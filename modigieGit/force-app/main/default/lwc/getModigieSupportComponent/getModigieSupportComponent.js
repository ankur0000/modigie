import { LightningElement, api, track } from 'lwc';
import MODIGIELOGO from '@salesforce/resourceUrl/ModigieLogo';
import getUsedServicesInfo from '@salesforce/apex/GetModigieSupportController.getUsedServicesInfo';
import getInformationofUser from '@salesforce/apex/GetModigieSupportController.getInformationofUser';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class GetModigieSupportComponent extends NavigationMixin(LightningElement) {
    @api recordid;
    GetPhoneInsightsSelected = false;
    modigieLogoUrl = MODIGIELOGO
    toggleSpinner = true;
    disableSubmit = true;
    @track serviceUsageMap = { "VerifyEmployer": true, "GetPhoneIntelligence": true, "GetLinkedIn": true, "GetModigie": true };
    @track labelColors = {};
    selectedService;
    selectedPhoneNumber = '';
    serviceSubmit = false;
    issueDescription = '';
    credentialsAvailable=false;



    connectedCallback() {
        getUsedServicesInfo({
            recId: this.recordid,
            objectType: 'Contact/Lead'
        }).then(result1 => {
            this.toggleSpinner = false;
            this.credentialsAvailable=true;
            this.serviceUsageMap = JSON.parse(result1);

            for (var property in this.serviceUsageMap) {
                if (this.serviceUsageMap.hasOwnProperty(property)) {
                    if (this.serviceUsageMap[property]) {
                        this.labelColors[property] = 'greyColor';
                    }
                }
            }

        }).catch(error1 => {
            const event = new ShowToastEvent({
                "title": "Error!",
                "message": error1.body.message,
                "variant": "error"
            });
            this.dispatchEvent(event); 
            this.closeModel();
        })
    }
    handleChange(event) {
        this.selectedPhoneNumber = '';
        this.selectedService = event.target.dataset.name;

        if (this.selectedService == 'GetPhoneIntelligence') {
            this.disableSubmit = false;
            //this.GetPhoneInsightsSelected = true;
        }
        else {
            this.disableSubmit = false;
            if (this.selectedService != 'Mobile' && this.selectedService != 'Phone' && this.selectedService != 'Other') {
                this.GetPhoneInsightsSelected = false;
            }
        }
    }

    handlePhoneChange(event) {
        if (this.selectedPhoneNumber.indexOf(event.target.dataset.name + ',') != -1) {
            this.selectedPhoneNumber = this.selectedPhoneNumber.replace(event.target.dataset.name + ',', '');
        }
        else {
            this.selectedPhoneNumber += event.target.dataset.name + ',';
        }

        this.disableSubmit = false;
        if (this.selectedPhoneNumber == '') {
            this.disableSubmit = true;
        }
        else {
            this.disableSubmit = false;
        }
    }
    closeModel() {
        const closeQA = new CustomEvent('close',{ detail: 'Called from get modigie support' });
        
        this.dispatchEvent(closeQA);
    }

    handleSubmit() {
        if (this.serviceSubmit) {
            getInformationofUser({
                recId: this.recordid,
                calledFrom: 'Contact/Lead'
            }).then(result1 => {



                //   var userinfo = 'User Information\nUser Name : '+uname+'\nUser Email : '+uemail+'\nUser Company : '+ucompany;





                var resultMap = JSON.parse(result1);


                var userInfo = resultMap.User;

                var userString = '\n\nUser Information\n\nUser Name : ' + userInfo.Username + '\nUser Email : ' + userInfo.Email + '\nUser Company : ' + userInfo.Email;

                //  var recordString = 'FirstName : '+fname+'\nLastName : '+lname+'\nEmail : '+email+'\nCompany : '+company+'\nLinkedin URL : '+linkedinUrl+'\nModigie Validated Mobile Contact Number : '+validatedNumber+'\nJob ID : '+Jobid+'\n\n'+userinfo;

                var modigieInfo = resultMap.Data;


                var recordString = '';
                if (modigieInfo.modigie__Contact__r != undefined) {

                    if (modigieInfo.modigie__Contact__r.FirstName == undefined) {
                        modigieInfo.modigie__Contact__r.FirstName = 'NA';
                    }
                    if (modigieInfo.modigie__Contact__r.LastName == undefined) {
                        modigie__Contact__r.LastName = 'NA';
                    }
                    if (modigieInfo.modigie__Contact__r.Email == undefined) {
                        modigieInfo.modigie__Contact__r.Email = 'NA';
                    }
                    if (modigieInfo.modigie__Contact__r.Account == undefined) {
                        modigieInfo.modigie__Contact__r.Account = { "Name": "NA" };
                    }

                    recordString = 'First Name : ' + modigieInfo.modigie__Contact__r.FirstName + '\nLast Name : ' + modigieInfo.modigie__Contact__r.LastName + '\nEmail : ' + modigieInfo.modigie__Contact__r.Email + '\nCompany : ' + modigieInfo.modigie__Contact__r.Account.Name;
                }

                else if (modigieInfo.modigie__Lead__r != undefined) {
                    if (modigieInfo.modigie__Lead__r.FirstName == undefined) {
                        modigieInfo.modigie__Lead__r.FirstName = 'NA';
                    }
                    if (modigieInfo.modigie__Lead__r.LastName == undefined) {
                        modigieInfo.modigie__Lead__r.LastName = 'NA';
                    }
                    if (modigieInfo.modigie__Lead__r.Email == undefined) {
                        modigieInfo.modigie__Lead__r.Email = 'NA';
                    }
                    if (modigieInfo.modigie__Lead__r.Company == undefined) {
                        modigieInfo.modigie__Lead__r.Company = "NA";
                    }
                    recordString = 'First Name : ' + modigieInfo.modigie__Lead__r.FirstName + '\nLast Name : ' + modigieInfo.modigie__Lead__r.LastName + '\nEmail : ' + modigieInfo.modigie__Lead__r.Email + '\nCompany : ' + modigieInfo.modigie__Lead__r.Company;
                }

                var subject = 'Modigie support request from ' + userInfo.Name + ' for Job \'';


                if (this.selectedService == 'GetModigieMobile') {
                    if (modigieInfo.modigie__Modigie_Validated_Mobile_Contact_Number__c == undefined) {
                        modigieInfo.modigie__Modigie_Validated_Mobile_Contact_Number__c = 'NA';
                    }
                    if (modigieInfo.modigie__JOB_ID__c == undefined) {
                        modigieInfo.modigie__JOB_ID__c = 'NA';
                    }
                    if (modigieInfo.modigie__Validation_Date_Get_Mobile_Number__c == undefined) {
                        modigieInfo.modigie__Validation_Date_Get_Mobile_Number__c = "NA";
                    }
                    if (modigieInfo.modigie__Name_Get_Mobile_Number__c == undefined) {
                        modigieInfo.modigie__Name_Get_Mobile_Number__c = "NA";
                    }
                    recordString += '\nModigie Service : Get Modigie\nModigie Validated Mobile Contact Number : ' + modigieInfo.modigie__Modigie_Validated_Mobile_Contact_Number__c + '\nJob ID : ' + modigieInfo.modigie__JOB_ID__c + '\nJob Start Date : ' + modigieInfo.modigie__Validation_Date_Get_Mobile_Number__c + '\nName : ' + modigieInfo.modigie__Name_Get_Mobile_Number__c;
                    subject += modigieInfo.modigie__JOB_ID__c + '\'';
                }
                else if (this.selectedService == 'GetLinkedIn') {

                    if (modigieInfo.modigie__Linkedin_URL__c == undefined) {
                        modigieInfo.modigie__Linkedin_URL__c = 'NA';
                    }
                    if (modigieInfo.modigie__Linkedin_Job_Id__c == undefined) {
                        modigieInfo.modigie__Linkedin_Job_Id__c = "NA";
                    }
                    if (modigieInfo.modigie__Validation_Date_Get_LinkedIn__c == undefined) {
                        modigieInfo.modigie__Validation_Date_Get_LinkedIn__c = "NA";
                    }
                    if (modigieInfo.modigie__Name_Get_LinkedIn__c == undefined) {
                        modigieInfo.modigie__Name_Get_LinkedIn__c = "NA";
                    }

                    recordString += '\nModigie Service : Get LinkedIn\nLinkedIn Url : ' + modigieInfo.modigie__Linkedin_URL__c + '\nJob ID : ' + modigieInfo.modigie__Linkedin_Job_Id__c + '\nJob Start Date : ' + modigieInfo.modigie__Validation_Date_Get_LinkedIn__c + '\nName : ' + modigieInfo.modigie__Name_Get_LinkedIn__c;
                    subject += modigieInfo.modigie__Linkedin_Job_Id__c + '\'';

                }
                else if (this.selectedService == 'GetPhoneIntelligence') {
                    recordString += '\nModigie Service : Get Phone Insights';
                    if (modigieInfo.modigie__Get_Phone_Intelligence_Job_Id__c == undefined) {
                        modigieInfo.modigie__Get_Phone_Intelligence_Job_Id__c = "NA";
                        if (modigieInfo.modigie__Validation_Date_Mobile__c == undefined) {
                            modigieInfo.modigie__Validation_Date_Mobile__c = "NA";
                        }
                        if(modigieInfo.modigie__Name_Get_Phone_Insights_Mobile__c == undefined){
                            modigieInfo.modigie__Name_Get_Phone_Insights_Mobile__c = 'NA';
                        }
                    }
                    else{
                        recordString += '\nJob ID for Mobile : ' + modigieInfo.modigie__Get_Phone_Intelligence_Job_Id__c + '\nJob Start Date : ' + modigieInfo.modigie__Validation_Date_Mobile__c + '\nName : ' +  modigieInfo.modigie__Name_Get_Phone_Insights_Mobile__c;
                        subject += modigieInfo.modigie__Get_Phone_Intelligence_Job_Id__c + '\',';
                    }
                    if (modigieInfo.modigie__Get_Phone_Intelligence_Job_Id_Phone__c == undefined) {
                        modigieInfo.modigie__Get_Phone_Intelligence_Job_Id_Phone__c = "NA";
                        if (modigieInfo.modigie__Validation_Date_Phone__c == undefined) {
                            modigieInfo.modigie__Validation_Date_Phone__c = "NA";
                        }
                    }
                    else{
                        recordString += '\nJob ID for Phone : ' + modigieInfo.modigie__Get_Phone_Intelligence_Job_Id_Phone__c + '\nJob Start Date : ' + modigieInfo.modigie__Validation_Date_Phone__c + '\nName : ' +  modigieInfo.modigie__Name_Get_Phone_Insights_Phone__c;
                        subject += '  \''+modigieInfo.modigie__Get_Phone_Intelligence_Job_Id_Phone__c + '\',';
                    }
                    if (modigieInfo.modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c == undefined) {
                        modigieInfo.modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c = "NA";
                        if (modigieInfo.modigie__Validation_Date_Other_Phone__c == undefined) {
                            modigieInfo.modigie__Validation_Date_Other_Phone__c = "NA";
                        }
                    }else{
                        recordString += '\nJob ID for Other Phone : ' + modigieInfo.modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c + '\nJob Start Date : ' + modigieInfo.modigie__Validation_Date_Other_Phone__c + '\nName : ' +  modigieInfo.modigie__Name_Get_Phone_Insights_Other_Phone__c;
                        subject += '  \''+modigieInfo.modigie__Get_Phone_Intelligence_Job_Id_OtherPhone__c + '\',';
                    }
                    subject = subject.substring(0,subject.length-1);
                }
                else if (this.selectedService == 'VerifyEmployer') {
                    if (modigieInfo.modigie__Current_Employer__c == undefined) {
                        modigieInfo.modigie__Current_Employer__c = "NA";
                    }
                    if (modigieInfo.modigie__Current_Title__c == undefined) {
                        modigieInfo.modigie__Current_Title__c = "NA";
                    }
                    if (modigieInfo.modigie__Current__c == undefined) {
                        modigieInfo.modigie__Current__c = "NA";
                    }
                    if (modigieInfo.modigie__Validate_Employer_Job_Id__c == undefined) {
                        modigieInfo.modigie__Validate_Employer_Job_Id__c = "NA";
                    }
                    if (modigieInfo.modigie__Validation_Date_Verify_Employer__c == undefined) {
                        modigieInfo.modigie__Validation_Date_Verify_Employer__c = "NA";
                    }
                    if (modigieInfo.modigie__Name_Verify_Employer__c == undefined) {
                        modigieInfo.modigie__Name_Verify_Employer__c = "NA";
                    }
                    recordString += '\nModigie Service : Verify Employer\nCurrent Employer : ' + modigieInfo.modigie__Current_Employer__c + '\nCurrent Title : ' + modigieInfo.modigie__Current_Title__c + '\nCurrent Country : ' + modigieInfo.modigie__Current__c + '\nJob ID : ' + modigieInfo.modigie__Validate_Employer_Job_Id__c + '\nJob Start Date : ' + modigieInfo.modigie__Validation_Date_Verify_Employer__c + '\nName : ' + modigieInfo.modigie__Name_Verify_Employer__c;
                    subject += modigieInfo.modigie__Validate_Employer_Job_Id__c + '\'';
                }

                recordString += '\n' + userString;
                
                if(this.issueDescription != ''){
                    recordString += '\n\nDescription : ' + this.issueDescription;
                }
                

                var emailTo = 'support@modigie.com';

                recordString = encodeURIComponent(recordString);
                window.open('https://mail.google.com/mail/?view=cm&fs=1&to=' + emailTo + '&su=' + subject + '&body=' + recordString);




                this.closeModel();


            }).catch(error1 => {

            })
        }
        else {
            this.serviceSubmit = true;
        }


    }

    handleDesciptionChange(event) {
        this.issueDescription = event.target.value;
    }
}