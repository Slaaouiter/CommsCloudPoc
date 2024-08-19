import { LightningElement, api, track } from 'lwc';
import { vnosDcBaseComponent } from "c/vnosDcBaseComponent";
import componentTemplate from "./vnosDcOfferPaymentConfig.html";

export default class vnosDcOfferPaymentConfig extends vnosDcBaseComponent(LightningElement) {

    @track _price;
    @track _initialAmount;

    @api
    set price(val) {
        if (val) {
            this._price = val;
        }
    }
    get price() {
        return this._price;
    }

    @api
    set initialAmount(val) {
        if (val) {
            this._initialAmount = val;
        }
    }
    get initialAmount() {
        return this._initialAmount;
    }

    get hasDiscounts() {
        return this.initialAmount !== this.price
    }

    render() {
        return componentTemplate;
    }
}