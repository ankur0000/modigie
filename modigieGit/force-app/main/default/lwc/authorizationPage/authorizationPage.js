import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getUserAndCredentialInfo from '@salesforce/apex/ModigieConfiguration.getUserAndCredetialInfo';
import getCreditAccountDetails from '@salesforce/apex/AuthorizationClass.getCreditAccountDetails';
import getEncryptedId from '@salesforce/apex/AuthorizationClass.getEncryptedId';
import saveCheckboxChange from '@salesforce/apex/AuthorizationClass.saveCheckboxChange';
import saveToggleChange from '@salesforce/apex/AuthorizationClass.saveToggleChange';
import refreshCreditIds from '@salesforce/apex/AuthorizationClass.refreshCreditIds';
import authenticateCredentials from '@salesforce/apex/AuthorizationClass.authenticateCredentials';
import saveAuthenticationCredentials from '@salesforce/apex/AuthorizationClass.saveAuthenticationCredentials';
import getAuthenticationDetails from '@salesforce/apex/AuthorizationClass.getAuthenticationDetails';

export default class AuthorizationPage extends LightningElement {
    @track creditIds = [];
    @track performanceIds = [];
    @track customerId;
    @track showConfirmationForDefault = false;
    @track showAssigneeList = false;
    @track showAssignUser = false;
    @track showAuthenticationModal = false;
    @track showToggleChangeConfirmationModal = false;
    @track isDataLoaded = false;
    @track isPerformance;
    @track noCreditIds;
    @track noPerformanceIds;
    @track isCreditIdsLoaded = true;
    @track showBalance = false;
    @track showCreateNewAccountModal = false;
    @track AccountPrivateKey;
    @track AccountEmail;
    @track ApiKey;
    @track isCustomerIdNull = false;
    @track showKillSwitchModal = false;
    @track timeForStoppingCallout;
    @track stopUntilReason;
    @track timePicklist = [{ label: '1', value: '1' },
    { label: '2', value: '2' },
    { label: '3', value: '3' },
    { label: '5', value: '5' },
    { label: '8', value: '8' },];
    @track value;

    connectedCallback(){
        getCreditAccountDetails().then(result => {
            this.creditIds = [];
            this.performanceIds = [];
            console.log(result);
            for(let i = 0; i < result.length; i++){
                
                let status, toggleDisabled, encrypted, checkboxDisabled = false, currencyCode = result[i].modigie__Currency_Code__c, showTooltip = false;
                if(result[i].modigie__Status__c == 'active'){
                    status = 'Active';
                    toggleDisabled = false;
                }
                else if(result[i].modigie__Status__c == 'inactive'){
                    status = 'Inactive';
                    checkboxDisabled = true;
                    toggleDisabled = true;
                }
                else if(result[i].modigie__Status__c == 'disable'){
                    status = 'Inactive';
                    toggleDisabled = true;
                    checkboxDisabled = true;
                }
                if(result[i].modigie__Default__c){
                    checkboxDisabled = true
                }
                if(result[i].modigie__Currency_Code__c == 'XXX'){
                    currencyCode = 'Cr.'
                }                
                    if(result[i].modigie__isPerformance__c == true){
    
                        this.performanceIds.push({
                            'recordId': result[i].Id,
                            'encryptedId': result[i].modigie__Credit_Id__c,
                            'Title': result[i].modigie__Title__c,
                            'Status': status,
                            'toggleDisabled': toggleDisabled,
                            'checkboxDisabled': checkboxDisabled
                        })
                    }
                    else{
                        this.creditIds.push({
                            'recordId': result[i].Id,
                            'Title': result[i].modigie__Title__c,
                            'Default': result[i].modigie__Default__c,
                            'encryptedId': result[i].modigie__Credit_Id__c,
                            'Balance': result[i].modigie__Balance__c,
                            'Status': status,
                            'toggleDisabled': toggleDisabled,
                            'checkboxDisabled': checkboxDisabled,
                            'currencyCode': currencyCode,
                            'reason': result[i].modigie__Reason__c,
                            'stopUntilTime': result[i].modigie__StopUntilTime__c,
                            'showTooltip': result[i].showTooltip
                        });
                    }
                // });
            }
            if(this.creditIds.length == 0){
                this.noCreditIds = true;
            }
            else{
                this.noCreditIds = false;
            }
            if(this.performanceIds.length == 0){
                this.noPerformanceIds = true;
            }
            else{
                this.noPerformanceIds = false;
            }
            getUserAndCredentialInfo().then(result => {
                var resultMap = JSON.parse(result);
                var credentialInfo = resultMap.CredentialInfo;
                if(credentialInfo.modigie__Customer_ID__c != undefined){
                    getEncryptedId({original: credentialInfo.modigie__Customer_ID__c}).then(result => {
                        this.customerId = result;
                        this.isDataLoaded = true;
                        this.isCreditIdsLoaded = true;
                    });
                }
                else{
                    this.isCustomerIdNull = true;
                    this.isDataLoaded = true;
                    this.isCreditIdsLoaded = true;
                }
                
            });
            console.log(JSON.stringify(this.creditIds));
        });

    }

    handleBuyMoreCreditsButton(event){
        this.encryptedId = event.target.dataset.encryptedId;
        // getEncryptedId({original: this.encryptedId});
        getUserAndCredentialInfo().then(result => {
            var resultMap = JSON.parse(result);
            var userInfo = resultMap.UserInfo;

            var userString = '\nUser Information\n\nUser Name : ' + userInfo.Username + '\nUser Email : ' + userInfo.Email;

            var credentialInfo = resultMap.CredentialInfo;

            var subject = 'Modigie credits request from ' + userInfo.Name + ' for service account.';

            var emailBody = '';

            let encryptedCustomerId;
            getEncryptedId({original: credentialInfo.modigie__Customer_ID__c}).then(result => {
                encryptedCustomerId = result;
                
                emailBody = 'Organization Id : ' + resultMap.OrganizationInfo + '\n\n' + 'Organization Name : ' + resultMap.OrganizationName + '\n\n' + 'GCP Credentials\n\nCustomer Id : ' + encryptedCustomerId + '\n\nCredits account Id : ' + this.encryptedId;

                emailBody += '\n' + userString;

                var emailTo = 'sales@modigie.com,support@modigie.com,khoppe@modigie.com,kleclaire@modigie.com';

                emailBody = encodeURIComponent(emailBody);

                window.open('https://mail.google.com/mail/?view=cm&fs=1&to=' + emailTo + '&su=' + subject + '&body=' + emailBody);
            });

            
        });
    };

    handleRequestPerformanceButton(){
        this.encryptedId = this.performanceIds[0].encryptedId;
        // getEncryptedId({original: this.encryptedId});
        getUserAndCredentialInfo().then(result => {
            var resultMap = JSON.parse(result);
            var userInfo = resultMap.UserInfo;

            var userString = '\n\nUser Information\n\nUser Name : ' + userInfo.Username + '\nUser Email : ' + userInfo.Email;

            var credentialInfo = resultMap.CredentialInfo;

            var subject = 'Modigie Performance Account request from ' + userInfo.Name + ' for service account.';

            var emailBody = '';

            let encryptedCustomerId;
            getEncryptedId({original: credentialInfo.modigie__Customer_ID__c}).then(result => {
                encryptedCustomerId = result;
                
                emailBody = 'Organization Id : ' + resultMap.OrganizationInfo + '\n\n' + 'GCP Credentials\n\nCustomer Id : ' + encryptedCustomerId;

                emailBody += '\n' + userString;

                var emailTo = 'support@modigie.com,khoppe@modigie.com,kleclaire@modigie.com';

                emailBody = encodeURIComponent(emailBody);

                window.open('https://mail.google.com/mail/?view=cm&fs=1&to=' + emailTo + '&su=' + subject + '&body=' + emailBody);
            });

            
        });
    }

    handleCheckBoxChange(event){
        this.showConfirmationForDefault = true;
        this.recordId = event.target.dataset.recordId;
    }

    closeConfirmationModal(){
        for (let index = 0; index < this.creditIds.length; index++) {
            const element = this.creditIds[index];
            if(element.Id == this.accountId){
                element.Default = element.Default;
            }
        }
        this.showConfirmationForDefault = false;
        
    }

    confirmDefaultCheckbox(){
        for (let index = 0; index < this.creditIds.length; index++) {
            const element = this.creditIds[index];
            if(element.recordId == this.recordId){
                element.Default = true;
                saveCheckboxChange({creditRecordId: this.recordId});
                element.checkboxDisabled = true;
            }
            else{
                element.Default = false;
                // element.checkboxDisabled = false;
            }
            if(element.recordId != this.recordId && !element.toggleDisabled){
                element.checkboxDisabled = false;
            }
        }
        this.showConfirmationForDefault = false;
        const event = new ShowToastEvent({
            title: 'Success',
            message: 'Set as default',
            variant: 'Success',
        });
        this.dispatchEvent(event);
    }

    handleShowAssigneeButton(event){
        this.showAssigneeList = true;
        this.recordId = event.target.dataset.recordId;
        this.creditTitle  = event.target.dataset.creditTitle;
        this.encryptedId = event.target.dataset.encryptedId;
        this.isPerformance = event.target.dataset.isPerformance;
    }

    handleAssignUserButton(event){
        this.showAssignUser = true;
    }

    handleAuthenticateButton(){
        this.isDataLoaded = false;
        getAuthenticationDetails().then(result => {
            this.ApiKey = result.modigie__API_Key__c;
            this.AccountEmail = result.modigie__Email__c;
            this.AccountPrivateKey = null;
            this.isDataLoaded = true;
            this.showAuthenticationModal = true;
        });
    }

    closeAuthenticationModal(){
        this.showAuthenticationModal = false;
    }

    handleChangeApiKey(event){
        this.ApiKey = event.target.value;
    }

    handleChangeAccountPrivateKey(event){
        this.AccountPrivateKey = event.target.value;
    }

    handleChangeAccountEmail(event){
        this.AccountEmail = event.target.value;
    }

    authenticateCredentials(){
        this.isDataLoaded = false;
        
        if(this.ApiKey != null && this.ApiKey != '' && this.AccountEmail != null && this.AccountEmail != '' && this.AccountPrivateKey != null && this.AccountPrivateKey != ''){
            authenticateCredentials({apiKey: this.ApiKey, serviceAccCredential: this.AccountEmail, privateKey: this.AccountPrivateKey}).then(result => {
                console.log('reslut--------->', result.includes('DisplayMessage'));
                if(result == 'Success'){
                    saveAuthenticationCredentials({apiKey: this.ApiKey, serviceAccCredential: this.AccountEmail, privateKey: this.AccountPrivateKey}).then(result => {
                        
                    });
                    this.handleRefreshButton();
                    const event = new ShowToastEvent({ 
                        title: 'Success',
                        message: 'Authentication Successful.',
                        variant: 'Success',
                    });
                    this.dispatchEvent(event);
                    this.showAuthenticationModal = false;
                }
                else if(result == 'Fail'){
                    const event = new ShowToastEvent({ 
                        title: 'Invalid Data',
                        message: 'Invalid API Key or Service Account Email.',
                        variant: 'Error',
                    });
                    this.dispatchEvent(event);
                    this.isDataLoaded = true;
                    this.showAuthenticationModal = false;
                }
                else if(result.includes('DisplayMessage')){
                    console.log('inside else');
                    const event = new ShowToastEvent({ 
                        title: JSON.parse(result).ErrorMessage,
                        message: JSON.parse(result).DisplayMessage,
                        variant: 'Error',
                    });
                    this.dispatchEvent(event);
                    this.isDataLoaded = true;
                    this.showAuthenticationModal = false;
                }
                else{
                    const event = new ShowToastEvent({ 
                        title: 'ERROR',
                        message: result,
                        variant: 'Error',
                    });
                    this.dispatchEvent(event);
                    this.isDataLoaded = true;
                    this.showAuthenticationModal = false;
                }
                
            });
        }
        else{
            const event = new ShowToastEvent({ 
                title: 'Error',
                message: 'Please fill all the details.',
                variant: 'Error',
            });
            this.dispatchEvent(event);
            this.isDataLoaded = true;
        }
        
        
    }

    handleToggleChange(event){
        this.recordId = event.target.dataset.recordId;
        this.showToggleChangeConfirmationModal = true;
    }
    handleToggleChangePerformance(event){
        this.recordId = event.target.dataset.recordId;
        this.isPerformance = event.target.dataset.isPerformance;
        this.showToggleChangeConfirmationModal = true;
    }

    confirmToggleChangeConfirmationModal(){
        let loopVariable;
        if(this.isPerformance == true){
            loopVariable = this.performanceIds;
        }
        else{
            loopVariable = this.creditIds;
        }
        for (let index = 0; index < loopVariable.length; index++) {
            let element = loopVariable[index];
            if(element.recordId == this.recordId){
                element.Status = !element.Status;
                saveToggleChange({creditRecordId: this.recordId});
            }
        }
        this.showToggleChangeConfirmationModal = false;
    }
    
    closeToggleChangeConfirmationModal(){
        this.showToggleChangeConfirmationModal = false;
    }
    handleclosemodel(){
        this.showAssigneeList = false;
    }
    handleAssignUserButtonFalse(){
        this.showAssignUser = false;
    }
    handleAssignUserButtonSaveFalse(){
        this.showAssignUser = false;
        const event = new ShowToastEvent({
            title: 'Success',
            message: 'Saved Successfully',
            variant: 'Success',
        });
        this.dispatchEvent(event);
    }
    handleRefreshButton(){
        this.isDataLoaded = false;
        refreshCreditIds().then(result => {
            console.log('reslult',result);
            if(result == 'Success'){
                this.connectedCallback();
                const event = new ShowToastEvent({
                    title: 'Success',
                    message: 'Credit Accounts refreshed successfully.',
                    variant: 'Success',
                });
                this.dispatchEvent(event);
            }
            else{
                this.connectedCallback();
                const event = new ShowToastEvent({
                    title: 'Error',
                    message: JSON.parse(result).message,
                    variant: 'Error',
                });
                this.dispatchEvent(event);
            }
                
            
        });
        
    }

    handleRefreshBalanceButton(){
        this.showBalance = true;
        this.handleRefreshButton();
    }

    handleCreateNewAccountModal(){
        this.showCreateNewAccountModal = true;
    }

    handleCreatenewAccountModal(){
        this.showCreateNewAccountModal = false;
        this.connectedCallback();
    }

    closeCreatenewAccountModal(){
        this.showCreateNewAccountModal = false;
    }

    handleKillSwitchButton(){
        this.showKillSwitchModal = true;
        this.timeForStoppingCallout = null;
        this.stopUntilReason = null;
    }

    closeKillSwitchModal(){
        this.showKillSwitchModal = false;
    }

    handleSaveKillSwitchModal(){
        console.log(this.timeForStoppingCallout);
        if(this.timeForStoppingCallout != null && this.timeForStoppingCallout != undefined && this.stopUntilReason != null && this.stopUntilReason != undefined && this.stopUntilReason != ''){
            const date = new Date(this.timeForStoppingCallout);

            const event = new ShowToastEvent({
                title: 'Success',
                message: 'Modigie callouts are disabled until ' + date.toLocaleString(),
                variant: 'Success',
            });
            this.dispatchEvent(event);
            this.closeKillSwitchModal();
        }
        else{
            const event = new ShowToastEvent({
                title: 'Error',
                message: 'Enter valid values.',
                variant: 'Error',
            });
            this.dispatchEvent(event);
        }
        
    }

    handleTimeChange(event){
        console.log(event.target.value);
        this.timeForStoppingCallout = event.target.value;
    }
    handleReasonChange(event){
        this.stopUntilReason = event.target.value;
    }
}