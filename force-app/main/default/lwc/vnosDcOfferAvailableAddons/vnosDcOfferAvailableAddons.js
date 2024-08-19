import { LightningElement, api, track } from 'lwc';
import { vnosDcBaseComponent } from "c/vnosDcBaseComponent";
import componentTemplate from "./vnosDcOfferAvailableAddons.html";

export default class vnosDcOfferAvailableAddons extends vnosDcBaseComponent(LightningElement) {

    @track _childProducts = [];

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