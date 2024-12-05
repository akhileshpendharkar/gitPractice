import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class SampleDataImporter extends LightningElement {
    handleImportSampleData(){
        importSampleData()
            .then(()=>{
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: 'Sample Data Imported Successfully',
                    variant: 'success'
                });
                this.dispatchEvent(evt);
            })
            .catch((e)=>{
                const evt = new ShowToastEvent({
                    title: 'Error',
                    message: 'Error Occured While Importing Sample Data',
                    variant: 'error'
                });
                this.dispatchEvent(evt);
            })
    }
}