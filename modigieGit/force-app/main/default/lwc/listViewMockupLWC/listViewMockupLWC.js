import {LightningElement,track,api,wire} from 'lwc';
import getSelectedRecords from '@salesforce/apex/listViewController.getSelectedRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ListViewMockupLWC extends LightningElement {

    //@api idList='Account';
    @api idList;
    @track recordData=[];
    @track buttonColors = {modigie:'slds-button slds-button_brand',linkedIn:'slds-button slds-button_brand button_custom_size',phoneIntelligence:'slds-button slds-button_brand button_custom_size',verifyEmployer:'slds-button slds-button_brand button_custom_size'};
    resultList;

    connectedCallback(){
        getSelectedRecords({
            idList:this.idList
        }).then(result => {
            this.resultList = result;
        })
        .catch(error => {
            const event = new ShowToastEvent({
                "title": "Error!",
                "message": error.body.message,
                "variant": "error"
            });
        })
        
    }

    openModal(event) {
    
     }
     closeModal(event) {
      
    }
}