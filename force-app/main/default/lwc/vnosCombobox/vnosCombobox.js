import { LightningElement } from 'lwc';
import combobox from "vlocity_cmt/combobox"

export default class AlticeCombobox extends combobox {

    renderedCallback() {
        super.renderedCallback();
        let element = this.template.querySelector('.nds-input');
        if(this.disabled === true) {
            element.disabled = true;
        }
        else {
            element.disabled = false;
        }
    }

}