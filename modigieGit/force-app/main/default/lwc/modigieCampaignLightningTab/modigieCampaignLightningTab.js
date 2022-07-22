import { LightningElement,wire,track,api} from 'lwc';
import getOrgStopUntilTimeAndReason from '@salesforce/apex/ModigieLightningTabController.getOrgStopUntilTimeAndReason';
import MODIGIELOGO from '@salesforce/resourceUrl/ModigieLogo';
import getCampaignMemberInformation from '@salesforce/apex/ModigieLightningCampaignTabController.getCampaignMemberInformation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import {loadStyle} from "lightning/platformResourceLoader";
import ModigieCSS from '@salesforce/resourceUrl/ModigieCSS';
export default class ModigieCampaignLightningTab extends LightningElement {
 
    modigieLogoUrl = MODIGIELOGO;
    @api recordId;
    @track buttonClickedInfo = {};
    GetPhoneIntelligence=false;
    toggleSpinner = true;
    @track buttonColors = {modigie:'slds-button slds-button_brand buttonWidth',linkedIn:'slds-button slds-button_brand buttonWidth',phoneIntelligence:'slds-button slds-button_brand buttonWidth',verifyEmployer:'slds-button slds-button_brand buttonWidth'};
    totalMembers;
    @track allServicesData;
    //Boolean tracked variable to indicate if modal is open or not default value is false as modal is closed when page is loaded 
     @track isModalOpen = false;
     @track getModigieData = {};
     toastVisible=false;
     classicMessage="";
     errorToastVisible=false;
     classicErrorMessage="";
     modigieAdditional=false;
     isReadable = true;
     isModigieUser = true;
     isOrgCalloutsDisabled = false;
    orgStopReasonString;
    isSelectedCreditAccountInactive = false;
    stopReason
    isCreditAccountStopped = false;
    showErrorMessage = false;

    connectedCallback(){
        
            loadStyle(this, ModigieCSS + "/ModigieCSS/AccordionStyle.css"), 
        
        this.refreshComponent();
        
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
        getCampaignMemberInformation({
            recid:this.recordId 
        }).then(result => {
            this.allServicesData = JSON.parse(result);
            if(this.allServicesData.length == 5){
                this.isModigieUser = this.allServicesData[4].ModigieUser;
                this.allServicesData.splice(4,1);
            }
            this.totalMembers = this.allServicesData[0].TotalMembers;
            this.buttonColors={modigie:'slds-button slds-button_brand buttonWidth',linkedIn:'slds-button slds-button_brand buttonWidth',phoneIntelligence:'slds-button slds-button_brand buttonWidth',verifyEmployer:'slds-button slds-button_brand buttonWidth'};
            this.getModigieData = this.allServicesData[0];
            if(this.allServicesData[3].Remaining == 0 && this.allServicesData[0].TotalMembers > 0){
                this.buttonColors.linkedIn += ' buttonColor';
            }
            else{
                this.buttonColors.linkedIn = this.buttonColors.linkedIn.replace(' buttonColor','');
            }
            
            if(this.allServicesData[1].Remaining == 0 && this.allServicesData[0].TotalMembers > 0){
                this.buttonColors.verifyEmployer += ' buttonColor';
            }
            else{
                this.buttonColors.verifyEmployer = this.buttonColors.verifyEmployer.replace(' buttonColor','');
            }
            

            var phoneInsightsData = this.allServicesData[2].GetPhoneInsightsData;
            if(phoneInsightsData.length > 0){
                if(phoneInsightsData[0].Running > 0 || phoneInsightsData[0].Validated > 0 || phoneInsightsData[1].Running > 0 || phoneInsightsData[1].Validated > 0 || phoneInsightsData[2].Running > 0 || phoneInsightsData[2].Validated > 0){
                    this.buttonColors.phoneIntelligence += ' buttonColor';    
                }
                else{
                    this.buttonColors.phoneIntelligence = this.buttonColors.phoneIntelligence.replace(' buttonColor','');    
                }
            }
            if(this.allServicesData[0].Remaining == 0 && this.allServicesData[0].TotalMembers > 0){
                this.buttonColors.modigie += ' buttonColor';
            }
            else{
                this.buttonColors.modigie = this.buttonColors.modigie.replace(' buttonColor','');
            }
            this.allServicesData.shift();
            this.toggleSpinner=false;

        }).catch(error => {
            if(error.body.message.includes('You do not have access to the Apex class')){
                this.isReadable = false;
            }
            else{
                const event = new ShowToastEvent({
                    "title": "Error!",
                    "message": error.body.message,
                    "variant": "error"
                });
                this.dispatchEvent(event);
            }
        }) 
    }
    openModal(event) {
        this.modigieAdditional=false;
        this.buttonClickedInfo={};
        var buttonPressed = event.target.dataset.name;
        this.buttonClickedInfo[buttonPressed]=true;
        this.isModalOpen = true;
    }
    closeModal(event) {
        if(event.detail == '0'){
            var currentPageURL = window.location.href.toString();
            if(currentPageURL.includes('visualforce.com') || currentPageURL.includes('visual.force.com')){
                this.toastVisible=true;
                this.classicMessage = "Modigie is actively identifying and validating the information you requested. Please check back here in a few minutes to see your results.";
                let delay = 3000
                setTimeout(() => {
                    this.toastVisible = false;
                }, delay );
            }
        }
        else if(event.detail == ''){}
        else {
            var currentPageURL = window.location.href.toString();
            if(currentPageURL.includes('visualforce.com') || currentPageURL.includes('visual.force.com')){
                this.errorToastVisible=true;
                this.classicErrorMessage = event.detail;
                let delay = 3000
                setTimeout(() => {
                    this.errorToastVisible = false;
                }, delay );
            }
         }
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;

        this.refreshComponent();
    }

    additionalModigieServices(){
        this.modigieAdditional=true;
    }

    closeAdditionalModigie(){
        this.modigieAdditional=false;
    }
}