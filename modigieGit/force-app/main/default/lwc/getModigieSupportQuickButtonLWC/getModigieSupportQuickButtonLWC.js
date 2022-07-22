import { LightningElement,api, track} from 'lwc';
import MODIGIELOGO from '@salesforce/resourceUrl/ModigieLogo';
import getUsedServicesInfo from '@salesforce/apex/GetModigieSupportController.getUsedServicesInfo';
import getInformationofUser from '@salesforce/apex/GetModigieSupportController.getInformationofUser';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class GetModigieSupportQuickButtonLWC extends NavigationMixin(LightningElement) {
    @api recordid;
    
   /* modigieLogoUrl = MODIGIELOGO 
    toggleSpinner=true;
    disableSubmit=true;
    @track serviceUsageMap = {"VerifyEmployer":true,"GetPhoneIntelligence":true,"GetLinkedIn":true,"GetModigie":true};
    selectedService;


    connectedCallback(){
        getUsedServicesInfo({
            recId: this.recordid,
            objectType:'Modigie'
        }).then(result1=>{
          this.toggleSpinner=false;
        
          this.serviceUsageMap = JSON.parse(result1);
        }).catch(error1 => {
        })
    }
    handleChange(event){
        this.disableSubmit=false;
        this.selectedService = event.target.dataset.name;
    }
    closeModel() {
        const closeQA = new CustomEvent('close');
        this.dispatchEvent(closeQA);
    }

    handleSubmit(){
        getInformationofUser({
            recId: this.recordid,
            calledFrom:'Modigie'
        }).then(result1=>{
         
            
            
         //   var userinfo = 'User Information\nUser Name : '+uname+'\nUser Email : '+uemail+'\nUser Company : '+ucompany;
        


          

          var resultMap = JSON.parse(result1);

            
          var userInfo = resultMap.User;

          var userString = 'User Information\n\nUser Name : '+userInfo.Username+'\nUser Email : '+userInfo.Email+'\nUser Company : '+userInfo.Email;
          
      //  var recordString = 'FirstName : '+fname+'\nLastName : '+lname+'\nEmail : '+email+'\nCompany : '+company+'\nLinkedin URL : '+linkedinUrl+'\nModigie Validated Mobile Contact Number : '+validatedNumber+'\nJob ID : '+Jobid+'\n\n'+userinfo;
          
          var modigieInfo = resultMap.Data;


            var recordString='';
            if(modigieInfo.modigie__Contact__r != undefined){
                
                if(modigieInfo.modigie__Contact__r.FirstName == undefined){
                    modigieInfo.modigie__Contact__r.FirstName = 'NA';
                }
                if(modigieInfo.modigie__Contact__r.LastName == undefined){
                    modigie__Contact__r.LastName = 'NA';
                }
                if(modigieInfo.modigie__Contact__r.Email == undefined){
                    modigieInfo.modigie__Contact__r.Email = 'NA';
                }
                if(modigieInfo.modigie__Contact__r.Account == undefined){
                    modigieInfo.modigie__Contact__r.Account = {"Name":"NA"};
                }

                recordString = 'First Name : '+modigieInfo.modigie__Contact__r.FirstName +'\nLast Name : '+modigieInfo.modigie__Contact__r.LastName +'\nEmail : '+modigieInfo.modigie__Contact__r.Email+'\nCompany : '+modigieInfo.modigie__Contact__r.Account.Name;
             }
          
            else if(modigieInfo.modigie__Lead__r != undefined){
                if(modigieInfo.modigie__Lead__r.FirstName == undefined){
                    modigieInfo.modigie__Lead__r.FirstName = 'NA';
                }
                if(modigieInfo.modigie__Lead__r.LastName == undefined){
                    modigieInfo.modigie__Lead__r.LastName = 'NA';
                }
                if(modigieInfo.modigie__Lead__r.Email == undefined){
                    modigieInfo.modigie__Lead__r.Email = 'NA';
                }
                if(modigieInfo.modigie__Lead__r.Company == undefined){
                    modigieInfo.modigie__Lead__r.Company = "NA";
                }
                recordString = 'First Name : '+modigieInfo.modigie__Lead__r.FirstName +'\nLast Name : '+modigieInfo.modigie__Lead__r.LastName+'\nEmail : '+modigieInfo.modigie__Lead__r.Email+'\nCompany : '+modigieInfo.modigie__Lead__r.Company;
            }

            var subject = 'Modigie support request from ' + userInfo.Name + ' for Job \'';


            if(this.selectedService == 'GetModigieMobile'){
                if(modigieInfo.modigie__Modigie_Validated_Mobile_Contact_Number__c == undefined){
                    modigieInfo.modigie__Modigie_Validated_Mobile_Contact_Number__c = 'NA';
                }
                if(modigieInfo.modigie__JOB_ID__c == undefined){
                    modigieInfo.modigie__JOB_ID__c = 'NA';
                }
                
                recordString += '\nModigie Service : Get Mobile Number\nModigie Validated Mobile Contact Number : '+modigieInfo.modigie__Modigie_Validated_Mobile_Contact_Number__c+'\nJob ID : '+modigieInfo.modigie__JOB_ID__c+'\n\n';
                subject += modigieInfo.modigie__JOB_ID__c + '\'';
            }
            else if(this.selectedService == 'GetLinkedIn'){
                
                if(modigieInfo.modigie__Linkedin_URL__c == undefined){
                    modigieInfo.modigie__Linkedin_URL__c = 'NA';
                }
                if(modigieInfo.modigie__Linkedin_Job_Id__c == undefined){
                    modigieInfo.modigie__Linkedin_Job_Id__c = "NA";
                }
                
                recordString += '\nModigie Service : Get LinkedIn\nLinkedIn Url : '+modigieInfo.modigie__Linkedin_URL__c+'\nJob ID : '+modigieInfo.modigie__Linkedin_Job_Id__c+'\n\n';
                subject += modigieInfo.modigie__Linkedin_Job_Id__c  + '\'';

            }
            else if(this.selectedService == 'GetPhoneIntelligence'){
                if(modigieInfo.modigie__Phone_Name_Match__c == undefined){
                    modigieInfo.modigie__Phone_Name_Match__c = 'NA';
                }
                if(modigieInfo.modigie__Line_Activity__c == undefined){
                    modigieInfo.modigie__Line_Activity__c = "NA";
                }
                if(modigieInfo.modigie__Phone_Type__c == undefined){
                    modigieInfo.modigie__Phone_Type__c = "NA";
                }
                if(modigieInfo.modigie__Best_Time_to_Call__c == undefined){
                    modigieInfo.modigie__Best_Time_to_Call__c = "NA";
                }
                if(modigieInfo.modigie__Get_Phone_Intelligence_Job_Id__c == undefined){
                    modigieInfo.modigie__Get_Phone_Intelligence_Job_Id__c = "NA";
                }

                if(modigieInfo.modigie__Verified_Phone_Get_Phone_Insights__c == undefined){
                    modigieInfo.modigie__Verified_Phone_Get_Phone_Insights__c = "NA";
                }

                recordString += '\nModigie Service : Get Phone Insights\nVerified Phone Number : ' + modigieInfo.modigie__Verified_Phone_Get_Phone_Insights__c + '\nAccuracy Match : '+modigieInfo.modigie__Phone_Name_Match__c+ '\nLine Activity : '+modigieInfo.modigie__Line_Activity__c+'\nNumber Type : '+modigieInfo.modigie__Phone_Type__c+'\nBest Time to Call : '+modigieInfo.modigie__Best_Time_to_Call__c +'\nJob ID : '+modigieInfo.modigie__Get_Phone_Intelligence_Job_Id__c+'\n\n';
                subject += modigieInfo.modigie__Get_Phone_Intelligence_Job_Id__c + '\'';
            }
            else if(this.selectedService == 'VerifyEmployer'){
                if(modigieInfo.modigie__Current_Employer__c == undefined){
                    modigieInfo.modigie__Current_Employer__c = "NA";
                }
                if(modigieInfo.modigie__Current_Title__c == undefined){
                    modigieInfo.modigie__Current_Title__c = "NA";
                }
                if(modigieInfo.modigie__Current__c == undefined){
                    modigieInfo.modigie__Current__c = "NA";
                }
                if(modigieInfo.modigie__Validate_Employer_Job_Id__c == undefined){
                    modigieInfo.modigie__Validate_Employer_Job_Id__c = "NA";
                }
                recordString += '\nModigie Service : Verify Employer\nCurrent Employer : '+modigieInfo.modigie__Current_Employer__c+ '\nCurrent Title : '+modigieInfo.modigie__Current_Title__c+'\nCurrent Country : '+modigieInfo.modigie__Current__c+'\nJob ID : '+modigieInfo.modigie__Validate_Employer_Job_Id__c+'\n\n';
                subject += modigieInfo.modigie__Validate_Employer_Job_Id__c +'\'';
            }

            recordString += '\n' + userString;

            var emailTo = 'support@modigie.com';

               recordString = encodeURIComponent(recordString);
            window.open('https://mail.google.com/mail/?view=cm&fs=1&to='+emailTo+'&su='+subject+'&body='+recordString);
            
            


            this.closeModel();


        }).catch(error1 => {
            
        })
    }*/
}