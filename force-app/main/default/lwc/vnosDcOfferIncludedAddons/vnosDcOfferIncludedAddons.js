import { LightningElement, api, track } from 'lwc';
import { vnosDcBaseComponent } from "c/vnosDcBaseComponent";
import componentTemplate from "./vnosDcOfferIncludedAddons.html";

export default class vnosDcOfferIncludedAddons extends vnosDcBaseComponent(LightningElement) {

    @track _childProducts = [];
    comboboxValues = [];

    @api
    set childProducts(val) {
        if (val) {
            this._childProducts = val;
        }
    }
    get childProducts() {
        return this._childProducts;
    }

    render() {
        return componentTemplate;
    }
}