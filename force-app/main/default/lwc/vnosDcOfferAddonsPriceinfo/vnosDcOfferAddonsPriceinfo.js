import { LightningElement, api, track } from 'lwc';
import { vnosDcBaseComponent } from "c/vnosDcBaseComponent";
import componentTemplate from "./vnosDcOfferAddonsPriceinfo.html";

export default class vnosDcOfferAddonsPriceinfo extends vnosDcBaseComponent(LightningElement) {

    @track _priceInfo;
    @track prices = {};
    @track adjustment = {};
    hasAdjustment = false;

    @api
    set priceInfo(val) {
        if (val) {
            this._priceInfo = val;
            this.initPrices();
        }
    }
    get priceInfo() {
        return this._priceInfo;
    }

    initPrices() {
        if (JSON.stringify(this.priceInfo.recurringChargeInfo) !== "{}") {
            if (this.priceInfo.recurringChargeInfo.recurringCharge === 0 && JSON.stringify(this.priceInfo.oneTimeChargeInfo) !== "{}") {
                this.prices = {

                    paymentType: "",
                    price: this.priceInfo.oneTimeCharge === 0 ? "€0" : "€" + Math.floor((this.priceInfo.oneTimeCharge * 23 / 100) + this.priceInfo.oneTimeCharge),
                    isRecurring: false
                };

                if (this.priceInfo.oneTimeChargeInfo.adjustments.length > 0) {
                    this.hasAdjustment = true;
                    this.adjustment = { label: this.priceInfo.oneTimeChargeInfo.adjustments[0].DisplayText__c, base: '€' + Math.round((this.priceInfo.oneTimeChargeInfo.baseamount * 23 / 100) + this.priceInfo.oneTimeChargeInfo.baseamount), value: this.priceInfo.oneTimeChargeInfo.adjustments[0].AdjustmentValue__c + '%' }
                }
                this.prices.price = '€' + this.priceInfo.oneTimeChargeInfo.oneTimeCharge;
            }
            else {
                this.prices = {
                    paymentType: "mès",
                    price: this.priceInfo.recurringCharge === 0 || this.priceInfo.recurringCharge === null ? "€0" : "€" + this.priceInfo.recurringCharge,
                    isRecurring: true
                };
            }
        }
    }


    render() {
        return componentTemplate;
    }
}