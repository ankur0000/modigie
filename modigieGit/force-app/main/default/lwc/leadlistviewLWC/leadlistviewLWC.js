import { LightningElement,track,api,wire } from 'lwc';
import getOrgStopUntilTimeAndReason from '@salesforce/apex/ModigieLightningTabController.getOrgStopUntilTimeAndReason';
import getSelectedRecords from '@salesforce/apex/listViewController.getSelectedRecords';
import getSelectedRecordInformation from '@salesforce/apex/listViewController.getSelectedRecordInformation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import sendAPILimitData from "@salesforce/apex/LimitsMapClass.sendAPILimitData";
import MODIGIELOGO from '@salesforce/resourceUrl/ModigieLogo';
import requestLinkedInUrls from '@salesforce/apex/listViewController.requestLinkedInUrls';
import requestgetmodigie from '@salesforce/apex/listViewController.requestgetmodigie';
import requestverifyemployer from '@salesforce/apex/listViewController.requestverifyemployer';
import requestPhoneIntelJobs from '@salesforce/apex/listViewController.requestPhoneIntelJobs';
import getMembersData from '@salesforce/apex/listViewController.getMembersData';
import checkBatchJobStatus from '@salesforce/apex/GetModigieCampaignButton.checkBatchJobStatus';  

const columns = [
    { label: 'FirstName', fieldName: 'FirstName', type: 'text' },
    { label: 'LastName', fieldName: 'LastName', type: 'text' },
    { label: 'Email', fieldName: 'Email', type: 'phone' },
    { label: 'Company', fieldName: 'Company', type: 'text' },
    { label: 'MobilePhone', fieldName: 'MobilePhone', type: 'text' },
    { label: 'LinkedIn URL', fieldName: 'modigie__linkedin_url__c', type: 'url' },
];

export default class LeadlistviewLWC extends LightningElement {

    modigieAdditional=false;
    data = [];
    columns = columns;
    modallabel;
    @api idList;
    @api objectname;
    @track recordData=[];
    showModel = false;
    showModelZeroRecords = false;
    @track buttonClickedInfo = {};
    @track buttonColors = {GetModigie:'slds-button slds-button_brand',GetLinkedIn:'slds-button slds-button_brand button_custom_size',GetPhoneInsights:'slds-button slds-button_brand button_custom_size',VerifyEmployer:'slds-button slds-button_brand button_custom_size',GetMobileNumber:'slds-button slds-button_brand button_custom_size'};
    resultList;
    totalLimit;
    usedLimit;
    remainingLimit;
    selectedrecords;
    limitError=false;
    lstPendingJobIds = [];
    haveRecordsToProcess = false;
    toggleSpinner = false;
    @track allServicesData;
    currentPageUrl = '';

    @track resMap = {totalSize:0,recordsRunning:0,alreadyValidated:0,recordsToProcess:0,invalidatedRecords:0,notFulfill:0,userFilled:0};
    selectedjob;
    modigieLogoUrl = MODIGIELOGO;
    buttonPressedModal;
    showspinner = false;
    showtoast = false;
    @track errorToast = {showErrorToast : false,errorMessage:''};

    showErrorToast = false;
    activeSections = ['A'];
    isphoneinsights = false;
    @track selectedFields = {selectedFieldsLead:''};
    disableSubmit = true;
    isEmbeddedInClassic = false;

    showSpinner = true;
    
    @track limitsData = {Ad_Hoc_Limits:false};

    modigieUser = false;
    spinnerCheckModigieUser = true;
    isOrgCalloutsDisabled = false;
    orgStopReasonString;
    isSelectedCreditAccountInactive = false;
    stopReason
    isCreditAccountStopped = false;
    showErrorMessage = false;

    connectedCallback(){
        this.currentPageUrl = window.location.href;
        if(this.currentPageUrl.includes('visualforce.com') && !this.currentPageUrl.includes('lightning.force.com')){
            this.isEmbeddedInClassic = true;
        
        }
        if(this.idList.length == 0)
        {
            this.showSpinner = false;
        }
        else
        {
            var idarray = this.idList.split(',');
            this.selectedrecords = idarray.length;
            this.refreshComponent();
            getSelectedRecords({
                idList:this.idList,
                objectname:this.objectname
            })
            .then(result => {
                this.spinnerCheckModigieUser = false;
                this.modigieUser = true;
                this.resultList = result;
                this.data = this.resultList;
                this.showSpinner = false;
                
            })
            .catch(error => {
                this.spinnerCheckModigieUser = false;
                if(error.body.message != 'You are not an authorized user.'){
                    const event = new ShowToastEvent({
                        "title": "Error!",
                        "message": error.body.message,
                        "variant": "error"
                    });
                }else{
                    this.showSpinner = false;
                }
            })
        }
        getOrgStopUntilTimeAndReason().then(result => {
            console.log('line 102',result);
            if(result['isStopCallouts']){
              this.isOrgCalloutsDisabled = true;
              this.orgStopReasonString = result['reasonString'];
            }
            else if(result['isCreditAccountStopped']){
              this.isCreditAccountStopped = true;
              this.stopReason = result['stopReason'];
            }
            else if(result['isSelectedCreditAccountInactive']){
              this.isSelectedCreditAccountInactive = true;
            }
      
            if(result['isStopCallouts'] || result['isCreditAccountStopped'] || result['isSelectedCreditAccountInactive']){
              this.showErrorMessage = true;
            }
          });
    }
    refreshComponent(){
        
        getSelectedRecordInformation({
            idList:this.idList 
        })
        .then(result => {
            this.allServicesData = JSON.parse(result);

                if(this.allServicesData[3].Remaining == 0 && this.allServicesData[0].TotalMembers > 0){
                    this.buttonColors.GetModigie += ' buttonColor';
                    this.buttonColors.GetMobileNumber += ' buttonColor';
                }
                else{
                    this.buttonColors.GetModigie = this.buttonColors.GetModigie.replace(' buttonColor','');
                    this.buttonColors.GetMobileNumber = this.buttonColors.GetModigie.replace(' buttonColor','');
                }

                if(this.allServicesData[0].Remaining == 0 && this.allServicesData[0].TotalMembers > 0){
                    this.buttonColors.GetLinkedIn += ' buttonColor';
                }
                else{
                    this.buttonColors.GetLinkedIn = this.buttonColors.GetLinkedIn.replace(' buttonColor','');
                }

                var phoneInsightsData = this.allServicesData[2].GetPhoneInsightsData;
                if(phoneInsightsData.length > 0){
                    if(phoneInsightsData[0].Running > 0 || phoneInsightsData[0].Validated > 0 || phoneInsightsData[1].Running > 0 || phoneInsightsData[1].Validated > 0 || phoneInsightsData[2].Running > 0 || phoneInsightsData[2].Validated > 0){
                       
                        this.buttonColors.GetPhoneInsights += ' buttonColor';    
                    }
                    else{
                        this.buttonColors.GetPhoneInsights = this.buttonColors.GetPhoneInsights.replace(' buttonColor','');    
                    }
                }

                if(this.allServicesData[1].Remaining == 0 && this.allServicesData[0].TotalMembers > 0){
                    this.buttonColors.VerifyEmployer += ' buttonColor';
                }
                else{
                    this.buttonColors.VerifyEmployer = this.buttonColors.VerifyEmployer.replace(' buttonColor','');
                }
            
        })
        .catch(error => {
            const event = new ShowToastEvent({
                "title": "Error!",
                "message": error.body.message,
                "variant": "error"
            });
            this.dispatchEvent(event);
        });
        
    }


    openModal(event) {

        this.toggleSpinner = true;
        this.buttonClickedInfo={};
        var buttonPressed = event.target.dataset.name;
        this.buttonPressedModal = buttonPressed;

        sendAPILimitData({})
            .then((result1) => {
                this.limitsData = JSON.parse(result1);
            if(this.limitsData.Ad_Hoc_Limits){
                this.totalLimit = this.limitsData.Total_API_Limit;
            this.usedLimit = this.limitsData.Used_API_Limit;
            if(this.limitsData.Total_API_Limit - this.limitsData.Used_API_Limit >= this.idList.split(',').length){
                this.remainingLimit = this.limitsData.Total_API_Limit - this.limitsData.Used_API_Limit; 
            }
            else{
                this.remainingLimit = 0;
            }

            if(this.remainingLimit == 0){
                this.limitError = true;
            }
            }
            

        if(buttonPressed == 'GetModigie')
        {
            this.isphoneinsights = false;
            this.selectedjob = 'Get Modigie';
            this.modallabel = 'Get Modigie';
        }
        else if(buttonPressed == 'GetMobileNumber')
        {
            this.modigieAdditional=false;
            this.isphoneinsights = false;
            this.selectedjob = 'Get Mobile Number';
            this.modallabel = 'Get Mobile Number';
        }
        else if(buttonPressed == 'GetLinkedIn')
        {
            this.modigieAdditional=false;
            this.isphoneinsights = false;
            this.selectedjob = 'Get LinkedIn';
            this.modallabel = 'Get LinkedIn';
        }
        else if(buttonPressed == 'GetPhoneInsights')
        {
            this.modigieAdditional=false;
            this.isphoneinsights = true;
            this.selectedjob = 'Get Phone Insights';
            this.modallabel = 'Get Phone Insights';
        }
        else if(buttonPressed == 'VerifyEmployer')
        {
            this.modigieAdditional=false;
            this.isphoneinsights = false;
            this.selectedjob = 'Verify Employer';
            this.modallabel = 'Verify Employer';
        }

        this.buttonClickedInfo[buttonPressed]=true;
        if(this.selectedrecords != undefined)
        {
            this.showModel=true;
        }

        else if(this.selectedrecords == undefined)
        {
            this.showModelZeroRecords = true;
        }


        getMembersData({
            idList: this.idList,
            objectName : 'Lead',
            'buttonPressed': buttonPressed
         }).then(result => {
          this.toggleSpinner = false;
            this.resMap=JSON.parse(result); 
           var count = JSON.parse(result);
           if(count.TokenExist == 1){
               this.haveRecordsToProcess = true;
                this.disableSubmit = false;
            }
           else{
               this.disableSubmit = true;
               this.haveRecordsToProcess = false;
           }

           /*else if(count.TokenExist == 0){
                const event = new ShowToastEvent({
                    "title": "Error!",
                    "message": "You are not an authorised user",
                    "variant": "error"
                });
                this.dispatchEvent(event);
                const closeQA = new CustomEvent('close'); 
                this.dispatchEvent(closeQA);
            }*/
           /* else if(count.TokenExist == -1){
                const event = new ShowToastEvent({
                    "title": "Error!",
                    "message": "Insuffiecient Credits",
                    "variant": "error"
                });
                this.dispatchEvent(event);
                const closeQA = new CustomEvent('close');
                this.dispatchEvent(closeQA);
            }
            else if(count.TokenExist == -2){
                const event = new ShowToastEvent({
                    "title": "Error!",
                    "message": "You doesn't have permissions to modigie object.",
                    "variant": "error"
                });
                this.dispatchEvent(event);
                const closeQA = new CustomEvent('close');
                this.dispatchEvent(closeQA);
            }*/
        })
        .catch(error => {
            const event = new ShowToastEvent({
                "title": "Error!",
                "message": error.body.message,
                "variant": "error"
            });
            this.dispatchEvent(event);
            this.closeModal();
        });
    })
    
    .catch((error1) => {
        this.errorToast.showErrorToast = true;
        this.errorToast.errorMessage = error1.body.message; 
        let delay = 3000;
        setTimeout(() => {
            this.errorToast.showErrorToast = false;
        },delay);
        this.closeModal();
    });
    
     }
     closeModal(event) {
        if(this.buttonPressedModal == 'GetModigie'){
            this.modigieAdditional=false;
        }else{
            this.modigieAdditional=true;
        }
        
        this.showModel=false;
        this.showModelZeroRecords = false;
        this.disableSubmit = true;
        this.selectedFields.selectedFieldsLead = '';
        if(this.idList.length != 0){
            this.refreshComponent();
        }
    }

    closeAdditionalModigie(event){
        this.modigieAdditional=false;
    }

    backHandle()
    {
        history.go(-1);
    }

    makecallout(event)
    {
        this.disableSubmit = true;
        if(this.buttonPressedModal == 'GetLinkedIn')
        {
            this.toggleSpinner = true;
         this.showspinner = true;
            requestLinkedInUrls({
                selectedrecords:this.resultList,
                objectname:this.objectname
            }).then(result => {
                
                if(result == null){
                    this.errorToast.showErrorToast = true;
                    this.errorToast.errorMessage = 'Some Error Occured.';
                    let delay = 3000;
                    setTimeout(() => {
                        this.errorToast.showErrorToast = false;
                    },delay);
                    this.showspinner = false;
                    this.toggleSpinner = false;
                    this.showModel=false;
                }

                else if(result.length == 0){ 
                    this.errorToast.showErrorToast = true;
                    this.errorToast.errorMessage = 'No records processed.';
                    let delay = 3000;
                    setTimeout(() => {
                        this.errorToast.showErrorToast = false;
                    },delay);
                    this.showspinner = false;
                    this.toggleSpinner = false;

                    this.showModel=false;
                }

                else{
                    this.lstPendingJobIds = result;    
                    this.checkJobsStatus();
                }
            }).catch(error1 => {
                var errorMap = JSON.parse(error1.body.message);
                this.errorToast.showErrorToast = true;
                this.errorToast.errorMessage = errorMap.DisplayMessage; 
                let delay = 3000;
                setTimeout(() => {
                    this.errorToast.showErrorToast = false;
                },delay);
                this.showspinner = false;
                this.toggleSpinner = false;

                this.showModel=false;
            })
        }
        else if(this.buttonPressedModal == 'GetMobileNumber' || this.buttonPressedModal == 'GetModigie')
        {
            this.showspinner = true;
            this.toggleSpinner = true;

            requestgetmodigie({
                selectedrecords:this.resultList,
                objectname:this.objectname
            }).then(result => {
                if(result == null){
                    this.errorToast.showErrorToast = true;
                    this.errorToast.errorMessage = 'Some Error Occured.';
                    let delay = 3000;
                    setTimeout(() => {
                        this.errorToast.showErrorToast = false;
                    },delay);
                    this.showspinner = false;
                    this.toggleSpinner = false;
                    this.showModel=false;
                }

                else if(result.length == 0){
                    this.errorToast.showErrorToast = true;
                    this.errorToast.errorMessage = 'No records processed.';
                    let delay = 3000;
                    setTimeout(() => {
                        this.errorToast.showErrorToast = false;
                    },delay);
                    this.showspinner = false;
                    this.toggleSpinner = false;
                    this.showModel=false;
                }

                else{
                    this.lstPendingJobIds = result;    
                    this.checkJobsStatus();
                }

            
            /*  this.showtoast = true;
              let delay = 3000
              setTimeout(() => {
                  this.showtoast = false;
              }, delay );
                this.showspinner = false;
                this.showModel=false;*/
            }).catch(error => {
                var errorMap = JSON.parse(error.body.message);
                this.errorToast.showErrorToast = true;
                this.errorToast.errorMessage = errorMap.DisplayMessage; 
                let delay = 3000;
                setTimeout(() => {
                    this.errorToast.showErrorToast = false;
                },delay);
                this.showspinner = false;
                this.toggleSpinner = false;

                this.showModel=false;
            });
        }
        else if(this.buttonPressedModal == 'VerifyEmployer')
        {
            this.showspinner = true;
            this.toggleSpinner = true;

            requestverifyemployer({
                selectedrecords:this.resultList,
                objectname:this.objectname
            }).then(result => {
                if(result == null){
                    this.errorToast.showErrorToast = true;
                    this.errorToast.errorMessage = 'Some Error Occured.';
                    let delay = 3000;
                    setTimeout(() => {
                        this.errorToast.showErrorToast = false;
                    },delay);
                    this.showspinner = false;
                    this.toggleSpinner = false;
                    this.showModel=false; 
                }

                else if(result.length == 0){
                    this.errorToast.showErrorToast = true;
                    this.errorToast.errorMessage = 'No records processed.';
                    let delay = 3000;
                    setTimeout(() => {
                        this.errorToast.showErrorToast = false;
                    },delay);
                    this.showspinner = false;
                    this.toggleSpinner = false;
                    this.showModel=false;
                }

                else{
                    this.lstPendingJobIds = result;    
                    this.checkJobsStatus();
                }


            
           /*   this.showtoast = true;
              let delay = 3000
              setTimeout(() => {
                  this.showtoast = false;
              }, delay );
                this.showspinner = false;
                this.showModel=false;*/
            }).catch(error => {
                var errorMap = JSON.parse(error.body.message);
                this.errorToast.showErrorToast = true;
                    this.errorToast.errorMessage = errorMap.DisplayMessage;
                    let delay = 3000;
                    setTimeout(() => {
                        this.errorToast.showErrorToast = false;
                    },delay);
                    this.showspinner = false;
                    this.toggleSpinner = false;
                    this.showModel=false;
                
                
            });
        }
        else if(this.buttonPressedModal == 'GetPhoneInsights')
        {
            this.showspinner = true;
            this.toggleSpinner = true;
            requestPhoneIntelJobs({ 
                selectedrecords:this.resultList,
                objectname:this.objectname,
                inputNumbers:JSON.stringify(this.selectedFields)
            }).then(result => {
                if(result == null){
                    this.errorToast.showErrorToast = true;
                    this.errorToast.errorMessage = 'Some Error Occured.';
                    let delay = 3000;
                    setTimeout(() => {
                        this.errorToast.showErrorToast = false;
                    },delay);
                    this.showspinner = false;
                    this.toggleSpinner = false;
                    this.showModel=false;
                }
                else if(result.length == 0){
                    this.errorToast.showErrorToast = true;
                    this.errorToast.errorMessage = 'No records processed.';
                    let delay = 3000;
                    setTimeout(() => {
                        this.errorToast.showErrorToast = false;
                    },delay);
                    this.showspinner = false;
                    this.toggleSpinner = false;
                    this.showModel=false;
                }
                else{
                    this.lstPendingJobIds = result;    
                    this.checkJobsStatus(); 
                }
             
              
            }).catch(error1 => {
                
                var errorMap = JSON.parse(error1.body.message);
                
                this.errorToast.showErrorToast = true;
                
                this.errorToast.errorMessage = errorMap.DisplayMessage;
                let delay = 3000;
                setTimeout(() => {
                    this.errorToast.showErrorToast = false;
                },delay);
                this.showspinner = false;
                this.toggleSpinner = false;
                this.showModel=false;
            })
        }
        
    }

    handleChangeLead(event){
        

        if(this.selectedFields.selectedFieldsLead.indexOf(event.target.dataset.name + ',') != -1){
            this.selectedFields.selectedFieldsLead =this.selectedFields.selectedFieldsLead.replace(event.target.dataset.name + ',' ,'');    
        }
        else{
            this.selectedFields.selectedFieldsLead += event.target.dataset.name + ',';
        }
        
        if(this.selectedFields.selectedFieldsLead == ''){
            this.disableSubmit=true;
        }
        else{
            this.disableSubmit=false;
        }
        
    }

    checkJobsStatus(){
        checkBatchJobStatus({
            lstIds: this.lstPendingJobIds
         }).then(result => {
            if(result != 0){
                this.checkJobsStatus();
            }
            else{
                this.showtoast = true;
                let delay = 3000;
                setTimeout(() => {
                    this.showtoast = false;
                }, delay );
                this.showspinner = false;
                this.toggleSpinner = false;
                this.showModel=false;
                this.refreshComponent();
                
            }
        })
        .catch(error => {
            this.errorToast.showErrorToast = true;
            this.errorToast.errorMessage = error.body.message;
            let delay = 3000;
            setTimeout(() => {
                this.errorToast.showErrorToast = false;
            },delay);
            this.showspinner = false;
            this.toggleSpinner = false;
            this.showModel=false;
        });
    }

    additionalModigieServices(){
        this.modigieAdditional = true;
    }
    navigateToListView(event){
        window.open(
            this.currentPageUrl.substring(0,this.currentPageUrl.indexOf('/') + 1) +'00Q',
            "_self"
          );
    }
}