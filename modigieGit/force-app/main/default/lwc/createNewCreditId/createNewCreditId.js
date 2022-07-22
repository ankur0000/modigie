import { LightningElement, track } from 'lwc';
import createNewCreditId from '@salesforce/apex/AuthorizationClass.createNewCreditId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class CreateNewCreditId extends LightningElement {
    @track titleValue = '';
    @track isDataSaving = false;
    //cancel the model using child to parent
    cancelModel(event){
        
        console.log("hi how's you");
        const custEvent = new CustomEvent(
            'callpasstoparent', {
                detail: event.target.value 
            });
        this.dispatchEvent(custEvent);
    }
    //save value 
    handleTitleChange(event){
        console.log(event.target.value);
        this.titleValue = event.target.value;
    }
    saveNewCreditIdValue(){
        // this.titleValue = event.target.value;
        console.log('print value...' , this.titleValue);
        if(this.titleValue != null && this.titleValue.trim() != '' && this.titleValue != undefined){
            this.isDataSaving = true;
            createNewCreditId({creditTitle: this.titleValue}).then(result => {
                console.log(result);
                if(result == 'Success'){
                    const custEvent = new CustomEvent(
                        'save', {});
                    this.dispatchEvent(custEvent);
                    
                    const event = new ShowToastEvent({
                        title: 'Success',
                        message: 'Created Successfully!',
                        variant: 'Success',
                    });
                    this.dispatchEvent(event);
                    this.isDataSaving = false;
                }
                else{
                    // const custEvent = new CustomEvent(
                    //     'save', {});
                    // this.dispatchEvent(custEvent);
                    let msg = JSON.stringify(JSON.parse(result).body);
                    msg = msg.replaceAll('<i>','');
                    msg = msg.replace('<code>','');
                    msg = msg.replace('</code>','');
                    const event = new ShowToastEvent({
                        title: JSON.parse(result).id,
                        message: msg,
                        variant: 'Warning',
                    });
                    this.dispatchEvent(event);
                    this.isDataSaving = false;
                    
                }
            });
        }
        else{
            const event = new ShowToastEvent({
                title: 'Error',
                message: 'Please enter valid Credit Title.',
                variant: 'Error',
            });
            this.dispatchEvent(event);
            // this.isDataSaving = false;
        }
        
    }
    

}